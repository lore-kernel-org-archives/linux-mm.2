Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01EDC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AF26B0088; Wed,  5 Aug 2026 08:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BEC6B008A; Wed,  5 Aug 2026 08:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A0A6B0092; Wed,  5 Aug 2026 08:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 330F66B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:15:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C62BFA048B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:15:35 +0000 (UTC)
X-FDA: 85067111430.09.F1A5283
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0C6A11C000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:15:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dMXyxVdc;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.14 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785932132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGAxi0OYTBi2XJ1sWoaKtmTq4ydAv+/iBKFBjwC9PKU=;
	b=xF+zkCnFmKKSGrNU63UzfazxxOP2vSxGNXJaycJaBnWPm34ETpL9Xq82jz4aHRwndsYR30
	djssdF92FMgWbGPKG/1J9qpfPi3FEiQ7w21wbpoTaR/CRXawO4JKDx2rxv3lCOKN34rvIH
	2YE1fKuBVbrLo1F3VPLMeKbCtGV6dkc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785932132;
	b=RRyt06yK7DH7OQQ7TCtMd8wG0fy5CdEiNsVkg26LY2C5KXeeSHB3JoGSM56ie9NOrJRzSL
	mjQYrpLGmINBDeTEl2u7Z6X9eGzBI50b3wd1B2eimOIm+PF30ZQSTLQGtuRuEAb6/5Ru9J
	dal1mGQZZYT4of2Q2hfsbF57VjtAp7Y=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dMXyxVdc;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.14 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vm+cltZL+WD7N7mrzyBcF2UcX/6tXxkWPSwQxY6lv52vYsb0cn3gC0gG3E/KEpYK4isL8wnmi+ZM2q3mrxq40xIiEb7RFO22cjTjIO38Naz1X0ecTQsBOn8oYn3i7WdYzTdEIj41eDHbwSVI2IazEtXXNen//0xDipR5JtMJalRxTOanLiHjSMCJH87QQ5TGU8gQ8OCY2ORdHkVhN8Qq1pnIKWMx30FXvQEedZxQEGJuwGpLcGIuLJty58lcVNPOnkmE3dG6KiGY1A9bFwp+3p2AdjpLHxILLJKEM8I8+jVjOghlzSQFHTI3ileyAVCamyBoeIUzu1LREkv2klMplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGAxi0OYTBi2XJ1sWoaKtmTq4ydAv+/iBKFBjwC9PKU=;
 b=hewevBMCj0VRSVyEEaXl0t6HNXKQgPBLBLx/F9R1SqAr++bcrZryq4e8V+JakcTdiyYoC9w8SPp9ggK8yEvgYW0LmcEOWW2ZozaGOp6wKlPCRSKryBy7YALXkYqQBRLIQ4IBwgcyc7iIAqS3ORKet8o2lDFY1v+y7a9vBMss0E3LLJYF3rAZ39OveYt1Tzgg3dmo+LstdW8M2vShVHzUkvAYWvdHjZkA0DSZFH5oWQfyKIcu5UnZgEpuaJmKY/qw2NQYnC6ZNFtxjD9fW7KXsir3vj13+GGKQYxcCOrgXJ9T9BKmt7EtYpQMOi7+27ZUtvUgb64fo09l1qFoY2xilw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGAxi0OYTBi2XJ1sWoaKtmTq4ydAv+/iBKFBjwC9PKU=;
 b=dMXyxVdc1fOLJBZjWyL7Yu07Dcpr/sVVdnEGvvaEhHLSWtv7JQOJuPhjr48vLEoFRqa3fWLmX/QYd13edA2OIe3WVVQ4F0+b+Pg789lw61JMyuhtW8hElmvxMJ1Vd6dASgBZj9fy1rjnfJqCD84gf6+LIJhpqiKdQZFkw5MS/CoSL20BX0Zl3vwVGE9r+8WTgPSXnxznkYdEk2v5sosFtOIVkbImR0dVCagUq6+Uv0vSGAsHEtJ75VT57TVb+cjgU9ZSYoWwWvG1dqM8id09IayeO9EKDCR0CX9ORA+he0UoA4aFf8YRsdc5845mEKtWweF2cn17I2EljUjUVOx5Ng==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB7175.namprd12.prod.outlook.com (2603:10b6:806:2b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 12:15:26 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0292.015; Wed, 5 Aug 2026
 12:15:25 +0000
Date: Wed, 5 Aug 2026 09:15:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <20260805121524.GM27883@nvidia.com>
References: <20260805055544.1568534-1-clg@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260805055544.1568534-1-clg@redhat.com>
X-ClientProxiedBy: BL1PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 3faa9985-ff5e-4d8f-963b-08def2eb3ae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AUTmjT2j0JYtMtmJy0jSfCGntdrfF3sNqIc9/falAp4+H7sQUR2E6PWJVbLMyKJ+CWKCtNXakyL720+z26ROoh14zS4t+kkzvzkwai0PsRN5CehqBWJYBfRVvZIA8/8pcZrny/u3iQ4dF6h0kSvaqyMZ6JNtY5TUptZ4RxlMeIOZFs+XwgBrL0p9stMnLficc7khYOIzI1d92sMOlJ7CGnENQOWPH5NESDRRAiQ8p5y8R88FRVAhB2ZWlnhkH7CE5ERwzwbLAyrtrun68KCMRVTPPpaof7e8U0n+hl2rBy2qzYFW1RE7ZNc5fwcydR8q3R+FIfFEBNj8Kh8avAq1P/gDeqZ0Lc3LOY044wWYK00z+jTmTCwVnNA2yTaPxICj17+sMXBOxYPV9AiZ3iFh0LQsZE8JCSrctzJuqsZKnTqpal3ToByJgbzXpCceBLhRKVDzE8jG35Gwd0WGz5c6MzzHEH8d0CNG2eLCGrSSU9LtGrrj36oTkZv1UgAh0x/piw616+M/Cqsmk7WEPqFbV4zPkixOC8IxskfJMY6KQHY4LiiC+K1IY/C9fbOv6Zvx6deFCZ8JJFxDFC93FImGHRnlIH1Nl2ojsPnKoJaoQ7Co3uCD+A4kTBcO5NpGZERrvJ/iEYKupOKyun7rD1nSoBPP4ZbCpHmJqL7uOHgANEU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFF5cWxHS01VcHBlOHU0bVF1dkpQMUd1MnF2N0wxeUlFZ3o4VmYwclpRYkxi?=
 =?utf-8?B?UkdzTW5UKzc3ZEE0ekRiUUkzSjkyS2U0VFRTQzJKZUp3WWVlNzVuc1JwdHNL?=
 =?utf-8?B?cm95QVNVZFdsUGlOVHYxR1lVaU0zVC9tTEdjenZ6VWs0V25PQ1hEdHRaMm9D?=
 =?utf-8?B?R2xqWEtwb1B6bWNQcXlqczUzSFU5U1I2RzRUWXBkVjk2dGZ2NDhhSHhHZjF3?=
 =?utf-8?B?N2RiRmdFRXUrMnd3WkJRS05MeWZ3cS9HLzUvVzBheVdTb1NNdGNwL3BZOWxW?=
 =?utf-8?B?bm0yUU45QXYrQVFOWFY4QTZRbGhYYml4eEs3bHR3dzlveE9KYTl0RXdCZHlP?=
 =?utf-8?B?alovdjMrTGlrQll4QkJjcld4SjZDT3FmVERpYkRCZTRiOHRxdk83Y016c2Ra?=
 =?utf-8?B?YTdESlpINHlNc2IwN0ErRjZJK3lpMWZpbXBSNkJ3K0k4VWdvUHk3UENqR29P?=
 =?utf-8?B?TXhLQUJxTzZsbEF3L0NtOUx5SGNydHNVSVlGYXV2L016eE1wdlFlY216Z3N2?=
 =?utf-8?B?c3BobE5tdEVoK29NalB6Qi9hT2FBT25ZbjdkTGh4WEk1dnR2VkpLOHh0NlNT?=
 =?utf-8?B?MnhoYjk5VjdFU2tkWFdQVkp2d2FwTGRmNEhiblorUEEreXRBVDBNQUs2WlNv?=
 =?utf-8?B?M2FTWU9LU0xRT3M1MllHVXorMWlkVi9wT2x6YjRHbkN4T3h4aGQ3eUR5U2Rn?=
 =?utf-8?B?WExiNjcvWXhqVWpYc1ArYXNnRXNvME00bDNLckFOaHljTlR1YkYxa01ZcERy?=
 =?utf-8?B?REUycG9tZFVINHc0NHJCMVRrTkU2SnpNdVdBblhTbCtQb1hVYjdtWlZ2S0Fu?=
 =?utf-8?B?ZmxZcnNOdXFTaFBXS1JTdk1yWEhnOG1qS3hKMFdld3V0MFN3Ukc3Zk5VYVdi?=
 =?utf-8?B?ZXFyRENzWC95eGFmU1BHMzkxK0xXaCtwbGptNzI0dG0reWhkTXF0Q3NBNEhw?=
 =?utf-8?B?OC9FV2cySlVLaEpMcGtLVlhUQnlPTXJzTE4wSWFpYVVJS29jcEV3ZmtIL1R1?=
 =?utf-8?B?NzQ5Nml6eTlab2krb1BHZGtTemUyUWlIOGxvcUhwVC9BWU5BemhWVXF5aklj?=
 =?utf-8?B?NG9GSStLaUNBTitJRDRrQ3lwTUpmQ1VnQlkrazZwU21BNTI0RGorUElUNUVY?=
 =?utf-8?B?T2RYWVU2cytENXZHSm1LSHRXcUs5NzNMcGdCWWJPalFQSFVhOXFnWWRJOEEv?=
 =?utf-8?B?c3dRa0tELzRRNktFMDlpYmNhdDQwT3ZkV2RWcnNRbURBb0x5Y1dQTkVoMGFm?=
 =?utf-8?B?OHZrZmcvT0tWRTczSkF2Y04xRnB3T2lyT3pPV3N3OUI3b29yQ0Z6M3B1UTJO?=
 =?utf-8?B?NVYvNnFBZTBkYm84UWdLR05CN0phNWVDMXBGeUFoOVN0TFdDcnBQMzZvODQ2?=
 =?utf-8?B?RFpEZjZFMVF0NGYrQnR6QXVYajV4YloyTVJ5VjNVcGpDQm9pcmNpUU5WK29y?=
 =?utf-8?B?cUw4OStNUnZuTko3aXg0R2d2amY5aTVNK2FuOFdyV0ppZ0hqMWNGeHV5NDBm?=
 =?utf-8?B?eE1NendDbjBGTGZsTFJ6NWJNNWNSc0hzS2MvQ1NQcldoZ0VxcnJybURpL3Az?=
 =?utf-8?B?SGZTN1FuVTE2QXlOYmorc1FQYWVYSVlRMHVMV1M0VXhxNzlsRE0rM0pwQXNq?=
 =?utf-8?B?bktmRkRuLzBaU0M1Z2o1djd1VDJrQ2lveW0rVmkxSHE5OFZlWW0vMWZBVU9v?=
 =?utf-8?B?MmhTenhONVhiWDh2RWM0U3ZSSFFOd0M1SStZRFdhS1krcjlOY3BuR1V6K0ls?=
 =?utf-8?B?eWdlbFdKbSt5RXk0ZXNLdUxYcEdrNlVjZVpJVXg2bkhoN0JpUlpBS1NYRVFY?=
 =?utf-8?B?OGgrMDVGOUI5eUw0UXNHRDJPY1R2TmRra1ErK0xRcnlGVkI0VHhvWkxMWW1K?=
 =?utf-8?B?bmlZUjdNZXpIbzlSTEl0b09lSGg2ZmhmcUpxUjJxYkpOZlVDVE9tUTR6eTRs?=
 =?utf-8?B?cDIvSjhBNFZlYldQUFpqR1RZUjlVR3FMVW1BcU5aNlRHNmZMWWpLVldhMHNE?=
 =?utf-8?B?QmE4OG5RcXNaSVoxdWliOFg3SVBrTm1QVlM2TjhBSzU4ejB1T0ZRdlNYL0Ni?=
 =?utf-8?B?UWFZTXk3YkJhY1VGdHBQTk4zVFV1dHN3RjBKNDR5cGJ5Tlh2Z1VIWWs0amtK?=
 =?utf-8?B?N2xKWmRibTAxRjd6WWxBTUhnSTNrRmYyckw2T0tvbWU5L1BJME9kK3duK2xI?=
 =?utf-8?B?azhtRkhJQ1d2ZU1TMHZqZmdMckpManh1cFB3VklUekUzc1pvdjVWY1hTM2E5?=
 =?utf-8?B?T3BqMGo3d0RPZE9VSlVvc0NPbGtqU3VyRGJxbXVOMDlUZHdaMXVFSm92c2FT?=
 =?utf-8?B?MmZnTE1Ja0FNd1RScDYxMzFZMjBtbG0rNEc2UjhTSnN2VDN5OUwrdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3faa9985-ff5e-4d8f-963b-08def2eb3ae0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 12:15:25.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/peFGsBV+JLUDQ+c22+wz3NKxg0g4CZEA1pPFtLA0jZwNX3rvZmZbbhZeDVK+0z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7175
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9qopmiekyhpfofogeeysbnsbqmjkpd46
X-Rspamd-Queue-Id: 0C6A11C000B
X-HE-Tag: 1785932131-522843
X-HE-Meta: U2FsdGVkX19/Nbd93bs6xhFzyMgA5oFEvbgwwhvTNYkhLGAEtJi9JZSvmiB8X/8Ff06ogV28m+QjZGsQ8Ugf/EBGzMSrBaBaqu2orOgF/25R1bDJKMjQuohEUSzguMr49J2nBYlfitfXLOwc0MRqKy+us+yepCZ9C+b5eUHAj1UdEuNAMeL23Ai3YgDNN3eXqpkuHcIOuQ+0axB1ckaSmcWpQdFxVqnOmdAuctc6egjlffcMKRY5m2BNvh76LjJlMxWaYjdZM0BBDsr+8gxWizhafNcBGNTt4gZg9vAHm2v/aTcxpRKxYkmdx4MWueBaT3tAqr48kwvVBUNx6QK23lmkA54KPehA5QDZOUE5doXscf6NTKnXLfyzOh6SpHw31oxhR6adI/pHJjUIaoV2LEkDfZBi0pzHTAIzrlXJGnTFaFvOabpGZFor1zByemx9tL0MSTERS6RndLPv3cGZ+75XMO92hRMaYqusDI5SMvV7Mpo9Lq4t4/DxkuM8/dsCuVvgAtO0yS78SO6jpul7Wz8PYMnfxXPnAA+zzCly3nSkpJnrTR1XCkltoD4GqDybBI0ZTsucFQ3S+hAtEOcRSUSNmPXN0AtHf9Ub8dz9GT9B4TxVco7oNYnXbj/QJGsBlHw66fkRlUnCeHSRM/WnwUy+0p5FfQzzInWHSqum3zu1wCxleKfWS090InhuKfhXVzcWtfE51TGR3/fXtJandQpweYpbiCFvZJSb9h8bYoIuf74EEinCvNOFCHW7nD1tisHHyH27hcRa44dbsSegkCAeyxYIGUIDo482VmGFKvfsWEWpNs0uhfCjiZeRw5AA9CSVoQ6zsCf26lem6t3YPgb7Js+FaaOk6oEbizJtAXiKbOPDk4CFEU1lC21FAURp9fv4oI3K8c3gbZbUI/v9cxmUikOlQ+dWA3bb5xxPIpFlkOs51eQBSPoiwZiwVSvydcDNt5RluzY4xNRmSnC
 iLl7g6kV
 1EcwrBLAiDMPcnH7N+TTmDtUEQpUkUXjU0PnTdOqte01ltriDCo4S6Tk9LPWtvkFcP4qW5XuOfpyacI7iOI82zetelRujiDZDZ6ERF1SILyQFkH1/zWzfEnLTy8mRIckqIIGzEoBM+XufJeOq7ckbcypJPN9slGww9zgrxpKUwtyv64bI3hBQVIoubJwEzFzJLc7WjE3hKhScNYDMfDopNVZ6XxLBYHxb0ZDLcLfCt+1G29Ob/QcEiOTT90+m00wNDhExYZLApynbx3Vafk8fQPtXfFKrisXO53Ae8UzLlyBd9oVkqdL/DnpwnExB/E1vYgNBez39Yv7zr29TKF8IrVVoTiS+nEJi144mzC7cYVRlcUaB/y5XBOGWt0yiXnQq6VVGeeh7rSse3K/TXAgRTJqO/JxIUVmvzy+t+UvQrVWRqrI5lR3OxF0VZbjRYPzHqcJXNUmVm9MfH80nrgvOkYQvJMt1ChhgkcFyrOWABCIidHWNs0t5tF58SKxGWukxz+C+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 07:55:40AM +0200, Cédric Le Goater wrote:

> The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
> page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
> with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
> severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.

Broadly upstream we expect people to use iommufd and dmabuf for these
configurations to avoid all this nonsense overhead. :\

Jason


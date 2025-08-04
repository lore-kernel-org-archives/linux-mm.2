Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B1DC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A1A8E0002; Mon,  4 Aug 2025 11:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62178E0001; Mon,  4 Aug 2025 11:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB3C8E0002; Mon,  4 Aug 2025 11:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B98E8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:41:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1476E135C5D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:41:42 +0000 (UTC)
X-FDA: 83739490044.07.7B8B1C7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 81ABC80004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:41:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YwLbW9yC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nF2KY6Gd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7AV/gPnSQu/IeE6unBpjhjgOM2uQ+ao/3oxEF2aOCo=;
	b=KCYij2ZUMZ1S/igLabPPvQ158VoR2QteR6RCxO05PF4RDYS+KZeXHuxzJOMWYgA80TKEKL
	57SUYcLDBZ6VLT4VeB1rtRzEOlwIO/R9iTz3lxPjA9J4fNef5PAXO+FAupI0kKNjcnBOeD
	zAAAQrZSHfqirSs/sws90AkqKpwGFG8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754322098; a=rsa-sha256;
	cv=pass;
	b=hXx3s3TvLkP5ggwPGEjvGAbbXzbU48kjrmAEg1UwnxVqIwLbCKSVo7W71TvOuKSLrTJ53o
	xu3Gr5i+nI4UazzvTu6FJmrGGjG3H+JKgEgxNcPCV9i7FxQQeUnPeOgWrLCagEuj+TYuux
	dJX5SfMPJpzsTpPSm+fqdmFeGAQPpic=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YwLbW9yC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nF2KY6Gd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6Zs6009197;
	Mon, 4 Aug 2025 15:41:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D7AV/gPnSQu/IeE6unBpjhjgOM2uQ+ao/3oxEF2aOCo=; b=
	YwLbW9yCE7HxWT2akRlr9pmaKco0IR2ozDSj78OozEoWUZ1BWpL6N9atWJEa5kFj
	e/yZexgbeM4N74L5ItQXln3+I0N2GBjU5/Wd4g8cgXQpw36ut6dm5VVobCPisvPf
	5I6m4KOhBbC++C1+NQdG6NtbYznksNxy7BavBra1QXsfgYJ/H7WCHm/yYBMeF5UK
	NCGTCv3JC89B4mr//daaZXmLt+88ARIiDwChbwwAp6taa70mXrpO6qdtZ9mOw4cK
	1RrJp1+QK0sgakvJlXmbKkGkIlss8BZ1I1txdfynIBfYXsxgGGqJbrgx0m0Jg9BY
	McIYBqDWzTs60V3fripbzg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489b7xjw94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:41:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574EKNZO032029;
	Mon, 4 Aug 2025 15:41:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jusru4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:41:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yRssZ74MOzd4aqff1L0+ZL7puTzmVS5qdYwXCsjS+ZScKDPVuykDykR45HlGZyQEZYYcrsEpcf9eaXcAs4DwNMMJoE+7PPIk6l6uvvB8amfLYUCv3qfh5T+UZw6mEnpNRvYHm9z90C4Y1SRetjN+WSm5m8MvtpvynDpfrv1/I4La1RFacRjxbvqHd1sjul4cFGCnkzetUAOq2gEFt1RAb1lfRqWYBJ9ktWVmScOCSgrfqLbPJs0zR/FxfpAbyszKzRHCkostberQ2PoIHgwIQpu+KJE4JPlYGERtdwyPPPmTD+agx9R0ogeoN8cRRcBsLSQWyaDctGRsKu4OKXW6DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7AV/gPnSQu/IeE6unBpjhjgOM2uQ+ao/3oxEF2aOCo=;
 b=AmquUYqJymxWUHV4lG5EOGhn5C66n3ylAtEvgaFQFz0MBK1EF9WQKHRnJLgGc5H7NuGqvlZwINMVaHKBK//4rPSR36SDe3j6oZYpBwvYTaxgbLFtZW0+U25hjq8ycWmB/u8GUegBR3++SfCk/W4Nelr41RIkIsGThTuweutCyVT4i+W5DBm7mOKgFY03i5vgHR43OJ/sb3AEunmtpmRORjynt1T3uq2rx9QQMum4eGZiZdsHGvYgEGaRrJ4SB88C58xOP9aUc2VazC7loKpy/klCTL9f6TtgBU8pQaqjwqMpoQX0hjFMR9eSWe043zLRUIJpoovqJymiiHmPplN+Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7AV/gPnSQu/IeE6unBpjhjgOM2uQ+ao/3oxEF2aOCo=;
 b=nF2KY6Gd4lpbBZ8n5u5i2C6xDF6hKxyK8YEpd7Xopb/VBFhdFHC50O94qd3l67s6vBUIgC8dDHOTEMz5SKBspAvp0IUP/23VguLprtzM26IuiOrBccE4H8oq58TkotLoYW9/nh3J1KEMJlB5qOob8owwl5OfOJac/DmHZivDOdk=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CH3PR10MB7234.namprd10.prod.outlook.com (2603:10b6:610:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 15:41:26 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 15:41:26 +0000
Message-ID: <addeb004-da7d-4608-a2fe-eef697aeab96@oracle.com>
Date: Mon, 4 Aug 2025 11:41:23 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::14) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CH3PR10MB7234:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c92a8bc-b3dc-43f8-7ba6-08ddd36d5f68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTd6YXNuQlkzQ0Vjdmt6aFA4eDJmM2hUbFJObTBjVk10bVF5QlJCQWkzaExS?=
 =?utf-8?B?WThZanFFeklIbUdybEpaSHlDWG9abGNmdEpoYytiY3BncWpjR1VZTXk4Skho?=
 =?utf-8?B?dEFCdkpzOS8yeXY1SG8yeE9EN1o2RGx4bVA5NFZ1NnhtbGZuMEFJU2VrYXlP?=
 =?utf-8?B?eUtka0FwMWRvZzg0R2ZLTTRpaFd2VG9SMU9KRWovbkRrNTRZSWpRdkR1c0VF?=
 =?utf-8?B?L2tFeHE2clhYb3dOMks5d3RPek15cE5vcndlTklqRkxydk5wZUIzRy80bTZQ?=
 =?utf-8?B?NzRzQ3JoU2xRVE5YeUp1YmRnSWh0UjFoQ1Iwdk5JRStzVzBnSVltN0dMckd1?=
 =?utf-8?B?TS9BMlJqTkMyellzdmhoZmxEMXZJalZnK2RObi9wZURWTlV2Q1ZwYUhYR1gy?=
 =?utf-8?B?QVJUdkV2WVNsc2ZFSGNLVWQzcVJRdWx6ajNqWkZNall0UVIxRU9KVmtiL0ZV?=
 =?utf-8?B?RThPMjlmV1AxbFJrSnJTS1hKME83UnlnNENBTU5OdkU0dStNUkhzTGtwWWtN?=
 =?utf-8?B?ME5QbEtmQUEvR1ZmanorQTV6MGU3TmphN0RIMEpEbytYV2NmSnhYUlBHdGR6?=
 =?utf-8?B?a1g5K0FDd2hIbzFsL2ZLUGhPMGpVVEJhcVBJV0JWNjNVaHc0M3Nmb2lRQndF?=
 =?utf-8?B?Tmc1RG4rZzJJOUdaQjRRdTZvcFROdUFLWlJuUjJnbGFUSUM0elV6Qk5HOEhl?=
 =?utf-8?B?WHVTellvZjVMV2VKQ2FtOEFrRGlMNUZRdU1QaW5RTHFaRC9xdVVKa0NVUmhC?=
 =?utf-8?B?dlFUd3J6SEpkRGdpdEZlKzRIUmN5N0pXbWVmZlllTmJDUmI3OWtOOEZWUGlJ?=
 =?utf-8?B?Q1ZlSjE3S08vWXluWnl5SERHWmR6Q1ExbWNEOU5sVE1Iek91UE5Pb3dCaHZL?=
 =?utf-8?B?bEk3aHF1RzRTR29wRkJMSlpkSFYvYUZ3M3ZsUGhpR2FiVS80RWhuUFpBZ0dC?=
 =?utf-8?B?Z1NXRHhmTm5vU3NvaFp4TlpQQmdBRlVWK29Dc1ZGWEs1Z0NaTmdvT00yaU80?=
 =?utf-8?B?czFFbXAva2cvTHNPdGRnVzlkWVNPenlvUm9oL0FBbEF1dTZzclNZUGpJZmhq?=
 =?utf-8?B?U01QOVFWZmpqYTY2MXVHcnpJVWpQeCtybnV4dE5ZclV6aVJBY3dHWG82WlFZ?=
 =?utf-8?B?Yy9jVHRHdGJaMVVPOWRzb1p4dWpqZXhzVmIxZHpLVWFZbUVwZVZNWjBhN3Y2?=
 =?utf-8?B?bGJRTVNZZzI3VDYxUkFJdERlYjI5YnNXSTVFaXVPYkFtNDU5OU5LdDhUcWlD?=
 =?utf-8?B?bFFpL2dWak5KQWZEcCtCN20xLzV3NmRucXJsYzlrNHN5OHJhRnorMG5KK3Q3?=
 =?utf-8?B?Vm93OWhSQ05kZElZNTBvbzB0T0doYitmM21oRFZxYzZmVmVoalQ1d2JwUW5u?=
 =?utf-8?B?REZKUGN1WHFPZWs4UE1BV1FlQjI5QVVpQUNaZTVkVTJ2Vy85aEluZnRobE13?=
 =?utf-8?B?S3F6TWcvNEhPWFV1QUVlRm9hZzZLVFJGOU5xK1I0eDZEek1WU2JRTTRNSU5r?=
 =?utf-8?B?em9IVlVRMmFQa0psT0FsT2NUaFpqalUwR2QyK2NsSWM2RU1HRGxQdEMvTlly?=
 =?utf-8?B?RjdzVy9mS1JlNmpGZ2taTTBCRTEyTmh6d3k4bjJXS0YrUUh4ODZyaGxnd0dT?=
 =?utf-8?B?aVoxbThDV1ExNHVaVVF3cEthdjZETUlZczU0WnRaMmt0TWNzdTZCemVqRGxr?=
 =?utf-8?B?Mlg5K2ZRemRhME4xQmx3NHRjb1R4VHdaQnJsUE1mMHp5My9kaXhRSUc1TXBB?=
 =?utf-8?B?UDRuK2FaWmlTN1ViTm9hSGE4N2Z6Q1VFbkg1WjBaaTExcEdPUmF1SWhnQ1Zq?=
 =?utf-8?B?U1U2TElYeU1hN08yRXZNQVBSUXF2L3NnYjJZQW00b2JzNDRlYkZpOWFZL1ZO?=
 =?utf-8?B?M0w1N05Zc3YxWlFPanNiS3FVYitaN2RwR09ndmthWXVvR1pXbmtzaUErR0x6?=
 =?utf-8?Q?xx6gVnPrhKg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTAvUktHaXYwbjdGc0FXeVI5emZPdkJ3V2JVWThTNzZaZHRzNmtVNFdZeUZy?=
 =?utf-8?B?ZGJudU1nc3J2dGRucWl6ZHljTUtVbTk3NXZFQk52WnBnOTlHMnUvNzVFQnFI?=
 =?utf-8?B?Q0V6MVNEOHNQQVQrdHVjQmU4VUY0QUFmbjVaQURkQUJsSGxGc2svZHhHLzhY?=
 =?utf-8?B?OEx3dDFDRk1UZnVlekp2WCtIYlNqZEU5TXVSWXVqWWxSZEVqeFBkLzJZVUpr?=
 =?utf-8?B?Q3pvRjFyT0NPYWJFUldkL2ZXU3ZDWmxzWlpvOGlMMUFjaEVXNzBZalg4K1hu?=
 =?utf-8?B?U25wY1c5WVZxclZTcVVYdnMwa3RlakxId3plZGVxUmxjT3d3VGREWlVRcXM1?=
 =?utf-8?B?STVuQ2tDTVhPakwwdk9zTmhVVk83NEdwbzRiWTUrendCZzdDYUVMNlZERW1y?=
 =?utf-8?B?cU1ROEswdDB1RkpCb292cVF5THVpRk5TUzh1N09yRlRnK2h5RWsvckJXT1pY?=
 =?utf-8?B?cEpzVUlXRDFZWE9WM3Q4R25KWmdmUkxqN250b2M3b2FIa2ZhMHZkemdadEc2?=
 =?utf-8?B?RlpSUE50cnVEaGduZ2MzRVBFb21lZzV5aEtHZDJ2TytTR1c2VFpuK0RjSzdI?=
 =?utf-8?B?T0FJKzhJSDJpV0ZuUWhaUk90Y0x4ODc1UVJ6YXg3WW1TVUErUFFSaEZxMFNL?=
 =?utf-8?B?Z09Ed0dTSFVmL1hKeWpubGFnS0N1WTk0Rm5Mc091eEQxZ05SNCt1TFRVNG5k?=
 =?utf-8?B?QjRSWEtRMXZDVFg0aEt1cUJFd3NyU3ViNGhtRWExcGpNaE0rT0RzbUUzTnVW?=
 =?utf-8?B?R2FBQXV2UHR1ZjcwWVpjY3ZpOVJuVjh0MC9tVXZmcUZ6TGtyUVFWanFzREZK?=
 =?utf-8?B?UWRZMTdyL0o3R21RcGhQOFd1UXZUVUVoQTVHOEdOM0tCY1ljVnB1cXhyTURB?=
 =?utf-8?B?NjFKbldtNTMxN0tkWElCdTNleFdScE9nV0dIQUtKbTdEQXNEbk16N0t3Tlo2?=
 =?utf-8?B?NkNFWmoyUDU5dHlML2poNFM1cTcyc09SUndxOUtLODhna3RxdjMzSXVKS004?=
 =?utf-8?B?TkNzRHJwaFhWRDJyUmFKL1pYRkZUN0h1TlRaSUZXMk1zT1pFeWdPSCtNRVR0?=
 =?utf-8?B?Z1o4dC9EekVnUFQzUEErQXpWRVVocHF6VmcrYmQ3andoWW1SNmxuNkRZeVk2?=
 =?utf-8?B?Sk9VVVhsQVdoa2hCQTZjbVlkeTFHL2ZuUER2T1pUODRxQ0xBRXNUV0pJdld2?=
 =?utf-8?B?TWNabi9wK1k1TE52ZW5QSW56MExrUFRxUksvR1lkMzNick45Z3NyREhzZnVr?=
 =?utf-8?B?aHl5R0pNNGhmWHdUYnRKNFZvQVNFWW1VR3ZFQ1N2dDBwQWJPSk5rZWd5VGha?=
 =?utf-8?B?ZVVxYXdCcUtTa0YwcmpnUW5ESTE3aDFrRTJMMHNmbU10T0dLUXJMWTlZdE43?=
 =?utf-8?B?UGo5azVVVm9BZ2RLSWxnOWUrSm1YQThXOEh4YnNuVE9oUm5BWGFkaTFKaW9m?=
 =?utf-8?B?andYSk42UmovazFralFRVWxTT1BsKzRUeHF3Ync0SEpJYnVzWGNNRjJwQVhB?=
 =?utf-8?B?dmk5QUxjTHkyMytDOVhtOXRIZ1VJdEY1Y2JRN2ZxcFY2R0JVWkdhcmlyc3Fh?=
 =?utf-8?B?MDh3Y3FKaG4wWjR4M014Q1dFRlBMdTM2a2VQdHpLdlhDTVVNcy9lSTZtT05I?=
 =?utf-8?B?QXRPRm5obnY0enlpYmFTcEhTVGhIbi9MRlZ2cmU4L2g3YVBNdlU3VkdQWWpF?=
 =?utf-8?B?bjhuZUhaQjF5TnJ5RWFtRVJrbmJOUVpId3NsNkpSb1JvMmhtUGR1eTMxcVBu?=
 =?utf-8?B?NEdMUGs3M0lUc1pNaTZFczRENDlzUHdDUFhVNDZFSWVqNy9CeDNiREpYNlpG?=
 =?utf-8?B?SHFhNXFMd1BxMHVaM2E3K1lDRkFCSm03cXZwOEpoeW43WHhHbEhnRHFQZVl4?=
 =?utf-8?B?Uy91cmJpdkJjVFlFZlZYTVJKU2EzTVhQU3NBaGJDWVdUaHcvQklCNkFpOHZZ?=
 =?utf-8?B?a1NoaEFaTjIzZzRLWGg4SkxsWFJmRTRnWkdIRmc4R3k4V29aV2tCcUFSZVhl?=
 =?utf-8?B?Mnp5RlNWamRVVzFrQTh0REtqVjkzUVZqTGh1a25nTU5ZZ29VTk1nNzJhdzdZ?=
 =?utf-8?B?eGFtSDFYQUMrOHFUZzNhUCtQUkdyMDZwK3VzcUo3T0N4UUpmSHFEWUl2empa?=
 =?utf-8?B?MTN6ZlVTL3ozMis2WG1qeGJ3Y0JmeWs5djFGNkdOYzNJMDBkMTZobWozYnBU?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lD0QuyZs+gQZQXjjaM050eSAERCQmPGfb9fDTSRN9fX/IgRvSAWDU1R8YSYD7hL5G0CMwdIMqKrlrAIk41/DacJY4O0P8SJ1Kvua7nTm0Uee/x47xSEvTgk33fo2qM9EMeWRoWKR7TA0YGibCZvyyrKdYrHSqzCYGhCcTVTclGKL7A3qpZvUetg0Y7wFcq9BPZYSj0rci++0ccACRGmEyhSev23QeZGZqnV8XtAKU1JtEPjxKxo672MGEmuIab1v9ldF2pJ5Ztr5BrYbT9ORPyZGdASokrsCTr0T+wf+fP2WIlr6+ffKaUTtMVwVnR5n9+AWmU6NsMzmh+fi/NnZIWow8zjbDjgVZUVeaLfeIKkbLPPcxtwQbrI7PeikMnCmbijf/19X2yz2rphugYJaxm3QLhsREBXUG+TDI3VdG7YEo2HtKpgQ2Rrbrh1s2R/T1dsxkKX5u/TWlqcFmy5e6N68O9wp8kVCtne2dteIeAdXXnRtSnCfDCkHjZuxLnBUkOWBkz+tiAOiwkDFJYqYGuhC2+CE5QhX0ZkA0evYe4X2y1FgGyCastYDzHuPOmxNcV2HsqGqKm3oieLYzfP0F58wTk6Pj7n+u3k6M5u6mL0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c92a8bc-b3dc-43f8-7ba6-08ddd36d5f68
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 15:41:26.4376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbrMd57SbgYkxlPWuCDhwyzLwwnPyB8FZuqlP1N7JIDgJYPpHOscViXpw51Fq8ofBVFwrlI8K6OWOxMRkYtR9RluiMCje9+W6N9X10EYLVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7234
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040086
X-Authority-Analysis: v=2.4 cv=MdNsu4/f c=1 sm=1 tr=0 ts=6890d4aa b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=szttPsjGShbmpES_YzgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _l6grMYb3xPpmWA1WxEbqyHsZzzMuJeH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA4NiBTYWx0ZWRfX/K8EiAZfsoco
 HaHv0aKExzsD8d6fiNNf9N0KMjjCcTsXeP3n2nZahwrW0WkwKdLUFVUpXlBrzGgoiMxzVC1oreh
 nFp2EK6ffDN3UKI9vX2lMDFboBART5Fi6mxqsCj7OwI+s1WIF5f1LnfrbU4zMCaPe7Xxxy2m8oY
 EF322cvJ7BLJD1EW8gvC+Vk7F0gz0pt6C0xXwNQk/6fatMRxMXKPWk829wV1czEr3XXvSb16bRp
 isSrTX3ZedKLw5w+/a9n4ys4WgvQIjkvaKOZNLXn7LH5tcBST0yU9X7hKzkc63tbKGv7jCtYo8r
 GbunBk20uvKI8AmIBUYKOKcXgAzhKdqRmjEOh/aMzsjptWLlcSrnmrHhqzMXwJBn9IS7I7FghOt
 w7snXYW/KMARl2gI7V94P01Owx/LBgzc8hgSP3ebhH6Yx0Dp1Wm88kvPwZ1VwE1PT/cuo5xg
X-Proofpoint-GUID: _l6grMYb3xPpmWA1WxEbqyHsZzzMuJeH
X-Rspamd-Queue-Id: 81ABC80004
X-Stat-Signature: xg48i46ncrw5tcsksfrg9ra5uc9fsgrf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754322098-157051
X-HE-Meta: U2FsdGVkX19UCw3d2ilR1J5UJKQ619KUXcGF4+RwgXuBUBxE5t3PF2XniuJAFlzISG0fM88eP6WtFdwacT+jub9lfl5baa4Ly3ZujAhLzoRz244svWU3A3e7m4rYlOCvJu2WTZWQq88ii5t/LqiYFVrmQPhdTQyFm/ASaYfrkYilGMuLFEx8iqXaGsU8oVrwXSo32g/QxRWlNX6GA76RuUF5OOV9b5DadPuwI407RHIvIZ7K3D5/tjIRUZA6qqD4n4ucvS4CUjU1NzO1784QLWHE0wtu0xQ2IYX2sR4UXT+qus0xPuF1eZQ55cz0uqms7JKZb/kVJwhuncc2pJ3C1Qw3LqMt5vCuqZKFvgaSSh9rH3TooXfduv2Wk8AAzPTNRx0QNo3xVAQvjTZT4OF7WYewI7OPAdR7qHQ2yOs5AKcafGouu1fr+RE1U4Qa6KU3UFwVbVLRwhsNdbQ48p8vLiadm56B2a6lDaSaeGua9fnvqP4eS40eHrcVGdVNjuDArBmv/HN6d2fHpViAfhp+EQY3QenLXF8KhPmKTTb4rWyvtb4/wVTk7C6JP3BrSlYmRNO6j/MiRZltdaX5Fxc8eA3VF5aC9LauoUb3ECQXLLITngIimrtSkcLP+1NcL+s4xONvEfRbAfOUMRUiaRlFe9Uzq2vCFgcROXEdebSdxw+Ub6kwV6XpSvZY3GjqzKMhUhC6qO0kZpzu/aNxGUaoUV1SDwhbUuUkOlvVwBtdA/7XzaaWECLea3B3vZnKwvmf72Ufv02J1ZvIIfaHzMM3wFmUwGZcrXRAPWQdzZhhSJmJkZfIiM0ugNR+OPjWWDZdyVA49SzCN0CXRfxf9phWndPqwBkQoltuNBXa4KNtHxO5+DqmDH68HX6P2yVhyuk2wBtj2z1PPRze21c+sEoRybs7fHpiRtOo+yYf4rdLV0PknMwNnPW+aYxnHHqDEwIoYFlaEFDjCIrZBrtE/pH
 yYps2S0s
 do7GGQs1HuXsP8IKRYmAa+C1J9sr85m674Iuci7rbfCAzucPQkvyCXDS3ylJgIFLba0Zgd8gTUvYTu522EXadtW58k5LbJldph5bze6rAVEo/RHiHSmzJmVfzbR8hlObCgFWBIJzEJ6P+ShVk62oc6bwXXqbgYt4Vvi9xPUu1McBoGDdFpEiIj9Un+tD1olnAvGBMktLLwMct7t3//XOLxp04jSrLO+Us4xZX3wIJn7oTwQnso+THgYHgcJaudY+ENoRSgibWttBXRw6cebXgfxwYU4vApDL2HFdA0+SqIUmbOnaRzRhxwxgH8M5Xme/qGu7sEaeX9Ntoct6D8VFVazpnA81X8plTksTX8SGB35RsBhG/aAxj5f9q1qY/xK9+rf1Fba3tOAwsQiA2/JXmIkTc+qgqdZNvsPQimcZzqVGfDmTCN2GEgkcl+qG3Aix4nhJ781lFzQl+cF4mzCmiVJThzBHghTwWASV66GLf7NSXZ6Absg0coOUu1Eeju73nBY3d1d5T9NcgHstFgi2a/LZLatbgipXCVuQtrrj304wefi0fNnHST2yka27raukpfXJ08k4hpg1ChYHBnS/5Gc+QMm5N/2qXbTdRQ98iXuFy/9S8JXbG2KnYeHJ2DW1RMvxjgPsnggBu5YWeRNmsXUcP1AIMyVO9hWJbTEC/lF8cY9YJtbvigpLeC0AynLJkVC/pL7PpIZDs1utRXPY17Pe5LCkthAm4IXoQJCtl2MSH0P7kkCHLYqE5oTonR32M1T5OnX3iv0mrdBF/yVTDx0u2+FEWxdRIYtl8OqkG1wW8Nm5O3thak2NXJsugRBZGh08S9nFqIrb0sZ31gYVLFec7fdzJ5Opz/UOI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/25 3:31 AM, Kefeng Wang wrote:
> Now alloc_fresh_hugetlb_folio() is only called by
> alloc_migrate_hugetlb_folio(), cleanup it by converting to
> alloc_fresh_hugetlb_hvo_folio(), also simplify the
> alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
> too which help us to remove prep_new_hugetlb_folio() and
> __prep_new_hugetlb_folio().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/hugetlb.c | 48 +++++++++++++++---------------------------------
>   1 file changed, 15 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b4c718..5b4c19e7a5f7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1906,20 +1906,6 @@ static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
>   	set_hugetlb_cgroup_rsvd(folio, NULL);
>   }
>   
> -static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
> -{
> -	init_new_hugetlb_folio(h, folio);
> -	hugetlb_vmemmap_optimize_folio(h, folio);
> -}
> -
> -static void prep_new_hugetlb_folio(struct hstate *h, struct folio *folio, int nid)
> -{
> -	__prep_new_hugetlb_folio(h, folio);
> -	spin_lock_irq(&hugetlb_lock);
> -	__prep_account_new_huge_page(h, nid);
> -	spin_unlock_irq(&hugetlb_lock);
> -}
> -
>   /*
>    * Find and lock address space (mapping) in write mode.
>    *
> @@ -2005,25 +1991,20 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   }
>   
>   /*
> - * Common helper to allocate a fresh hugetlb page. All specific allocators
> - * should use this function to get new hugetlb pages
> + * Common helper to allocate a fresh hugetlb folio. All specific allocators
> + * should use this function to get new hugetlb folio
>    *
> - * Note that returned page is 'frozen':  ref count of head page and all tail
> + * Note that returned folio is 'frozen':  ref count of head page and all tail
>    * pages is zero.
>    */
> -static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
> +static struct folio *alloc_fresh_hugetlb_hvo_folio(struct hstate *h,
>   		gfp_t gfp_mask, int nid, nodemask_t *nmask)
>   {
>   	struct folio *folio;
>   
> -	if (hstate_is_gigantic(h))
> -		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
> -	else
> -		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> -	if (!folio)
> -		return NULL;
> -
> -	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
> +	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> +	if (folio)
> +		hugetlb_vmemmap_optimize_folio(h, folio);
>   	return folio;
>   }
>   
> @@ -2241,12 +2222,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   		goto out_unlock;
>   	spin_unlock_irq(&hugetlb_lock);
>   
> -	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> +	folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
>   	if (!folio)
>   		return NULL;
>   
> -	hugetlb_vmemmap_optimize_folio(h, folio);
> -
>   	spin_lock_irq(&hugetlb_lock);
>   	/*
>   	 * nr_huge_pages needs to be adjusted within the same lock cycle
> @@ -2286,10 +2265,14 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>   	if (hstate_is_gigantic(h))
>   		return NULL;
>   
> -	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
> +	folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
>   	if (!folio)
>   		return NULL;
>   
> +	spin_lock_irq(&hugetlb_lock);
> +	__prep_account_new_huge_page(h, folio_nid(folio));
> +	spin_unlock_irq(&hugetlb_lock);
> +
>   	/* fresh huge pages are frozen */
>   	folio_ref_unfreeze(folio, 1);
>   	/*
> @@ -2836,11 +2819,10 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
>   		if (!new_folio) {
>   			spin_unlock_irq(&hugetlb_lock);
>   			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
> -			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
> -							      NULL, NULL);
> +			new_folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask,
> +								  nid, NULL);
>   			if (!new_folio)
>   				return -ENOMEM;
> -			__prep_new_hugetlb_folio(h, new_folio);
>   			goto retry;
>   		}
>   



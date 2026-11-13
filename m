Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FB2606ABA3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=I8M+/Lsl
Received: by kanga.kvack.org (Postfix)
	id 7A4C36B05B1; Fri, 13 Nov 2026 08:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754936B05B8; Fri, 13 Nov 2026 08:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644176B05B9; Fri, 13 Nov 2026 08:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6566B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:24:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C49D5A801B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:24:17 +0000 (UTC)
X-FDA: 85430164554.19.6FB7F62
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by imf06.hostedemail.com (Postfix) with ESMTP id B3BF2180003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:24:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="I8M+/Lsl";
	spf=pass (imf06.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.93.196.0 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794576255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEbssf/iPew9KcBZFoXr9uJ3U1Ef0Mi0uoKhVrqhNLI=;
	b=Lt78a4c0t8yzFpKyBB7PnCuRMnh4kMTshhowaif2ZEBbk8F7THpeWRcuHn+5OFHJkzLe3L
	/LnRzN6ROHA3HvjIWKuyBbSMAV7yvB+jGgnA5Kcx50KWdapbTh13pN0rjxO3dmBcQiPdsI
	NZz3Rh5uMIDvCFt1hQhaZ5qKNNChUYE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794576255;
	b=nGbdIgdDTCZSe/Yoo9NePWTVjUbrJkP4UAQnnP7F+0tVuK9Vayq4tpgeypVcTKW9t79epw
	b2wep1AJVBEntDreoQut5oZpd0cfJwEIYk0AfKENkWJb3qLywUyp5di0K+JyOfgJnDp8KE
	KiZwo37b+nrf4gKq8lFT4jFt9s7zgb4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="I8M+/Lsl";
	spf=pass (imf06.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.93.196.0 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJ711i+U0RKDupFxB7IR7x36zOWg2qWCWXIhgxcOwH4Hy5XqBcbCE/izAkOl9GIrCW9+AOoxXdhip26slzgYTDWoFiKx4K8g3ornXdNm9L04Uj478EULCgiJUU178pvucz1zRbWSdfIc8+0BQn2yyOvRgqe7RLzZ6NFUVoqiSC6osveea+Y6yZ4PfJ20hknQrvsXCNPase2/aPCr2b3FvD+W3IqIL/5ihooIhP4Rn215Es4kK8aHBLDE1/HvyAstd1M6VfVRb6oc+0EvPcqCC+NNGv+diLqSABfc5dIljMEyXm7rTqe3MaQBKVYfFzqmROrgvV2PVF3b4q6Sd82fMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OEbssf/iPew9KcBZFoXr9uJ3U1Ef0Mi0uoKhVrqhNLI=;
 b=C49UK4UrQPcTdh+DK8fK9spFRkIh3OTDwyZkhUzu81yMb5vAZ59470/BVOuUnVAvyuNJFHOLx7JBWMvi8yXqC6f67vr06+AVvLMoR0VZq/GbwAzIOaJ3Ku3jrQqIdX06g61/wWyg5NAMGu40kvW0/a6O/pEABjbYSvBbebwLB79DoBIMXiVhUT21H1MoZ4z0d+gPiQgCnt9YVf1BVTVYK6G5CmxvvVEC2yxiwqq79Nyz3Bb77osYGjstwdRoz6NBwTxhMGBXk3IByfrNc19PTmb1Lm+FWP36iizGZHF+uXJXqaIDonxU32zMtjimcLMLd9w5Egl1bSPmjj2BT29ppQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEbssf/iPew9KcBZFoXr9uJ3U1Ef0Mi0uoKhVrqhNLI=;
 b=I8M+/LslWgbIN5XeTXs7nAKZsmNJv4b3mYd09U2VpFJwx59GubvXXxi8aRHTe+GqVNMgUPwZHnnVhxACaqpgqHqbiRFNVdG41Hnho35qiOj+X4DEpPXTNX+/qV/oFd/DytaMsSCuRlbXg2ayTsIXSoLi1FvhuWmJU6kpnHmPeeQ=
Received: from CY1PR12MB9697.namprd12.prod.outlook.com (2603:10b6:930:107::6)
 by PH7PR12MB7796.namprd12.prod.outlook.com (2603:10b6:510:275::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Fri, 13 Nov
 2026 13:24:05 +0000
Received: from CY1PR12MB9697.namprd12.prod.outlook.com
 ([fe80::3a41:55a0:8203:596d]) by CY1PR12MB9697.namprd12.prod.outlook.com
 ([fe80::3a41:55a0:8203:596d%4]) with mapi id 15.21.0592.012; Fri, 13 Nov 2026
 13:24:05 +0000
Message-ID: <5acdf1f0-7b77-48f7-ac22-2095830936d8@amd.com>
Date: Fri, 13 Nov 2026 18:52:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/cma: reject CMA areas that overlap the kernel
 image
To: Mike Rapoport <rppt@kernel.org>,
 Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, m.szyprowski@samsung.com,
 robin.murphy@arm.com, baoquan.he@linux.dev, pasha.tatashin@soleen.com,
 pratyush@kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
 kexec@lists.infradead.org, anirudha.sarangi@amd.com
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
 <20261103162429.2053989-4-radhey.shyam.pandey@amd.com>
 <avBXZ8iW2XPyVbmF@kernel.org>
Content-Language: en-US
From: "Pandey, Radhey Shyam" <radheys@amd.com>
In-Reply-To: <avBXZ8iW2XPyVbmF@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5P287CA0025.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:263::7) To CY1PR12MB9697.namprd12.prod.outlook.com
 (2603:10b6:930:107::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9697:EE_|PH7PR12MB7796:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f3a29d1-f88e-43f6-8f2d-08df418963a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|4143699003|261102123227099003|56012099006|11063799006|261021121427099003|261009223027099003|261022075727099003|261022115727099003|261026121527099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	FdwqzHqJMRArJxppoAaaSlO2j6swueGrQbB3FhEcLIWSMvwGYtTq8zOl8EsMkKBEEWqUZvj7UBLupgH0GyBnJit+3Htw7Sh6S3mu9MF2+PTYttn5u4suaL7QR8KjuvhVOrExI7nzTKIxxrziFNO08XZPIb+yreYE08buS0l+BgEb3KZu6Wv4jqyp2+YpBAUXiWdSekyyIRpIRlSXsSMEw86R/JD8l8nr4Qg/OVoNcm4BkBswBVkfFlWOR+mpHHwCby7xVMbRzByeeEasjA06naEc2kiIqdcOPw18THyPDemLPO40KFGoFPJCZtf9L6+63jD+WCJqVaU7dxI9KP01tSS2gli+pLuK7DPBw0D9H7NEzmWr/wWtjyy8sDyQTHIHMk43l2pb2GtyQDn7f/5VuPxeTq1JCrodLewnJ9lkNw7NAecSWpdqlvXx7jcTuEFp/DInZWuWlhrKSEFUtR3I9cdMqkhYKeMLvqPBHnE5/Fb9rSiv+zZqJug3wx9fKva679rH9mvECkDfc+5s0Z9Mr+r44toZbALx0uky6XhL0fVfbLA+GfMR+hOHUuBLmS7td50gdpemYqnsrpMuDogS1u3hzImwqRER91LKoyWToqBjt3aSk3rQoq5hTKsI2I3g
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9697.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(4143699003)(261102123227099003)(56012099006)(11063799006)(261021121427099003)(261009223027099003)(261022075727099003)(261022115727099003)(261026121527099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWxwWXV6QmhnRVNhekpXcHJpTXk2QWJvV0RhSFpjakhuRnhtakxZb1l6a1FS?=
 =?utf-8?B?RGRSVW44Ykg4L3BUaHlwMVJ4VTBIaUt3U1BzZjhUbUNtUnc5NklYZXN0VWll?=
 =?utf-8?B?VTBQUUdOZmVoWDN3VmJwcGdFNnlnSGZIbWZHN2RiclliK01kNzFGRUJiOXdm?=
 =?utf-8?B?eE1GcjRTTDg5ak5pczc5R2VOWVIxUVp4cjk4OS9HVDFxNTZjazBFRUxDa3RZ?=
 =?utf-8?B?akVuRTl3MVVOV053MUFNV0R4K0txcjFwU3p2Qjdrbnk1dCtadm8vaVVZREV6?=
 =?utf-8?B?dzdZa0RZN2x1WCtzMDVjRjFuNlVRcHZCWkpBTXY3WUxndjlvYjk0bHJMRU5H?=
 =?utf-8?B?NWpCM3VVenhuTU84YXRkdnM2MW14S0dzcDI3eTlNVkdKVHBBeWt6RXhBT2Yv?=
 =?utf-8?B?UzNmQm1BQlQwUEhueHdlWTF4SGVEUkpjSTJSR3FReFIxdEx3Nks5ZkphY0lY?=
 =?utf-8?B?NmhKTVVmMWhXOTRDMTgwdnZoQ3JFRU5wODBlOHFGaTZubWRQV3pUMVB4T2t3?=
 =?utf-8?B?a29DOHFGaE53QkZCUUlCRXNPTjI5VzFCaWtVUU55UFhRTytlbHo4MXJZMGs4?=
 =?utf-8?B?YXhCOUhXZHpER1Y0Wk1FSDJWcTE4L0tOTjJMd1dmR1pHMThDOFNMem05UHBK?=
 =?utf-8?B?ZkJkRjlsT0s3aFBudUlOeDY0aXFHREZCSUtNY0t1Ym1renF4NVl3UjNPUE83?=
 =?utf-8?B?R3ozRnJneHlyTW80Zno1a0ZFQ0xIVlJJaTdGN3czRlpWeU8vVXh4RWVaQ3Vi?=
 =?utf-8?B?S0NTdlFUdzlQekQyRFpYSjBxSXovdDRGSWRkcXZsUDlibzNaTlcyNEU3LzNl?=
 =?utf-8?B?RjFWYjErb09kZkxsc2VlMG9vZFp5eXBWSkFib0FueEw4QjIrM2RLR2dacWl0?=
 =?utf-8?B?VGplWjQrdDVvNlBMUUszeTN2ZnFQb3RjZmUvTlprYmpmV1l1VnlQNUJNbUFM?=
 =?utf-8?B?cnFzUE9RNmU5Y29yMm1USWFJMXVpZ1NHdWtVS3FzSEVtRVlWSnh0enpwWld3?=
 =?utf-8?B?Q2pVYjZzTFdLbUxRTTFWNFVjRjhzZGh2b05PbG1vbS9Yd1FiSkxIeHBocXZ4?=
 =?utf-8?B?K1MyZlJrUE1vWE80a21PVkR0WlN3MGlNaWhzelhJWlBDQUdRQmJjdm9yanFI?=
 =?utf-8?B?dStsbDZNVnVZUVB2VVBJMnR4RFY2cm1vbVdLTjJCU3dXUEhtdTFpMUlkSU5j?=
 =?utf-8?B?S2VVcWdrRVBNWVB1dXdFVWRuUTNneU80dC9ZUEtONkJlSHkvM0wzdzFhaVlC?=
 =?utf-8?B?dlAwR2hLNFhmQVdtazFSYzlsNzVkM2hrQzRYOXVkZnhySmZHbVhpb2JrVmJK?=
 =?utf-8?B?TGpYRGtEaENKVGZWdG1XeFA1VmRVN3UwS1FxYmNIL3A1R1dWYWlKWlJYblN3?=
 =?utf-8?B?a1VJU2NYL0JYYzZYV1Nxelh4SkxnTmlBa3NKMXFjbWFGQ2kvaXo0djRjTFBG?=
 =?utf-8?B?NGJqU01YMGVuV0N5ZHlrSFpJd0J2cjJ1SFltRGlnd1ZlNVN0L0UzWlRiM1Zn?=
 =?utf-8?B?Wi9GVkdZWlZNRkdqMXdUUE5JekhjTjd3NFNsSFc1aDVWMVV4WG9Rb1ZuRURC?=
 =?utf-8?B?OVlSRTkwWWJmVndZWnc3YVM2ZW15U09EaEFYdGgzNG1tUjg2Ynk4VzhxZDhs?=
 =?utf-8?B?QnZmVXdHR2JydjVNTmpMU0orUlhmTDN3OEJ1WXVTTjJBRldJcUZTYThzR0RP?=
 =?utf-8?B?YTdyamVvTWQwaCtUaDB6NmVUeURDM0JwZWFYeElVWWNnamoxemJyc0YyZXBM?=
 =?utf-8?B?VEU4aVB3RTRYV1ZXR1QrRTl1QmY2bk9hSm16bTFtSkdmQjlTb3JDVFUxQkFv?=
 =?utf-8?B?enE3MitPSUJVRDRPamo4ZWJMN0xRY29BZlNBVlZSQU5EQjBSNytuTWNlRDQ5?=
 =?utf-8?B?ajZwZHBqbzF0Q1h5R3pOTkg5NUQ4bkRXRXRqSStsdDZqQUJpdWRES0M5WmN5?=
 =?utf-8?B?emIwYWhMdlJ1dWhtSGJFYmdWUXpLNDJEcVV5Yy85aDdrOFM2Ukc1K3VqS0t0?=
 =?utf-8?B?WHVPVERFMzVmSU40amRsTTVrUDUyM2wzK0t2VEpiY05MWlNraTNYQjdES0FY?=
 =?utf-8?B?Z0dGUEtoVno0RTM1elYrZS8wOHNLaEU5a3RJQW1ENWdIY0N0WWRwTUVPUnVw?=
 =?utf-8?B?ZGNqc3N3UnhVekNjbVdUMWh4b21xUStXVFZleEk3QUUrYW1MRDlwSmI0U0wy?=
 =?utf-8?B?dzg4U0plbU4xZXMrTTVFL1REUGRldWpqMGlkYmtxdTBFU0sxQnpVbFFoNnF2?=
 =?utf-8?B?bVVGSzNoTGJBUEpxUzBBc21XZkpWN1N3cHpSNmV1SFRtM3Z1V0VFaDdRUlk5?=
 =?utf-8?Q?u8rWBC3Pd0l8txJDJJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3a29d1-f88e-43f6-8f2d-08df418963a8
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9697.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:24:04.9889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ux+EzuLBNrQKak57PHZRxL8ax4FclglJKa0jbs3t7k+TVoQ00mA0bA7C5WCbiF5h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7796
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3BF2180003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: be6itg5dz3gkfrork97yaqz55ytct13d
X-Rspam-User: 
X-HE-Tag: 1794576254-585004
X-HE-Meta: U2FsdGVkX18toBVffskeQzuZ2Irrn56LSTMJzGO0DjRKnEt+sycDuM7CRwbdyL0Uorul7jR3m1a2ei/tfIiQrrqMtqLBduzAlJmVK4N3SJRrTsSn9O2ZH90ewvAfmBqQUQXPoB6qHcb0LddWLAtmOM3m7xIEtzd41luGern9ivm9w/VTPohHC2ZlwwceUpYTGwN+q2mN1QSXkY1P5FKKlBOGSDZALR0nUtyZcoL6hrdPIY6w+QBmqs7PNELiX/s45Cfw1vDELss9yktvZqodfS4qVIdW5KsXCtW6OLyCD//jljM5c0iRNP802jlEZsaOxAg3xJ0dWVLLScE5+4Lhwv1Ec6hupKhXuR8N0XbSwUZv52LCjQIWoUoR+F6jn8HyEpnwzq49NKPQRuSvSYQ42o/4jNpy905nLiZLaXQGLcuaugsC8q7J0ylC0pSmuC7aeqVyS1eYRaWBjXYD4pXGJ3tk7ChKU3wDOX9tYX3tJVsU/yWhIDMWg4Dp2admGl9f97aEnzlCDVFz46o0/Wqr7Lh0SYL+3tj8Recj1qoxYK/wL3NDd16oz1KjH/DqWms+yPf7U8CIWX8H1KkqlCJKdBVzLZVOlFKBBXV4VyD4VqJKfhxcffZDD/QavkfCczQ11Da1ANnJeuPyzoMaNKwVwwsDidPbrXVnRMV/kQ9BB3XDGAGQ9IIlW/Zal6a02NdabjEEUknntxtV++6Xp6MxzVqqyQAhFd9vWQ31WhESSNo63U3ZMh1Q4pLvnqckHLY2LFJNyB5IcpYfA8jHRZodg2eImWnhbbzU8ttyIVxvsWQhN3o5lU+ANyI1Kx/p7P8+QhI7ksX95B2v/mIftU5Dnggwct+I4j16gBk3OsdPLLymUHRvowGbOfZUdbZOzsA5zDpDZDVcnPqWQLGKfJIRx75X4wNA4wDsoAwjndDL8Pd0DaS91aAdBJtN8Sm/x6d2Cd+YwzMYlna0Cd1pYjz
 M+N/wk5+
 C2zmnDLgebeinDtHyL3NhH/IatdI96YBIVoOqTgF6abcJlbpAnrxadowN+Q4w3CDQTcTSqGqbqkH9kStGcHUiFuxvm1Sx7/MinA+Zqq/OmKsSShARm8BnW/NLFjbHFO1mftY0+w/ZN5FtMHeIOV5aoM1P1EL/ssdiW9o0nBvhYlgn2EDk7jJ4SIdX72lb2X+IJtMLvncRkLTiHmQ+OlGx34SlqLPUCQe8v2xRxdXtNV1F024g+85vgge53K99ltXOgJQcd8WDyFJ/3dyKerceSdQt3LFJbRPSn5m4E/Tlyc3HiFuUqJCavQn4atXyEcfk9LZeDLHR72XzONZdIPZ5PQryaRLhOEuBdxVupl7rN8AxvrKjcglS40SgJuj5nDK9BYKC8I56V0o3yjPlLp/NRJaWyMpA5FzWcSyYpDSK7IEBlqwjaxMZTZjeC7/M0FdJsBmYrGcgSfqnhof1pmuMAqvHfKPXrnEjMltBYaRmJwa3ij6zIJKKvbcg41Hha3dqQCfwtFYbB3ihGQV6OlEQ+hFSM+Je0cio257z6wNmV22yHoeh8E9q/fBt3Fq8b/HvsB2KBRAeo4un/iqawvZcol88dTZOFMYIbE3L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/8/2026 4:35 PM, Mike Rapoport wrote:
> Hi,
> 
> On Tue, Nov 03, 2026 at 09:54:28PM +0530, Radhey Shyam Pandey wrote:
>> cma_init_reserved_mem() takes a base chosen by its caller and only requires
>> that the range already be reserved, so an overlap with the kernel image is
>> indistinguishable from the normal case. cma_activate_area() then clears
>> PageReserved on those pages and frees them into MIGRATE_CMA, overriding the
>> memblock_reserve() of [_text, _end), so live kernel text reaches userspace.
>> kexec reached this until the fix this series builds on; a device tree
>> placing a shared-dma-pool over where the bootloader loaded the kernel still
>> can. Reject the overlap rather than let such a caller corrupt the kernel.
>>
>> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
>> ---
>> Changes since RFC:
>> - Drop Pratyush reviewed-by tag as there were few changes.
>> - Trim the commit description.
>> - Drop the redundant comment as suggested by Mike.
>> - cma_overlaps_kernel_image() is kept as helpers in asm-generic/sections.h
>>    are virtual-address helpers.
>> ---
>>   mm/cma.c | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 9c53b2b70dc8..3231a53161cd 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -31,6 +31,8 @@
>>   #include <linux/kmemleak.h>
>>   #include <trace/events/cma.h>
>>   
>> +#include <asm/sections.h>
> 
> You probably don't need this.

Thanks , will drop it.

> 
>> +
>>   #include "internal.h"
>>   #include "cma.h"
>>   #include "mm_init.h"
>> @@ -68,6 +70,16 @@ bool cma_has_dynamic_base(const struct cma *cma)
>>   	return test_bit(CMA_DYNAMIC_BASE, &cma->flags);
>>   }
>>   
>> +static bool cma_overlaps_kernel_image(phys_addr_t base, phys_addr_t size)
>> +{
>> +	phys_addr_t end;
>> +
>> +	if (check_add_overflow(base, size, &end))
>> +		return true;
>> +
>> +	return base < __pa_symbol(_end) && __pa_symbol(_text) < end;
>> +}
>> +
>>   static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
>>   					     unsigned int align_order)
>>   {
>> @@ -295,6 +307,15 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>>   	if (!size || !memblock_is_region_reserved(base, size))
>>   		return -EINVAL;
>>   
>> +	if (cma_overlaps_kernel_image(base, size)) {
>> +		phys_addr_t text = __pa_symbol(_text);
>> +		phys_addr_t end = __pa_symbol(_end);
>> +
>> +		pr_err("area %s (%pa, size %pa) overlaps kernel image [%pa-%pa]\n",
>> +		       name ?: "(unnamed)", &base, &size, &text, &end);
> 
> We don't want to expose addresses of the kernel image.
> I'd drop text, end, and probably even base from the printout.

Thanks. I will fix it in next version.
pr_err("area %s overlaps the kernel image\n", name ?: "(unnamed)");


I also want to discuss on this patch sashiko review.
https://lore.kernel.org/all/sashiko-outbox-197614@kernel.org/
Sashiko says:
Because _text is below KERNEL_START on 32-bit ARM, won't calling
cma_init_reserved_mem() -> cma_overlaps_kernel_image() with
base < __pa_symbol(_end) trigger VIRTUAL_BUG_ON() during early boot?

any suggestion on how to address it? one option is to switch
to __pa_symbol(_stext).

Thanks,
Radhey


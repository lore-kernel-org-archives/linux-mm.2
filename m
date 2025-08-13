Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3768ACA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 02:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52D290002E; Tue, 12 Aug 2025 22:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB0B8E019E; Tue, 12 Aug 2025 22:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA2890002E; Tue, 12 Aug 2025 22:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB188E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:26:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 504E5135CDB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:26:03 +0000 (UTC)
X-FDA: 83770144206.11.4F5CA68
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012062.outbound.protection.outlook.com [52.101.126.62])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34B4314000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:25:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=mcBoqign;
	spf=pass (imf26.hostedemail.com: domain of rongqianfeng@vivo.com designates 52.101.126.62 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755051960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hL9iZBN8GkU0UTCDUv2nEZdr/lNCJVrWlKzmhiA3SeY=;
	b=xCedPOtiOprzvMoT+GcAUF+/Jy/GO2bIL6lwf12O/lD94mW6/4Evn90u500CY574wehVLK
	hgOT7BE6+afbnyl3Z8LQkjwMxaIkJ20S/5cIeyH+tFgZZ4REQx1JbgNGgtjtqJNgEB3inr
	69pxfRhkrHwlPqB4sNCi+6xah4lajIc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=mcBoqign;
	spf=pass (imf26.hostedemail.com: domain of rongqianfeng@vivo.com designates 52.101.126.62 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755051960; a=rsa-sha256;
	cv=pass;
	b=391DjOCM/u3Z70nRFIld1l1dfmOj8PH9UK6EEoKK2V6ugZvPZU+l73vus+jRjByu034kQi
	4dw6Duz50dOKupG1fUOTfVYRQ2m/bboZDoFeOOdeDNKM5Q0CGh7VvB3le6LjS43w8sbcrT
	ElMPqKaBbFQcNyKuIUZ8f/v7lbgPE8Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vhfFxXen0bzBHF5UER5C4Kek7s2izmwSlXMDKtHeBKf4CFfAkgHrlzhiii/sI8iIyRgsjadY5qrgBI6OrTldDbGmC8u8IkAZamRtk3VV7QVPhyTxPYEQOE+aCH/grMHI+QS5KWnu6elGI9WrHUGh73oXgmU9B8reuFbO5gvhIfo0MFi1H82euX9cBixCJYnJp970zV9Bt+SheqLlAZnAIqk3QxsH0FAELEbzkF7VfhIKfvSidzwFKLYshM++iLsICGWLwEKscQrc3xhqE4nff9VDiQgCuVs4bEyQtQ4J/2vl+5VcfO+cN4Xrl6G80sRvlzeDELZXKdifyf21Mx5UuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hL9iZBN8GkU0UTCDUv2nEZdr/lNCJVrWlKzmhiA3SeY=;
 b=suPKtsH1s6wIyPzQqmKOPAuR5wxu72AW8iIsouWMxrXoBG0XmwYD/I4GXrMGHsGWJzOqLGytf0z6K7N2FITB2CK+dJCZig7e0jL6J2KJkP4KpeG3+7u4elPD/Cta3P7/8K7vSiDj5I0CnA9bwA5tj1d4PKlGJhtL3DHAaNxJecsHqY0FBeQpUqQmKLRhrDhNOnhaSzLP+Nz2e/gpDIAKRzap5Sze5dYWYB4gpaErB201Bfjn6OoZncQSp0v+JshrWS16YhwryLc74ylV+51fYFcmknybirWZx4zMeFA4jV9hKpekNv1nFHbj6dzQPXPFbpfdjPnLldPEvfuuR+0Cdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hL9iZBN8GkU0UTCDUv2nEZdr/lNCJVrWlKzmhiA3SeY=;
 b=mcBoqignWCD2XOsiI8fyjFMJrfbBiOFpVRDqxSE6u/EBBLmdLJ/ppOqHAhISUOP3+wu8Mw4lIADPkdnZ6CGOQ5LKCQJOx5O7oPXmtQnOGaIO00YZYN+tzIBrqBFWYOrPyy1zrf7h13NNgaiwLzIwYeK+bajlnsBcSS/v+eYnXQqDOFLLha2W6aZbjxd3BG5WVkAPAK2lf+ZW8T3ZNd3r4mobjeJE5LIv5F8qsqZdP+5vQWprUkLyybHMtF/mW8kHozpold/EOIxDIy5SkdFS/tJzTHJDGGooTVquEwQfoaf7gRoDozkX3SY29twYOyMRuEa/gpW5WQhXEKDxk4iz1A==
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYSPR06MB6409.apcprd06.prod.outlook.com (2603:1096:400:411::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.22; Wed, 13 Aug 2025 02:25:52 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Wed, 13 Aug 2025
 02:25:52 +0000
Message-ID: <784dd559-612d-4037-b315-d1b30253538a@vivo.com>
Date: Wed, 13 Aug 2025 10:25:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: remove redundant __GFP_NOWARN
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20250812135225.274316-1-rongqianfeng@vivo.com>
 <b5ca3ef2-bd36-4cb5-a733-a5d4f1fb32fa@lucifer.local>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <b5ca3ef2-bd36-4cb5-a733-a5d4f1fb32fa@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) To
 SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYSPR06MB6409:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ddd737c-05b8-4ba5-30c2-08ddda10b998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGJmWDN5T1F3c2N2cTREWEE5bUc3L2duL2dHSjloRUxYRlkyZjZPSkNqZmVx?=
 =?utf-8?B?cmNUdFl6dlEvK0NHVmRMVWc3WlhjYXJaVngvcUI1Zm1kdFNwVkpCYzFSbmVQ?=
 =?utf-8?B?eTRvVVE5RCtIOXY1d2lOQ245dVprSGM0MGRidndYcjNZaWF1allSN09oTk00?=
 =?utf-8?B?RUU0eTFxaFMwV1NoMzlGWEVldkJLN3BVdkRXOXR2ckt6YWRjSTNPRzN4end4?=
 =?utf-8?B?a0c5Ykx6elRUOGNZajVZWHBkSUJaQ0Z4aE9vcW5SbzVkWDhHTTVrQVg1bzBx?=
 =?utf-8?B?anNKV2UrRHpVUGd3NC85alU2Um5OTzJ5aktyQ1BsVU8zQmVMSnJWQ2VjZWtn?=
 =?utf-8?B?UjNBQ1lvbGxuczkwZTlpKzMxT3F4cXdtWUY5NjVTVmZUUm9naVpUMTZOSFNa?=
 =?utf-8?B?a0xLeWtsS3UrQUw2VUxFNkd4SUVhR3JxOEdONE9BaDEvV3dhYXdXVmtFUVRU?=
 =?utf-8?B?N0RCWWVDQWN6WldkYWsrM2V1Tk9XdVZNSlVpa21DQW12WlNXZW5uRnovdm5O?=
 =?utf-8?B?WkxpeTJnS202TUZpdHZRa21ZVllMaVFNTWxXQ1VDeDY2VEtmV0w1cVRYNUxn?=
 =?utf-8?B?RjNOQ1AzWEpDU21DSGlreWFoUnJXVGFCM0pUbFBscVNXM3AwUWhobUhmOUNm?=
 =?utf-8?B?VE9ZWERkSVRocWNtWnNMczBVS2JSUUQ1WEN4QmR0ZG5yYnMxa2NkdmNRZFVE?=
 =?utf-8?B?Qjl4Tm9wT3U5b044OGYwQUtrdUxYUDFFemlkT1FieHFVUVdQOXFzT1JISkVr?=
 =?utf-8?B?dE5Zb2FJN1Z0NUVQVnc3aXdTVmJEUUo3eWVEWEovV2ltMTZmYmQxZzQ2RnRX?=
 =?utf-8?B?SktuMFR5M2hBdmJXdWJkTm1SUUZOK0gzaG1OVUdyU0djNFJYOFdUZ2FNT3ZU?=
 =?utf-8?B?Qnl1M0MzbkVCK1RVVnRBM2ZXR2lUOWQ1Wjg1SWl5WVNEV2VoL05qM09HalJQ?=
 =?utf-8?B?cmxudjNyUVVqbVE0cDA5OUhRMW4xNkc5T3J2MzRDTHhhZmZHWDFHbXA1ZDgx?=
 =?utf-8?B?QWVwa29uc3kvUFc2c0xtQ1gyREVoMlZ6dWZFVDUwM29acnhmamxPcjRwUHhs?=
 =?utf-8?B?SVY5MG85WkN3RnpvSTZ0UkhRSTFjbUpRQVNldWxVRUZKR3orazVBY0NZbnNi?=
 =?utf-8?B?VE1BRnAyYlB1aTNWMDNtbERkTkJUNlp3ZDl0Q1l3MUJ5TDF1aTlnSDM3c3RU?=
 =?utf-8?B?cDRKTDloN0Y1UDBmZGhJZ2lRUUQzQ0ZyUktoL0ZLV1dEVnIvY2htVGNSRGZO?=
 =?utf-8?B?Vk1XVDlsTHEvdVdveW1DeC82Z0JDTis5Y0EvRm5TV29zaHl0SkRiVTBBZld4?=
 =?utf-8?B?Y20rWFF3eHhiYVZTVmRzK0NnWFJKY1hacU5XUHFRdkNBT0ZnU0NtbzIyYjda?=
 =?utf-8?B?UDB5ZjhFUzRIY2xHSDlQMUVOK0VubzNaVXJxeUVZWHZ0c2hZeVlwMnhkWDNt?=
 =?utf-8?B?MU1hM1NwTjRCVlJCWk9hd29DRFk4WTIyYWk5VllHR3hINXBibTE4VlBxRUlV?=
 =?utf-8?B?NklXTElHcDFuVURHcDZlYjk2b2QxV244ZStmWGF3dzVBRmRqQVo0NHpHWlM4?=
 =?utf-8?B?NVNudExMM0xnOE81TDg4a29leE0wSTFJWVUrTFlmSUE1ZGhJMGpxVmlJenpO?=
 =?utf-8?B?STlNM0ViYTQ3aDdmelVmb0dlOUgySFV5eVVPanYwNzdHU01MQ2dCU1V6bDND?=
 =?utf-8?B?aStqaWJTMVBjRnhEdFZ6dHdzajVub1lMNkQ0SlcvUWV3UGN5cFFsWWhiNS9u?=
 =?utf-8?B?YzRIQzdYV05aS3JEWmkxYTZadE9YTm5MZkRTL21UMUs1Vjh4a3JQWmxqSzZo?=
 =?utf-8?B?aUgxYnpUWkFCaTFWMTBkcHRQeVYrR2JXWERlWUVXaE5aUHdKT2hIaGdQaDNn?=
 =?utf-8?B?R2JMV3VJdU40bFljbVovMWNQRXBnYVNlQzhpS043NkU2UDVVVEExekdyZnBE?=
 =?utf-8?Q?WIuv4VEXmxQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUhiaGpqeVVMeHZPUCtlcmtNaXhzM2xJSHFSUDBnVm5leUM0SDcwUFNyS1c2?=
 =?utf-8?B?dmZMUUlsalpKQXg1dXR6Vkc0aFBSUkdkeklOZjRwMTZ0T1hHVmhMVHJ1dDQ2?=
 =?utf-8?B?SU9qS0I2NktnWWROeEdGYTIwQnVmMy95NTJlY3RJcjh6bzM1YUtGTVE3d0Zs?=
 =?utf-8?B?WHlJc0Q4c0U3SEsxRWxiOEVpM1J5a3hwejFHeExtZUw2WWJrb2lQM1NvaDM3?=
 =?utf-8?B?czg1MEVNc2szNTFQR0NoWUI2VkdFQ0F4aGwzakY1VTFYdUZRcUd5elFJdDV2?=
 =?utf-8?B?RzdxV0lEV3Nyek1pTnM0T0o1dmRNY2FNYnpTZm4xaGw2Nzdzdm1CbDJwanE3?=
 =?utf-8?B?RkJDMC91d0srb3FlUm1kN2VDR1BITm1oalRLZU1FTm5RQmI0N2RCODRrWWUr?=
 =?utf-8?B?dUxTc0doYU9IWGhEc1BUYUdieUp3UUJWMFFNZnNrcFAvSSs3Wno0R2xNd0R5?=
 =?utf-8?B?ZzA4OS85eVFKZVZ0WEVJdWdaWEdWWElxK3VsMi9LVU05d3ZQS3ZZbjhrc1NM?=
 =?utf-8?B?a0ovb0NtckV5cDBjR0hYWTVMUXZ3SjhqVHZveFA2OFZaL2RzS1lVT1NSNDd1?=
 =?utf-8?B?c2ptN1pXdE8vL2l1U0FwRm4rMTVQVEY4OFlmcU9lWVV4RlpUTWlKQTB5S3U5?=
 =?utf-8?B?WGNDQkVHM056UExFVHFycUp1cmsyUjdIKzBmM0FvMVVBZ2xCeStvNndHbmpr?=
 =?utf-8?B?b1lqWjlKQ0NDSDl1TmNnd1pJUmkxTCtmZ1lLZTNpNmxIMkhUQk02aVFPTzc3?=
 =?utf-8?B?d1REa2JPeitvREhtaFVyYklSdnlSSnprTkthekEwY0IrQTA1SThvTjdVeXNi?=
 =?utf-8?B?QkRxdkt1U1dCeEcwb2w0OGdPN01ocWQycnU4c3Nmeko2UGliRjl6ZEhrRkNW?=
 =?utf-8?B?cndsd3FqbTRsVkVpWFdXWDBQMFdWMCtleGdXaUVFM2JYM2hXRXRGemIrbGlV?=
 =?utf-8?B?cWRUZFJxMlJrVmhHVTZTcEh4ZExlWGt0NzNTb2ZKV0h1WnFhVjF2aU5kbFAx?=
 =?utf-8?B?YlI1a21qQjFVRlU1MWVNZjBlcTh2MThKS2kvMzJtL0lTcUlWdUx0ODBCL2Z3?=
 =?utf-8?B?QW5PR3BJdTFGTm1Oa0FrUDdKdSthSGVNUDAwdGZhRWl0dDlWdDZZK25SekhD?=
 =?utf-8?B?RlpTejd1NVlxdlV5czFJR01UTmRNZlpaZzFObGtLL296WHpqcGJFK0k3WmpP?=
 =?utf-8?B?SnAwM1JiakhpQldpVzQzUWNMWE11MTJnd2RoQmJKU3VPbXRLR3dEL0ZxYXZ5?=
 =?utf-8?B?bWd5UHFVTzU0dE9ZazJnSXlXTE9PY2w3U1A1STlzUGplQ3psWnpPSmJwdW8x?=
 =?utf-8?B?VFNaOWlBM0ZpbkxyRXUrQzk0UEM0dXpSb2VrYnVwenRyVUowSzl5ZEgxb3BJ?=
 =?utf-8?B?Q0szejVzYjJHTmZmVW1hOWVrc2pLaVB5QWhzdno1NE5waHB4SHFPS2hXVHkz?=
 =?utf-8?B?SEtYeHE5d2VZRFU4cUR2cDI0YW9WMlZncElEejZPeHhTa2dnYWdvZlZwTnNF?=
 =?utf-8?B?c3VXcFBEQVU0dVJUS2VtdENaRERxK3hvaGFKYzhqZ1N2ZG1YVHJBNFdaVGt2?=
 =?utf-8?B?N0ZWNm1ibTM5d21MVjdOcVc5Z1JhTnZORjl2NExhYkhkbDM5cllrWGFZR0hJ?=
 =?utf-8?B?L1JQbVdsc3cwWFBDRG9ZQnVyOURSNnZMM1Y3a0NGeURIOFdmYmxoc1FRY3ZV?=
 =?utf-8?B?V3RqR0dXdGxqd3d3dDZMN2ljZDZlNFVKeWVReVE1enZ4QXpjejZDV3pwWWpO?=
 =?utf-8?B?VlNrOGd2NWxKYWZocU9nUmIzS0UxUjU5VW5IUFlaWW1NOU9PcEcyTWswM29N?=
 =?utf-8?B?akhNL3psbFNOT1J2ajB2WTFzWGxzbnVSN2xjSzdKa0FzQ1hkYlBUcnBVR1E0?=
 =?utf-8?B?aCtSNHRZN3VQSUE0QWNUMTVvT1V3VDFlT0t2SVV4K0NhR21Zd1ZUSU9qZkc3?=
 =?utf-8?B?SE1kZkcxZmJMaGVZYjU0OEx3WUxTaXB3UUUrZ1hBY2d0ZktCNDd2ZnlqR01k?=
 =?utf-8?B?VTAzSmR0aGZpb0p0U0NKbFZ5c3BqWlRJQVg1VUJURitvdmJrUzY2cE9ETzdk?=
 =?utf-8?B?N3VLZnFuSGpZN3lMQjFkTldpS3RCUkRnakxSdGlzUzgvK0lvV2RZL05pcWhs?=
 =?utf-8?Q?jlq1i5MmERhR8Y2p+8yXGVvOV?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ddd737c-05b8-4ba5-30c2-08ddda10b998
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 02:25:52.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFcXLstFqaAzY0yErOeCqfHju4GJfFceycPShuNaOHwodkQAZdGIBRGPz+4MqPmY9xtonhDWHycGwW1NhOJJtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6409
X-Rspam-User: 
X-Rspamd-Queue-Id: 34B4314000D
X-Rspamd-Server: rspam06
X-Stat-Signature: cmztk5r7q58e7urxbfcejms73bjo61xu
X-HE-Tag: 1755051958-910584
X-HE-Meta: U2FsdGVkX1/eL1hy2ztrj0OCed7nHFxATFScFw7iiLVAswMK3b8xFK0mC9urA/R6Jf1srAR2sxw9LgJBkLwUf4GLDyhuuGlVfJ6qgd0SLgZnIEiZ7is/DuB2NVBwJpUI9ywBco72LekyiZjPTM1P8kNRRldDAiTu6MFHODOMWJx+npValAgIHfAPoOuIG7COb/yzxkWkwUPdpHjO4XaVyhM2k7uOMtCwK/MoVTrEDg1b3ixOKNPCQxgKT0f4+azyk173liRIT5CcO9H2G7GyOdILu8C0xm5S3ELIIAT/gj3PVIRixmDnXVhNn6Z5phN6rJOWZna5VCnxEDzNeW4p9cgm6pwedpbZMuwcoB7YmKmyxPQQB9S8XkigUMLv50n0w+DXzPEM6HWAgqlwpv+KzFSkDvj/mk7SzSSinxiJiPLdtDVFsRZjUw6k9Bh8EzkKThbSwDMRopRpD8DQO6VLl5WKbSQOi6ZuL45kpFFQN3XKW7nzr+laLVo+k7P5rHWUHFmnPxp1e8PD+2mmNW3aUfq80kOjrKQMI5XvZ90FSGkE6PdOlnsfCHdHiy4Opk7HE1XXDI8SXQGDh+M1+GSV7DXZgFfzP2RTbHnHk5IY/JOhYk+uAy+BNycNUFxJIxrTHUMY0wBdH/IQ1cRPd1/lvbf7WWQUsMUODhtO4dSFhMd1B3YVxHUcXLb4XoKxSAyonEhIZOTJ85zGomRHavMctqIrNvIt36IfH7IW7XXS3azCh1Vm2AWU74z01Q2HK6DX5Zd/4EUAHBP2/f4k8ifx0DpywSlP/GSbwvMERdMXUakN6K701Qua5IBnbPS2D1IKc5OK772QSAJFbbIc0rMIQuXcFl5FS2ZbdftsQLWjejgdX9PWLyYISTOvV9XC/gghU82CenNzUrkNaf1l5PWKR6wFxmoQBPRpChFDXauhpQWW4U7JFNuLiJMEsyuhFaiP67+3SLcRwIWKkzE7Yko
 Qk6T+qYX
 oeD0ZokxbYYt5yf0fO1dWvLtKg6hqsbPswtPn0pgfAgrVEC1NpBS0jd3W9WkP9I4MXVbY4IM3C8wvHhlALRDn+IEvKU1N0ihohnURHSXOEoEqOvH/5xbN3lR1teL0CmeXgVF5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/13 0:46, Lorenzo Stoakes 写道:
> On Tue, Aug 12, 2025 at 09:52:25PM +0800, Qianfeng Rong wrote:
>> Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
>> GFP_NOWAIT implicitly include __GFP_NOWARN.
>>
>> Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
>> `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
>> redundant flags across subsystems.
>>
>> No functional changes.
>>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> LGTM, I wonder if there are other such redundancies in the kernel?
For similar redundancies in other subsystems, I submitted separate patches
to minimize potential merge conflicts.

Best regards,
Qianfeng
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
>


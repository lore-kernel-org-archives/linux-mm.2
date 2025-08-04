Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7784BC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96246B0096; Mon,  4 Aug 2025 15:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44E26B0099; Mon,  4 Aug 2025 15:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B957B6B009B; Mon,  4 Aug 2025 15:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3A146B0096
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:09:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82701140914
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:09:28 +0000 (UTC)
X-FDA: 83740013616.29.86211E2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 076E320007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:09:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LYeAOiMu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I3zzIzjA;
	spf=pass (imf03.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754334565; a=rsa-sha256;
	cv=pass;
	b=S1UoXykL02QAxpZxzhyHFsi6LHVzEkQamNje8wqGZzVL0iaYe8AKTAx6mrAs8J3Y/u08z2
	tyG/PEBpbZRadryM8dg+c0Jrou96S4a84RHKLq5xkzOXHiJPa0RxDgNc9Ppm6NVLGb4Dq8
	4NMMisITEOFjhtCaJkmBdO/xkxRsO+Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LYeAOiMu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I3zzIzjA;
	spf=pass (imf03.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754334565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3wdYgFZCGOMnaDVcZDi4KJb8BvamOh6FTe6SFUfNoc=;
	b=cqQtw9hY+sDu7lw/hinKycUVH1rBv/yYVrxXDObXa39V5hPmHkpKKuM9zWYimqONg9YWx7
	SOi6dpFlGIVQpp9rB+XbnykTfcpPbinr2JQ8g7HK+alYfYPiRxnAnTNGpBRi9hs6wTHOTi
	li+vYxguVMY7NdIi/iIcokWhIZolDAI=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6WII026252;
	Mon, 4 Aug 2025 19:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=a3wdYgFZCGOMnaDVcZDi4KJb8BvamOh6FTe6SFUfNoc=; b=
	LYeAOiMu/livS/ccsD9SQaHqry2KLrWpCj/08SRVqXJrDBK5jW++AqBRj4dG4KUQ
	HnhgT394/DMmsI7iMNQaCZxTMTjGajrlffEvGBt4VhJqkFmse+9LcrKSWCmfuj89
	5HP5JYRTRon1Qwdx3FpND1OyKiqJktusosKizCub2ZO0ftgGOoao9CPtdapOYBIY
	mCPGENBgNaXW+XOhM77ETgxiIDTRmqRD47LYRwK5gRwCzhsx454Ij5VVgCToKjlr
	SI8lqN+xik8w19EWUakdkpYJnlGGgEiaZOSUNeliWHj6KCKdpDYMMM385EFw/TFX
	58INUpwXS9tV5iy837gkOg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489a9vu8nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 19:09:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574ImhhJ028766;
	Mon, 4 Aug 2025 19:09:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7qd1fwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 19:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mh1dmAwkWwabGzirlaAod/RU9I2/2I0B9y8IEHyMwoQaCnTkVjYtOcGRo1NlLpliJyCFzHn0/QooPc5tf29eaK+BXo8loygF7ipRZOUaSEfvv9nKAiR6nqbh0v3qgP6rXskU6iNbk4of/0vrtNaIsrEZ2ECzVSs6fhGu5jw20vI1XZ3OwAX0GxAkfnpmGkewzcl+V7ixVpEPJ5HWoyghXD+kCM5g70KWyIANjdorIxBv8eT7l3RohB9KLJPeaH+U5DoS4ReMJv1XQS10NdZ8pEaC9tpjK3mo+MwSvqru0TZcWV2E1EndRwSBEUr3MEa3VGYnNqnZbSh3Cs0nNBRVCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3wdYgFZCGOMnaDVcZDi4KJb8BvamOh6FTe6SFUfNoc=;
 b=EPKMJNRd9bdrdHsPmiLn+6djjw+O2qoKVBbdl+DO0vn3ppBqrGEziEK459pbmixJcOrlClMjdux/LJm0qSea/CmoTfDOAt05UavhXQS6kY0z8WhAXnYFL/wEMYrYz0SK1DBdjf0Ay7SDDhOn0CNCBqglwurmO3e2TUK/VLN4qHcgnz1S4mstndQC5TZEQ9xbvml3MZmAYx8Fqe/HPa+npUDwYx77KwY7r+I6YlV5pYtuQCY8KLA6WAHHsi3oTWS2rgg9z1yekrz07ry7M7U/P3Sy3GojmEsGGpN0FsMVxwfx0izgaSdWIK7ZkYRGZmxFrhu4UsbzymQklfe0NV6n1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3wdYgFZCGOMnaDVcZDi4KJb8BvamOh6FTe6SFUfNoc=;
 b=I3zzIzjAK+c9rb6ATJyZyj1L+/7yC10ef4rD3bYaxuNSw3D3rGn9DxrA76+F3DjuYF07HfAoY2cmdpM+NPbhctWMY0OCWXmezuxr2bBMnOZFrYPjo0OiWzyMade9GiX+droqsIV6Dw4nQk5ftn2VDVOycTBZnZqtEk1f47qLY84=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CH3PR10MB7806.namprd10.prod.outlook.com (2603:10b6:610:1ae::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 19:09:13 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 19:09:13 +0000
Message-ID: <d1097cdb-03d6-4dd0-9ad7-f056371fe1e3@oracle.com>
Date: Mon, 4 Aug 2025 15:09:10 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm: hugeltb: check NUMA_NO_NODE in
 only_alloc_fresh_hugetlb_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-7-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250802073107.2787975-7-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::6) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CH3PR10MB7806:EE_
X-MS-Office365-Filtering-Correlation-Id: c177c883-6784-477a-618d-08ddd38a6660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NW93U2xlcFJwM0NFMEV2NUxvdnYzaDNYcGttTENkd2M1anFMRjVtMnBkVDNS?=
 =?utf-8?B?OWl5UWpRci9DM3hTRVhMbjRWZE5CY1owNjdaaURFWFkzd2RGNkNKOFNrTVov?=
 =?utf-8?B?c0VVaFNxQXJjS2lBYjkwTWVldDRpMWpSdjNkVllsLzJkL1JUeVoxSHFwRTEx?=
 =?utf-8?B?TWM1STRSRWVZczREQjZNb1M5OTZaaXlyUkNzUlVWMHVBQ3krTWtGbEtKT0c3?=
 =?utf-8?B?M0hwb25sc0NyOHpDcEVkZTM5VXVNU0RUNFNpN1AwY2hsSjVxWDgya3QxZWI1?=
 =?utf-8?B?RlAvcnVYZnc0QmRyRy90VlBIanZmVERQR0cvZC9UdlJaUnJpNDY0VXhBeXR0?=
 =?utf-8?B?c05EZlFzamMzNEFnVDk3SC9iamhFQm90NmxuTzhIQnVQMGhsZUhEVXNmQWhk?=
 =?utf-8?B?ZEk3NnU3VThaWUZPSE1oelRRVXpnQklKaE1VYlV0Rng1VldPZXAzRXNzNWRk?=
 =?utf-8?B?VkY4cFZ4SmdiMWlhS2txRVVYMUJaWTAyN3owck11Q1FuaEJuVXJEOW9hREc4?=
 =?utf-8?B?V3NZU3hkMzVVZEc1bDlsRU5VRm1aUy9xSFFRVHFuSUNoS2FXdGVUcHc2U0NJ?=
 =?utf-8?B?WTcxdG9HRUE2ekNqd1crcFQ1Wmt0eGlyNE1RZElTcGhmOG53bWZRNUs3clVN?=
 =?utf-8?B?SE5lVkdaNUpaRVpKUUUzbitZWU5FWWt1WXc0VXoxM3VMc0xNUlNFanlUTTMz?=
 =?utf-8?B?dUFhWUpaYU54OWpHRVYvcTRuaVVjOWhhT0ZIVTZqVk5jQmdTeGZqOEdQWjZM?=
 =?utf-8?B?bHFPN0hRNWFORWtuNXdTZ0xEdHI4WldRMjFRdjNlcHhoNENIeTJVZ0lzSTNU?=
 =?utf-8?B?ZHp2czRUT0lKVjZpdnlrL0R2akZoTW1wUFNiWS9USWlpUVpWSkJUNlpCNlhh?=
 =?utf-8?B?bGZaRE9PUnBiYjM3VWRCR1Z1UnQwa0RLUW1zbmtuNDhpL1loTHVIVnM3STEy?=
 =?utf-8?B?Q3F6dGdjMDhTMjRtTmZaNFM5R0tDVStjR0laQ1lBemJUMklmMG1vU1JZc1Fn?=
 =?utf-8?B?SmFhbFJQYW9Gdis2VVZGdzY4OXVsNDNLNmJmdE1rbkFPNVBWZkNJVFliUGE4?=
 =?utf-8?B?TDVlVXdCTVlrYm5FTXROSEJlUDhMci8zWkYrMVBaSlZ3cm1aWnMyS3F4bjFZ?=
 =?utf-8?B?aFZ4V29pUitXekJKYi81Y2FJczJCUmErY0MrcE1SU2RGRmRQVjU0U3NVZ0J2?=
 =?utf-8?B?SzVFbFlKYWI5TmY0ckJFdE9PT2drb1d1UGVvQjZmbUpDTlJHMk5WQzI4czNY?=
 =?utf-8?B?b3RJOXZ3NXUvMnZ1dE1jaW5aeVNVcHRnaVpWU1RTZ2xPek5RSUNMeTV1REd3?=
 =?utf-8?B?SHhhS25VN3FMc2FJL01ZNEVtczRHWU5NVytvSXVkN0Z4MEYwcTI5M2tFMXVv?=
 =?utf-8?B?SERqUVBZcWFScTNDVmhHVnhOTU5pTFNaUjN3RUVENWZPUUJwSFY1dW1nd3k2?=
 =?utf-8?B?cEdzRU5kSDRPTTh3SmJMUnI5NEZhVnBEOUZhTFVEZWNkTllQa0NFM0M2NG9Z?=
 =?utf-8?B?Ulh4UjRDbSszWVhWeXk1RUdxaVNKeVR5Z01VMnpxKzcxMzhENVQxOVNvR1Nv?=
 =?utf-8?B?SFZpQm1RSVVUWWYyWlpOd1FCb09kUjk5ak1JY1g3WWVjU0ozbGw0WlBiZnli?=
 =?utf-8?B?MjZxU21ZS0tuR0ZGbk5ETjUxQnNtVmlNTll2bDlVa1E5L2pzd2loTEVhd0xY?=
 =?utf-8?B?NTBUazZENmluVzAzQWNRSDNwZHlheFpqU3BvcjdpOTljOExvaGw0QXZna2hB?=
 =?utf-8?B?UDQzemhLNjFkdGhFZEFYMDBWdm11dElkTkxpaTg1aWN3OEJiOWR5RkxzRGZJ?=
 =?utf-8?B?SW5CUUdJVHlqL2c2dC9CRE8yVXBLcWg0bmp2QmlOVXg0SVlYKzRZTjBJL3Na?=
 =?utf-8?B?TE9FU2s0UzU5VUxIVkErVFBVdUNjNVgyT1M4REdxUGo5VXdZUW1DbWZMZ1Nn?=
 =?utf-8?Q?mTbV1RiF4QQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkNYNmNjUkFBNHJsVm5PNDhGSWxTTnBKNkVXK2cvS0NhVGQ3TWhoRmlrQlRT?=
 =?utf-8?B?VGo1ckhxMFpLZElJdUhWbHpIbUswTi93dmJBNTBYSmhac3JDY3FZV01IVWlN?=
 =?utf-8?B?U05kUWVvK0p4eDMrdjJQQzExK0xsTS8rTXRrMFEvM0JiQlA2SStvZzhsUUtN?=
 =?utf-8?B?Q2lINSt4YzdyQjg1TEVKbm9Pb25FcTA4M2lHMExvRmJlMXpmUi9yRWJydSt4?=
 =?utf-8?B?djYwc2lMZjg5bEVMblFKRU9ZRHgzQTdhRWxSZlVHNkFPSUVPMjltYm1HRTZq?=
 =?utf-8?B?ZVN5WURQYTcrYmFkeFZ5VUxWTzZvaWxHV2VveU5CajU1K3B3QjZUWU1Tbm80?=
 =?utf-8?B?NTRmUWEvVm0ydmlmYkNZTGpWZlVxRTRxaGN0Rk0wM0c5cDdqUkxGbVFYK05w?=
 =?utf-8?B?U2M0VnVKK0dock0zNkVVVmJ5OE9lV3BpZ2hnTEtLL3RRbmNnZDlUZHlIVm5S?=
 =?utf-8?B?bzMrV1dZY25ybHhSWkJqOFdxc3Fkdkx3cmQvbk93VVpMbEw5bm1acWE0MDFS?=
 =?utf-8?B?MDFUNW10LzliTHZ3dmhBanZLUWw4emxVcWFHSG5qc1diMklUWjY1Sm9PL01Z?=
 =?utf-8?B?ZTVMMmcvRG9xUW85RFQ2aXpvQTV5SVZLMXUvOEo4OFZ2ZmZFNVcvUmk2cTc1?=
 =?utf-8?B?bnhtNjlPUFJNOXdlQ2I5a2pMcWdDVHVsMHkwdlJqWlhKakVYMy9tTzVUVGZV?=
 =?utf-8?B?NTlQVzJPV2pXaFB5NlQrWHQwWG4rd0htRjcramhzOFdHczhCcjBValBiU3VX?=
 =?utf-8?B?TnpkYnBuU3lxVHhIeDZzd0J2ZHNmUitFbjY4L05KQ0JReTI4WDlOejZ0ZzdL?=
 =?utf-8?B?YS9XalJjZ1RWMUM1NURXa3ZzYVU3bGVOVDdRVVRqRnBuZFdrN3hVRUQxWk8w?=
 =?utf-8?B?TmdLZG53N3JkQjBmVzNwNUR6S2trbWpTanBMYnVwaVZzT216UjA4ck1NU0p1?=
 =?utf-8?B?Ujl4ZS9kNm92SVl6TnJaK0c5c1k5d2ppdy9tSVViaW1WVVFXWkwvNmV0eU9m?=
 =?utf-8?B?T09JL0d0WFRrZ0ZGeXVLNUhxM3JNTGpyZG41ekRuWlFLaXVQd2U0M3B2RStz?=
 =?utf-8?B?NXpzS0tiUWNBTjJsbXlrWTE0NER3TWU4SFBWeXRuc1dZdVE3RXYzU3g5Smdh?=
 =?utf-8?B?QTB2eTE1WXJLem9ZWjRtWjZjdFFQcTNKTGdlQzUzMlJMSVJSM0RCNWNjRDFq?=
 =?utf-8?B?anlScWN5Z3gralF4aFdlOTVxMnZ0TFNIZHE3aTZIMEd1VHQzeXU0c0k1SnpZ?=
 =?utf-8?B?VXRLUE1OakJEeUxYbVNCN1hmY1VTOEJCSWtNNkY4TFJSemFqYVRIa0wvN1d0?=
 =?utf-8?B?Z1pvams2UW5FM21tZ3djYlJxZUtDQUJySW42a3NnakEycXFTajJxQkJKbEN0?=
 =?utf-8?B?Q3pydmZ0Wk5ITVE1Z2VVQVdjc0lIN1lkS2d2d1NBaDNVZ0hGd0RiYW9CWXBQ?=
 =?utf-8?B?aXBmRHZuR09wWjZHd3lDaXRUYjBuSUlZNGVSYTVLUDMxeThRRVZyR0w5K0Fn?=
 =?utf-8?B?RXZ2eEtrbmd3ZjczYk9WakhvR0RyRzFkMWVrM1o1NFlNRWhyZkIwMmRXN1Bi?=
 =?utf-8?B?Q1dlM3pYK1liNjRDT1g4QUd0cnRxanlPcjZnVEkvUFFuQnVHNWs5ZlRJQy8z?=
 =?utf-8?B?NzMzNGloMXUxK3JSbzA0TnZJVnRwMnZZTmRWa1FwSTFkUUNTdUlnd1k3bVJW?=
 =?utf-8?B?ZnVLaDJhUDFuYTY3QVRVbHNMY3E5VDZkVm56VFF2UkxpSldkaVhBaUJKRzRn?=
 =?utf-8?B?dEJIbXhCTW5MZ1gzK2VoYnByaUlNMHJEeGdkRm9NdUtDOXZDZHp3c0lQMXdX?=
 =?utf-8?B?ZzNBVnNFRTRxT0RsdnUzYjZkbFlFU2pKSVg1RjNHL2FvT2JDYTMzVFVHR0dB?=
 =?utf-8?B?VW8wMWgzTnZBWDlNT0JpdDFQQkdZYUxLYzYyWUk5NjczQ253cjdGekI1NjAr?=
 =?utf-8?B?bXlKTzZBcjl0SHJGQ3pkeGo2bWRMS2k4NEcyVkRrM1Q2U3JWU3U0OUd2ZkRm?=
 =?utf-8?B?OHhHbWlYWklOU2dSNnJNMUlMbDBMcWtvUnFWS2xTdm1tMXRoaWd6eUxkVGh3?=
 =?utf-8?B?RWRWRkNtM3RDL0VQRVNWSG9zeFRSOWh6UDJuUmtwYkR1aWIvSHFYM3NBT1NW?=
 =?utf-8?B?RXlrQWNTUkdJTmowRFVKQW9ENEtxVEpSUjFLVFpVcEMyYmNTdTVlbDd2M21N?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kZ8lSoO2iCTz2YuLROumZcV8h7PN2neHyxvN30BW+KJIDZrm39bOlqa5bFqMtvsIqYt4v9gH6BO6wHDBXW+m9j+SHdSHCFqh0tq65Znz3MNl9flpHFKCMjdmpEiGTrPG+mcCsZpNZFlcVtxruMy4o07Z6GLJXptltWdcEeNmEUF71+ODC0MVQQIDgKEr0k6BcWlgKMlz7tK0rgVZ4En9ShVvFjl21KPhmpLuAjfds/+gtAMatbDJ6/FBA5WtxLsqiWejrWmenglhVfmHC6ej2IApE4i+03flCb6+TzaydCdc26wwB7+DENQdgtP+7f6tFrJ2QHusHS7ObxNf3A+q1J0678UhZp9eW0vXYwE6BTOwclJVpjGtOTSCpOA4wxLXq0EM7cNsjfBSg3S5OIyyPuCe+tErJA4YXM68uJQeNheDPl7ZjJyVPq4Fzmer2xMDhPi3MKvTMf59iE8CT26J1dAZJhuR+x/XgCgUSgHVMQ7WRE4/81G+i4GHMf8FXpvj6dZbceBKmFYKD+jtSLYuyr5iGrIVuAXFFs4LAfl+213uh+c2Vf34i38hDN+TwRKtU05x8yxXIR8IHk6MazMCMuxEAeEIBYOOvkrDlaLorYU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c177c883-6784-477a-618d-08ddd38a6660
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 19:09:13.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WToTgrO4mJ/+jA5P7pNVeAulup3YRqE573zy/vgYZwtsLBqFrNsQFswa1I7kVlsheaxAm71xZuxqVgQQUVAl7F9TqZ5GTRTknqVX+7FQ1a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_08,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040112
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDExMSBTYWx0ZWRfX3EQZWTaJdJLD
 rVk5dntW4P8rNWigSGEkmEHwF9VKckO5kjOQu4whVJ/v/HBFciLT1BKfil3PS3Y93ICsCWn9onD
 Q7rk4GQzAya7CqxloDal68zLSvyxCKUqQPCiHwHkiEspzIs+5eZgvScfkBaioc/qKCKmwrt8plx
 UnTyUiJYCEKQYtgykKvPwCfroOgXp0Es5HwcOgja6p/Yo/cmwAB2RPtAfESjgm3mgYtgIMx04hH
 +IVR35YbWdWLNL4OH83LY4qLJj9NjXD4PBr9u2GGhjj1mD9iXtIqSXrwGjBPGXZzEHF1PxeHrFG
 HTIMSjlS8yicLK6Rs5/usjicipFEFdiTBL3P1Y19pSRJcOzyR6T9NAhYO5NsVcCE8iosk2IRIsG
 LWJlqaW35vrF+dFS8oxSp0JkuYpILo/EGYQOMGrRw9KiXjMGs2TnQ0vPZXsFh5iHsrpm3YcL
X-Authority-Analysis: v=2.4 cv=SIhCVPvH c=1 sm=1 tr=0 ts=6891055d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=PdlntDmH2kYkbykWYOwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: SNBw9hTM5KK0TTyBrlrUG_F93QKKBwv2
X-Proofpoint-ORIG-GUID: SNBw9hTM5KK0TTyBrlrUG_F93QKKBwv2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 076E320007
X-Stat-Signature: t48mfkx8osf3cw7pcbxqgb1ano1quyfk
X-HE-Tag: 1754334564-319348
X-HE-Meta: U2FsdGVkX1/lGMtuzkX6z95H5mdvIX8r+1g8aX5XG4HaMLDYZcQWQZCDpyn8zk/EewV29js5YZasQgIMR0PKjmoP5URCHbqhMB8oK49Pf3ZK6BO62qUHcDVfDXxDa7aLriSePtjlz5CkM7LBvhIK4RB5eTGkLRn08n/D5cbvNExLOmjLX0eoxF3rNd8G5wft9Z4uu08r0VRStmmXqN9VkVIjGPNXvXbidmizzormMzHpSrQly/F0g8mFVXQbd7W4LuqK3bUgVbCPRvstCpU2C6qvgbhS8sKOSrkoVXbhPdetJn7jAkC1EK6YChrjU8tVLKO2r3O/kxDgQtt6EYBoUEfvEuhFYuPgELk2DiF3lvMvUZBQtAreQqOEMjEKeRj/ypA3x3NiwN1aWlPVbVSsiffUb7/WuLymL1oO4Q7ScJ3fvPhJnm0eEkYb3RzmPGcuvfnZ0wkUEvcSNBQHtoNvJoHPHL9Hs2B3bco6FMwAWwvNiQJaNh96M+ehBrByMNDGgC4L+/LwkObFdT0ncZwD3RFMI8X6jFlTdKW8zcYW0luppOIWIfVDjfmleTc0KV4cPvHyuCzzZA8WY9Vnw61+4GPsa07+Eix/SYFzacXJy08npYqLYUgmPcgD57+e2BVr3Ua8mzJoynvmZbEjq6dXciRCf35VfjOF24NrEJU+PNr/cWt6EiwbkahvpDgV/0ifGqpceyZK/BZt9xZKVFMzAHmhQH+JVLlLr7Ry4Ndl13z5yrrnYAsEVm8e3AV+ftXx0meGNb2KqyEOhNZguLArBh2rAY4/sDBrdMg3tyw3PdnxeCAJGTG3SYAAP1+J2vi/00xXJtG8pc712Oc3SEFH4ZzqtP9k0yqPVWMRjgmf+DBbqcI5vuXVMT/dBy3YJRjZGoXzM40mv7dT4Q4USH5FnaFMG1BAVf9eYspk0WuewjXZ17bVoaNkuBwT27tGEwwBXonwl7b1wf2NoHYUc+y
 uu+sROFk
 9mnp+nqHk3LW7eE4lG1S6QYRIxCk6Pme5LK4jM4qhq19Dog4Ug07uHhqZNlMbfIhC3KVVsCc0X6tl2Rlols+vxwOBl2tuGn+dYPahifS7L89nRF8hPe+qv/eyZiDdu+XX8LbFz2gWys+GEDls++gBlmVnicas34bsP2Zf3e6r2vt2F/KN2KN4HfvWdjdIqtRrLRGWd3h7a9TfzMJq/yOcXQpnBlj44AVBPp8RWbq7lUMFn6nmfiHcDXo6YRFFIDNwBOwycyfYSSfx8T2593e3M0A67ITZsGQ62dSZ+8MVoWFRpJQQkJwrsBfgiJwlU4C9C+zaxCByrCP3QMZ2gcLHgHdme7rLp4oW13XAdidEYqkY3seB1FbpCAhEqzrLU8kooV9f0Y6yAzzdcZcaMTWsrYOJiJJb5qFkN87v+KWn1Kw9z88iJG5NZvWqfXP5aah6Xh3KrWAyrNP8BsAS/JjeytmhHxVet+1wgxDwhy469cq2XutC4YCxiFRxB6MYGSfwSajHZCXSkiFNpCWJ31FqRc0yBV4OLZCaFNqujasjdeuU5V+PMJ8OgMccP/SaXVgo/9M7VkqMb0o9wn14yfWY3gR2gth2uLz+Sc57vKA1sn196csZaEQXJwGo6rmWmA+WFsgoZH/uF8rJvfhMzMAbkcg2rRor3XpF3+4Xgh5OsTdALiaVGDsNRG6gSEVOiQcI406p/OJH3o2vqC8hkNfu183unINF/kRPs0zZeoQD4KuWS/RlVYICK5ZdtVtDY6MbiMBQKMNBhjBlegKCoLB9eVRARpCU+I0gK/GqjerNkYGU6w0J2F3jQsmJelLrjDO6KbTAQeaab98jvzruF7MrLUcMFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/25 3:31 AM, Kefeng Wang wrote:
> Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation
> to cleanup code a bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/hugetlb.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index b16011c9645d..4f73b74a2cff 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1479,8 +1479,6 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>   	struct folio *folio;
>   	bool retried = false;
>   
> -	if (nid == NUMA_NO_NODE)
> -		nid = numa_mem_id();
>   retry:
>   	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>   	if (!folio) {
> @@ -1942,8 +1940,6 @@ static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
>   		alloc_try_hard = false;
>   	if (alloc_try_hard)
>   		gfp_mask |= __GFP_RETRY_MAYFAIL;
> -	if (nid == NUMA_NO_NODE)
> -		nid = numa_mem_id();
>   
>   	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
>   	if (folio) {
> @@ -1976,6 +1972,9 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   	struct folio *folio;
>   	int order = huge_page_order(h);
>   
> +	if (nid == NUMA_NO_NODE)
> +		nid = numa_mem_id();
> +
>   	if (order > MAX_PAGE_ORDER)
>   		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
>   	else



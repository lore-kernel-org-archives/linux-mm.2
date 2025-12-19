Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9246D711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A62B6B0089; Fri, 19 Dec 2025 03:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3881F6B008A; Fri, 19 Dec 2025 03:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C716B008C; Fri, 19 Dec 2025 03:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10F906B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:06:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9FC013B0AA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:06:31 +0000 (UTC)
X-FDA: 84235488582.07.566F64B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 36D281A0018
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:06:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bLj+eASp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XLj16Vp2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766131588; a=rsa-sha256;
	cv=pass;
	b=nkd+VHNFmqJPGt8Rw9E5zlA7ouZhqPjzgZv9sP1a1LMzrzxe/wFkqmG5B/GiP/YIdDyeIM
	AclwRm5+LAZEKeSpkJT1BrN+DggDJagNtLjc+DzaZYjBll4CR9rms04VFvU/EizASJ2hmb
	y5cpnOA53g2hwHVc08QZM7T4POEt35k=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bLj+eASp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XLj16Vp2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766131588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuM6U0KK6b0GCgrT1unFlqwc/XTyopSaSPTspjgClFM=;
	b=VcT6ZpO+roI3kbyqa/bUOKaWg/q3/FqgVuT9+l7PN9W5FjSOJwwMn1Hs9kH6x6kYQtVtwv
	KXup7kOGCCh3lYYFfgyS0NyI1lsQnILuvlprWtv0ObP3Zl1CFmo77ZkOdZJnIucqgZmGnU
	ARX/jinEwshN3+W/F1fzdjxnFPTPjMg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ4NLps3042396;
	Fri, 19 Dec 2025 08:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uuM6U0KK6b0GCgrT1unFlqwc/XTyopSaSPTspjgClFM=; b=
	bLj+eASp5NtBJufTISPKH/rsFhCZN6cZ4RSB/JD9od487cOUMst8XZB4QAsZuzHE
	nYe1Btlq7Q6Lu7Bf2hbR6dP+uey4rA91OC1eIBdDKZFcNQkEAcwpBhwTOM/PGrlr
	IHNzMMFYR6U2647jO42YHtfeFMeqpOEwsKkuTK3BlCTZQ+q4P5vgnPdRWNU3F02f
	Ja+0SQj9Np0nQPzYnEzdeMJz3K7MVgZxo/fYC2/yG+/ZExSCfJXViPMN5MrWOxLF
	1tCdA6iVfEb6m8ziOg/zwkcPrppVLmkxOOShIZRJ96WfSIkST51sKgERZkyt97Ua
	jxZBIKpdxcdP5T19pl4SLQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r288mrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 08:06:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJ7fGOb024168;
	Fri, 19 Dec 2025 08:06:16 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010057.outbound.protection.outlook.com [52.101.193.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtduhc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 08:06:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dE2Y6RS9nwmeL0y9VDGOfgWydBzL0BKIg/mUOzb5XXJDOYbyb5FYn8xvhw88eomqUBMPnCdlyAc6TlNa788b9JLBMMOnfHYM4g1vjYyHebmPvIkklR0EOqNBfkDm8YmVnL4+fg6g+tYW/IQQvH9x/E4nAni0Mjau2GylFcOH1xcUuZIU6b1wPcewR9sAdOn6KUg3IxUvJ1+tG5BDX3UlMAqybqGy+lE36+1kuxtw/G5lt1C5k4oew5d07MAAQBCP2hXpAYHxLIpwta7TgRdIpsDzqlQiRSWM6tX1dsnlvtRSpUBae/tgq0Z7XRto/JsNO4/X3wTSx4RGqq9yvPgNSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuM6U0KK6b0GCgrT1unFlqwc/XTyopSaSPTspjgClFM=;
 b=oMMmbaoe0yvLqYGMC2fmKxWn9PMcAYFse7lYgI7vax1ScdkRrvq2vuo+1goQ//wD6Jg7s9b6EsvrR5EZu05wKAhILtA9UYBCdTpnt+KsLqLeK228KwREx53OTJaVIGyXcRpM0gX+dpkn8nkcL/M9ZjYckGZnjbzGAGbp2IrUk8tMOqRWsUUxF5uTnxgCcLMONSi0/645IN77TBQCvIX0haJ4/a8GY9+wO+ZGbjyAX/KSdZR7bjF9Nz1toGtEChjQXa9sTIVv9hqD4zlCPWSr+7uH+MpXev7x8NHcCF2gNR7WSh8td396LfEKD3+WISJ4e5+pdL2uocjfp8rEyxiUqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuM6U0KK6b0GCgrT1unFlqwc/XTyopSaSPTspjgClFM=;
 b=XLj16Vp2HM7/NRrakhRFdYvVmasj6YjdGUN2l4VBkstiEqvVT8QQii3VXD2zLtpeKzgJktiR6bHznAfAX+VYyRsItnDM6+ALXrnEcEw7zDIaIqnEa1HZyxI9RvbG2yqHBtvuYOoEuSXBumCVnW2waTpwt4dknd2EuW8pEcZI8/o=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 MN6PR10MB8095.namprd10.prod.outlook.com (2603:10b6:208:4ef::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 08:06:07 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 08:06:07 +0000
Message-ID: <38c098ea-95bb-476f-80c9-de9231b9c991@oracle.com>
Date: Fri, 19 Dec 2025 00:06:01 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
 <eade3d62-8102-22a0-637e-ae2e34f11406@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <eade3d62-8102-22a0-637e-ae2e34f11406@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::13) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|MN6PR10MB8095:EE_
X-MS-Office365-Filtering-Correlation-Id: a8eaf86a-b364-4c44-ca97-08de3ed57664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjZqNUVLaXZEeFpEOXRDVUpaZHhoTkorUFlhZk4wSUJ0VnBGZG0yUnNRQm5B?=
 =?utf-8?B?eXhLMUdNcDAvaE40Mmhxb0thZXR0TitzcnAvTTJSeTh6dVJUK2lvc0FKSWVY?=
 =?utf-8?B?Ukt4M1NzMXNoMEN3MW5FdkgzL09QU2N4UFhDMk13OUNjd3N4bDNJWEVsYmJC?=
 =?utf-8?B?MGZHQkk3aDgzaHJwR0xvaVhMREdDSmtHUnJkbU1lSi9RdWozcmxIVER6TkF4?=
 =?utf-8?B?c1didFJ0dENENzNwUkV3NTRMTmFaRWJHNWZkc0NCbGM4NVFBdG51RlYvWDJl?=
 =?utf-8?B?cnFjbm5mQnNUVnpITTVwSHVNVE41bTZZMVkyWUxYMkZRVERQc1ZwR3hzbEo0?=
 =?utf-8?B?bDg1RzhxSDloaFMydU4wWGUrZi9SeXBQMXZGeTcyRmIzZTRTc1lmQkk1bGxj?=
 =?utf-8?B?d1ZHcGFUZXZoOFc3b0xYTXZFL2pDYXMxeVo3RzVZK3Y1aktZcFluMll6aFJF?=
 =?utf-8?B?dU5YSndvMFNXeUFlNy9vT1Fydk1OL2xaVDhPRUlvaXJWWFp5M3dnOTFlckFM?=
 =?utf-8?B?d28yRW9kWHAyUEhudmxxa1BialZtcU9sdXN5SVBmNDNqemxIeTBkNWtEZkhq?=
 =?utf-8?B?UGxjV2NxNDVyYmFkaXJIUklQaFBab1pXbGJTWGUrU2UxWFl1UVgxRFNzR0tE?=
 =?utf-8?B?Q1g2NkhrbnlERC9YU1luWFZvR3VHTzB6dUI1N28wTk5UM0xmZ0g5NW4zKy93?=
 =?utf-8?B?ODRkeGl5Vk5wNm9GTHd1SXpjYTFkU1RqcjNDNkdLOHFxNENhcjQ5ZElVNWlX?=
 =?utf-8?B?MmlINEVscmFJUXFadm1CTnY5dU9KNytpT3liUGtIQnJiWFMzSEo4ZHlqa1BV?=
 =?utf-8?B?QUN1eGlQbUhvdGFJM2ZPRnFxSlhINGpHUFlqMGZyTXdybVpFcGNuaS9MbEhM?=
 =?utf-8?B?SW5oY3kvNHNMNHM1NjFGSzJiQ21hTWFWaVViRld0aFdoMHFxOUptcUxHQkdL?=
 =?utf-8?B?eFlPRDV2a0piTEhVenFiVjlFRjFEVGMyb1FJN3IxbHZsRWdDaVd1SEFzL2F5?=
 =?utf-8?B?QmNsMGtJWHVTcE45K1V5RThEenA2UWhJY0lrdHNQNkdaS2xlZUpwY3FQb21O?=
 =?utf-8?B?Ny9iYVYwUzg1TC9wK1hTUTFNNXprbzFINEhXY21tQkFiaDB4T2Q4bFhOc2R4?=
 =?utf-8?B?cisyS3Y1UmhPQ1RNcHBNczJhem5lbDB4UXFBNXpIUGtTSk9DNDkrVEZwR0JJ?=
 =?utf-8?B?aC9MYkM0MHlHOElKYzRtcFR0K3FNdVZqalFnTmtpUUNLK1cxMExNUi9PWlB0?=
 =?utf-8?B?akI1elBqSEZHUGVSRDRjNGdaL2tmQXpqWnNDWlRLMHN2eWxVVXZEVkJQR1A5?=
 =?utf-8?B?SkVDNzdiaHYwbnVFZFlwY3FGK1J4Sy9CekFzV2lESTUvTlQrVytubHE2cmpr?=
 =?utf-8?B?MnJlVVlBeW1aOUVIeHVic3hQZ0J3cUZrZzdoOU5rblh3dXpUM1JhMFU5ekNl?=
 =?utf-8?B?YUJtd2tJcVhoNHFjL2FBa2JQVmUvNlNDOERBWkk3a2RjMTF0UGVFQTJzMjhL?=
 =?utf-8?B?TDRTckxudmVGMklEVmRqckVjY015UEZTQ2puN2lDUVY1K29RSEZCUVRpRVMv?=
 =?utf-8?B?NGwwOHhxWllzQlE2QXZyWUhtS0RXV2c0RDJTTzVZNldiTW5wS0FDbHpyeTBY?=
 =?utf-8?B?eVR5RlpXTjUwMVhLeFBmeW9CQWhWQVVNVjYrKzRhYVFHWi9mN2RRbFFhR2ZC?=
 =?utf-8?B?dlp4YVF0cFp1d0xndCthOFJiVHFQOElWZjBYNEVUaUpkaTZWb3RnSjM1d0JE?=
 =?utf-8?B?eGc4blBYZTBreHRUQWhsb290dCtqMCszNThKNkdWY0dXak9yZURtMk5Dd01i?=
 =?utf-8?B?ay9vdUdtUjJLaUdRSDBOV0FWODFhb1I2WGVrUnFHRXY0TUZiWmFsdWJXY3NR?=
 =?utf-8?B?UVAyb3BLc25zMjh1eEg0MzVSOE51TklMUFBRRnk3QXphYVFzU0tuTEUrQ0NK?=
 =?utf-8?B?U29yYldnTzdqc3ZkVDFSdWkrRk9kZU90bFh1amdYN1lMVWhOZXczMHR3Mmlt?=
 =?utf-8?B?a2xUMmlwUmJ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFNXQUxYUHpWb0xhbnpYOXZyTjZxb3c2Q3ZleEhFQURPY1hTMHJaQ3BiQmpE?=
 =?utf-8?B?MS9WOGgvSUtPcHBDZFFNNGpKc1RLSU5ITC9VT0NLQmU1azQ3Tjl6THFoV2c4?=
 =?utf-8?B?RkZvbDhBN2FrcEhQOUZ1YWRtakVhU0tTTFRoNzE4ZHNlVStnL2tvNUo0M0Vh?=
 =?utf-8?B?SVEvQlR1UXVvRjQvU2dOaHduNWVnSDd5ejdyKzFvSzUxYm1VdXdEM1d6a05z?=
 =?utf-8?B?VzVTRXdNZ3drSmFvcXRvNEVtcWU2T2ljU21MczdzeFArSDVKclJ0V2xMODJD?=
 =?utf-8?B?TnpPOW9MMkdrN0dXSHVXODZkRkpmU3BoRkFORjJIZnhRSG84bEVtaitUcTRD?=
 =?utf-8?B?ZG9RVXFGcUFyRW1BNzJjUWkrejA5dkVITCtjbGRLT2YyY1prd0ZmY3hiTXlS?=
 =?utf-8?B?S1hVYU45WCtjdm5UQWVZaFNOemE2YTluTWZ0Q2ZXMmtEMGNnR1hVOG93K2E0?=
 =?utf-8?B?dVVrZWVRRjQ2ZW1oZWdRc3k1cVcwaGRQNVhTdjBjWTJSSDgxWHpBVHR0UTJ0?=
 =?utf-8?B?cGR6QW5HOHc1ckxSeDVVM1N0VHgrcFhnQ2ZZMlF1cmxDalRFbzhiQTIxN2hv?=
 =?utf-8?B?VWVHbWprbjBXZ0V1VC9YdXF5NFdTcGp2WE1Fa0FBNkJveVVjc1YxOEVyeVAy?=
 =?utf-8?B?cUw2Y0tmTk5iM0V5dDJJcjhPeE5xNm9iMnJYWXpianoyYWZLVnErUEFOcnQ1?=
 =?utf-8?B?bGhGV2FXb2tHY1dVSXpxK1V1TXhCUkNwb0JNQnN0OGphMGR4YmVDTUZmaDh6?=
 =?utf-8?B?MFREN01tV1RmcUhCWGVsVTlVS0RGQXpkemNNd3cyaW90Z0Y4TDkrc05wRGVM?=
 =?utf-8?B?Z1liUnAwcXI1SkhUcVVtbm1BSEJOR2NwZlpESjRzaUs0bTF2eGd5emZFZnMz?=
 =?utf-8?B?WTFRT0N4bGUxQlpjcFVwODFWUCt3ZnNWZ3JrNzd1MmF5UHZsNTcwY3dQazlD?=
 =?utf-8?B?T3REYmxHaE5MWWdKN0xLRzdQQ1RDZkRic0lwQUtwNW5xMmFnWnEzMlQvTjRC?=
 =?utf-8?B?TSs1YVRFRWdMaEtUVlNNT09KVW5zUEw0R1g0a05hNE0yeVo5amYwQWt5QUVN?=
 =?utf-8?B?bjZQVWVwTzcxendaTUFyYnNvd0pTZU9jbHkwZ0RWVTk2aVZsN2NVdHU1WG9U?=
 =?utf-8?B?YjhidGtQdTEyeks2Y2xWTjhQUVRIS3JFQ0EyOFNUejRZeDBWemhlWUlmWGFV?=
 =?utf-8?B?WXc0aWpkeXFlVlgyL0VRTi9rc0pXQ3hTYlBKSUd3czM3ZnBqZ1piWk5reUpn?=
 =?utf-8?B?akpFYU5KN3RTSmR0Qkt4bEI3Rmx4c3o2YnAxRzRHUW92N3lsS2dJN3Yzcno1?=
 =?utf-8?B?N2ZJVUdERFcvYUZYcDJrTnZUVXV3WmJEWER0M1VhcnZ4Z1pCbjFKeGx6bzIv?=
 =?utf-8?B?S09XSVhpcG9IWXpzOVV5Mk1MNGY1RkgvUmRvUTdHeEZLVkl5Uyt0U081Ti9u?=
 =?utf-8?B?d0tNaHlORmFzWFhqd05TVVhCQlQ2MWswUERnSnE4dWFuMDdwbUQ1WmwzekdI?=
 =?utf-8?B?S1NzNTh6Z0oxaDJTaGd4MFlxY29lc2dSc3ppbnFPR2VPU3daZG1PNU5IemZ6?=
 =?utf-8?B?ZDcwT3JUYkdzdzlNNUZxeVYzUHFVdnR1cllramFwNWRLTHZTSlhFWTRtaFBj?=
 =?utf-8?B?aXNFcGJXa20yWG5obFVxZ0FuTVBvdU4vUHlxVWcrSDZQdmNjSW1PbFI3TjhX?=
 =?utf-8?B?NVRNRUtUMnZodlN3UGJzZXlMZ3RyZHZubHJHc2RrV2Q2OUhFWUlUYUNrMGor?=
 =?utf-8?B?WGFPVFRYY0JKcmRJUVlYRzZFVjZ1K25RQXRUTjVJeThDWW53cGpIR0RscEtP?=
 =?utf-8?B?VWpya3VBZHNCSjRvdG1pd3NrajVBdmg0M3RGbFBia2dCa0lOSzhybzlTbE9X?=
 =?utf-8?B?UHNwU1l1MlU0R0s0MHdkeU1mdHc3Y3BtTW5RUEN6NmlLTU9xR2pFZVZBanl4?=
 =?utf-8?B?NTBsTlZTQ3R4L2VNSExnRG1yRU85enVQRjgzOVF0ZlhOeVhnRFRKS0xidjht?=
 =?utf-8?B?eEY4UWQ3Z09EMXZwaUI3Z0JvNytXcCtrSXlkVmt1am1JSGs3UTNpUk40STR1?=
 =?utf-8?B?dDVHZHkrTEtxK1hDNWthYXRuK2trdFl4dUl2aXA3ZWZCeWdiSllEV0lKV1Fw?=
 =?utf-8?Q?K6qw6XAMOkvm3397js/D5wO0Z?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uJkHKmDyocSCx8AqY7DYrLPPHNUrNjW9797TUZhZVmoDZoCVSZaSLoTa4CfRXa/Vdldyf0wkwCcJoHtZI7uZ+BgWlw9vHeQNTFw8t4P3sepUc7yDIBRf6+VAjRs5CwFSIEDd8faiGAxutOD6Fn9eoROTwprB+N1NAvJIx4KM5TLQwsHv8meJlO69PUyqcZFPRYp5xWrCJGa/cZyLxTeZijz5XQwul2HAB0093CpohSVutEl1EuJ79KQYs83UfjEGM4V33r+JWtWo4KfIBYFn5oJ4UFnscUTLqEvCx1eICJ/qizG8GDcWy1NFtWhxwcG8mrC/dPiUgvvUw5dVubKTBVaTIGll2lrAzDE/lhJA2mzDdP+2gZPzINyCr/6hJaVfrESC8Rud2qk0C2J4FLB+ukwQzdfvovp/F+LiM9vVGhy8KfgmTx8vF1tAMGrLrML3lTQgWwLVurEi11nrTj2RX8yF3ai/oljju/eDe6V1PScoTtvA/A7SWXVm4Odu6QQ4sfQekfX03orm1J7DI0gDyclEYO1E9iNkBQyQgTtoGQpXssbBXo+T8vyCMf5p/8zeqNm1QTPlkiMM0MWtIfhnnFFBlDAlGBXQ8J4ks8hE25o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8eaf86a-b364-4c44-ca97-08de3ed57664
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 08:06:07.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +XF1ao+OVOLIwfafrS1b6cJ8ARWeX63CemOGSDvDiW2O1t9H6ao5WPekWqBK+Hu/F2n8Tp12Lgn3VELzTXLJgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190065
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA2NiBTYWx0ZWRfX48FqEUbP16wA
 8GPrePayy9UPXd7zhDBq6v2bQfndb6KG099nyB1LuGaZpm73R5zN8bg13VUu5YPxFj2Aq3vDCxb
 AEhhVhV1D4a9VQTj8umLdHX9X8qzvO1gjmzUJejxSgqijPv/kjUu9RGYqiLV2xV25bMqM0/QoLW
 LONO8kMktLgEUitW4kDPanlyUS2M9m4cHiab3/S7XuAFAYoxjBdEuW0J3+NsSnylCELBOCWQ+wF
 kUS3WueAZsz3qPTPTKNnX3/OuVJd0SqSjYIUvvKOzMicCWJSowvl8d2KFaPOR16oKasL1wUZTls
 Fc9k5f13RyEH4Z+XJJBG5tHgDcC6yLLDlSWeZsYFMQPNPu8aMpB7Tq3JQsla8s6euX2qEgd9HIj
 IXLcVlJY3O+5sGdMW/YiucCIdzYnwpvw2Ct5uVaDf4E3OtGpDhXUuOBS/6Tnmt1GNwNdQD/klnD
 Ie8OOVn4bA1aO6lC51Q==
X-Proofpoint-GUID: BR5cim1NB12bBzBbsjFpgrWOfZbSOlu_
X-Authority-Analysis: v=2.4 cv=H/nWAuYi c=1 sm=1 tr=0 ts=69450779 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=5Zckf8guCu-V8f7WwOkA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: BR5cim1NB12bBzBbsjFpgrWOfZbSOlu_
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36D281A0018
X-Stat-Signature: k5kznb11y1mo8tg4wjbxtwf6cpw8kwn1
X-Rspam-User: 
X-HE-Tag: 1766131588-691391
X-HE-Meta: U2FsdGVkX18FmTE1TwVzjsV/RsS2H55gH14p0EHhlqUXv7N4LnIf/QEDMVjohnoaapKdGkwNKZwAErC4AnKzyw6JrJRU90QgtfSUv0ybAoAQ0ey9S3nMhLR9bEnCIUK6nKy9ORtMQnB6QeWumdjstDCnRft4RpoitQsyzEYMpaiyqGKYlONy0gUZ3CBB3q92iwt6rAFWf1mE2qPgXhPnaz0OCTBQ93QmsksNMEiek0rEIqXJsgKOU0V1yIUJXaafZjy0c1scwKii9ALN9FTsYaB5dplouKJ0Df3yWMO3sCwBPkkHc3HkpF8XbDHSQlHJgNEnH6bKDAK/A1+day0MS6Q6yOj88x6awURpIKXXL/PbbH5vFzNMjLfERWTvekPyP2t5BvFCJ+Xzuu1h0IpraDR97GLlSw/MHFyXuMPOkpNayLIsv7N62Bf/7BNpPrB3o3wMdEiOk0EbdpZadC6b+SDGrfXV0xFzZPXQRxHQmQJMgwWX8eP5vNfKh90OGGvlN04PBW72WpnC67IylJneQ/FkC//j6C2/Y6kcFZPU6JTV2fBdQlM+adakr7+hGDqm9ZJFljkRN6+K+/gJ+MzBfOp7GnThW45QAxlWxO75dhTDOS+xhYhsHx47WY3q8STzWIybnFms0RrHqVywgxdBmL8nXF3klF6j+OmS8+gQw8qzx+SlkEbEFu00b3dmUTXpHLqnmcyW0R9yyom6iuaaHPXdTRG6z9SX9YGYczTDeG4GsuYfuxsClqMYFQ8tMJXojgnxttgK+KO+XWOhgtDO2t8EAzD5StoHrdKMBYJVZn+NjyN7df8HbS61Wz5GPz8GBtWkFdqlqb0NtU0Zxuy+mLqnLMBtxvCsDbtOfdysMYvCF0uqffqurAHZS9aHdNN79KEZ9vQ0BcNqzNytklBQ50uV1DP3qiT7c0wwy64QD/xsVod/qo/+/E7rSg1h+FTFIapwlSFZwctWJGKiSiv
 iuPfIzFg
 Ggb5lI4kc1kf6ehRMT67Itup6JTAKUfdcCe/3YioZxrN5htUBvfY0t6wp8+jC88Ly7tJajZtEmsaZXd47ayGziKnyv5lgBQTUzGpQOGlJIL0BmtDGyyJ2RFUNTGyad7/WZG9AsO7UFU650lDwb8c0CE/+I0C54Syi8Bm2XNh7/MrIQ2BB+FbiLCCum+E78+PDH4ag8zRRollo+ok94D3szkSj/ioTyos5vcmz2xH3zUT1aKVhwgcrKf34QYqm+hFgyWIrNL2AJPOTAXg3T3X0qihFojpznzNormoc+lv1a+5OUtlG9eHZpk5irqJ80HrTXXDns7oD+/BhOQNShPs3GxgSHeP1T+B7STekoOUErcRNmAL3I7lkG69JGPcwtgVdpOH9aoufrA3L0QMBuSLQJdLm0KcegDHeQRyrzcEwgbIy3ISvhh+92KDJHxNgUjOIGl3fBqS/kGV7lryq3cwG8ENzmOrd0bQos0uNl0g9f4WiiZyCombpVDB2yWZhDKooyzLPFJQypXGwPmdkXlnTfuRVjuHvilNMPIqMjac2vA4fBLIGmuGKQ48evR9nc59zdLhtQ+DaTxuL39G/BsIO6HprVlTHJV056D91SIsn6q9FLtNo8J4GVpZWy7LHvD2DSYqFcTgo5AIO5YUG08QBF4DJPx9YkcB1BF9ch7zQUkX71IBAIZaZ97/5BS8LzF3Ca5+paINZb8Du6MyXr/hDiw4DKxyOmu1HfpTKixv6iw4ckda9ddTsID5tR8Cys18po452I0lvtWMGkufx69AXd4xqBUJeZjLVsKh0tcKWDlMmHvvo/Vqy3gCBUE+D+rrfV0lpkgdn+y+ko1slm0CFrkpqEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/19/2025 12:01 AM, Miaohe Lin wrote:
> On 2025/12/19 14:28, Jane Chu wrote:
>> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
>> passed head pfn to kill_accessing_process(), that is not right.
>> The precise pfn of the poisoned page should be used in order to
>> determine the precise vaddr as the SIGBUS payload.
>>
>> This issue has already been taken care of in the normal path, that is,
>> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
>> correctly in the hugetlb repoisoning case, it's essential to inform
>> VM the precise poisoned page, not the head page.
>>
>> [1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
>> [2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
>> [3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/
>>
> 
> Thanks for your patch.
> 
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   mm/memory-failure.c | 22 ++++++++++++----------
>>   1 file changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 3edebb0cda30..c9d87811b1ea 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -681,9 +681,11 @@ static void set_to_kill(struct to_kill *tk, unsigned long addr, short shift)
>>   }
>>   
>>   static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>> -				unsigned long poisoned_pfn, struct to_kill *tk)
>> +				unsigned long poisoned_pfn, struct to_kill *tk,
>> +				int pte_nr)
>>   {
>>   	unsigned long pfn = 0;
>> +	unsigned long hwpoison_vaddr;
>>   
>>   	if (pte_present(pte)) {
>>   		pfn = pte_pfn(pte);
>> @@ -694,10 +696,11 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>>   			pfn = swp_offset_pfn(swp);
>>   	}
>>   
>> -	if (!pfn || pfn != poisoned_pfn)
>> +	if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
>>   		return 0;
> 
> Can we get pte_nr from @shift? I.e. something like "pte_nr = 1UL << (shift - PAGE_SHIFT);"?

Why?  Is there any concern with using the macro pages_per_huge_page(h) ?

thanks!
-jane
> 
> Thanks.
> .



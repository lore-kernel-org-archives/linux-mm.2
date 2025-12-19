Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D92E66880
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E51E6B00A8; Fri, 19 Dec 2025 12:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1988A6B00AA; Fri, 19 Dec 2025 12:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045F16B00AD; Fri, 19 Dec 2025 12:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E61976B00A8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:29:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F299B7141
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:29:37 +0000 (UTC)
X-FDA: 84236907594.30.B0122B8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 22C39140015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:29:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fn+tnQyg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wnSMvEzU;
	spf=pass (imf09.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766165374; a=rsa-sha256;
	cv=pass;
	b=wQsDkH0fGdlmqmFIHhdlaageaV9u1ZryhMsT8kmAHCIr+qGYCAz2IldyuVhj8NWuarXBxG
	SsvfqalfuuvqkvIgtGwbjLjLEo5SjG3/cK+/t8zzbto9YS8Iz6aVnvObW8qfA8kg9cFbpt
	4tLmFtbhVeVuoOJTEZ8WtyC6BtoU0qI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fn+tnQyg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wnSMvEzU;
	spf=pass (imf09.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJDrPs5wqjj1QYvxyny4VYHVtHpOH1Onr8nPIl0pvKg=;
	b=PxntAfKp1SotC03IAGp3DYSfF3zcp+S6jM87SWaPyG3KeWQBo5Z+HKrQq30934wehEXMdm
	GEzfistbfxW4LNQPdvcmbEAf6hEiH0+/3GtlR7p7RQtJwIZkU16W9hSl79BX0Z2Epvol9C
	qS9WNeg3Og7n+FcE09f8n1eaWn9w054=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJGOshe3120766;
	Fri, 19 Dec 2025 17:29:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PJDrPs5wqjj1QYvxyny4VYHVtHpOH1Onr8nPIl0pvKg=; b=
	Fn+tnQygu9TIVM1IEN0H1ztpEXFOLUXXMm/i8Mj2GicJoxw0l3/beVfE0g7NhdSF
	S9Mw7xKQfxjfGmLEh9mvmjP+p3Ti/6VF+PN1/LG7iZdngtOmUvYnFWHb8t+hhLQy
	/c6EOWnTYtK/Ud7NKX9zVp+sNkUH3XC19IJlpxJooLiBO+fmAQV4/8SjZCtOkT0H
	HfJS5IxTV35gZvhm6MyZzIUak6BF2kP9m/hRAU100zV0Tj7plNraN+0eorw3hIuq
	BUO137IMvPhmFKB3G379pwnRsDQBkFGvs2+spllf5XMuIAR89i2TU6UmVInO+rRf
	40crSq4NSr+weXvtFokYxw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r299gcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 17:29:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJGVk5t035208;
	Fri, 19 Dec 2025 17:29:24 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012045.outbound.protection.outlook.com [52.101.53.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtdrkwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 17:29:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cej9surpXT86sR0BBXmMTx7WeoX6zYRMhZxIzEHJkHjYyftSwbu845EwJpe7Tvp3GO6sPDbXWRLXdnqbKAPo16bpc03aAQ25dGUrF3eQQXbxwVNhlpQTAI4lcfu/Lj0RN+6y6JpnJ+wgD6VIfegWqa+J97WWVXQdHyaz5DaQ2tdraOfMb4QGHvNawCyY8Y9J7hmAmYi6M+689N66CKK1lFjfU7RCclWDMJedCTiQrsNTie6dahBav2fBoUAh+s6nbwlYCvG5Yhfw8SXbZdsu+o4fyLXGCH3xl/MtE0dDU3qHEPwOPVf5KiW8w8UpY0VO5FHt7WlMu7JCdIsnr9UR0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJDrPs5wqjj1QYvxyny4VYHVtHpOH1Onr8nPIl0pvKg=;
 b=BhtkQqJ9yop4352+Vw7MGvLcl+hZ+24kwQeOCbkiyNzAujSswnDwBxma79lIO7z6VYmCWNQQRwEl06V9r0p/k0O6TcPSkG93mTBaxAP3pmXNjPOwAk8+ctfYxxHuD8daeisHwHGli8SHO0jzE0wtxMG32O5KK4olTE8l5OS9UFaeHBtiCD7ty7TB7Dotr9LdbfkMKyn2Q2R883TED834NJdLDtsxnyH+BJCYutKxn8vqfl/MahxJ2adCpMcv2eAHUeXCcC/abSGNRWNVnzJ5AVcNS+TQLPf7TZqgjopM/2Z7KuHXWo4bOf2Qj8Dlnr7J1cp22ix0Y6dbPSt4EI7gpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJDrPs5wqjj1QYvxyny4VYHVtHpOH1Onr8nPIl0pvKg=;
 b=wnSMvEzU73T5Fkzvv2XIp97phDwEdyMH9YnEbiCsiztTAEZXCCuwoi8zoVDHcEiDV/gZ4tlmC5rCK85PQ2TO/9aHgzKpognF6Xad4spjz7L4lIsCBthiE369RT5p268AfR23ysq0tiDyCFfIpk8dMs2wmOdO4nSuO1Caz6q/JkE=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DM6PR10MB4331.namprd10.prod.outlook.com (2603:10b6:5:222::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.9; Fri, 19 Dec 2025 17:29:19 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 17:29:19 +0000
Message-ID: <885df351-63c2-41b1-a934-638b914771c9@oracle.com>
Date: Fri, 19 Dec 2025 09:29:16 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
 <fl5lkxxvlsyeur7e7ls2tnsh4afzyhvotoaluxcv2ge2tm2dp3@7vf7xvbf7mkp>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <fl5lkxxvlsyeur7e7ls2tnsh4afzyhvotoaluxcv2ge2tm2dp3@7vf7xvbf7mkp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::35) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DM6PR10MB4331:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d10e4d4-0e06-4aa7-faae-08de3f242442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUxNNXdNTEQvTUJGQ0dCQlJmcXgyZ2svTWJteVZ6cHpxRjAvMkp2QTAvUFcw?=
 =?utf-8?B?ZXBETmQxS3Rqa0k5a2VCdVVWa3FnZi9nSVNlUDNlMmNCKzZJcElEWUdERHYr?=
 =?utf-8?B?dVAvSVIvVzdoT3l2QmdBZ2l4dDJORFkvTTl5ZWtJZEQ3QnFPZjFaVkFkWkxD?=
 =?utf-8?B?bUVyMGJ0NFd0WUhrcCtJSVI2Ukc3dHJDaHl6MnFicjMwRVc5R0Y3Q05UanBB?=
 =?utf-8?B?VmRLV0txK21keUhYQVZ5WjNhNmpEOTczZk13QVpGMXpERitRRTl2VmpJUFp2?=
 =?utf-8?B?M1IwV1lCNTBwVEhKdm1WM0Q1ZVhiMFNhcUZMQWpOR0JMR1hOU01SWFloVUdn?=
 =?utf-8?B?QnFPWlRKWG9GS3VvY3JMdmlmMVY2RW9Sdll5RWIrT3FhNWFuRFdPU1VBR2Rv?=
 =?utf-8?B?Rm02enJrQzEyWGRDdWlVL0ZJRG5INFY2UlVXc2xPRXQ0SnErNkJhd2VZL3Fo?=
 =?utf-8?B?a2k2aWVyREswWXd4QVNtOEF3T1dOOGxGck4zZ2VDbDFsVEJ1Vmg2RVFWKzV5?=
 =?utf-8?B?QnZKUFVXbWphRWNtT3dObEpxZi9WRUpRNi9DRVdZWEJqeUEvTzA5YmQzS1Uy?=
 =?utf-8?B?QlErdFJFQXErRnA3aFgwYVBENGxCL2xQcW9wWWxxOFFtb2MyK3AyRURZNTBG?=
 =?utf-8?B?VkxYanU0eXhUM2hWay9pOFZYV3dLOThEdUV6TGdsODdFbkJyL1k0RExHbG9t?=
 =?utf-8?B?ak9GR0JRRnVmVWg2Njk1bWlzMHV1MjlYdWRqZVJmR2pXNUhpR1huZnlFSmo5?=
 =?utf-8?B?RkJ1NmlDaUJzdWRJdWV6L1Zsa3VMNm5ldWFpUGU0SlJYaFFwc3R2ek5PMjMr?=
 =?utf-8?B?RGhaTXBZb3p5M1pVby9uNEVvYVNzYUoyWlJHQ29sQXFJbWF2ek9XOGhud3Bw?=
 =?utf-8?B?d0Z3TUs5dHNPRW9OYnVRMkVXOVFnSWVTWDMrYnV4OFRyZHZxMGR0TnVRbjFz?=
 =?utf-8?B?ZUdvT1Y2WnUzNnltVHFvbzB2Q2JhdzdaWnRLV09ZWUoxL1lYOVpSZW5hc3o2?=
 =?utf-8?B?UHozc1RNVmNZWjhuc0tMNDE2RXNOQnlIdWQ0ejFrSUxZdG44MmhRY1ZTNTB1?=
 =?utf-8?B?TTNZLzZBcnVWSUhOelRseDJwQkt3VTFaMkpaYmhZWG9FNWg0YUFlNnBYdjlj?=
 =?utf-8?B?d2VHZUV1Q2ZjcW9mYTlBQjJOU0Yzc2htTXUvV2lUUnZidEk5eGViSVAxYjFo?=
 =?utf-8?B?bnhJckVrTUpZMThQcGcxVzFSRGdhdG1vQml4NlkwMW1TMHIvWDBjbHQxS3Y0?=
 =?utf-8?B?WWZxcmpyZG9YN1Y2WHcrWDErUTBkMzU1SDVqZ2duUGVmZ3d1aStEQjk2VnpS?=
 =?utf-8?B?VVZQQ2dkZUcvVnU5WkNST21sMWppdTlseFUxL281YzdhNERWL2R5MFhReVYv?=
 =?utf-8?B?V0JvY1pENFVNc3NqUERvSldkbUZBK3h6QTRBNW9ueVZNdnYyNUVKYWI4ODE0?=
 =?utf-8?B?d3ROeEZBelZuZ0syeVRoV1NWNG5rTjhYa3pZWFlNRVkwVm1DanNqWmY4aFc5?=
 =?utf-8?B?cTJSSHV1WEhKSytJV2pRbE1nVkp4TWxFY1VnbzZMVkRiNFNLQXhvNHB3NWpK?=
 =?utf-8?B?dG9GRmFJelRHZFp6OHdPNUpyMmYrdURpOTVrYmFKajhJbnVSdTRQa0dtWFNw?=
 =?utf-8?B?VEVNY0pxeGVtdExtNmRvZE5TZmhPb2lUYm4wVXdxZjYwL3dMdVVNNHU5SDRR?=
 =?utf-8?B?Vnp2R1Q4TG1xcXMyQyt4TGFnZ1NVQnBrNGxIUS9EbzZ5TW5KZENoWS9qNFB6?=
 =?utf-8?B?Y0IrNWdlWndtejZqYUtJWXFWV3BLQ1lhOFJsTHFOUkhITTlNTTBtV0pXZU9O?=
 =?utf-8?B?UFZDZnU5VG5ERGMyNlQwQlVpL0daTTJXaFdOUHpBMjBCRXB5QjZrVTdmMzlu?=
 =?utf-8?B?UjVPaHR5dUdiaG5pY1pFbjNQK0k0c3hoNTJaVW80UTZYY1AxRHg5OUFQeXYy?=
 =?utf-8?B?TUVXWUd5T1pRdUUrU0kyeG5KL1NQM1cyWGFnWXVuRFhtVDhQaDdRYXdWUTdV?=
 =?utf-8?B?TVdSOSs5dDlxL24vV29Vck1kWWcxc1dXTTBiZFlla1RSMXphOWpMb1dEcU1R?=
 =?utf-8?Q?uPbszT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWRjOFBOZXZKdlA5ZlYvWmhaeTVVenlyQVZUbmFhY21hekFoS0Y0eFIvVVV2?=
 =?utf-8?B?bnE0dU5mTllmY3BJY05RajB1bjJ4aGEvaW5ZWHRNNDhWMU1lZ1k3aUVjZE5C?=
 =?utf-8?B?MkNJckRUQ2cyZFdXQXpma3IxOVBvNUxwRWZUcHlSZVgyNkxrNnRNU3dNSFRr?=
 =?utf-8?B?SDVHb3ZCM1JvYSt0UWFSUFRHNDhWYVlzTEVEak5iMWJHRzNPSnJFS3F3SEht?=
 =?utf-8?B?Qk5NUWVDOTFBempLcXdBTW9qYVpmWFFYREtSSitBRzk0SjZPSXIzQVpudGEx?=
 =?utf-8?B?Tjh2NThOREZmdGZPaERJelhXVkEvaE4xOHdiSEtiQURNODFqanFNVDZLWmN2?=
 =?utf-8?B?YnY5ZUYzY1F3K1cyVkZXL3NVVS9BMi9tVlBJQWswamZKQ1NyZ2pXTUZjQ2lm?=
 =?utf-8?B?VnBCZkYwb1RIcisvZWV1ZS9PeCtKWk5UUm1Kd0M2VysyZ3lyZU5COHNieldz?=
 =?utf-8?B?TlhyRVZmbEJSSnJuaDVnb0taRkFiVEZXVFJ6aXQ3N2svTHdnUVpUdzBTcDg4?=
 =?utf-8?B?ZUo5TDdWUk0rYnFCbG85VTFnbHRhUkg3YTVBN3R6ZHVlQXJ6M0lUUStYKzg1?=
 =?utf-8?B?bjcrOElQSWRKdnB4VllPTjU4WmxUaWxSMWRVc0ZMTTNQcGI5TXhuQklpbUpt?=
 =?utf-8?B?SWR3L3J6WHJTYkRuSnVWbGR2a3BHRm10Vlc0LzZwTG1IVitUUGl1Vzd5ZTln?=
 =?utf-8?B?ZDJQU3JneUZPb0RaVTBVdnUyWlNqK0FSc3pIQ1RnbUo0NUNkVjd3VXJpVU4y?=
 =?utf-8?B?SWNBczB5engrQmJGcXhhV1FNZnJOendVTnQzTFluVCtuWmlDN3ExSk1iQm5F?=
 =?utf-8?B?NFdza0FRbm1VL3haSEttRUFua1ZqNG1KNkZpZERJcjVJYnZNclZLUTI0L3hy?=
 =?utf-8?B?dVFrUkV2eVg1a3lzYy9vckNuVEYxMjNidjVOdldKWlpUYXBBUXROY3ZKUTFY?=
 =?utf-8?B?dStMWU9EY3kwcVZCeVF6ZlVHRkt4WTdKOENPTUFydVpVc1RHUGZ5dVpIUGVw?=
 =?utf-8?B?N1dlYm82OFJDRFFkbzdUWngxSGVVL09KUjNsdjdVQjlUaWZXNFEzMm9tcC9v?=
 =?utf-8?B?N0MxWHhqQUxvN051SUloLzVyaGFtNlltOUM5TXdORTJ3aDFWMFp5aFlLOFA1?=
 =?utf-8?B?d1A5eTBDZHVySXRPOW5XWWs5OWd4VGVRaHBIMjBGYjM2ZUViUEY4cFlMYi9n?=
 =?utf-8?B?K2JycEJlZ0s4N1V5UjlRT2Q5UlA2WnVYVXlQVGpocndyS25HZ01zV1BkaDY5?=
 =?utf-8?B?ZFoxRlFMR2paRDJXLytzS1BJOW9WNWR4RG9xNk1KMGczdEpSTU1sSEZIT1Ja?=
 =?utf-8?B?ZkUxbXlhRlRnVXdrcXdaMHJvaTM5aFpPUHE3TVpVdnZmYUZzVjBFSG9tM29C?=
 =?utf-8?B?UkJaZXdjeWRma2VjbXF2RGRqTUxWVkxRR1FjQzVsSFFScml1MnFkWVJtbWZk?=
 =?utf-8?B?UDRIandZMGVRdWpyNHRQdC82KytldDBndmtoRVFoWjBnSGNJcVlITzJ3R294?=
 =?utf-8?B?NS9kWUtzZWhVZlJwMUZCSFAwZzdWNmlCTEJvbjdFbGhDVzNwMHhuRmpvNVZp?=
 =?utf-8?B?U3FlOVF1NDcySVUrcW5ZTElVekJISjFkcGoxc0NvY3hzNHBXbXRUM3UvTWl1?=
 =?utf-8?B?UitLVTNVeW11M0xzRmdEMkJWbUIyN3dVcWFsU1h3dmhGVUZ4ZURuSEtBNE82?=
 =?utf-8?B?TXVuWnRCVGFQS1BaN2pVZjBDZTFYdU1TWmlzMXNaUVh3bnE2R0MrQzhFTWxX?=
 =?utf-8?B?NXQ5L2NEQmN3NjZmUkFWQkk0ckNXR2k5b25TZGpsR0tURXJ2YVZ3VHFDS3pZ?=
 =?utf-8?B?Y2VpdWxzb1RUUUNNZnR2b0VmUE5iL1hXcndEeGlPeUxuYzRmYUlvenFYeVgr?=
 =?utf-8?B?VzNIK3ZNRGgyZUxrb2ZzcWVBTWhBcEhtdnorWitiZ1MzQ1MzVDFnVEhGYVpn?=
 =?utf-8?B?MGdLWlQxSUpydjlvTVI1NnlmOW9OSEw4TVVqelA5dXVtVSt5MUg3UGJDWjRK?=
 =?utf-8?B?bGZ3VkRoakJlUWQ3Z0EzRTgwZXVQVWxDdmNrQjVkc25kZGZneDN1MS9BUzlM?=
 =?utf-8?B?WWlHSWhENTl3aDVYSjIrdDdzM3pnMk5lc3c0aEt0dUxCNTNVb2IrZGZWWi9r?=
 =?utf-8?B?NkNJUjhKN21PWnk0ckl2SE5jdllJcyt5T0l1d20zQ1FFUUpZTVFtZEJXZTh1?=
 =?utf-8?B?Y3VvUEVWb1BWZkZMc0g1Z0FtSmo5M3FmUHZWaVJ3Zk15UVZCcDV3T3BDelBO?=
 =?utf-8?B?dUw0M29JRHMveFRyVS9BRGZad0xZUjVoa3k1L2gxWktsOVdrZ0FXTXZGQXBU?=
 =?utf-8?B?cHFlNDJnc2g5b3psV3VBWmEwTHhaM1N0V296K0V1eWIzSVplSEVOQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hPFeCI8tyjkERY+fAeqS5tH//GVLGzrrBIBd34GvjMDbtTVwGY7/2PVlUevXBRNJSCvfCOmWgboGqmNW+gCcEfxYWLoEDkATz9HeqQ87hOeaaUoObbsPye84466TOJgr9Mc7zLOkpSSwK9a5HEyFSd9HVe0hL5SfUyzKhcNTWj/M+MmYre4YheUibPpuc+c3Hqj1PROQy8P5rsifY7dD0JCIHEf45CPy1Xa3DRQ3vkyJJvCXBEQNNkMlK93oXZ8X2PPQuZjmf3iYU5qREwbRdF1MXgK95qxvlUC7SyYVxA3gDcl7ZTO73lt3dQeFhWfEQLu2kL431bFw6qTlXZBuMeDCC4hEIgzswobeMnEaPuXUghO/FerHKemenNVD7JNbaQTHwtwDC19e2QvMb/udMPuT2lR6F55EhLe7qVZkPih3GFDrG4SOuxTUXYqO8GSMs1QqqnpFkJiYSAoZ8fvWb9zs/7VIiz77K/cM2uKBC1+qq1YZV1G+nNZI5UTPnRbcSr5ciamrLafE/JlW6L+FLEe2o8wzmHHaiQiNC0beXLTmaje9AYMvhbC6V8+zdBR84azQ5MeXQ/dhp2EIlqX4oVAn0SUwOVDC9nRh1VZWRkI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d10e4d4-0e06-4aa7-faae-08de3f242442
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 17:29:19.4845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tW4O5fIXCP87I43ShKiuxBfba2Xs+YZ4tU1QvCuvKmxOemDFhvnLsRR9XIX7TQx3ce7/Xh3YkN/ObMwUh8YFLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_06,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190146
X-Authority-Analysis: v=2.4 cv=Ib2KmGqa c=1 sm=1 tr=0 ts=69458b75 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=LY-XGDQcbaNydRAuD3cA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: FsA8aahIXscblE49gS3b8xRMBXiGL2gB
X-Proofpoint-ORIG-GUID: FsA8aahIXscblE49gS3b8xRMBXiGL2gB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDE0NiBTYWx0ZWRfX4sgJ2ZfcJLvh
 72bRTmSX4qYbGuaUINEI9HuanrLP3I5WtQMnKPSnrUbKTrtqW4XERAtfTWEeGTCM4DyrIPSxh8g
 npyqnzlQFGlqRPSjg9yqoUrNkxFQ99zXoRi/mjvePtNR1tvGRo4jT7CyNWycu3h6d4ih6AlFM0I
 X6BN2zYO378eASYIqG/Hs+JN/TK3Qz2D8mKYQJWEVCmTRaQv+uEVsm4oB6lVcLt2jD9PqZtjEN7
 zDTMlNergX4RTvCU/Xd2qhzheLy+32HCY92M6HUglDK67DV8fAx2N/t+Ttw9nzekZ+pNWGRa7pp
 Cx0/wWM+hgjcsytuEaz1cGRHKmWMzeprYsPZdkbM4kAYNgCcsSQY564jclusobGuJixCvbaoIAs
 ucN9i2BEAHAsMSyXan6tlfCkBSBuH1vWInn/1E6Iu00YoYd4xtj0oJWWUtHAxsi6UhS5r+ISQBy
 DArhDnoVuePKi9o1NkQ==
X-Rspam-User: 
X-Rspamd-Queue-Id: 22C39140015
X-Rspamd-Server: rspam04
X-Stat-Signature: qcnc7545eskptqhghyjczg9n67jiqtsa
X-HE-Tag: 1766165373-860324
X-HE-Meta: U2FsdGVkX1+cAEjCbq6FThn5r9qGhhmMn0yLaIKWuVYYCL49c+NS34gZEMP0VNQDldBWep1H1W/KYJVpvtLHz1kJf0jwgm6DSyLhHJcp3Qm9Jq/zSwAHhGCtdhN28A9QJHn9TTdyjwWDZyM29C8mIQR4u33FOidfnh3sYrsbUdHCNPnJ7jgTaWfieePT/gfNEejHSXW4q/9T4zOEGBBxJ4qu52v91T/ACLNnlrE1xoL2EbTN9Dv4tCM1VoHo2HrTa+b1lYMIccyZvYdQ9Fe5Vb3uzkWCnGIcipKy6VmY45q6aGw/ILIYKZX2T4Gbrcd2Cf8OBrNqfThYWYkjI1dYVzZprlFJ/jQ/WukGwJZyh85VJpy3f7p7isNhO8SZSzAqApP2JgyJLi8mnvyrM8CyRIVLa+E7rdCyHTuvH1mrOwRKr6bgJfJhsPTt7+BWAVXJn3csV62rHU7WFQeIx3gZkjwcHFKUezFCXER9G+9l+yWUEZWCMzOJpA+LhgAoFOKSwEHPvGF2reabZjge63SlBhFA/7HKTEIhpBpDSyb7H/uhQBIojzRi3Dcub8gI0Ogamc2amPdIh8YdtDM9lMXQS8X/Q7oaeJjntVKy0fd46RKfpnJxvI1OClPJgEc6Op5EMPsVVSrgv+Q4XBttTfMx6g6DHAVVki2QUfm18gqL4tPyWKDW1oEra2JcmV2KIc+OtJoahD0NAzmMdOsa0lJ+syXsMnxb/9bEO8OFHVgSE2rg6bY27jylqwM607EOe5ValqrybIHDdqHg9NVYoA8dOHRWxaBkEB9TVuKbzOdAt3qbStwu2TeoIrtOiy8l11QzR1WsNDWgVHXIjG3pQviDv2pQb7v0wB4VhiKWsuxIlUMeiM+N1O9aZG4JWHoCqPi5FEg4rHZghlQhnVFGjhdOrMLNpSm9LAMpJKCedrc6idFU6Bm84sRkzSn0XtGPiPX9PYPnDzFDi11AjJxjEud
 7fL8Bbd+
 Ur4Xwk0iLWWUUHpCW4f9imMneQuRA+dm8j+HiE0lckdT5/UZmZKvAVGv0C3dughxxaE795xXoGTUMm/+OaVWDyuQpfdHO4M4JCB6jIvd1JJ6UvyV9R35qzBkBQVs4ezl0Tp0SKoKOFj9Vr29EcJynpSjFWF+9vUM6eNcEm0tIMUuLKL4RSR9lnslM00SLMO5Vm9ykPsL+9nbgWiOBChokgEX3+VHOLFxRhSYeU8iGNComxO6PdV/KEn5i7nB2AB32RBl6HwNw4MNrEhy4StQhwinZlmt/4xQhwqou9eNVaCbTFaUJQQMzhvPYo25ewY8AUXK1y7Ols9km3VMgjcZRWUNDDyrBqMMcnSJsZhKC/58IAycmeVMheF9h4udg+RbkQwSFb4+Id1sqqcvhT7YXePYuC+Z/WSIO/9PkzFW9pLbg3a7Hex9qn7Mp+VqbV6WusKASY2sM/qQIyoGeFyQkiKM5Y6Vpj8+m4V3PDaAi7qEXOo9h38sfeeurHgRaWwFTwRGkoy8FCXadXjhFXHdGvtBupo6PCTR21Q555IOinijSylfMXQFLuSjgo0x1v6BZW8jByq/cBlfn/LhBe7oyLADg/cJ2BP8lJvd/uIHxQQZIS+s36d+M+eOB7+dPLDcmmSBeuWpYzFRjTY590D5isrOP5YMP4Rqj/NxCKnHuSraK08mOXp1jNNvRWTZ+FUGN6Nm0ZkBbSbotVDkg8WvjPU4hOWBAc+tSg3ei3RaO1Q//YvR2G9YB1AaSFMsg2DyfBAqW6BWl/j6+Qt5/My7YCD0Ylhf1GBHAho70wVvfS4yjd6fa6hxXUcM4eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/19/2025 9:27 AM, Liam R. Howlett wrote:
> * Jane Chu <jane.chu@oracle.com> [251219 01:28]:
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
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> 
> I don't see stable in the Cc list, did you miss it?

Good catch, thank you!
> 
> Looks good, small nit below.
> 
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Thanks!
-jane

> 
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
>>   
>> -	set_to_kill(tk, addr, shift);
>> +	hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
>> +	set_to_kill(tk, hwpoison_vaddr, shift);
>>   	return 1;
>>   }
>>   
>> @@ -749,7 +752,7 @@ static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
>>   
>>   	for (; addr != end; ptep++, addr += PAGE_SIZE) {
>>   		ret = check_hwpoisoned_entry(ptep_get(ptep), addr, PAGE_SHIFT,
>> -					     hwp->pfn, &hwp->tk);
>> +					     hwp->pfn, &hwp->tk, 1);
>>   		if (ret == 1)
>>   			break;
>>   	}
>> @@ -772,8 +775,8 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
>>   
>>   	ptl = huge_pte_lock(h, walk->mm, ptep);
>>   	pte = huge_ptep_get(walk->mm, addr, ptep);
>> -	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
>> -					hwp->pfn, &hwp->tk);
>> +	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h), hwp->pfn,
>> +				&hwp->tk, pages_per_huge_page(h));
>>   	spin_unlock(ptl);
>>   	return ret;
>>   }
>> @@ -2023,10 +2026,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>>   		*hugetlb = 0;
>>   		return 0;
>>   	} else if (res == -EHWPOISON) {
>> -		if (flags & MF_ACTION_REQUIRED) {
>> -			folio = page_folio(p);
>> -			res = kill_accessing_process(current, folio_pfn(folio), flags);
>> -		}
>> +		if (flags & MF_ACTION_REQUIRED)
>> +			res = kill_accessing_process(current, pfn, flags);
>>   		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>>   		return res;
>>   	} else if (res == -EBUSY) {
>> @@ -2037,6 +2038,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>>   		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>>   	}
>>   
>> +
> 
> nit: extra witespace added.
> 
>>   	folio = page_folio(p);
>>   	folio_lock(folio);
>>   
>> -- 
>> 2.43.5
>>



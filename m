Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9A1CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF5558E0002; Mon,  8 Sep 2025 20:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA68A8E0001; Mon,  8 Sep 2025 20:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DF98E0002; Mon,  8 Sep 2025 20:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A51DA8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:19:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54A5511965E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:19:22 +0000 (UTC)
X-FDA: 83867802564.14.E48ADAD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id F05EA1C0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:19:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=liVfiLnn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CAdTtmPL;
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757377159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlHaO+oIxleMo76FYCxTfmnGop2+vy8hgjKrarjTH7U=;
	b=Uu2+l6V+IaVn2BvSIElgZ3Pv5f1V6NFzrNKIeZuohJoZNpXnV2EMOfHFPz0frLcr496TWs
	W7e8T8sz+Musmd0aDbIDId18aD/oY7zyvPFvUX77Mnsn+1m3Qaa1LxwV1OEWgbudQPb+Vd
	XIh3Ffk4F0EqCh7YmyNXT6Yc4xx8G2M=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=liVfiLnn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CAdTtmPL;
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757377159; a=rsa-sha256;
	cv=pass;
	b=mAs1A6+O6VA/6tEjyodZKFHgDY5bEjRLa55h23eaSYaN/n7f3yjfOG/hWRPkfgs+Pa//f4
	qQ1tIcDHy2o6Np0n0Zes+WT2Gj8MQ2O0WA6X8PslIY+VAJJKpkPbLg06+sYp39FskYbpGd
	xrT2hjMh+fSKERkwsnhkfB831hlPA/E=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LBhOv026466;
	Tue, 9 Sep 2025 00:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RlHaO+oIxleMo76FYCxTfmnGop2+vy8hgjKrarjTH7U=; b=
	liVfiLnnSclIFUDv5QA6VOM6Kngp4L8HXiVEL2RZqaBsqKT9F5q+DX4PVE0I2Rpz
	PRQLbRb9hgYQhY3MhipfjjUSmivMV7CY3AdjOErb4d7hxVHRKvojtgmOR4vKvBpN
	WL8y/icOp4hQeelq2acCHpCX5VpRlI+PAifQHvjQhRcDCBk0JMq0zx4IXRluzMd8
	xDFtKCwZFMB45pga1AghrCPCBvTHIzgVvPBYhasuiPl5kklY/7h71PYGhbRoQ2/W
	qK9zrD1A4XVRpdmflp6LWEVvJ07dk1hm/o4ftdQJHpHSVZK1TXufEJa0Tv90FZDP
	CDnqrvxt/gEvFHqmFzTtkg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shrnhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:19:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58900MEA013581;
	Tue, 9 Sep 2025 00:19:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd93u81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:19:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8UetxHYAoSr3Djw02ZO2uhqMnzcMVP0LrjWHbRrmTivToWbGhwlnL+NzC5Gu6hxuP/AIlLsAYgofovtc8bb7FTN8W/8zUppeXRJhrcjsOyKhcihDENnawn4zEkQyyF/KDRID3xKBH9clr/jOb8MrxfpfRBjMd3SoQcD9N9Oe7tnoOi3aXePCRH0WxKDgmmwqA0itnuQwDw+RtQedchYw/F8ALbsjxCBSGQyKHPlHIyuj/ebIsitorax+IrFizlMq/8Dn9TA8Hi4tEk7nJzLvCuHh4aI5Kom5a2DUQOrqjy/hctY4nlEumb6cLsqvIOvdU6FgmBrRdMSamwkbMmgtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlHaO+oIxleMo76FYCxTfmnGop2+vy8hgjKrarjTH7U=;
 b=p5W90O1hkgmlmPY75t9R3H5kxC4jPw6fAPDybKmwnngaSOm4rCruTJi6WTCwzIA8piVfPICviqiMBL9mXVf4SJISwrAkWNucA9it3drqTS0O6+aZorEb4l/6lUJeZtwMNjI80tGjP2ZbM43ruog0xbxC1CBiN1ckQNdXSXl7tIK6pfTZGFLIHljzYOMofjFxE9neU1GmRW5SJw93nYMtWD2Tn5g/GLMlh3vI6jdvE+sn7AfmN5XIkGO1x8iUn/Ec3r5VHmiGJDkW5Aseq+i6IVnQDzqJ9o7D6PSWfyMq9VtA4yZAdslx/e0SFQ4/sHmtIXQU34NsVxP2uJ8H5R8dtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlHaO+oIxleMo76FYCxTfmnGop2+vy8hgjKrarjTH7U=;
 b=CAdTtmPLcc+Yi4uk6EYUpVw3nksHgZaNH91K5+YDomWNnPHn2Upg7SQMFIvEsvDRvc+guwCq0s6ocDri+06h8dhO24i5XgiHs/vvPU6dMEz1a9oRHy7nFwu5MLwr7rsMdmIg4MG+ROF45RofWTB1R94o5hViiodvG8snpEox3uc=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 BLAPR10MB5203.namprd10.prod.outlook.com (2603:10b6:208:30d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 00:19:06 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 00:19:06 +0000
Message-ID: <18d3f516-5197-4c02-adc0-b4fa03f7c191@oracle.com>
Date: Mon, 8 Sep 2025 17:19:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] mm: cma: add alloc flags for __cma_alloc()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, Zi Yan <ziy@nvidia.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-8-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250902124820.3081488-8-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0267.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::32) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|BLAPR10MB5203:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb17657-5fcf-4ae5-4d38-08ddef367cb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVRBWnhZVmNQcjRJNEc2RFB0SzZabFdRZTlhUEU0VFVrTGV3djFTbDlJdTcv?=
 =?utf-8?B?WjB4YmFaam5ycHJGbG1rK1VMRmREV0x6Zy8zWHhxTUpNcVN0NEFKTEdKVEx5?=
 =?utf-8?B?MTZVUzVIVGRBelJWakUwR21TNzdnT2pCOGFpeCtSQy92WFRqTkwrd1hkeDJV?=
 =?utf-8?B?aVM0ZkFYQmVnOGx5endMZmhtWWYraXc4RktyUk9uYnJsWjJOUnh4WnNXUmJw?=
 =?utf-8?B?dmNqTkJzU3RROUZyWjJ4VWJLQno5dG1RUVhoMzlHWjROOFkxVjJQUTdhNU42?=
 =?utf-8?B?ZXF2RHE4RGlBNkpoSnUyWUNla1NFdTcwZ0UxOThTMHVCRSsvSFlCc3BudzF4?=
 =?utf-8?B?cjVRMnhCMkM5c3ZidXUrNkVGQlR2akJ2ZWhZSlZkNkhXZnNBVjF2SU9FdmFC?=
 =?utf-8?B?b2hyc1lJOUZKbVpvUzFlTXdQQ2F1ZlRzUVhyeFc5NUU4V2NUR0plRGoxbWxk?=
 =?utf-8?B?ZWs2bm1MdzhlZTlCcmxoZ04vVmlvYlB6Y3FuZWFRVlhZemU0STQ4bVZSQ2Vk?=
 =?utf-8?B?NHZqQWhSLzdjcFN5M25SVm1MM3pWZHRJLytaN2hRNks0OTByVkF1ajJ1a0ZI?=
 =?utf-8?B?NGw5Q1l3aWJRRjFJTlYrL2tjZUxuU1lra2h1ZDRub29kY1ZqYjI5M1hwUmtl?=
 =?utf-8?B?ZDNraGV2U0ZTbTlLYmpFMmJVNnBPY3hWdCtmSGh0UkNxZFBZNE85em9ra3BW?=
 =?utf-8?B?anZ2L1RwT3JkclVzQXFTdTc3YXNqWUhNUFZTcTBVNUk4OWJZRkNuTlZ6Tk1Q?=
 =?utf-8?B?WlVVSmdoYlAyUWZHOWJxbE1ubVcrb2grWXhuRElwQXBybklFWHl5UXlobG12?=
 =?utf-8?B?dFZUTC9DclpzSEk2TmY0N0YyditsbUQ2bzdyTXZBRHplUnQvS0w0KzkyVTFL?=
 =?utf-8?B?SnlTeGdZSW5ra0dEOEJPcDA0NWJFZ0ZxM0dQbXRMbGpqeDZCV0N6NnVjTDJE?=
 =?utf-8?B?SmdUTVpwY1dKb1ZWT3FBZDZ4a2ZTWUNmVXQ5MjBxRURJTzFVSk1JTzI2cDRM?=
 =?utf-8?B?NlJhdlVJeXUxTlV2TkNpY21pMlE2ek54TzkrQzgrR0hDRGkycHNwcWpTaWM2?=
 =?utf-8?B?SE4zOG1CeWNjQmdYS1NCR1dra3Z0VTczbzcwWnRDVWhoZTNIQm42Z1lad1dE?=
 =?utf-8?B?UzloaGlrcEJmNnM3aWNJYWJzY2dmS283MzJ2TmVBQjRTbGx4UExDalRmUy9q?=
 =?utf-8?B?ZE52VFB2VWh6czhiTmN1R2hESGRyNlRQYStsT2NNUlJEM1lqbzVEZGxmNW1L?=
 =?utf-8?B?VzRwRVRJL0ZTeGtNeUxWdldZL2hJTnIwcy9PeUdqdkVYWEpXUEZ6YUdIeW5i?=
 =?utf-8?B?ZEx2UVpYVkc4bUZ2ZDcxZ2RLczFrR2d0S1pvcVJyVU1lc1lZMHRiVHhFL1pa?=
 =?utf-8?B?eitTYVd5bXhxYjY3WVAvbFJhYUx0emhtRC9qQU5CQTl2TUlITndZY0R0UUlN?=
 =?utf-8?B?SWZlVHNuRkVRbHRJYnJTWmJRMXVLK29IUlZlTHo5eTRBdVZXTS9Rekl6SU1U?=
 =?utf-8?B?RVBsTnJVY0hHTXZRaEJQUU0raVVNNFFyUHVlTlUrTG1TZ1pQdmh6dmdsSmxl?=
 =?utf-8?B?eEtrZFgvTHRpS3Q2c1djaFoyaXRKZHhqN0oxSnJ5TkZFMkRWYlduaG9MdFpu?=
 =?utf-8?B?RStkWGhJaU4rTEtsbzdoWExJR05GTmk0U3JOTHZyL3ltSjE2Kysvbkcvc3Ev?=
 =?utf-8?B?aXpLc21mSUVRMTBrR05tekw1dHZGQkdPSWdKa1Z1SkNpR1FCZ0VmUHZpZXBw?=
 =?utf-8?B?Uld1UUZxcGZ1cGhzUGRDNHIyN1VhVnFTNW14ZFdsK3N1V29XclNKOFE0bjFD?=
 =?utf-8?B?UHN5c2pxbTl0QzcwSEFCYXRCWklmUDdLWUYvVHRVVXJiemN4eDh5TjNPUHR2?=
 =?utf-8?B?ak14SWtrQ0FDZGNxcXFFbmFxSUZ1TFB4c3pYaitxdUd5bEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFpnUWFtYlJoekpub05YcEp3d242M1ludythRjVFaFlTNFpMN3V4enlYSUJp?=
 =?utf-8?B?TUIrWlhGc0NVKzNKb29kUWZYblZhYUcxdU1FMWNIRnRQVzN5a0VvczJGS2Jw?=
 =?utf-8?B?V2NKcTdQZk9ud0U0UlRSOStLeXRpOWV4SzYzbmtiRlhSaXVDQ0pEbmF6eE1a?=
 =?utf-8?B?Ly9UQVNIcTBCQURPNmNqM3cyUzBDbGFCTkhhdW5MdkVtYVpRSVZ6Y05aTGxT?=
 =?utf-8?B?L2s2V25sVHFpUVV4RlJhbVZiQWxXdUVCdDBYSHQ5c3IxR2dlcU5JeFVCMVpq?=
 =?utf-8?B?NmlvckFsc0laaE1IOCt3MGg1bGhsZTVlSm1mZ1lDdkRaamNHUDhFNDBHQWR1?=
 =?utf-8?B?Z1AvODJkcEVZNldwRzdyNUZtL0ZGU3NCOGFtUzBzbUZYa2J3dUdlMFF6cE5o?=
 =?utf-8?B?WGw3VjlkRnB2cXM3UEFveWdvZEpHOVZmVlU0ZUhOSmRHV1hiSjBNdUtXVmQy?=
 =?utf-8?B?RW5zRDh5TWpEaEx0dzJldGNaTk5wUzk5RHZoeWp3NkNtamlIZkdrU2NGdVFM?=
 =?utf-8?B?cDd2ZmZjZUNUaHZwYm1rektZNG9wU053Sm1PVU5FSmhCTks4UzBpVjdqNDRY?=
 =?utf-8?B?K3VTbUVHWm1IR0NUeFUyczA1Y3kxMWhCMTlaN0p0eS93NDZqek5qUkhaV1FM?=
 =?utf-8?B?TmxVWmhsU0U3UlArTlpGTURmempWczNIZlIxaFJCQXBKYzlvbWNJVVQ3aml6?=
 =?utf-8?B?NlRES2hGTmFEN21LOExFczA5cVpUUnRnSVJQenBrUSs1dDdqK2R2OHdSc2VX?=
 =?utf-8?B?c3lyaVkzZi8yT2pJVWNQa1pLMnA0a3NUSjJ4WllJYkd1Vit5RVNzUEJmSEdN?=
 =?utf-8?B?eENBRXp0TE5Vc1VqK2JlaXIyTzZMVW8vL3B0bkk3d2wwN29TUlV2ajhtd3RN?=
 =?utf-8?B?MXdVclFkVXpMMnNYWTAzK2tVT2dhcmxWY0QzY05LckI0WFo2Y0V5REJmbzlZ?=
 =?utf-8?B?UDc2aDZpaGxmSVZna3p6SWRtZ0pvUm9TVy9ER0x1TUdDSStvWGRvSGxWSnVQ?=
 =?utf-8?B?ODI0S0VMaWxOajlCSDNOa2tBWlJwQVBGSWVLWkZYb2hmaDIxbU1DOWdOOHVn?=
 =?utf-8?B?UFEvdzBMZkUvKzZWT0N5TGE3UWt4V2FKdFdMSnFYcytWSGJVSGR0OTBKL09j?=
 =?utf-8?B?RVFqSUt6cEpSK29PVTgrMEdxaFhRRzVqWGorSzZZaE5ndlFjaDk5aGxwRFFR?=
 =?utf-8?B?dWxDc0wzMkN3bHN5YXhrRlF1aG1xS0xuaXNNS3lFTVEwcHRyU0thNlhBWTJV?=
 =?utf-8?B?ZkdaZ1FzdE0ycDhSU3NZV2F4VUNXMnNrKzhFU2h6SmZaT1BpSlBUY3NPL1BG?=
 =?utf-8?B?eEczSHcrdC83WE9sVHVjS3pBYkVMRVYvVnQ4TmUyQjlSQnlTTlZyaXBuVlh6?=
 =?utf-8?B?Y2VvVEkyN2xFS1lpcTU2OXkybThTMXlqeEhZdXhUVHdVRi9NMW1YQm9IUW10?=
 =?utf-8?B?K0N6TFo3UVdhc1VGcFFiVlVnL096c3F3OElrREtYd3lSNXRJc2ZqMUFqdnlu?=
 =?utf-8?B?NjBxcmR3Q09tcVN3TjZGMEszZTZVYWFrSVU3YnFuMUcvbCtVQm9KRE9TNXlJ?=
 =?utf-8?B?ZlNqdjZRcktWRHRQdUpjUnhqYVViU1dkRVRGZ0V1Yms2NFd4WTMxemRGRERX?=
 =?utf-8?B?UDBtMUJKYnZyTEVsRGd2MXBNUkREMWpEN0RWMTBDWGRxNHpQQ0ZXV0NnaVBk?=
 =?utf-8?B?bEpMZ0tpOW0rbmZyVUJTUkFPL3hncGdUVk5EODN2b05hUytZVmVNSXFOdlZW?=
 =?utf-8?B?U1ZQV3ZCNkJmTlJ4SXRqMC96WGZYTVNFRHhQWGl4K2hJSnVlYkpyNWdFTUhu?=
 =?utf-8?B?MWt4TGIyQjN2cjU3UFg2UFdPd0pyMXlsVzRDdGxKeWIySDFDZlN3dlJqUE9k?=
 =?utf-8?B?Q0xJT05PSVk1OGJpbDZ0RVVBUHRPUVF4d0g1SWlCZ0xMREpudW9VZXlBa2Ro?=
 =?utf-8?B?aC9qQWZIMEE3U29JVGVYNDdISzEzT2FQbW5mZ3AzSnd3TU9ocmRGZWcvREk5?=
 =?utf-8?B?ekJBODlYV05naE1STit0YklPV2tDUzdhOW9tNHkyTERYOHBtV0dtK3lwN3Bh?=
 =?utf-8?B?RG5XemV6bVFGOEczQUJLY1dlelZ0RTdGREM4eDZuL3pxeUxYeTZ3QmIrRGd2?=
 =?utf-8?Q?x+o8vDn82YawBjCdaaTfpdtfn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w2rVGzKgighibP6HfBbkYXMInWOpdnwSmk6OAy3Xv4ZeggKmpo32Ge1BJTaCV6EmFZym/B2Q29IxJg7Kw4Zox1+GQ85UXpkaig4hdVF0UNKcdWX5i/ngWOa2K49PrrP5I+5Y5thXXKgUn/X9ZHB+/VNwtd1a1gBv5yz9V6/01tVen2j54Qn9O77FXSAgSs+Usnv9EhjNPi9Ys59c6UvAcGGS5+i66BYijcOJxeOVVuiQ2PkmGnliRwFAS7hoPwMEmLMOwBS6pQ+LHCvFhCIBx1TF2IqO9bz8NCtNly9grKFQRi3VRJR3VnPrVJhH60aIfPLXDF0vv8suR/xAhQVJXNZcZQWJ4hVYN4NrD+Jbkf3navje+BjttKA7UDX4hrgC+OrUbI1L9YuYp2H7t8hq81WZbR60vSEVM2q3fPZ8hgAuC9092yfqzBPb7OECBF0bwYrXjdUkX+74rxTNLtSSWjsU4siM8q34NwjMDZN0YAsLDXzXEedlZ0CvwcnFj3K5MyNcfgC3uIuJNBlkLYrOgfB3r+bWu9A6Dx86kbAfMX54mb9iOVtsHua/1cI5SuS0G8xDMFbVX6exGdmX5Ia2FMvEXCTsPlB8GodIXOHmii8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb17657-5fcf-4ae5-4d38-08ddef367cb3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 00:19:05.8966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHUZnBefRtnWOK1v6D3Px7zzuaKVyKibbV/Ut11zHJ/DhbiY66SAvQTL3KjiWNnmhOfyEvxLmkZNFQ5wZPz0/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090001
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68bf727d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=xcjCPb61YmKyrO5j7rsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX4VBv9zxALtOV
 11coG8X/qvgrw5qQkA4zyzTzHASZUSBmi065/Z9tF7slrKnhJAksjGfSftn9/4bH7KYQGBKVnMQ
 lwo0APY6oIIQ/+X0wAAiWGUZn2pRTfPFb98PkcjBamn2vdeDuyuidpVJuZiRQ7EslZnOsL+jStH
 +rPVXfGxKPfCsDu9uJymbEGoKvtlr1Pqi/lhtzZxCHZVFqhI9HL/Fr9hsBXFxiIeIYlNWAmyNOd
 VofrqNDW5VsgKmL13bQ44VoqHe8XgDAhLX3XPt5TRpoKk02n1zaIHQqXM69Ow9okO4nT5CTGRx2
 8xPecFb/vEjbs5ebnCeUXcgJGHgRnLBtklpIlFzdu9gTnS+DEc1BIIyVFoDa00Ih0585Z+kZIKX
 DC7enxTJ
X-Proofpoint-GUID: EJIqHcJjC6U3_nVFC60J9eJGLhgcX6Hj
X-Proofpoint-ORIG-GUID: EJIqHcJjC6U3_nVFC60J9eJGLhgcX6Hj
X-Stat-Signature: zmhpojh8iafk511fqm4oi1b81s4eqxcg
X-Rspam-User: 
X-Rspamd-Queue-Id: F05EA1C0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757377158-570459
X-HE-Meta: U2FsdGVkX19bmy0Si8W6qmcf8TDGxFEvQ3PJnXDiOcR1mA+uLSf6lPH186qDE1dONsM2M6dNq3dQI/V2yCSYZG3F9k0OELdb/7ldDbMoORsbaK/y/qongqN6UKLAM//AHR0SWGtnKL3RaFlh4umgZGJPY4+YgS5/8FxRN0Gu0USga1K1dfyL+Ty7o0Z0EORLYyD2u3/eHXeuc3sYjBsZJ8kvk3NM/8CQ1SzHIKKaQOEWX5xneBrc5qLB99m0Dh/9//RgdNJ180i5/gyopTQ5B59Y4MrH9SvmZTH56kX7J6wcPo9QgJF/AFLdj2Of0cqc0pgvDxfWIHpfmv6J09LoWx7FzIf0N/BpnvvQ9xVkEHnJHqNYL3IByqzqwoK+rCtQNLg2Cmlm9ktusOPP6kT9IoqtuvPwUMl5s8WEOj1NfCxyAqOsHM8Hs2aSvCsBOZJpUEAFimuPm4s4i6bd+q36fT+XA4Zt7d8dTTfO9hzo5bBMUHtsA0XH85Y/YHLn2hURMvQnWv9xZV5JGFmCEpNXAnHz79YUlyVkjGoXAyLcaxOV5f7P4JVjNTzlUgcbC4lbwPGku4kzYl3V1cSNXybURHf8Q8uJJK9V1DIxv+r/A7mpktGWpHOtIcTy5eSfVRqpaFNpRXyokOYSTI04rzT3iUbu6yKKou7icsNAoq4bt0g6w3yxJIA5fwoffAdugQKLmLKxnAI8cFUFANxRwTRAV/1s6PgRNEJKETxcMp9fgqFZ2JBYQRfdZxfHj7AMJ0jR+OGNfN34VXfrrIyXQcS5V7PJXUAUXNUjkgjqXq+5+2CNDub8D8nywatqJBp5GVW5AvANSpQTs7jsTbXdRLCR0YzWCNvCr6N7bi5Iuj7hpdFKaxs01BiEM9lEc1iV0SLQ1tqJRstiaSH00VEon5p3XsC71stzmuI9seU2OpUeE32n3V5V6ozp2V+xB/5Ws+lbucZ1SH0zJkYH2MCn749
 TkiU5CE9
 1c0u4gLcY62A2cy9Ny45SwJkGbaCyDxgGF+vvUJ6TtlzK0+QxjomES8R7yQBhZ2/Ib3+/our20dTNAGpHwrEUGvqeKse1ganERgtpSlBr8jZQphnWcM/obi/os3VSc/Oi07lGAhu2JGIXwIJ3kUyjhZ71plWzvRZ/eK5nLaoqBfFsMZaQovNf9ZhYQfSnR8Jfxi9pZQYxsPa3Asfn5KC4RT8BrwtBpw6lQCLo3fLT4X0ftAQlXkt4ze3dXeLidPl4XiSKdmg/0fHZ+DFKgJoIQinIkNhFgulvJcmRM4FAWYyoEHGVPNhB9WPrL8trsl0Lqnk3IbN8SS10XyKoqQ6rDQVvpO0rxk1ns6ySXBE/KsRHmi01Gr1St6s4qZzYnT5pd+ErAah5f1HvJipoqCLaRT3O2qARpTf7y+b6wDmQL27rOXQ6maldjJYHsyxSecOmNwHNpBfwo9HE7dCy5ofxHm7fdWbn9+2gwj/3v9sjE8l6EaiPQ3QFNqZFxlQqUGz4SiOfuC3TY/ztYiaH3g6UvqKEL2wZqNYAWCkirM4KYm1e+hcJNJpfwbvzWwSfLK3xb7dk3U7zPTK79e2atPR5VoF3EDePC/y3ubnHWlus1i92zAleT/s9u62Ia7/ll8mW5hq5AP0RHEDrCvI8pEp7dK/v9ql/5OGNrf2ggosLeVNowrPDodz3y1zgwVS8PmyaIVvKeB4FEHtgHp1Ox+iIJLr31raj/1eyH7vOOEatMv75vXeRE8QPGTHhQoHG0sf/yZdQdsgALdXCzf2liVVBFD9HexUHpmh+AibfGD3f4yHR0NhK5LChES+alMaurI7Z8NObyH7PJwxt9GJEwKE8x8gThUvyuODazGiz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/2/2025 5:48 AM, Kefeng Wang wrote:
> In order to support frozen page allocation in the following
> changes, adding the alloc flags for __cma_alloc().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/cma.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index e56ec64d0567..3f3c96be67f7 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -778,7 +778,8 @@ static void cma_debug_show_areas(struct cma *cma)
>   
>   static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>   				unsigned long count, unsigned int align,
> -				struct page **pagep, gfp_t gfp)
> +				struct page **pagep, gfp_t gfp,
> +				acr_flags_t alloc_flags)
>   {
>   	unsigned long mask, offset;
>   	unsigned long pfn = -1;
> @@ -823,7 +824,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>   
>   		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
>   		mutex_lock(&cma->alloc_mutex);
> -		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
> +		ret = alloc_contig_range(pfn, pfn + count, alloc_flags, gfp);
>   		mutex_unlock(&cma->alloc_mutex);
>   		if (ret == 0) {
>   			page = pfn_to_page(pfn);
> @@ -848,7 +849,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>   }
>   
>   static struct page *__cma_alloc(struct cma *cma, unsigned long count,
> -		       unsigned int align, gfp_t gfp)
> +		       unsigned int align, gfp_t gfp, acr_flags_t alloc_flags)
>   {
>   	struct page *page = NULL;
>   	int ret = -ENOMEM, r;
> @@ -870,7 +871,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>   		page = NULL;
>   
>   		ret = cma_range_alloc(cma, &cma->ranges[r], count, align,
> -				       &page, gfp);
> +				       &page, gfp, alloc_flags);
>   		if (ret != -EBUSY || page)
>   			break;
>   	}
> @@ -918,7 +919,9 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>   struct page *cma_alloc(struct cma *cma, unsigned long count,
>   		       unsigned int align, bool no_warn)
>   {
> -	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
> +	return __cma_alloc(cma, count, align,
> +			   GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0),
> +			   ACR_FLAGS_CMA);
>   }
>   
>   struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
> @@ -928,7 +931,7 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
>   	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
>   		return NULL;
>   
> -	page = __cma_alloc(cma, 1 << order, order, gfp);
> +	page = __cma_alloc(cma, 1 << order, order, gfp, ACR_FLAGS_CMA);
>   
>   	return page ? page_folio(page) : NULL;
>   }

Looks good!
Reviewed-by: Jane Chu <jane.chu@oracle.com>

-jane


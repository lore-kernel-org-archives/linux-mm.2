Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330A6CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0D1900257; Fri, 15 Aug 2025 11:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7AF900256; Fri, 15 Aug 2025 11:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A632900257; Fri, 15 Aug 2025 11:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89815900256
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:35:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 495D557375
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:35:50 +0000 (UTC)
X-FDA: 83779392060.05.D6A7BBF
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	by imf01.hostedemail.com (Postfix) with ESMTP id 376984000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:35:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bgHr5zD5;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 40.107.237.70 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755272147; a=rsa-sha256;
	cv=pass;
	b=xY65rJD7KKN353wwY3eWzas0ow+yUzEe+kPZgw77cQS9tZez8159PzGN+Yi6Y+Rh+BfrbK
	hSV+OH8jL3i/oyyZUezT+GQRJIgRIoQ5nVBxDGn+DZx2d8ML3+gPT7e6FaL4BKeThJ+i80
	MStBtWI6TcgHmDzrDNOegnSCUHFpddk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bgHr5zD5;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 40.107.237.70 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755272147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3iPKf49zGpK21vypXgCJvugnPeECissmRn15ZDekF8=;
	b=h9l9ITVvXcySGgrKVSXdIzwUm7gAfi8WerRQtvwJ8I1hm0SdtazvppU7UeGsAHJwzlhlUJ
	aktB0XLtdu8ovVY65nG3tkxasTSVpWFWZv6hTzaL+cNZ7t+ryHzwRcUddz8xkMjIg88R07
	PqI48e41fE0G3UVJeqJuMMZ0Op5cWwE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQ0d3WaFqzZRVGa0eywOLbT4AU3h6VjIb5H4Gh3viV2Y41IMf6w9N/7zclALkGsILOfANi+9z2ZCYYyBFno+lz+/V16R4LsH39HhBI8dxx40IXXgjiF5eOfK4T3tXSHVY8Qag0ZSkV1lPOEyKq2G6OOAjoEY0wDWL0WNNXd/AiCh41yBHXa1jQ1o1/5haiMdb+uZJByNvf07oUre311awau95nrPvk61kH/dxHWtYBmNjs52sQEd1BCWdJR0bBIGvSH+miGoVUix80wEvCszpXzHgRDR3G9bgFvC3IS9SbtfCqdcdVJsriVovoMhhPYtbbXBynbbhYeQzPE16wj0Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3iPKf49zGpK21vypXgCJvugnPeECissmRn15ZDekF8=;
 b=BTUs8vgZpA2UONORpUGxwEaa1KPZdGdLBRKBzga54YhukDLer7PDJv/qIB1NUF8gmNxDT32gnHzUDIbOEU1pTtMQDxhoJIQOYG+stdUo/AOIoUXuTXN0ZuT8gRYYd/xakE5nT/Nf3zyXwjp5C+PsWV/tcMTOwv9O693U0T51tTc+aesd3AHYGPA1RYqtSydjfsbYqyX7/xzsZmgvl1rqUXFuSwuecqJvdQK1vQG1aXaCITXE9wppVMAuI5p21ev3/fqMN6YpUi+WyREnISaQomPT0Z5UIq4MKykfk+xJy7lQdLnIRne4HJ26e6DE1Y1Q6C3FlIuZaYU7s/iQRNkIMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3iPKf49zGpK21vypXgCJvugnPeECissmRn15ZDekF8=;
 b=bgHr5zD5BO7IV/NRIiA6FBrVV4fZ0sWMreFRg+qlJAHZAtjk8NfICp+Lc41RAbmTwLC9PfG1fRcERVhkEgS8+2b93VfeENj5JvZX5aeI2VaRhuLUoYhPasDTUo33/bpJs8P54b94txga/AjRm2CICmqPfil8DZCO7qo6aL9KkQQ=
Received: from DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) by
 IA1PR12MB9523.namprd12.prod.outlook.com (2603:10b6:208:595::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 15:35:45 +0000
Received: from DS0PR12MB6439.namprd12.prod.outlook.com
 ([fe80::ec83:b5e5:82dd:b207]) by DS0PR12MB6439.namprd12.prod.outlook.com
 ([fe80::ec83:b5e5:82dd:b207%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 15:35:44 +0000
Message-ID: <14359326-bdc2-4d9a-b243-b5ffcad0716b@amd.com>
Date: Fri, 15 Aug 2025 21:05:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/7] A subsystem for hot page detection and
 promotion
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
 hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com,
 peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
 rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
 nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
 kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com
References: <20250814134826.154003-1-bharata@amd.com>
 <fa0690e8-ad88-4ffc-9c63-c1d8f3d60f47@nvidia.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <fa0690e8-ad88-4ffc-9c63-c1d8f3d60f47@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0152.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::22) To DS0PR12MB6439.namprd12.prod.outlook.com
 (2603:10b6:8:c9::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6439:EE_|IA1PR12MB9523:EE_
X-MS-Office365-Filtering-Correlation-Id: 44e548a7-483b-4697-5d4f-08dddc116617
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2NYZVFDUmMvV0VUVDE2VHBjakYwT25VNUtWMHhjc3orelEwR3UzcTdzS1RU?=
 =?utf-8?B?SnJEb0YrdVp2VEZSOTJ0NFh5UkE4S1hwVHpHWFAxZjc0dUF0cXE3b2xVbTlD?=
 =?utf-8?B?OVp5bFBFcXVUM3FXdkdMQWI3aExnd0pZa3gva1c4UnptY2o0SE5sVnByUmth?=
 =?utf-8?B?a1ZIMks4WlVCMFQ5eHlVQlhQMU5xMkcrUU54alMyVEJ3Qkk2ejNvNFJKaXNU?=
 =?utf-8?B?bnl6dUlNeE0wTzlUMWh3U2NoMVA0aXRXZ0FpaFVDOGJSSjd3V1ViVzc5WjB5?=
 =?utf-8?B?akhzK0VNVFgySklYSDdEQWdjR2JORFl0OE55QmxtaFg5dmJXbmJoaUZNblV0?=
 =?utf-8?B?dVFMdFE5VHlDbXRVdDVNSUg5NnZFTUNvR29CbG12SEkvLzUrUDVjSjcrcmFF?=
 =?utf-8?B?OHV6NnFEcURRYU9vVm9velBZdVF5bndVR3hsek5NNzEwM1RQc1ljd1ZMY2ph?=
 =?utf-8?B?dStrQ2ZVWXBiS0dNdDVaSDVSbUxrYTJjU3Q1bjA4TWR3UWN0cmFGcWdvaDYy?=
 =?utf-8?B?dXM0UHlXOVJJb0UrSDZpTHVZdk9Hb3YrZmxTd1BBK1pNdjdKUGdndWpXYnZV?=
 =?utf-8?B?bkw3Ui9VemlRU0RDYW9vRDBjNzFTQ1NFL3h5ajM3cmZLRnVvb3QreWdRSXpz?=
 =?utf-8?B?TTBKWFZpci8yRFByZHI2MFJpcXRXNUhDdUh0ZkR1MkJkbUhpNU9HQm5JQmps?=
 =?utf-8?B?dFdQalRHQUt1bE1BNkQrRWNJbE5CcTAzdytLUEJHb29ZL08zUGUvQlowemFF?=
 =?utf-8?B?SjhrdmZuY0tVK1d1Z1JwZVhVL2daanR0Q2xxR050Ry9EeUtrOWYxbGJDdHZH?=
 =?utf-8?B?Wlp2UndwOUN2M1JYa0ZqWkx4L3NXYlUvRUFrRUNWb0VGQVNrVW5GWFdjSXZF?=
 =?utf-8?B?bEg0UlZvUjBtcEJ0Z3hIbURSeG1ORnpXVWNJYVpYWHgxNVNaTmQ3UDBQTlJF?=
 =?utf-8?B?WFBsaGxienVvRGlhc1hUblZWeGZvaTMxNlJCWW42c3J6ZlMrNG9RcWtnd3Bj?=
 =?utf-8?B?blZFSFAySENOekZzanNjSTd4cy9nWDRUWmZRZ3lDUGFlRkdNRkVoUzQyQ2dz?=
 =?utf-8?B?eHBUbENLOTJ1Sld2TUw0TWtMdk1lTmZveVQvM0VxRG5qU0tJNWtyTFFjUnM3?=
 =?utf-8?B?a1Exd0txbVlMK3JEeUJIVWo0WXhqTGpDcUhZL2VickVmcjlTWElrZTYxTllF?=
 =?utf-8?B?R3BYVjVTb0dKekRKUEZ0QlJFSEgySTRGR2E3MzNsZ1JyeWVhc21RMmhHYUxH?=
 =?utf-8?B?M0MzZmtMSzNQNkFaN3F1bTVPT3FIVC83RWpxa2dKTEpqay90QklNZHJjd3JV?=
 =?utf-8?B?RFg0WUgrQXlJeGxFMjFUSmIrbjlkRklDM0NzbFpTTUlKK0gyYWlWR3ltRjdw?=
 =?utf-8?B?RXE3R01CRTZUZEJtMjc2V2VEeTgreXQ2bWRjeG0rYkVPRXczSVhmMHlPUEZh?=
 =?utf-8?B?ZDRiVzR6T0VTM3dxbnMvSlVlamVYdUt2ZVg2QkpDbUQ0V3pXY2xQRDhJeW9Z?=
 =?utf-8?B?ZDFLZ3ZSMG5YanBOWnFpbE9oTFVzdVR6bU1nNTVVbVVtekpvNXk2ak1GSExo?=
 =?utf-8?B?bEg2RFZpSlJKM3h0YzFkOTlPa1hFWlR4SnB4OVYrUmVHcmMyVTh3WEQyYWhh?=
 =?utf-8?B?NzR0NWZqOUF5ZllScHFkMXJWQUsrTVF6bjE0UkVZazhpaTcxRktCUGtSSm1x?=
 =?utf-8?B?NDVLS082YzJ1eWNKUUNtWGFSRnpvZGtxaGFsRzRXWkc1RFZ4bm94Z01QT0Fh?=
 =?utf-8?B?MlBjdk1LaFJKQUpUQTd2Zi9SQm5jVk1PUm43TUlNblhQeGhGZUMxbU5iampH?=
 =?utf-8?B?ejljaisvSVlWaXpjWXY5UXB2NG9xYWwxM3pyNmhoTEhJSEVsMm1oWFN5Y0hh?=
 =?utf-8?B?Q1JxcU9PL3hGN1N4eFVGc3RiakkzTUF0U1pidzlMYXBBTllncnJlUTVRSVVx?=
 =?utf-8?Q?tGaUGjxQgfM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6439.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGlSQWg4QlcvWk9WZkRYemk1ZXJ4N3VkMnZxREpkZWxTS2FWTndIQVpzcDBL?=
 =?utf-8?B?Wko3RVJtUDBUTk1BUWtRYTZ0SURlbDU0QmFmdWRlK2tZQmhjRmlJWlJOWUNU?=
 =?utf-8?B?b0UzWkdrUDdTbDhwMlNybEtlbE02L0dOOVZHa3BxLytJUjQzR2NmN1Zjcyto?=
 =?utf-8?B?MzY2OFRYUFV1QlpOS0J3ckFpZUFVVXh5d21EelVWU053b0J2WG1yeVJ5RExa?=
 =?utf-8?B?NzZSSTlMY2pzelV4Z0lMWm9qU09vU0tIZS9ITFFQU1owWTVmcC9FVjFFTVhG?=
 =?utf-8?B?UkJxRTRTMzFiUzdSc3VCQUpPL2VKRFBiL1dwNHhFOUxrRmFObFJONEpZVU14?=
 =?utf-8?B?UWJHY1E4c0EyR3RRaU1vQUFxNkQ2am16YlFleEI1NFN3b3VOamlRSFQ4cnBo?=
 =?utf-8?B?QWNRRDhjVlpBeVljZmtoSEVWZ0hlNGNUekxmdTdHV29BMS9wK0l4WHZZWnNu?=
 =?utf-8?B?VHpIYzRTMXB0UW5iaUlhckFicHlGc1VQV214MmZNbHNWWWpiWVFFOXRMWlJm?=
 =?utf-8?B?NU9uR2tTcTJKWk1XaXZmeWNXT1FmZkowd3UwWTBTT0JiRUlqQlA4eExCZnlB?=
 =?utf-8?B?N2ljaXB1QW1vZnRNU1JpWkVPV0s0TnJvcmdzM1FKdnhTK3c2bFFOVlVSUVNS?=
 =?utf-8?B?OXhHL3U4MHpkd1V6dU9aYTdmcjJaTWxaUUJ5RjF3RjZ0SVNha0wyeFdaNE5t?=
 =?utf-8?B?V1JEa1Vka1Q1Y3lKTFdNV3RNQ1dHZHZRcFYvTnlzTXZCN0p1NDExMng2VnAv?=
 =?utf-8?B?NVN4NzhNWFpIMlFKT2JKd0xsL3g1MVhvS2ovVmZLWXZyQVlBdzAwRG5Oc09G?=
 =?utf-8?B?NC81TXBsaXRvMmovSHhJRWlTYUpPb2JoMVJ1MDlrZWZCeU9PNU5wdUs4UFNM?=
 =?utf-8?B?NFNmMlh4ZktBK054S2JiK0pEMGxLZTE3YWZydkVxZCtzckg4MGhaRFlSY3d0?=
 =?utf-8?B?MXVrOWl5YWNRbEJyTGtKVzBzVU9oU3hpbTE2SnUrVDVPSkRTZk1ycmt1eTN3?=
 =?utf-8?B?d1hrU3dsajRqTml4L0RXRmhLTyt1dnF2R0pZRXNScVdDSGxhU1loMUI0NS9n?=
 =?utf-8?B?RmZVR0t3WFgyZCtsYmNHSEZ0RVZRRmxGa0Y4V1dlQy9rQUFwWThGbiswZTdM?=
 =?utf-8?B?Q0k5WnkzYVZZOGJJYnRLOTlLMm9vWnB4TThCN0tDaUFsOWhBWndGa3V3dzlh?=
 =?utf-8?B?cXZKRVZKQlFuYlczbFJPSG1tMXNFcGFRbHBab3FPNlk5ckRxUGZ6akxleFc1?=
 =?utf-8?B?SXBlR3lvKzRaUG9FSlpneEpBZ0FTdVIxUlZLOUp3VEQrdHdsUTlyNTFxeklx?=
 =?utf-8?B?cjd4NjlnZDBOSkVPcDE3T3Nid1Yrd2V0R3gwYzhzTDJhUDZyVVJVWmE3bjB4?=
 =?utf-8?B?T2VBZWJUbko1RDhGMEFicXVVWkI0OE5YdTA4MlJMNGhrT1gxbWhGcjV3M0xW?=
 =?utf-8?B?ajIxRElSZjlTenlEVzlzYnB4SVhmYUxzZC9RQzVNRXZIWjMwMDhPYU9JWkho?=
 =?utf-8?B?N3k2bUMxeEhZd25aNHhLaE5MdDNnU2ZRV1l0a3NZcmgyMksvQ201MGpDeFZV?=
 =?utf-8?B?aUROcGpCL0JJU2pCd09XN2g3R1FJaVB1QnlBTVBLV2NzYWJMZzFGNTBFMTZB?=
 =?utf-8?B?azZ5RzdIZkRML0Z0RU9YYTBNMk5NdzFxbkxHNUlEV0l1ZmdnL21GYjZmelNJ?=
 =?utf-8?B?UVlYR1VhZXBjN1FCeS9vYnMyblpMNnhTL2tjeEVieEVETldiaUFxMExWWSt2?=
 =?utf-8?B?MW84c1R2cTBsUFA4djFiSG5MTWd5MHlBZ2NYdk9OanBMZEtvQkZtcTdqWGMz?=
 =?utf-8?B?MXQ2M3g4U0gxMFpMVUJjUVBza3JWK1J2cDlOT2JhQjFTaVhNdWhZNXlsMVVa?=
 =?utf-8?B?eVY2VUE1T1UvTzVoZTJtRnRXRjROWVNXQTBmOUppdHF2c3NCZDZ5WHhEOHRR?=
 =?utf-8?B?N1JOdnpxRTdDZGpPUC9neSs0eGYwUEIrcnZ0eDM3Y05LLzZXdUdOMXh3bnoz?=
 =?utf-8?B?MTB4MTdyYWZKYWdBVldMSGZxdWVScDFKeWNFbW4zdHVuWHl1MURoR3J3cDBZ?=
 =?utf-8?B?dkkrNHVXMXg4WUxpWithUjJTai9nM3VzZnhWaWUxVjNkUVdYWkgxNEhUZ1Nm?=
 =?utf-8?Q?yZ7pn0D6BSh7MrErUVVktBZlU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e548a7-483b-4697-5d4f-08dddc116617
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6439.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 15:35:44.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pRC7K3XNnVEcT8wmOTxm7NmZjvlbNbqT9A6sgdUILlx6kifltwpokPvh2yKaELcxhBQ0KX3bENCSP3cRNxTXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9523
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 376984000C
X-Stat-Signature: ed7utwt8kiyh8bwqnqqwech9hxc3m7g1
X-Rspam-User: 
X-HE-Tag: 1755272147-482039
X-HE-Meta: U2FsdGVkX19iCtblA0TDhObH4QCNFXt2GxoqupxHMn4Gknc3GjhEdqdOMcwUkCBAzJqDiBPb7qK/FCKPnIvPrK7MQz8Bnf+dV5+9AHNhF1odb+D31aYy78qBfO9wEJcQy5rp/ao7kVZJDvma/A5LAH6WvwdtL7tfRt5icZNa8UMsHvlFG1dEUtVi/dC1whCpptgqKak41M0WIHXJGIXn1QMX6mhHUQVjR9lN0UFIlbJBeAvUoG+pm6qP5hzp+4ZYnBwyhK8uhKOO69kZJY2Z7Tr7h4uGrRf7POs3LVE1fLIuXglsLOiZp24tGx0Sw8zp4okb+pyAEgXDA+VvhCC93YFV4Y+H5qKrvXtTuKxZrBZiIzWbfcXekU3+iSbDaJAN5qzBsw993i+cE2LZ6AIcwPdkvsqcyoOh95g0WG3oIb9NjJ8uvlqayZsS5BpnZsYtOi9MyQitFiAkl8WP5kPX8BKrH9Ua6HhW2uGsjCgh83E2NCt/MRjQoi0ashFpfSFDM31rj7SlbcwYFG4T8PC35znxRsBoC/MTvCFGH2X7MCTAaQhEUrFNDuJ0hqJO/JjM6rsqyBN3HsOWrgFhm1z6rsNaXA/4f+GfwuwdRcvjvrteDDCg+2yRBmG/SWdG02Oi95YMdRp3RKpIMT4mtq2p4cjdCeVDJlwh4PoaEgOjK5qdjw1MsPPHv6FNrRQG+UX1hpesvVr4bMrD36sJ+ZNedhz30c3iiJCWMRRE2T2tkwyS4LGAHLX+olSJjWKquFtjtMJW1CVZHirg5evdEmuZ8X5ngfhDbwyYdd+jzd11tc+LL9DR4NL96FKZ3hQ3uVavzahbFnl/aG1uqEmUpNOFdAMBsteE7bcWEMeeo0GBbWMnTxbPoPZn/NdPUkAQ1BE2PRn4iOMDzdTe+pnPnFz/9KDn9t+4gvr5ag9xjP9Yr6W4dci2Ry3uAxHS9mb0Ugyv1z7N4WoZTVuD6j+INX+
 LA0QtCCZ
 YyFfur2dCDhbs8/zwsVOd55StA7ovnVJNxl27FH1ePPADSkweaAtwChVlT3rNUL5qBscgJv6W1yNrZWVxspY/96xGA64jj2YUwF0vJt59stMmiTntt+iYr0yQ+X0Bu1KnqhKT6/te4voJ74KLQ0CxjD05WWwNaiBV6sGZBNUk7cHGatQkUDJV8IHyKRaACF4czFbWsb4sQElxWgsXfEza34ZqffmGhYofci6lq9wZy/qw1ZEcpDFuxIpxxRGPN2CEvr8XzRzPThpQbAWT+BCQsXIRclTYnkDyP3sKhAzDzmopL5xTM4lH5DirD/isqy4wX/kSzMxLu7lfMS2BSnT5VvZFdlr6Z6wos9wi6VeMrfSrtUJwhaNEfd2Ow2PP4fESq5l7LEBX6UxtuKcHAEhEDO614TVzjJ5kC0LN+kcpzPqB64ucYLgiNUcH4nmLkQusP+7c3E6Fj/I0xgUl4tD6YLEUAV2xSFbEUkbOevA7qPV7stnz8ys9ZgGg8gGLqADuCPpxzfNVjxAvmEX762bmEe/r/dBZ5ljlcklJlCY9lHMJm5bLQCYbHlcA2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15-Aug-25 5:29 PM, Balbir Singh wrote:
> On 8/14/25 23:48, Bharata B Rao wrote:
>> Hi,
>>
>> This patchset is about adding a dedicated sub-system for maintaining
>> hot pages information from the lower tiers and promoting the hot pages
>> to the top tiers. It exposes an API that other sub-systems which detect
>> accesses, can use to report the accesses for further processing. Further
>> processing includes system-wide accumulation of memory access info at
>> PFN granularity, classification the PFNs as hot and promotion of hot
>> pages using per-node kernel threads. This is a continuation of the
>> earlier kpromoted work [1] that I posted a while back.
>>
>> Kernel thread based async batch migration [2] was an off-shoot of
>> this effort that attempted to batch the migrations from NUMA
>> balancing by creating a separate kernel thread for migration.
>> Per-page hotness information was stored as part of extended page
>> flags. The kernel thread then scanned the entire PFN space to pick
>> the PFNs that are classified as hot.
>>
>> The observed challenges from the previous approaches were these:
>>
>> 1. Too many PFNs need to be scanned to identify the hot PFNs in
>>    approach [2].
>> 2. Hot page records stored in hash lists become unwieldy for
>>    extracting the required hot pages in approach [1].
>> 3. Dynamic allocation vs static availability of space to store
>>    per-page hotness information.
>>
>> This series tries to address challenges 1 and 2 by maintaining
>> the hot page records in hash lists for quick lookup and maintaining
>> a separate per-target-node max heap for storing ready-to-migrate
>> hot page records. The records in heap are priority-ordered based
>> on "hotness" of the page.
>>
> 
> Could you elaborate on when/how a page is considered hot? Is it based
> on how often a page has been scanned?

There are multiple sub-systems within the kernel which detect and
act upon page accesses. NUMA balancing (via hint faults), MGLRU (via
page table scanning for PTE A bit) are examples of the same. The
idea behind this patchset is to consolidate such access information
within a new dedicated sub-system for hot page promotion that
maintains hotness data for accessed pages and promotes them when
a threshold is reached.

Currently I am considering only the number of accesses as an
indicator of page hotness. We need to consider the time of access
too. Both of them should contribute to the eventual "hotness" indicator.
Maybe something similar/analogous to how memory tiering derives
adistance value from bandwidth and latency could be tried out.

> 
>> The API for reporting the page access remains unchanged from [1].
>> When the page access gets recorded, the hotness data of the page
>> is updated and if it crosses a threshold, it gets tracked in the
>> heap as well. These heaps are per-target-node and corresponding
>> migrate threads will periodically extract the top records from
>> them and do batch migration. 
>>
> 
> I don't quite follow the heaps and tracking in the heap, could
> you please clarify

When different sub-systems report page accesses via the API
introduced by this new sub-system, a record for each such page
is stored in hash lists (hashed by PFN value). In addition to
the PFN and target_nid, the hotness record includes parameters
like frequency and time of access from which the hotness is
derived. Repeated reporting of access on the same PFN will result
in updating of hotness information. When the hotness of a
record (as updated during reporting of access) crosses a threshold,
the record becomes part of a max heap data structure. Records
in the max heap are arranged based on the hotness and hence
the top elements of the heap will correspond to the hottest
pages. There will be one such heap for each toptier node so
that per-toptier-node kpromoted thread can easily extract the
top N records from its own heap and perform batched migration.

Hope this clarifies.

Regards,
Bharata.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E42D232C6
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 00:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B526B0005; Thu,  8 Jan 2026 19:01:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8186B0089; Thu,  8 Jan 2026 19:01:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F826B008A; Thu,  8 Jan 2026 19:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93CD66B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:01:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B389140298
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:01:31 +0000 (UTC)
X-FDA: 84310471182.24.0312DDB
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012022.outbound.protection.outlook.com [40.107.209.22])
	by imf07.hostedemail.com (Postfix) with ESMTP id 55ECE40010
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:01:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="p/5eIJbc";
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.107.209.22 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767916888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkJXu03MJxVbuy7YLcS2KiCyGPqrSwEE5Yx0XEdHM6w=;
	b=EMfXrFsRMxlr4jn0Xt5jdqEc9aEvxPU+SR71rRYL8aSwdM14M7EF/6hH0BVA6TCVNyp9Od
	PGKwOVTsRCZnsyB0TPewW+j4raBIACQRvpIQ6OyZc4BqfAmIjxg6/zMXu5bUlQWHpxMcVN
	wnUYaQQATjvx0MRYzXXZrYfY5suW9y8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="p/5eIJbc";
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.107.209.22 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767916888; a=rsa-sha256;
	cv=pass;
	b=Cqn6gKHJLuCvY17sgCBaGTtHR9CWTUzYaYOaaoWeUY/j67dYNls9d+I3kpoMfSSlsN3GoD
	V++ICLfJPqg2h7SHV7Q8i1N2hcPfXO42diqXVcPylv2bQoLgOx0KcB7XYH0HZzOM7ZLNVJ
	OfHl837MBuL2Syqffi+Uf5w3X+a+WWg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5PHlpNSzpf3WO/5MbdX4RCyGMTIyuWVR6C2hwsl6ADPCksAwPx04l+A7lHRAXLVsYDxWAx5/GZAMXlQnMoZtfc74QFw3vSSlTUhxTwHHkebhaxGPVeGc9m49BIFoqdmcq12mJD102yaN+ganIGDrqUs5mPQ7vH9QPEYuSLYN/l1cnTyJmpSNE4PDKXnyt/uxUrMAwfT1Rt9AbfTi6Ghf3ysJ8QJ7DcIFSt+saCCU62FNHmWndEjQS1KL4OAf9tkcWEeOAsG9wK7WyhepFqsNWayqdtqjqBQR0/SuxwEiXc1BwgdHWcQZS93CPWw4+PpOST5pUIyoTsbet+9n+825A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkJXu03MJxVbuy7YLcS2KiCyGPqrSwEE5Yx0XEdHM6w=;
 b=aIqO5bUXIm4Sx6fKqJqSul4wEhi5FWPteixkGTV8c8xKFBzmwdWcHmkfuNLu3TooXavBpfjsgsWOn/2YHP7+7Q0Anq5s+2wPb+B3ITg0AmHDFNC+6j0q3XI0Y6siRuYvNNDBqKV2n8OWWIFMy/TUEriVaZAmAX/egFkUqx2wwmsBlDHmn2AE62zrvd1Txg9/aIHXiBg/wQLxCiWoVZ/5/3y4H5zy8CkJx87igSVfW+i22QQNU45viY/DPB5a4jt68OiscZm5bu7SwjY4VfKdyXz//nM/05kwoaazfcj7eNqtoBPyvfdMJ4hfFGWZ7+x+AbUaMPX673osLzaW241dOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkJXu03MJxVbuy7YLcS2KiCyGPqrSwEE5Yx0XEdHM6w=;
 b=p/5eIJbcTg2eaiDqPMFY0/cP7wwFGyR93OKIcS3T7iRfLHwHEqiuQMv1bq6T6AKtgpmuNI70aahaH2yIR4D0U6B2rEHMR1f2SMNsgw2vT/XXm560goazUIhHOG8Y5EkHQK1kDTxOcA6VUW+pT1+ByimYeBONX5xX/DgsqvnDsm6V+YFRWMvsxXfsuNxTKE5nfdtJARMFIKTMx6H2dEdrl69HNXEbfxp0s/3UkzQKd/06H/ZsEh1pmKVu5gP1ERFG2qrgObrFi4zndWZ4nJ15X+IkEJTQQuvM3XB0ekNy4BVqYNy+4xzvvr2I/iAfsO+OoQ1SIXumzktpNg68c5QSTg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SJ0PR12MB6992.namprd12.prod.outlook.com (2603:10b6:a03:483::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 00:01:24 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9499.002; Fri, 9 Jan 2026
 00:01:23 +0000
Message-ID: <eb45fb36-4f0b-4a83-8852-abac3205a988@nvidia.com>
Date: Fri, 9 Jan 2026 11:01:13 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] Remove device private pages from physical
 address space
From: Jordan Niethe <jniethe@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <aV6nvCw2ugAbSpFL@lstrano-desk.jf.intel.com>
 <3586d8f1-a25f-4087-a987-162ccd97c25f@nvidia.com>
 <6a911224-05e5-45ee-8008-e36ef35cbc7b@nvidia.com>
Content-Language: en-US
In-Reply-To: <6a911224-05e5-45ee-8008-e36ef35cbc7b@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0011.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::20) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SJ0PR12MB6992:EE_
X-MS-Office365-Filtering-Correlation-Id: 74adfc7e-e766-4fed-5751-08de4f1239c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHRnL2loSjdzK2NYeTBiTTgvWW9LVE5MQ0dkbnlUM2RZZjc1YkJWU20wMm1I?=
 =?utf-8?B?K2N1UmlVK0JjSFk2bGwvcnA2OUVFM2FLZEFVaGdOeUlxZThlY1Q5ZlJuQ1cx?=
 =?utf-8?B?cjJrYmxHUWREbzcxTEhmVGhLODFtaEdySXRxOHcrdlQ1QTF3MWgrN2NzWmtn?=
 =?utf-8?B?dnRoT3E5bUFkWWlaWC93MENmUHdPNEhFeXh6d3Zud0pwUDAyNzRSK2tFTkxR?=
 =?utf-8?B?dUd6RklFV3Nia0l3MXUwMWtTeEh2SFRNUVprNWV3M0Z5ckR4cHYxNmZPMlNX?=
 =?utf-8?B?a2JUN3J2QXRHdWxjRGhVa21FcW5KSXRhVnYzL2dhdjhIMk50YWt0d0VtRHNH?=
 =?utf-8?B?NWN2bWIwa3JBSXJ3UGdtYmRPMCtGeXVKRjUwZVA3Qm96cmhjaGpaVnJVSWps?=
 =?utf-8?B?TUVQcGc2NSsydk9VOVpIUTFKano0YktSUnJ5SUhSM1hYTmZaTW9EN0dMa29H?=
 =?utf-8?B?UnAzOWcvMnpCYlY0a2NDWTVCV2JjR0dRRjdJVjA5alpqLzVpWXE1bDhLNWU0?=
 =?utf-8?B?OGIwK0pwQ1B1MEZLUmduampSUEF5ZlhlYjUxdnF3K2VBTnFoUkpQbVN6UFpJ?=
 =?utf-8?B?a3RxYU9SOStOS1ZnRTFrUDRYT3pYVE1Ea09PVngvcEJ0V3R1SnpKTnB1UTF3?=
 =?utf-8?B?dHQ2SkhIWWVaTlBIbll4SWpHNkllWXhEMWVNa3FjVWd6ZTBuMm1ka3RBMGgr?=
 =?utf-8?B?QVVNeTZJNjNYY2puRUZsOWQ2M0FZeHpRaWpUMGRUUlB5eitudjZXb0pwbFZn?=
 =?utf-8?B?UnA2RHZSRmNKN3Z1S3ZBeFNVYjQ3Uk45bmt3YVRnYzEyMzlPcHlLeGRJcEQ1?=
 =?utf-8?B?WFd2V0V4d0dsaHFDUSsrTENpL1VKSEhmN0pSaGp4Z00yY1NxL0c0UUI5SjBo?=
 =?utf-8?B?WXdNZEIyUXp2RllTZFo0MzVmZGZyYnNiY0NSNkdtVVhzNWRnOWc4TW83RjFN?=
 =?utf-8?B?bEsvS0lZaG12bzhzd2xjV0NhMi8vWmhwZ0t4dW00R1RtTUdTN0JaOHFoQ0Nw?=
 =?utf-8?B?d094dGZYd3B2TWVWV3UyeGIxcmx4WU8yTVFaei9vVUZFc0xQV3haY01DV0lX?=
 =?utf-8?B?UjBnbUloSGtaWlVxVDR5RVdxQ3pHV01mRldPT3M0NkxyODl5VXlxTGp3R2Qw?=
 =?utf-8?B?cTFQUHdpOTdsZEJZQUpObmVCaEVaWGZVRFpISUR4Tnd0L1dneHNYSDNxaGpZ?=
 =?utf-8?B?WENtb1hRVDVBZy9pUHk0RFlyZUdNS21ZRzFuUTNIRkQ1bjIrQVNFamZQTDlv?=
 =?utf-8?B?RUtBQkY3SENXbDNYdW9XMWFHSEMvcUYwbXBNN0N6b3dhUmpybkovejJjdU5O?=
 =?utf-8?B?TmtMYjJKdUNhaXpGZzhaNGZ6RGtxaFFCeGVtVTUvcFNTQzRsekxCOTNPalFt?=
 =?utf-8?B?R2JsTTNMdy9PajhLQTZuOXM5SGdKZW1XTGNJd0dDck4vUndrSFVPc3ZYMnpp?=
 =?utf-8?B?UENLc0d0a1hTeENvc0pHaXhJV3VBaDMrQVI5dWdNdXpZdXN3VUM0ZHdPaGxy?=
 =?utf-8?B?dlJsUGhXcGkrOW5SYi9rY3VraGFkSzBMdU1iRVNEd1J5ZjY5YkllYlFDOWI2?=
 =?utf-8?B?YnJrbEplb1R3V3l5M0dsbE5mMFZuRGdCVFc0Y0RMbDFtZ0ZyMkY0cDB0bHhm?=
 =?utf-8?B?WndWZjEyVlRRK29JcVpJeVhqZTcwTnluQ3ZET3B3bklWbGJwNGxGTnYreGVO?=
 =?utf-8?B?Y3c5WTdyTmJxTzhJTjdDWWptQ1lQWk9lbzZRVzVVcmVSSFI2eW1taWNjcVZP?=
 =?utf-8?B?R3A1N09oNkZTK1JlYmlYMjNMMkcxeS93WGZxbHBNcy9jS2hqbFlKaExuTU9z?=
 =?utf-8?B?UWI2Yk9FQk5EZzZxdzl1d0FhanZEZ2dCaFdJb1NoUEFEQlF5WFBtZEVyekhG?=
 =?utf-8?B?S2ZvUlAveDYxMkYwcmhHVDg1ZUpkS0FLNXNPUktPdFMrWFQxck5pNm1lODAx?=
 =?utf-8?Q?HuL4PTS08WqB7xIaccJJ4KmpEhwXvh7p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVErdnhiVmVtZmhYcjd6eHJLNEZWOVRSamJiWEJ5Mk1nY1N4Q1M2ckRnN0dz?=
 =?utf-8?B?QWV5RDFHUWFFMXczU3BSblVMYU5ZR1JiYzJKeHFuRStaNHFtWXhLayszTkc1?=
 =?utf-8?B?emJiYncrblJwMC9iNDNHaVI2bXZIQ09pVXYyTHgxanE3YVN6bHQ5dC9wdndX?=
 =?utf-8?B?TWhHeWxkVThEVDBmSHZha1JQZmZzakZLRlkvTk9mV1VjbzVQV2p6SFhzYkFK?=
 =?utf-8?B?eWlhUkNja0VIUXh0amRlajhUbWM0QUlwRVZRVGhYRENUTnRxQ25Ec2YzeUlB?=
 =?utf-8?B?QkovSWRXSzR2TVFEeXlkMkFvVDVtNVNDNFVJTDVTK3FMMjk0WGRBQUNtRnR3?=
 =?utf-8?B?VU5KK0ZrMVUrWUFobnl1KzQ3c21ZOTdTeVdHb2dOOGsxZU9BbXVUMTR0MlRO?=
 =?utf-8?B?ZnN5eiswREE0SU8xQ0dkdzlDQzNkc004bUZOOWwzS2t1VkFtSXhFTjluS2pD?=
 =?utf-8?B?TW9PejRrWmNEWkpia0F6TzR5UmRBbCtWR2FUeVdVWjVDbkZsWkFQOVh2b1pG?=
 =?utf-8?B?ckkwRmhrWS9MTWk5ZVUydXhYTlZIV0VKZlEzK25Zd3YvWjhjTGVYRWNFQ1U2?=
 =?utf-8?B?azRJNCtKQ2JXL2haSFRSempvaHU3WGErQkozSG16TWNMdm4vRlRpWnZSZDNh?=
 =?utf-8?B?ZW5lS0YwRlRqYmZVS1VOeHMxdERZTERRQm9va1VIYm9SaVU0MG1nNWpaaUJN?=
 =?utf-8?B?ekYraTlENU9UdStHZ3VMY09oWnVxcCtucWYxZnZ5TWo3UWZWTEYyUGttbVdv?=
 =?utf-8?B?cllMcTlxM0pvdm1Zc25ENndZVHdWZFlsNFVscG9TbXlzb2l5Vy9mQU1LRGd1?=
 =?utf-8?B?LzM1bnREdlFJMnJucHF3VHVNTWsxMlc0dUZVc0psUmpLVjVxYTZmakM2REtp?=
 =?utf-8?B?ejF4cU1xMWVXMThUOTJ6NHBBR253aGhKVGVwbDlmQmd6cTlJWHJ2R0pPbkNH?=
 =?utf-8?B?ODBlMWVlOWd5WFNzeXI5RUt6aTl5dzh2bHJCaWRiR21RSWpSS0g0YmN3U25l?=
 =?utf-8?B?MzB6S0g2ZFFWcVd5VEhlY28ycGdkY1BqMkl6eHJEVmN0N2puck16SlZMWWdJ?=
 =?utf-8?B?TUw2QUJHUmlObjJFVmdHdTRHM3pnV09DTDNNT0lOTG53akx4L0dPbjQ0N1N0?=
 =?utf-8?B?VXUwTWluNjRIYlZNSVErUWxvRmZJdnN6SExEdmRhbUhBbUhYNytXZkxDMEln?=
 =?utf-8?B?c3JMOVN3MlY4NVFGTzd2V0R3RHdSZVBsWDQ1Z1c4WXliL0Jhb1MxeDZYdmxH?=
 =?utf-8?B?b0xub2lJRndoTjVTSFpoS2ZHdW5iTk82OGM1aEJXRTZlYjBzNUhENWNNL2Rq?=
 =?utf-8?B?V3lBQlhYTWdtMjIzTDZtejYwdU5SWFNrQTVJZzNhRTFWV0xabldqOHBobXF6?=
 =?utf-8?B?ZWNwUXVsOEVhdUhlVzRkdEtHMFMxdGNPMkNOU2M5eTNMdFJ3dFBjMUhhN2lD?=
 =?utf-8?B?VjhDMzVEQ21nVFI2ajlYbVFuOGpodmpYeUdIemxWNDNVcWVRdDIzV1c0NWd2?=
 =?utf-8?B?TGV3L0dSVGNINGFvNlpRTkRXT1FvL2RXYk05dTBicEVWWDdKcFhLZHFzaDhE?=
 =?utf-8?B?UkxwUEdrSlZzQk16VjAzbEViRXB4by9YTWgxeWpydzI4TnBZYmpWcVMvV0g0?=
 =?utf-8?B?NWhOQS9ORjUxV0daOTdDc3NzRGVYZDRlbTl3UUlZZTBnbVVRMEo5S054MGI2?=
 =?utf-8?B?b3Uwc3hKSFR5Wng2K2wwSlJYTVluUVErVHM4SWtwaUxSNEhoTFhOWDRRODRD?=
 =?utf-8?B?eWlSK2NzdUdneHZVUVlrcGlSbzRaQWNmaU1ObEx2UUc0RGZwdkRrL1N1bkRP?=
 =?utf-8?B?NjBXbDFhSkVIN2wyUVVmalIxRStaeWNRbGVFTGY0Y1gwM2RBL1FMQXNUUkpQ?=
 =?utf-8?B?MmE4eW81UjRCSWVqY2xvS2xlbExnN0FvczlqNmpWeFVGblpEZWowZUtZVENl?=
 =?utf-8?B?NWt4YXJ0VjJBdFc4RCs3WGg5UExQZnFETktBTHVqS2RSWng4c1R4VnJtRnZD?=
 =?utf-8?B?dm5pT09WVnhNT3JSbkZ3dFRuWVc0Wnh0NmZpcUJtbzdtTk9Sb002TUlFK0tI?=
 =?utf-8?B?NURWVi8zWU0rL1hBTld6N3ZlT1VDY2pNZXpKZk5SRUtqVksrWjNNd3IrVnVi?=
 =?utf-8?B?b0JrQ2NLdUh5QkY4YWlodjR5bmpZUlg5ZXpHQXdYcDhZSmJEVG05VVA3a05K?=
 =?utf-8?B?Z3FSMGd4QzRaVExUSVZCejFQc3pIbURlbm9MTlQyTi8zUGlkemg2V0Z2Wkli?=
 =?utf-8?B?bllkWE9IMWhpbXhhWjY3TjFuaXNwSjkzWHh1MHp4YWRJbjNvaGd6dW11S0tC?=
 =?utf-8?B?bFptSm5ONzBGMXZXN3NWWCs0VXNyWlJTL3JVMm9wMDMxNjV4ZUhJZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74adfc7e-e766-4fed-5751-08de4f1239c9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 00:01:23.6301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEjSr86M0AoaEzGgt5YZaYWi5FQZruUTddHVW/A83pki3vm99b6IHzirHUZbh2cXE+0+i1BKTQYWWTOQqrflvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6992
X-Stat-Signature: 8e1raa9wxtsyu1rtbpifsnhf6y5eitfi
X-Rspamd-Queue-Id: 55ECE40010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767916888-71338
X-HE-Meta: U2FsdGVkX18T6/6tRX8jzEqILN32eOg2+TGUrCh/YLlKA9T9SMJgBOM+drQE8k4OtK4hPDvJSXSHIwvEiYzlY1FKreuAhq+X7xGY0BqlKk4V2vJATyDQYc77PDTWOfbJem2FU2i+UnooSOr6x/mhcvoTZKP6NE4gfIzK9wtVFoZVCd52nGo0Q5RO0rve7r72dgHyo2qUh/DFHza/riMsOgeCZSaN/2sjy6neY2fuckf8cEsrisKogS2LahY8kj/JiR7kefNeo/T6om9PwUMjaSFaxZRETv8H0w4hNdN0x0yNL00Vl/QvPVMdwg6+RtPqU4U48RphHAa0zEJ4jeW259QqGg9+33HePk+xVbiIjlkLQbabLcKCFEEncvsbePppIUClFsgoHL1xaNfY5KkcBcDIU3SFZUvV17SOBy0RAQEjSJeU/dO0J7e+hr1+a3DMkY64tReQb0rWmTpBaAL4N9IZc8XXSY4Zb//6uMHPkpFlYjmf2nMZFkiba9WnSXBzFOn2muofqWTqzRGr2111hmRYChEzHCeL6xSAuZTk+cDg9WoKcO6YBZirjtk+iJNL5wp+GdYUaUFDAOX4fBVEaUDReOqrnmJkE/LbGzJcsk/S2Tmuo2sEJ1IsLZwdgnUo1uldkGh0nlXzZVVDLZjKa/3GYYmRzC4yzog75XaXk9ovPz/vsn8NfUCHTrqSdeNm4SXcLL307cr1GND/khMEonLVvoHgVpEY+GtCLe6ZhAxFi+0lwhLIH4HCOn2J4b/T7Vh1BVtQsvHZYnlCeOnEIt3CSxRV+h+mFgrtS2jDk14UFx/TzQm9REAKHmuIK6ewf2UA81NQRcrTGqSOlM4RztjGvvulk1YhcxZmXHoWz6VerlGQo6dfvotH/W/YVHfBtSd4bysG0SH4FTrjIa6ay2cCvKfauwTfv4rQYDWeQy7AFHSnB0Iot/JEMhmuXf3rgg6P5xABXhd20NgnD1x
 Sf0Cb6Ax
 RztYiNpQ7NegWzuguu/2EoAyBgSmxYWnskZ+AFBwtKyWNqpMFbf+7ySGbrW3i/LfFgpwBcVY2Lj917DuRLawI7Q/B5xhg3pzgABk//d7SXxPqUJqNNS6RB8UoQpJPRdPq6Tv64FinXFlq5w31sPcMdHn3pHc9S/vp2uK4X8mYL/6CPezsTBY/Hd8rZ9U0HSUctQVdRFK+h44oLz+IiMwsCTbIicSHWhrjoRPydCvetPk78Fpyiq5MsTi7r6zKRB/cozN3rac1hx2CB4hQ/CJCO9KB99+OTQeZN5P/+AHDAxOIVrR4lLmwzlzYtUF2tLltjmKkMgxcde1g1LqH16PWitea7lrUBbEtK2nQn4VpUlHU9XsGTilnAu5vh/dueF+80cfqnKhm1hEInquBnkUoyFVweSx3RSbHxVlniA83CuJYnNzSynQfgSOMWNRAga4NsP18Zs0aC6z2tvGXGGQdVBX9HbTLGHzcSUiu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/1/26 16:42, Jordan Niethe wrote:
> Hi,
> 
> On 8/1/26 13:25, Jordan Niethe wrote:
>> Hi,
>>
>> On 8/1/26 05:36, Matthew Brost wrote:
>>>
>>> Thanks for the series. For some reason Intel's CI couldn't apply this
>>> series to drm-tip to get results [1]. I'll manually apply this and 
>>> run all
>>> our SVM tests and get back you on results + review the changes here. For
>>> future reference if you want to use our CI system, the series must apply
>>> to drm-tip, feel free to rebase this series and just send to intel-xe
>>> list if you want CI 
>>
>> Thanks, I'll rebase on drm-tip and send to the intel-xe list.
> 
> For reference the rebase on drm-tip on the intel-xe list:
> 
> https://patchwork.freedesktop.org/series/159738/
> 
> Will watch the CI results.

The series causes some failures in the intel-xe tests:
https://patchwork.freedesktop.org/series/159738/#rev4

Working through the failures now.

Thanks,
Jordan.

> 
> Thanks,
> Jordan.
> 
>>
>> Jordan.
>>
>>>
>>> I was also wondering if Nvidia could help review one our core MM patches
>>> [2] which is gating enabling 2M device pages too?
>>>
>>> Matt
>>>
>>> [1] https://patchwork.freedesktop.org/series/159738/
>>> [2] https://patchwork.freedesktop.org/patch/694775/?series=159119&rev=1
>>
>>
> 



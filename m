Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C300C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C908E0006; Tue,  5 Aug 2025 20:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CDF88E0001; Tue,  5 Aug 2025 20:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EB78E0006; Tue,  5 Aug 2025 20:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA1128E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:54:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 789E2140308
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:54:17 +0000 (UTC)
X-FDA: 83744511354.04.4A19558
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 003E140011
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:54:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N0q5auP2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GuqLWYSh;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754441654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZJFpXrk75g6fDLodVzAMwsNyZTxWjSaREdcu0/iM1o=;
	b=gLUh7dM2x93LWiykwiGVzc6mY3OyDoXvZc0ryvQEhb7Z3873GI8+5yQt0gPxhNiHWFpIh4
	76uMjF5MBYDHMSaVLyDFvjJuw/VdrZVFsktM3qcuD4qdY8P3Sq1plhbahIQ0bV5nxj8zae
	yrAgSIoB2eCYrOHvU+koKNPzdnO8beY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N0q5auP2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GuqLWYSh;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754441654; a=rsa-sha256;
	cv=pass;
	b=LPmkCXMTMWdANkaJ4cj1TzoTcO2fYWNn4Y4Cvo36wU7BMGEGyXXaXUqWZuz0H3SdIju3pF
	YQOTEPBNlKkSNtaF4+M/KZOheH8l42CcQ/LKPMZQD+qWr4MoP0lu6/ZwZMj01SEq0b4w91
	KxkVZJKhsa9Bxt4KUbTEEceWXL7TxWQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575LNaVx027916;
	Wed, 6 Aug 2025 00:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zZJFpXrk75g6fDLodVzAMwsNyZTxWjSaREdcu0/iM1o=; b=
	N0q5auP2LCfet+roBDBVZ04QHxAZJhqLdjRLPPkdFqZppMCEXj4slLRTM4onu+XU
	9oRovrTKtPi7HyuEJs0dGrmUYtkAeZqGYrI+bTPPcuBnNCCIukRLwxAhI7pKxaUn
	NinuKTgKerVwKVOS4UQwdAuzqdQjwllQwSZoGz5mFu17NzyakmTEMOKOi1kTs7At
	D+dl62BWOmf7MMjbfeNoHlPrTEEXVIKUSy6DJPkdFd3FFN6uIWyjJKGft0l1qsKj
	0sYh6xcGimP6bsqX9oslRBA3Gkyuf0OYheVsMpDWquJJ5iUP35g6uTsIrQK9Jeib
	ZTMDw5HLGkYaJdCO1NoOnA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg0jgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 00:54:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575MUECq027366;
	Wed, 6 Aug 2025 00:54:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwmbm8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 00:54:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlh+4Mmm8ErnFvyq39gpa7CEBvQjg/fvLT9cBhsvvIZqNS0PvLWbjcRcKwv5kZc9QpvSUeSh+frBCGAHjLIZrRL7OUaXBNNaQ4Qv8GinGXzm5jUnPEH1CcCOgcSrYRLZKsLw8aaTX6EfLPyWt98ETJMPpr3Wv2826nQTBr37qmKcV6Qyjwb1rGDNyIvuI5rt8Wj5PKnBITeCGDvF5VBsbG8K3fYacHCRFgIzWvgo5UmrzgEzA4T62ZrE+6D7MnKNOUWGkA7P4ASYNeFIVdEJ7P/EuoIN+/7hjwCmmkxybx7Es+omM8INvOw+SLzDvBzx1nxOnvy3eKKHGZxmZqUP8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZJFpXrk75g6fDLodVzAMwsNyZTxWjSaREdcu0/iM1o=;
 b=kID2x7XOg9adhlNklC3BY8sry8GG6ZbZoqAsmK5Zai/LSYWEXMuphOcL4h7rT5hXWSt7BInIze1Pcqt+Z2LbXOcdGOmmLKG5E4pmADjmI8yvXf6GG8nlxP7GaBcSOCPupPSTq09WUMeVSwN0jdyjI/OhJSpFi0zdzJsrSs6Fbdc5wsbHLXgfR/xLzjqYJbIVuFKCyldmkP6zjhdrJ7zNEWEDnbbxp7DiYWNIxcmN01HJn5LMU/EBlahrPo5Qb7oCtPYnAUfqFUSWEwtUJ2Q/rsAbgjlGY9gOWZPIeLS0JYbK6QC8gM4+3uSXahyc2zJOUho0qifXLKVIIK/YnC+DUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZJFpXrk75g6fDLodVzAMwsNyZTxWjSaREdcu0/iM1o=;
 b=GuqLWYShzfOYbiX4UVIdKFyVtefa0lu4xQsL0d6gMps6cETkpBAIHRY1zCGSdgOoSJmzPrpCMzJchO2XT4V0TFHe+6+OMbs6SCBpuT0L5Fz/sX/rJk7i3lIc7g9wWpxJrljGhvyfn6gT+zJvaievvgsP0HHZ7YaHdzd0RMZLurM=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 PH7PR10MB7085.namprd10.prod.outlook.com (2603:10b6:510:279::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.13; Wed, 6 Aug 2025 00:54:02 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Wed, 6 Aug 2025
 00:54:02 +0000
Message-ID: <55ee1307-a367-444c-9ecf-e36b3f77152e@oracle.com>
Date: Tue, 5 Aug 2025 17:53:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: hugetlb: convert to
 prep_account_new_hugetlb_folio()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-3-wangkefeng.wang@huawei.com>
 <aJEZ08orJ3jrBTH1@fedora>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <aJEZ08orJ3jrBTH1@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0094.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::35) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|PH7PR10MB7085:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d2e56be-017c-45ae-5940-08ddd483bc35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDI4a0xteFNEM2FFcmVOWER1bkd0U2IybDNtVm9CVXdSTUMvaVNhZnRJSTFj?=
 =?utf-8?B?SjUyN3RnSkdkUTIyVGhpZG5JNUMxTlJMZFc4WjE1M2ZIZmVEek9DVnhpUWRG?=
 =?utf-8?B?ZnV3Y3FSS1ZwMzZpTm5aTEF5V3hHMGhFZmZsajNSSUR1VXNmSCt3OGFnOUJi?=
 =?utf-8?B?MXlpYkkvOXI3TnBwK2tFTU5VS01BUzh2Ukxsb0dVdGJZMGFJcjJNdTQrY01I?=
 =?utf-8?B?N1hmTWVZaFJXYnBCNUlJcGhHTTZ3bXhxT0lwZDJkdVhTSno2SHRrSFlZVnRF?=
 =?utf-8?B?THNEZ2hjSnVUUGZQNmsxYUk4S2N2enFVWUpwc2RiMVhLMlRtMmpmWEU3ckRp?=
 =?utf-8?B?YnE4bU4zTGZadlZ1Yis3Z3BXZ1V3OGwyYy9KNFhwb3Y2RjBVMVVPS2xXdE14?=
 =?utf-8?B?WFZYSHRMQ1FGdzN6c1Bjb3V2OVlTU2VFZGdoZ01Qd012cmVFSFBTeU5aRmFQ?=
 =?utf-8?B?V2NmaFF1WWVQc1AvMnp6aDhJMGpYdHVyTnpScEVOV21ZZTJxRUhMNEV3QkJL?=
 =?utf-8?B?a3RWUS9BU0QzRHY0UUk3dTIyRjF1TzhIS01vRk9ZNWkxMGRzZTFRdit4RERx?=
 =?utf-8?B?VW9yVVFpMGFRclBneTF3YkNTeUl3RXc4eXc3b3JxQWdJUDdzNzVpVS9OSUJK?=
 =?utf-8?B?QkFoa1NUWmI2bkdIKy9lUy8xSjZ4SklzQVZBZGQ2WnhEeVgxR1RJT3g0L3RK?=
 =?utf-8?B?aUFYRksrb2h3Q2xwcTVTeXYxR1h4U2xod0RKZ0FqOHYvR3hLczFKeVlVMWxC?=
 =?utf-8?B?TnI1K3hLbVFRMS94Wmd4YitoblhOV2h3Z2ErM1hDMUlVQzVvcFVxY1E3TExr?=
 =?utf-8?B?b2FxRkdSUkpyaGJoOVZKZU1ndXlpVk9nRFZWckJEdlBiMW1kMW0yTkcydFpG?=
 =?utf-8?B?NU9VS1k1dlBTVDIyc1lTZm9BMlBabWZRcXlzb01mVUdTM0xrcGl0bXBBaElO?=
 =?utf-8?B?NWhIK2pyQ3dZSVZaU3VNdlZFQkVhWlBreUE2T0hGSjh1TnBHZ0RmaG1TZGIx?=
 =?utf-8?B?eFNHVFEwK3ZESkRzUnRtSXBxZEo2S0RtcjA2dnBGelhtanRXZzJ4RURVRm4w?=
 =?utf-8?B?aDBEbEhyVVlSeUlHaEtFSWhHb2Z4eXVhQUUyVWdxUHRBNkp6cG5oQ3VocExW?=
 =?utf-8?B?NnVzUnRuY0l4QTdKeWhYRGVGMFZ4VmJOT0pZWUZVWm5aSGVNVmRhQi9KeFR4?=
 =?utf-8?B?bE5hZ1oyUEdKekM1UlVqcTk0Z2VjeG9teXJxTVhJcmQrYzZFaDVZSXVxSFNV?=
 =?utf-8?B?eEJyR0I5U294dFAvNFh3b2xWdDJCS1JTM3BpaWJtSzUzQUNMNlNzWHp6OVhW?=
 =?utf-8?B?ZFhTVE02OEp3ZzBnbzRZY29ody9vVm5oY2M5c3pjdEZzWENDNzQ3UzQ5MUNH?=
 =?utf-8?B?bENmNldQU25ESkJSUmFoOVYzcE9ONUY0K2k4bjVzTmlJNlBvK2VWbzZ5ZkNY?=
 =?utf-8?B?UVVOZm0wdktOMEdDcU1acUIvNUZIZUdpb3pHVUJGaGRWQXpUWUluZ2VyV3Fo?=
 =?utf-8?B?MkJsMzdSMnBjbi9DZXc5MkRHeGt0Nko3MW5YM1QxYzZSNFhRN2svTmpPOEFt?=
 =?utf-8?B?MmRLZDYzaWwyNkd3ZEQ0ODdnaTZlYXNiNlFDSk05a0lBT1pFK2sxdDFmaUdw?=
 =?utf-8?B?U3BXMEo1ZC94dEVVSXpkaFBkb3hsTFM5N0lDeHRTeE1rbVNrZDlWUUhCQlVu?=
 =?utf-8?B?VjNLYlI5OW9USG5jUlpTWDQ0ZkJnYUZBSkcwbVNUc05rNE0wZmJWNHYxS1Q4?=
 =?utf-8?B?eFpVeGJtZUg0WnRCRFNCNWNLTlQyRkxMZ0NJM2FPeTBZNldmMHpTY1pYb1VZ?=
 =?utf-8?B?Q2ZWSU1BNkQwNU85emxISFhlaXVNVjZwanJSak1Qb2d3a3Q2c1BtNzJvWTlT?=
 =?utf-8?B?a3NqVFlxRGQyS295NEp1VXI3KzkyL200UWpmQlRKSUgzbXlMQ01xejBZcmdP?=
 =?utf-8?Q?NEp1EHg/pUA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXVYS0pwL0czcm4zUjJhRkFoeGNJN04vN25HaWtHUHJrZ3dxenZoYW9VZFk3?=
 =?utf-8?B?WTBSTml2QzlNcC9aemozSk9MQXJkMXJSc05JOWdVTnM0NStKcVQ1ZTBiZG5p?=
 =?utf-8?B?b082aHFQTXhZVXVYWHgrZDRlbzZPRmdhajB6cnZZOWJRcURmMy9EcUNhNi96?=
 =?utf-8?B?aDcvUUg3MkdoSG5pK1dHWGdnRTBiWXlEaWExMzRhb1ROOUZMa01VbE13TWl4?=
 =?utf-8?B?dzZtd1E3STlPRkw0RnlXY2xDRm04bEZoTnBZNkg3YkRFQldpWTZVNTNiSlhs?=
 =?utf-8?B?d0NMN0RkT2NKTUQrZzFuV0NVSzhFcEJNTFZyNFNHb09ZOVdkUmtYQStkSlA3?=
 =?utf-8?B?RVZZOWt6ZG9FdURnUmdhbk1qbmFWcjFKMndtb28rS3FRYytoUlBseHk2STJV?=
 =?utf-8?B?Z3lrK3N4Vm0wU2R4TVFJYThHM3c3VFZaVzVYaUlKeUN3aWI5d2dVeTBEblJx?=
 =?utf-8?B?ekpWQnlsSWZ2eEUybjBNajZIOEQ2VlBqMFVrVC9tei9ycCsxemZWM2lFdFZK?=
 =?utf-8?B?RjZ5YVNJUm9ZeDlqM1dJK2ZsekplckhCL2NvY2hPbXA0UjhhVU1jcmx3WXdI?=
 =?utf-8?B?Q3NpNDBaK1kwcnVDdFFIOVdtUnE1cWx4Ynp0MHAyVTJTMWN5OWZtclViQ3lV?=
 =?utf-8?B?RHMwT283OERnK1BiUURldEE5VkM0T1kwcEduMzEvYVVWc1lNVUdWU0hwV3Nz?=
 =?utf-8?B?T2VFbU1sbGpoMlUvNE1PdVZVU09rV09xRTZrTURtZjd3YXgzWDM1U1N1NGky?=
 =?utf-8?B?TWJpNzU1K2RpNzBtMjM3YzRGMll2N0RKZlZ3MFNCRGR6MDF2eVNnczZ6TXRQ?=
 =?utf-8?B?MnRrYXg0SkhnNTc1QTNHYkVDMzhvTVJSVUZnUE9iSjZ4dk5QZUV6S1BuME5G?=
 =?utf-8?B?WVUrWkdzVExIa215TTYrYitxMXdlZytzQmZRY2xFTlJlc2tadlhyd01sMFVi?=
 =?utf-8?B?UHA4d2RObmdSK0pPLzlyakxBcmFoOVNDcWxUWnVMQnNaYm01bGR1azhyNUlr?=
 =?utf-8?B?OFE4andNQ1NWL0dlZ0JLSE0wRFpveGoyOXQ3NE51QmV0d1VpdXI1SG9mcXVh?=
 =?utf-8?B?WHo1OHV0Y3UwNUQzbW9zWG1sRU83b1lZdWVMSzkrYlYwejVmYUIweWVaaElS?=
 =?utf-8?B?N2hjbHMzNUVlcEFnYVpqSzY4Zldkb0JIeENLcjFNWThPY1V3OGdWdHhEby9j?=
 =?utf-8?B?Y2JydTh4Nk4wNmNaVkMycnlkVXo4eHFQbFF3QjdPS29zbU5xNDB0Y2ZsaHB0?=
 =?utf-8?B?OHhvRXFOVFg5b3Q0QThyV2JiS2k0N1RWWjFRdDhBMkhOek5ZK0hvTWZZTFFB?=
 =?utf-8?B?djc3dE5pWHY1a1BiOHY3WlVTVUQ4Z1ZScmdVWU4zUnF5SWZjVW1tVkxwbXNI?=
 =?utf-8?B?eUJUQ255UWJaMnJDWWIwVG9vdjdKd3pzL3c0dXlWRTJjWGRVN01XTlNmdUlO?=
 =?utf-8?B?L1Axbml3UHhRY3puU0syMXVvUGVWQzBCOWZkczA1ZHl4TmlLVXBJT1lJYnpp?=
 =?utf-8?B?RjJ2eTdGdFNPVTJoNXozajZFMndDbFQzb2VQVWhuaFN3WDM1L2JzbUhuUUVm?=
 =?utf-8?B?NXhJYTZ1WlNUaHV3UnRXYVFobnBSZk1SWnpEbVcwYlhGSUtVeEZhVFlBcjJw?=
 =?utf-8?B?S1AxOVczWnIzaThqTzJzd3FpRVhsMjJZWExYNlRIOHNwT1Q5dVc2VVVzZmdt?=
 =?utf-8?B?TUVlckI3TzVyQ0xrdlhXVkxNUlJEaENjbEVDUFplMlVRekRVTVNTNFFxTytG?=
 =?utf-8?B?OHJvZGk5WllNNGVmUEVCRGVRTTBQS1FNd1lDc0VoSFFVTFRKSGYwc1VCK1pG?=
 =?utf-8?B?L1o5Sys2Q0JKQmU4c1prYW52NThMbkJ0ZUhxOHBkNS9RT05NQTA0T2hCZnZt?=
 =?utf-8?B?R3ZBcVBDaVdDUjZINnlTNHM5bmdxYVp4eTA1UjFUdDNoSy9xUlNWRzJVaFVW?=
 =?utf-8?B?OUpDcHVWTE05ZTVubmY0M0pESlBYVndGVFFjUEdoTnNzdlQ0TU5MeEtPeWtq?=
 =?utf-8?B?dzRHRzlHc2NOVExGZk9WVy8zNk1PRGdpdk9NUVhWdXBlTitmTEV2SlFiWENi?=
 =?utf-8?B?UzdqdmU3ZU9YanB3N0MxcnFDZ212UmQwcmR5REkzSnFOVTRqN0VIcVhIbVR4?=
 =?utf-8?Q?kY9fdeu/m3qJqZt5EoDnhWo+X?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bmHvXWNS3yyAIh5/G6Y+Ynj3+QeZomdIMbuLFOBz5HFK/kmM7JNeFJob+fDqpF7UDRYgKKVecLy5njK/1iRIJ/2XcnoJnLqoxdLb0Ccsomjs63lk8qFP4aMr1O09qM/pRZygN+0rcabUk4kJbDPaTO484UvfP0mx9xv0gpSuOZgFAaa4RgkfHQUEsyLR0/bTJccfWcwT2fG7mdP5oXHJ9iCELt1paYR1K7uSvQEfptKSYNrIBbuQnDkEIWIflgFEdKrhizuAYgWihn43mJNxWX4hFiDOM4aOhVtMEhu0JTkAWpDyay+6kguGZ1CTEIGYDWI9G5TS+t4eZA5WH55qcJKJAML/bfVL2YQ/04wI/PuFsRMJKojtQ4R7HzFvW40fGianFlJWqUwMqJIGtkG7NtV7rTIFuuPeGbrN+T9x/pTRP0OhD0+sMN5Qkkm3l+Cz1SbNscoFLseObwwWcYDFtLOVH7kZWjftbv88uHc6I5Ljr6wQTEnScAlx4u2ebxq1cise+VJrIxqXWo8zSeVZQHnFQHVAfiIUVSlacD9KGr6TqSv0+Xai/Z4BCawB55nIaGYgO/Uy1WYILDkfbiaEGlKbNtnNrViN5aw4iiXAcGo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2e56be-017c-45ae-5940-08ddd483bc35
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 00:54:02.2384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ar5PSJhSbIqoJuwt0HX8jjDuBCxZBGyRTkvAgbXik0vQY/u9YBFSd6HHAGUKTUFKjAjEj1wXLLnuz1xNjHXONQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7085
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060004
X-Proofpoint-ORIG-GUID: Ytl6LHWvdZ75zhx3StM-0Q7ILX0Xr6TF
X-Proofpoint-GUID: Ytl6LHWvdZ75zhx3StM-0Q7ILX0Xr6TF
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=6892a7ad cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=7E_JW1vpA8CAaGgluKAA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAwNCBTYWx0ZWRfXyowE2amU49B5
 admQ/vvin1fC7NZJ4tSOuodWyl9Ti/3qlOyM9z/8XmNh7WHxSDkfLj/170YxKq3LvHC6/x3E+v6
 0Xu2163UKESEIvut7ZXkXqRPahOi1iqEUUdNUG2GvWgDhyaOcA0RzAxeFqJ8/PNRp/FWE1TVdmM
 svz9k9bIwclg9/PQluV9t9a1lHaKA6r9mVpPyaQRtRWmnWRKuS6SSxp5FthReGOLW1ZjsWtiY2n
 G+/yE8sc81t1bGaPZzkSAwO87Rr/JZbZvvUHIXoBHHFLu/iTDiVhla5UjBGLN+CCPkNXXGerEg9
 +De8CBpOHqJdzBsIVmpaWZGJvRlTlLwbf73Cx65mZkttb0Aq/S2/GpTY8hdC4cDDfC77jED8J68
 KiVu7HcwV/xoM8FhHruNuI8QPUAov73qnFQTMc9PpZorpkZ2Wu7CncUCVF4UmGVszlJHkeGy
X-Rspam-User: 
X-Rspamd-Queue-Id: 003E140011
X-Rspamd-Server: rspam06
X-Stat-Signature: bzhj661bqcxjf1rbdsgeyxc63xa57pps
X-HE-Tag: 1754441653-816062
X-HE-Meta: U2FsdGVkX18CgLRaRQeqs9rLWN6W+yYMqaJnZcXHGNn6jjL9m0wQGnvOi3ZeVnZ8/bApucgkdwPOHsCgAMsIXe1vJhy0Sv8VnkW3i2HIYI5MV54o+Jhjs3XqBQFy34qKCzXaT5RiQtMYRCUW0KhXEadSXnndqLKvLXGu5Q+qYqdlge6IazPWtoQMJcgahQefmX2saGYLqDmN0yplTCDYMgra7hkO64TG2uDSVqJ1WKesiPlPjH6B3x9lAGrj/OdF63+n+U+1IBC6mXrH8C4VuSAKGM4pEjrWsvGosxwkHrukFptM/7BQ1Y22oZQuTBZJJjfftzvSKuUHzO5pqg1fAU8i6xi/dIkVgYzqIMulWDSWpUw5NN4XevMhGaHGouJafc6AsezENgIpKhx89vXvtU0ZeKty6qJH/LmO9xrj7LeOViiI71cJFDsjVFsWxUt6DI8vDfy6GdVuQtStmZwSIC7OcGrYvBMnH3QVG1EkDWELOqRYK7eJ9fJUJK+hgLKA62ePHAm0pECB1o9Sa8ycK97NiEfeK7a0kiO4WoB82gaNcQwAa/3WZ/DoMO2qjBqaB4MAKF6KzV9XeQePLuGFmVRuHs7vYfiznT0qD9L+vOf2F7d4IaqLFm7h72jKKE6dBIdH80nXkqxvbAOipda5DO/HYM58krUGFBt8xxSR9BgxHZnjvKafiLGOsb/zgDzLZmMY7JSH5+MSrrCeMOTDLeVjuq5d5eAvVpcxQZMEtNHzL3UdVrRlIdwga1+KKK7N8roO+J4UQ6U/1z3v5dK8aoNlxMSOc2rl8gSYmMw/F7yeygEiX04skc0Ir+ozCMrttpnXiW5tU0KsujRNk0DNA6sCx5t6KSPq7jn1pOp8EuakpVItGGQEJmOvkJLWlINT0XlKPHq06NzQYixgSzbcMGwB0ENRU+bw2SzF4N8LRCFQ+QNP4f770AweD+kLfVOlSgZIQHlfLfRVAbN+dcY
 pfs+q3K3
 L4DKm02nByUpexVuAsTQYVE/2ruFT6dkmtBchoU2ReNtZSAwDP2JtT8cgl/ynzPcEBp7o+i+uxst3W3bKlkxv01wMmQLuBi7RrqP8evbXgR8jlEh0Vo+DAIqqXVNMu4hPRFo2tjgZByd23gT1/D+tgMAJqy32ZCDQx4EEqlnViKpwQh/23TaxPBgFZAVgJH8wya4RMlGD2ZCVdvw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/4/2025 1:36 PM, Vishal Moola (Oracle) wrote:
> On Sat, Aug 02, 2025 at 03:31:02PM +0800, Kefeng Wang wrote:
>> In order to avoid the wrong nid passed into the account, it's better
>> to move folio_nid() into prep_account_new_hugetlb_folio().
> 
> I like the patch, but I think we can rename prep_account_new_huge_page()
> something better. I don't think we need the "prep" part anymore, could
> we go with something like account_new_hugetlb_folio()?
> 

or, hugetlb_account_new_folio() ?

Unfortunately, the names of the hugetlb helpers are all over the place. 
Would it be nice to name most of them with the prefix "hugetlb_", 
followed by whatever they do briefly?  For example,
   hugetlb_init_new_folio (replacing init_new_hugetlb_folio)
   hugetlb_prep_new_folio (replacing prep_new_hugetlb_folio)
   hugetlb_alloc_fresh_folio_pre (replacing only_alloc_fresh_hugetlb_folio)
   hugetlb_alloc_fresh_folio (replacing alloc_fresh_hugetlb_folio)
etc.


thanks,
-jane


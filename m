Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AFFCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 06:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C29A6B0088; Thu, 14 May 2026 02:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273916B008A; Thu, 14 May 2026 02:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114346B008C; Thu, 14 May 2026 02:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F28C36B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:07:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D3628D94E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:07:16 +0000 (UTC)
X-FDA: 84764992872.19.0D13D47
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9FD64180008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:07:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PiPgS0qy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TDjP0CN9;
	spf=pass (imf06.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778738832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEDOlYkf5pG/tWnjic2Oqan5UTdvBg9ljhm0eipD1fw=;
	b=f/TsoY5J1thvEkEonCacNBGWTIDHNyeww7obtSu6qPpFfPjkQVRdjgzM6Ny9eRrtw5l1w5
	RMjM5V1XDFe9o1us54kHTwPVrwscQAt3qCRS43c+qEzq3cPFDIarhVJ9CDIx+xyK/aYTyP
	mwHF3igo2WQJPMZDKl5HLkBafj7N2ic=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778738832; a=rsa-sha256;
	cv=pass;
	b=tt7iC5xQu41PGv3zkJhHju/mN4oM9iGT8uqIVKa7RAbD+zW1kP83PfDYZh5SBTzbkrq2B2
	EMGUa47WON9nCLN6Rwda6Unuh9HMpPZ5JoWI8vLQWKQ+80yRGlx2op1Si6zeD12hkqolx7
	5qCCNaNssmaVgHHMFqfqLH0kYXqUQCU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PiPgS0qy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TDjP0CN9;
	spf=pass (imf06.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DKuOHE2899521;
	Thu, 14 May 2026 06:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wEDOlYkf5pG/tWnjic2Oqan5UTdvBg9ljhm0eipD1fw=; b=
	PiPgS0qyX2EP0kdvjV1m3ba2tOfbDmpYIIiag5MvEyemfLtssS9ChgeySnZBtvMb
	DXUDUGHdTdINUsmecSHWGzsqxx9XvRKbbE7huWX0qilWjU6rlRlbdea2R3qOxorx
	NEG524HGMWnmjbQJ9/96UKex1t2pj3N4+iAFHOxF8jgwY1AUJPJcdiDU47QHjXv0
	ZTWdFNym6gRHSdUAgZSFteIB3bMb74oyRO2LXF5kvGwoLZ6scYD/dskxj42VTXyp
	A7EX9xasQmQBjGcyPX0uG6NdusL5C/MovlC+45/eCrMvgMJrBZnvFvipUngjWTh1
	clNlyPOzdoteYaCe2Y9WNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c96tjkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 May 2026 06:06:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64E651Qs007599;
	Thu, 14 May 2026 06:06:50 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e3necp88c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 May 2026 06:06:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XIXO+01G9/uZoeljtMMwCDuC8xfUKxQvvPNgehfZ/LNnFRYiY7uh4eKFaU4rNvAXBvb1Am0y7xd8sO+UAZgC4q/NtxEIQM/frkhadDEWeX9wv1NGLb2iG8pDkqigDuDpN+KjaVwc1O70YwVwK5azYbqf/s/chH9SNAx6GvO9zbK3wxwh0gVlIAEj96YU5QmksbEgswlWryFG7t86GSLoOBFTBt9eKR/OQctBBoddYjjERe/3raNAluAGgDxF9ZP4FR2Zy0VvpPf/zbLjZzUX3+Si07I+Kh7/BtiSHrRmOMUIedyMl/z+dOdwxW9JMAbfNHOZaCE7HamQsaCxJjKn9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEDOlYkf5pG/tWnjic2Oqan5UTdvBg9ljhm0eipD1fw=;
 b=Xcao04m0A0KexkO4G3z7jQuUISlpPwrQMbrmISoLM22H1YIQ+8uJctYeEQFXcl1bEf+H/IQI8Jm2USYQ7rwdK61iA1aC+vn+sxfDqH+2Ghh2WS2NKJvPXiILCoj8lMmYzi4c7CzNBYoXnFfTccoVe4PNrmp4w/N46ZfMZSs4vDsg1NNJhA+5VITxI4WoPCWzN4wdWlZ0NM70q1dl7UgITDqQBY/RX3f6GwLmtldTnhBLadcNTYjbN8GsCywCRXV+sui13Bi/UhERLXDmVKWjO7Jy73iBUYE2IifsE8IRzqMgaI6f8KdePPcILhdfouS/rqqVeKH2dh8ijiG015j6QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEDOlYkf5pG/tWnjic2Oqan5UTdvBg9ljhm0eipD1fw=;
 b=TDjP0CN9ok+a0isabpSi7dkoS7FJaMBZjUEgKIS0bt5Ggt5N9egBpsMsER2jq2euRaKao6ms8Gl7Kvu/im71HE39OiA12O7w0IkOce7X88iZZs+Ogj3w+RxaWdUD2dFnNtM+oLwmxSViSqJWd0F5Ypo/E2pcgmJcnaSqySZhHdw=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA4PR10MB8586.namprd10.prod.outlook.com (2603:10b6:208:565::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.22; Thu, 14 May 2026 06:06:45 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9913.012; Thu, 14 May 2026
 06:06:45 +0000
Message-ID: <27931068-2e1d-4837-9a70-3b6885368c16@oracle.com>
Date: Wed, 13 May 2026 23:06:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix deadlock in __hugetlb_zap_begin() by
 using trylock
To: Kartik Nair <contact.kartikn@gmail.com>, muchun.song@linux.dev,
        osalvador@suse.de
Cc: david@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
        liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        syzbot+bd6aaf99e8443d8a9034@syzkaller.appspotmail.com
References: <20260513211927.4206-1-contact.kartikn@gmail.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260513211927.4206-1-contact.kartikn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR17CA0045.namprd17.prod.outlook.com
 (2603:10b6:510:323::10) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA4PR10MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: c9b4dca0-1539-4439-f8a8-08deb17efa0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wZwx1KRhZdMjG3IYt7IaTDdDh5z+h+MxOQ2dEtWzC/NHaGe2xNTzdmtmiLBclhKat/iGF2gRYNrJhpHfX+u8PpwgpmeW1AtB3olDrspgLLxkVOo3pqzzRyDANo4R7M6re7aYSCe6sayhY6UUfLVQpCqCXZd4WOPEVM9bJqJAo0e8KQqgSMt+GHGlB4SwIfQaD9zqADKfJzWGQKepZm3oqoAVYoUmkwq/DPneOw059Jxve90yIYjJSrZnqAnlZv52CfcIqaO5T1ZjINNU3hzRAvtzD3eqegRv8dwZxJhuYGZRIkg9b7e0OKO6NZtlxNoUbjgb22vY2dIQiIyAO6xwd1O0YLTww81p8FCoSw7j/3un3W38NjGIfM/aWfoJeA9Kv82EcV1RCEMjUgmn7SSmPYJz99OaWI0Qto0wgbja31ccp79BqXYB6qWWhuXWa775ITyFHG1iD7jDEUKnLkW/yxfdKJ8hYMbFBagu3zL8iGyh7jvkm3z7RLdhXyqKw4synZXZqhNnFLxgdX8uP9ud+IwAb6rhWg0KZbx8C2FEThSK6yNBdKOpSUl7m9ctcBlJsOltOrsPQPOA1bswRFjVkL4a4ytSLNrT3wKEO54F7BCN7PEDvP33YKbvRf3CoXr7fp9Xo8K429ywGFaeOFGLqA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDV5YU11djd1VUpHbnF1cW5tZ2dHazJaYzUrNkd4QWowTTZyWmRud212RVRU?=
 =?utf-8?B?bkxHbFcyWS9NK0RUTzBwa0NmZUpjakVJVXZIREYyRWFoQysyU1MzazRPbE5V?=
 =?utf-8?B?YU92MDRkcnJVb3BERWR3empYYzhDek1Md2NNUXBQOUpqaGZZSjV1cVgvb3Zu?=
 =?utf-8?B?NjBBY2hsRkVjb2tjOGlQWWF0VXlZR2o2UUpzR2VDL2ZOOXZGaWFrVmdNL3Rz?=
 =?utf-8?B?eGxzUHdSZDVKd1FEVm4zV3NRNVdaNXVZV1ZQSXpVbC82MHVLby9MenE1ZFZC?=
 =?utf-8?B?UXNWdE13KzdLR3NBaU1lQk9peVh3ZVhmOGdhQjRBSFJYVktuY0Y1d3pUeXpu?=
 =?utf-8?B?SFFNa3FSNUtlaWU4a0x3VFNZUk1ndVNVMGEzSCtvamZEdk5CZnpTQWRQck9P?=
 =?utf-8?B?TWV1Ym43eXI3VVUvSm1zc21nakx2VG9Ta2tPbU1CYmNEOXdyMzZVdzdBK05K?=
 =?utf-8?B?RlBDN3Z3THlEMnZmMGhDMEk1eU44UHh0aHNBZElKNlJyUDhiVlBDK2N2STAr?=
 =?utf-8?B?RE5wU3M3M3I0ZjZuZVQyYSt4SUNWY20wZUZsS1pPby9CQmdsaXo1Y1R5a3Na?=
 =?utf-8?B?bkY1Y0ZpK0FWU1NQT2VyZExDR3gvS0hZQ1JYTldrc25JamNWYVE2ejR2N1JX?=
 =?utf-8?B?UnNuVm5qSXAzOVM3RHlsUVFsdDQ5Y3U0bFJzdkNjUlJGK0RTUjByelYzeE8v?=
 =?utf-8?B?OXV3dkY3ekJsc1htd2tocXVpYXQwUGdzSi9PRTcydWsrL0FiV0hCcWd5Qm5B?=
 =?utf-8?B?YTBSakhPQkwwSGlaczlvcEttM1BwQmZDY1Y0OTJPdXF6NTUxQUF2Ynk0aTNG?=
 =?utf-8?B?SXNVQnpkUXg5M1VRVjVPb1ZLOE02cUlsMmI2cnZsOGExRWVmeXVNMnZUc2tX?=
 =?utf-8?B?eGZBaUNLSlJDQkpFWExPWDZ6UUlkdGtYTUQrTG04bWVDSlUvVitPRnhyclVK?=
 =?utf-8?B?c3Fpb01PbDRMaTJkWjBQZlRUQk5yZ0x3NGRhQXliNGN1SFVQTEo0ZkdNdERn?=
 =?utf-8?B?TnZyOE5hY1dZd1JnV2cxaWdzRTFXdkh2b0t3QjYxQlVrTjNrZm9tSkQ5WHRv?=
 =?utf-8?B?R0t4MjBDbGM0d2V5WEo3TTQ5S01ydFBmdjRQQVNwVEVsZGZnckkwVGZuNUpX?=
 =?utf-8?B?RXd1a0kxWm5Rc3RiQ2RWVFRZeXZMVE1jb29WYzJqSElhdmYxZGZrc25FeVh0?=
 =?utf-8?B?T0dQdU1ualU3YWhVakhnVm05eTFsdnp3eUZ0TTZWcE1zZXY3aFd5S1UwNm15?=
 =?utf-8?B?SDVZYzdhVzBmWlN0RUl4N0trblRHcHlvcTNuYlA0bTRUS2tPTjFjMFBGTDl2?=
 =?utf-8?B?U01yeUJIaFozUEQzMU5vQkl3Qk5YazhRLzk4czNRb3pwRDZMY1BpVWQxYTYv?=
 =?utf-8?B?N256VURxMngyTTE1WHNyVi9tWnMvV1hhaGQ5Sys1SDNXVXdHMk13aGZKOWxY?=
 =?utf-8?B?bWs2NzFFZXN1SGhFQk5kZnNMdllOb05rK3ljRUpneUY0VDQ3bTBidHlIVVBl?=
 =?utf-8?B?M1VOQ0p3VjE3TERLdmlIWUIwSTNncTJobjdPZTlsa2h4VW8zem1NT0JzOXht?=
 =?utf-8?B?U1V2OCtxRFRBWWVhVG5ZNnB3eFlzNUFLSFFlWFB0VkZHSEwrQ0FqQVMxTThq?=
 =?utf-8?B?T0hWa2tKWGhSa1NqU3ZyOUxQOVgxU1Axd2Jld2pWeGtjVEVEejNWNUJzZGNF?=
 =?utf-8?B?SDdSNzR4cnZ0LzF5eEtYckx0emJlUjVoaFllVHVnNVEvcUpBNzdZWUwzTjh3?=
 =?utf-8?B?YkFrbXorbFV1Skh4OUNFRWY1RldNWFdseitScHNtYW5LSWsraU56MFhkamhT?=
 =?utf-8?B?NXhySnBhMDg3RXdlUmNDcFVNbFFURExwMlUrNjRtS2c0WGJPbjRMLy9Dam8y?=
 =?utf-8?B?VWNERXU3MkZRa3JTd3gxeEczT3cvOWRCdjF0MGtENEZJVDRZODNZZEF6Z2xN?=
 =?utf-8?B?UlhLSHVSZ1hWY2hnVXRvcTBtVWVSZlpGMkxaUE90VFJKQ1FZQmhNUkpyS0g2?=
 =?utf-8?B?STE4dlcrMjNYdEhXc2I1cVNHdlZXbkNsM1lVZERtR3llWGNiVFQ2ejZKa3dm?=
 =?utf-8?B?ZTl0TmJadC9SRHlhWXpHNHMzL1ZWNnJiMFRtZld0UFUwa253T0o0T2pobzVK?=
 =?utf-8?B?b1BRZnUyaUtFY3IydUl0SDZXMHgwMHlvTDF6ejJmcW45Y2sybG16QjBwK216?=
 =?utf-8?B?MnZyY1p6ZE14eEkyTXVFTFc2N25yTFpZYm0raEY1VUJLMStKclRjSndzNkJu?=
 =?utf-8?B?OWFmRE9aRC9keFBucE5tSFpzZTZMQmRTQ2RxVkpXQ0ZyNlNMbkNFYTVVOXk4?=
 =?utf-8?B?Q21LY1JiZmFNb1lJZDVPMDFmejEreW9nZ1JUQk5vWFBkbStQZmVQdz09?=
X-Exchange-RoutingPolicyChecked:
	pFiRX2flMujzYp/JFgsw3QpqBkTRFn7GjnbAxuy6PaB27sH6iU69HUExKiDJWQkfksVPAWJj+supGakFepKwUxE5+JkHg2K5WQ8F8n8rqgQiInxhVkOoaqsrWTClu+wcKeREs+6tXXCwHSfcn4mspAU0hU4ooOGVfB4vFDqxWPAozt8ojCMPUMK+mTPllyvAcJtGsjafcH2qTfc7cfc0txhMQrfXp4eqKs0gJXrUOot2yP+QC/71B5tvE15qtHCSo2Jr/J3kJodMuOc7oqs+QEJXziwwhk5jJZf2EPjjBdmfgBCky3PadW4B4LrT4V7F7Qn9Do3hftGYdLDWDTodgg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b0bEJOOGgBrUHHc4JxI0b4muv/kzp8xs0m+fhBPBjmuxqnxU3Bqofh5TVb8fNs8bppnUdqVtKfN0gx8xxKNCkHC6WNEiDS1XfuJfNXcsXnhRz1hXgSEatoahEkB+AZ43zhjMAul4/JfZgC7xlks7AA26fZTu3qe3D9lfYabfu44M2vqWD1iqG9s4CHUtGiMwRG1glkkGqVohumZ01LJYvsqR7ippmXVUcfhoGStHPnVVaC3CxeOY5ZVAH97tY+8018WYXAKMBptHbXQdbuhbpfTYjcoGSMl7u54BNyKxXan6UiUk+E6MZPvRd0GSfxBpMKkONSutH/DlcjrbdhrwYrGax4uo9NbPk3y/ae0DB+LCLwyBuPxmM4vDgm6w1zSXhhMQ4YLYy0LnVF5WqlZibKcUCsYfasW+BQTnRw6l/KltKGPTTQlR+LA1Lvu/93weJjo6p4r2HyW2lPAegzntV0hgp+NcUbvuFW1n/yAUHFAy5bVmxSmI8CATh2v8TD2ZqwNnieqlKTvUO7oe52EdZtDh6ZiVcF+e3TZjIT7NZDWV6feGsP+2AH3K2rje96bnEu3yctnaXIibIGH8FGC7ooVBvZ+8H723DQ0J0QH/DVc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b4dca0-1539-4439-f8a8-08deb17efa0a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 06:06:45.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSho5CPEvTdj/SGCvROqa4Gaf7KKxMAjK5y9l07hRbTKMUM4bAEU4NzpX4O0Om1rRl+SnuBzKvxEJF2uwzqgpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=951
 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605050000 definitions=main-2605140058
X-Authority-Analysis: v=2.4 cv=bbRbluPB c=1 sm=1 tr=0 ts=6a05667b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=edf1wS77AAAA:8
 a=hSkVLCK3AAAA:8 a=pGLkceISAAAA:8 a=Gnbi9GJZe8mThbsoGX4A:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: UBsfxOab4N3V35v2J5iqx-ajUDRJP11K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDA1OCBTYWx0ZWRfX6fdgIxBs0Ql6
 srGXEfPxg61JRoUSipeda6osRD+YVxBB9WUKhGbzePBJb2XmIYiMFjPOp7/fOEUwVHhzAA6PVvj
 UjecekKmZZBlL2J+C49slZXn+AuxlOQdbzHyxzaNJcE7O5yb44K7aePNd36ZrZrNmEIn4pnvCTi
 HHyqHF5/r1VTjsBFjPQ9s7y2aJa8J4VATIi7claHZkeUuKZQ4YxfxLxwVNpT97b4l13jKtx8Iuu
 4SROJzltyYJuSlhlkgcVwKrvMQmbWpTM/SD4us+5/gapWFprwVATQSDkWIKCcNVyKKUyX8VQUyM
 L414H/cnqUM8/oZ318ikyBb+cNbD93UEfH2gkFhm+tE3tfG1GEpcdmCP4cjekJ0ufRmyjH3RKV4
 qhaODkIKBdQNfHu6ZjKtGX2fJc5oqteahsKww1Z7sPir11JckvSdUoVcuFrclp0efRNL44dWaj8
 kA0/nFYExrrKDATB/9Q==
X-Proofpoint-ORIG-GUID: UBsfxOab4N3V35v2J5iqx-ajUDRJP11K
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FD64180008
X-Rspam-User: 
X-Stat-Signature: wir9e9ywp5xrfbc7a1reuu9zdgsz1nn3
X-HE-Tag: 1778738832-151577
X-HE-Meta: U2FsdGVkX18tZ1d+en/3R/zmCZwZPMhamG0TaOGjZfYC4JX0ncwI8CXQNGCRNBhfXdfSSMK/wkCTRUBJKQlgBZYZMOWHC6LEd4P9ArAvH8uoHH4QdrRs10id7VKZ8HpeLh8tR1jaDlRM1jGha7yb8Kcs/6l+w4eX0xPkCX4W0S4/TGW+4k/YYDRIf+m1SljWb/QFDNmeRXHQTWaLDduUpoMJeJ8jqtMrjCMbpboAgVOVmsqCBJciPcP0rb9nUN08yw1mRgQcWBmOlIlkpjbFeKZqnmpteh38aoLzpjriOk7P7OT41yxL5StxVlqV/lUz6p3lDgv4AZuinUQ6uTOlO0PsO/NEhBg2dbS+pm9Hek/cp5DrqSjR3SDp9ZJ+ckd9TC/UJroVZ6/pDMONx6SELcOdY/0zCr4sxm7Ip/+toY1X3dASykz5iDgpO94DkzPnVYaW3/y9Fqqb3M7A2WHt0kSmhu5j90IcScp7rteVNbLLnTudflY4mLrze6GLX5Vbg5n3jJ/xKpF661TxOzcuTal3nnuUrMrFxowwBrccqPz2NWsgfCi4penSCTIv/t4Jv2d/UA0m+OXdW9IpPH0xEB4iP8QQ5SORTKqQgNuGdEjhPBL440Ikajh+u5QrRY8aD240gqS+csRrq8GzX59gK7TzZZODFLyFbyEQ1fmpdeBbSgiL4OOpMwn55DczcsOse2voPuC1Rpm1N+ZzCbiNs8yxjI6nvTKMoOvah1Kc2wsgvM1Bj8lF9e9xexys2gIJb7NqZNEmkaCL2ejIE+A5wsCMjxKGCE0cR9hbxi6s5sbaFLtcF9CcpqY+qptqyan6SSl6OfXTJjQIjLH9pnuLvtiNgX3rAZRWXWY/0BBskbWnJ6IN+TpMRRM0hbUnpYWfB7iYoju+Bga9jBWAyA8O0VpaaqXvbqbOmECFvEnjY8LDpbgFb3IJN+O2YfbwAGiz2iRN8qea7Eo7BBl4pL8
 VvEadfqu
 8knnS6UeKcCb5MX+I19cXZwnYQVr0O3GmNaa4Ja+F5dUqjegdt+UInO8O9z+v3IjKIrZB75JuOoGi7TZdOoqQGKm4ED+4U9HzDE+0nC28xRZtExnTdgfUjpb8iMExPMQlSndXdnXjj3pcD58p7tYg+Phep6zEwPQKgdsKBE/E+CCebSzbqc6JkgfKDsHhcqO/CDw7vIbSDHBCNuiwU+FnQaPdTpQk4wMFv0kl9pjEYVCbw43heD624YloCXu6cJqRt9anQFafbQmRV4AW9xT/7O7GuBqNozoYwRL+k1zGJ9SwiZ4AbgflqGFWmUcRQYVBAi6sDadiXw8xe4yi2tVeSXDj2lbAEb9+XQ8lGsgHOdipv3FyAX9BSuwJfCSlDgf6Qpz/gruf/rRNShXo8bBZLlXD/fOzicoGosIsGFyJc5be4QHWBvkUiIQr7c53V5Wl6S8XU8lYkxfoHaEfYFuXe11ohKOc/Z9NdnM0T8rFoXU6eD7bS/k3g5iEiao5BZ2mrAgjEREIn+q0WhGdDf/j2KFiG+/nriQ49xeON6jiApiHV59ia6ryTth44Yk0wyZZeCRGdhY9TjFWK5qd7pAUdEyR2tvpR/fC7C4RnzMTcvbJDcB59TAqZg7YcUN+SSAKL5GGOgjz9NzyFALjn/7YAfYEEBdvow8EVJ6UZAJJdcH4eZ0qQsWQJxAkI6uE9SlAdtiwP5JaEDLZ3BeCstBMKD0pj/N3faMHmkwGUyhqk9aOdWhopmmEdEGhxPkuBGIXD4PYoZDcop7dwOQUA1Wv1zM5YE8eGIk02ZmOOT46E6PYZO6r/n1jmc4y6xnBQPiS9nr4Rq/8ScvFsXPK4UvyEwsCh7z15ON7Eb/xG7NW0beR+7WCTgG2szkYYMMfyvrIvqTcygC5TirjxX6PGPluIRyNiMwAOiNwaxG6a5WeDIE49E65Vui7mxmsv+zN5M3cPQPyQV8bfvKZ+LCnf/nk3J4RPJiB
 rHj5Z1w1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/13/2026 2:19 PM, Kartik Nair wrote:
> syzbot reported a circular locking dependency involving
> resv_map->rw_sema and mmap_lock:
> 
>    CPU0                          CPU1
>    lock(&mm->mmap_lock)
>                                  lock(sk_lock-AF_INET6)
>                                  lock(&mm->mmap_lock)
>    lock(&resv_map->rw_sema)
> 
> __hugetlb_zap_begin() calls hugetlb_vma_lock_write() which does a
> blocking down_write() on either vma_lock->rw_sema or
> resv_map->rw_sema while mmap_lock is already held for write by the
> caller chain (vm_mmap_pgoff -> mmap_region -> __mmap_region ->
> unmap_region -> unmap_vmas -> hugetlb_zap_begin).
> 
> Fix this by converting __hugetlb_zap_begin() to use
> hugetlb_vma_trylock_write() instead of hugetlb_vma_lock_write().
> If the trylock fails, return false to the callers so they can skip
> the zap operation safely. Update hugetlb_zap_begin() and its callers
> in unmap_vmas() and zap_vma_range_batched() accordingly.

But where exactly is the Chain
   &resv_map->rw_sema --> sk_lock-AF_INET6 --> &mm->mmap_lock
in the calling stack on CPU1 ?

thanks,
-jane


> 
> Reported-by: syzbot+bd6aaf99e8443d8a9034@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bd6aaf99e8443d8a9034
> Signed-off-by: Kartik Nair <contact.kartikn@gmail.com>
> ---
>   include/linux/hugetlb.h | 10 ++++++----
>   mm/hugetlb.c            |  8 +++++---
>   mm/memory.c             | 10 ++++++----
>   3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 93418625d3c5..1972464bd92f 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -244,16 +244,17 @@ void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma);
>   void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
>   				unsigned long *start, unsigned long *end);
>   
> -extern void __hugetlb_zap_begin(struct vm_area_struct *vma,
> +extern bool __hugetlb_zap_begin(struct vm_area_struct *vma,
>   				unsigned long *begin, unsigned long *end);
>   extern void __hugetlb_zap_end(struct vm_area_struct *vma,
>   			      struct zap_details *details);
>   
> -static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
> +static inline bool hugetlb_zap_begin(struct vm_area_struct *vma,
>   				     unsigned long *start, unsigned long *end)
>   {
>   	if (is_vm_hugetlb_page(vma))
> -		__hugetlb_zap_begin(vma, start, end);
> +		return __hugetlb_zap_begin(vma, start, end);
> +	return true;
>   }
>   
>   static inline void hugetlb_zap_end(struct vm_area_struct *vma,
> @@ -318,10 +319,11 @@ static inline void adjust_range_if_pmd_sharing_possible(
>   {
>   }
>   
> -static inline void hugetlb_zap_begin(
> +static inline bool hugetlb_zap_begin(
>   				struct vm_area_struct *vma,
>   				unsigned long *start, unsigned long *end)
>   {
> +	return true;
>   }
>   
>   static inline void hugetlb_zap_end(
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047..dd55ec2ef007 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5309,16 +5309,18 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   	huge_pmd_unshare_flush(tlb, vma);
>   }
>   
> -void __hugetlb_zap_begin(struct vm_area_struct *vma,
> +bool __hugetlb_zap_begin(struct vm_area_struct *vma,
>   			 unsigned long *start, unsigned long *end)
>   {
>   	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
> -		return;
> +		return false;
>   
>   	adjust_range_if_pmd_sharing_possible(vma, start, end);
> -	hugetlb_vma_lock_write(vma);
> +	if (!hugetlb_vma_trylock_write(vma))
> +		return false;
>   	if (vma->vm_file)
>   		i_mmap_lock_write(vma->vm_file->f_mapping);
> +	return true;
>   }
>   
>   void __hugetlb_zap_end(struct vm_area_struct *vma,
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..c1451e5b6ee7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2158,9 +2158,10 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>   		unsigned long start = max(vma->vm_start, unmap->vma_start);
>   		unsigned long end = min(vma->vm_end, unmap->vma_end);
>   
> -		hugetlb_zap_begin(vma, &start, &end);
> -		__zap_vma_range(tlb, vma, start, end, &details);
> -		hugetlb_zap_end(vma, &details);
> +		if (hugetlb_zap_begin(vma, &start, &end)) {
> +			__zap_vma_range(tlb, vma, start, end, &details);
> +			hugetlb_zap_end(vma, &details);
> +		}
>   		vma = mas_find(unmap->mas, unmap->tree_end - 1);
>   	} while (vma);
>   	mmu_notifier_invalidate_range_end(&range);
> @@ -2194,7 +2195,8 @@ void zap_vma_range_batched(struct mmu_gather *tlb,
>   
>   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>   				address, end);
> -	hugetlb_zap_begin(vma, &range.start, &range.end);
> +	if (!hugetlb_zap_begin(vma, &range.start, &range.end))
> +		return;
>   	update_hiwater_rss(vma->vm_mm);
>   	mmu_notifier_invalidate_range_start(&range);
>   	/*



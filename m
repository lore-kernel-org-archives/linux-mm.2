Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52027CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B448E0017; Mon, 13 Oct 2025 11:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911FE8E0006; Mon, 13 Oct 2025 11:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9C48E0017; Mon, 13 Oct 2025 11:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 652898E0006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:12:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E93CCB9D76
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:12:25 +0000 (UTC)
X-FDA: 83993432250.03.A4584F2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 81D191C000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:12:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qrCF43G2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xGo5xWmg;
	spf=pass (imf21.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760368342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyMrzjWmiwERpBDaIikWF1JSJU6LiiYqti9SYkd7anE=;
	b=jPerYTkz7iQx5zluVtGxIRpG+lTQbViF7ODa2JQfTQQ5jOXZEqjy1QuSFObfJGvb64D6qD
	o3qPF3ssrZTG6LLpMm46emcHRvW91Y0FDzKuJ3iN1k9R5pW7VTLfJOY47gWIz08LelOwXe
	gyzKaZWnWYyGHMfk0kNP6Hsb3pKlzOc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qrCF43G2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xGo5xWmg;
	spf=pass (imf21.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760368342; a=rsa-sha256;
	cv=pass;
	b=Td1eTEqEWL8z9GoH/yU4DnDy4cgEIz8W9PDGLvnRE93O/G4HnYv9/dhLOI2JXT0nrFTEGH
	hS7v/VBhdkhrjTqoSNahoa51ICZ/jZo6RP4p7IYn1KyMG8E4gH2cvQxRcm/QYSA9DjhGcJ
	x8nv6O6pLJFBZz3qPQmH0bw0REMALt0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DEkuAf022999;
	Mon, 13 Oct 2025 15:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UyMrzjWmiwERpBDaIikWF1JSJU6LiiYqti9SYkd7anE=; b=
	qrCF43G2uuq8C3+ry5DhmKTZGVLOJFJDiQRjtteubBCM51UHXJKcy6cg0+Ar5LeT
	vFiugoy1PMQcGJtZ+WIYTSMMZChOEJukSTmccjpGVrWKdn1Hd+81/wZp44aR6Hg5
	kF7+hlhr3Wb+tZg1EkOxZ8mhigMC3at26H1IQdPVl1D9xW11Rujo/LZpT4gy8Q77
	JiYx8hGrYqgcxDrLCIOhll/01JzJV23LpBhdf0GTTqxaovPwa4fI4zsVK43n3BGj
	gWCoqJPAAKf4KowCzJLPdNmb7O3Km4CGsJ1w6bmNbtBtUjvcl8T94bFoSXxva7RA
	bbG7jHfv8NRnzTm6YGlcyw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1q9jr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 15:12:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59DDfSCv017436;
	Mon, 13 Oct 2025 15:12:07 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp7erby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 15:12:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4YqJpqOJHfwsv+41cm8LJVSMs3WZs6uhiB6CI/Dlm7hBDegaAyOBFxYqhsnk+yjjgIHVscpf4ItXu0I4RNiHhoCDh8ufOqUBxiB556VODXthzeC0V+mB0TwTolLFiejXR0NPNQmgjemJPZNe+hdQ/huxHxHsMPjE1qxANpRKwxMr3aIBxIoX3Fpf2pWmmkd07iAMvQGa3K3oCkEUJxU94jKmiSf1JrFoFIa2tWOSrGnlTDGbFPtEfK6BqpBE/3VsO1SSq1X1hASwgoTAEiDojf17izzMP5dZzBosMG0N/fP6i5xl0+MF1S9VJUJqojsxyEte7SN1HqqhEziex6SXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyMrzjWmiwERpBDaIikWF1JSJU6LiiYqti9SYkd7anE=;
 b=NSZXKVfLn0wbcXIBB6jDTEf0aVWMxmSX7/vSsThDcDtCB1ylL5+mWa9g/ZQjXV7NDYgMwUOz4L1Xs6JtbeUOiExGxHbH+0GlSZV+W3Jml1ooMu4ukl9nbtkLsRflgZXSb9n3cCTf/8AzMQyS72qXX133hueIyiahKh6eY0F8dyLBorCmT4pYZ062VruTARIOAQr+bVFLc6e1dZgQbcPr/2yk+pZYnIPsW7pTMdWCgS/uGZ/fYiYwF8MF3Ie/6G7RnMi3StQl58sr2LlkwSt7k8819EgxWrABEgzESVL50ex8qRkjUxgKSIzCzWTNxfOaYa/tCk3ohs7SwZV66MtZzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyMrzjWmiwERpBDaIikWF1JSJU6LiiYqti9SYkd7anE=;
 b=xGo5xWmgbqReBqIdVDL0RF+0D/b43ITfws8F2B3EuJtH013ATTns+nBscMfhQIzkbPiA/MLwLBJTcuMGjrVYpFPIn4twnlQSWRQ+KdoE6YVCFiv1zVAW+NwGynKE/SNx7ORdx6ladcik6cnoKi9pTnsUAj0m0pDOnon7toU13zU=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 15:12:05 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 15:12:05 +0000
Message-ID: <1b596590-6562-4c8b-97ab-bb474abd527c@oracle.com>
Date: Mon, 13 Oct 2025 11:12:00 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20251013121536.2373249-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::8) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 84d04262-fcef-4534-8f9b-08de0a6ade4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFJXY0dOQWtCQUgwcjNBenhHblNWSk5qSkVkN1Y2b2pDaDljM0ZBZEJDNGJv?=
 =?utf-8?B?WGtwenJRa2toZVVSUHVFby8remFqL3BsdHBuMm9zSkVvS3I0d1NzTFdtbWRC?=
 =?utf-8?B?S3Bmcml0a0s5NGF2bkYveno0NmFiRWxMbk4zU3pUUzZBOEhIamJyNVg1TGNz?=
 =?utf-8?B?MEdtL0tDb3NUckoxaTdCNHlhODJSNDRiL2pFcDFLc0xrSzVpRXN0cUpzTGsr?=
 =?utf-8?B?bE9KbGp3UGZ4QWtEbkJrVnFsY2VkUnlqY0dZZEV5MTgvWlZhWFh1cUJRSGpw?=
 =?utf-8?B?UXI3L2wrbUZtYWRCaDI1cjFUVjJ4NDVYbGF3cDZ2SnZBM2VsYVhFN01jSEJC?=
 =?utf-8?B?SDBIem9KYk9zMHZjM3phWjFzRXNabUt6cUgvLzNCYjBwa0JNWHp1d1F5ekhK?=
 =?utf-8?B?V0I4eG9tTVdHRGRwS1FySWZrK3I3bTRvZFY5NzV4QmYrMGFCTjhOZzRaL1Ns?=
 =?utf-8?B?dGRhV3prc2w2dHIvVE1kdk5OdmVnczlRbHhTSDk4ZmU1ZUJaK0tnSUh3TGla?=
 =?utf-8?B?dWFoNnh0THAwLzNOK0RsQ2s2VnIrVWgxNlpPUjJaNlNGMkZzVnRUMFBMUXBi?=
 =?utf-8?B?b2hCTld2S3RnRTVqZndBbFhwcUR3bVBDQ2lkVVhXdVFSZ2tPSDAyQWwyUTVT?=
 =?utf-8?B?M05mekl1d29zUkxMaGZRWFNnMG82Ri9TL1R5L1RKVTFuQ2R5RVR4Tm5UQkh6?=
 =?utf-8?B?bFJ1TXZQS3k1Z2RFT2JuMytKUElmZThhYlViVFZ0NW9MN3p6TnVHT3FQVUM4?=
 =?utf-8?B?cG1tN3JISUNZbGJiVEVPZVVQd0dGSlRhVHNCa1RMTmdiVmdwaSt1VjFKMEVR?=
 =?utf-8?B?OEVoYjJCN1ltZnE3VGZhZEJzaVhmbmlzcnVDMExnZmxva0JkUndHOGZwaFNN?=
 =?utf-8?B?L2MzQXV4YWZmZ01Fekoxd1RiN3NNcWFYS2VBT2xWQjdySnhuOVVleEFOVFFq?=
 =?utf-8?B?RnZhdUx2WjdMazJtU1BYU3JDZjlEZXdxR1RKWXM5WTFxanNKYzdkdldlRVN4?=
 =?utf-8?B?SHBFS1RUaklTTWRQeng4UStjTXptRVhiT2UxUFo3clZXOXB6NjUvTUplbnNr?=
 =?utf-8?B?dmlzZ21KU3YxRk43bGx0OHhYcmJIUVREY1cxdDl5QUxiRTdBZUhnV1pQTmdS?=
 =?utf-8?B?UnhmeWdhYVpqNW5NMC9NMVNpK1BwRkpacWw2UU9xTGUwbGtMRm1mdU13R3dn?=
 =?utf-8?B?OGtHdlZ3MVc0S2gyM3dwaElKVTR3cHFiS2FuOHRHRlZqajRoQlYreWRxVEYr?=
 =?utf-8?B?NE5JK2o5dkppOGxWQnVSdUJtMGw2c3lzL1hna2pzZEVUOGZKOW9FY2xoSXgy?=
 =?utf-8?B?NmJiTzNOL3IvZ1cxVFhjTHVEZEsvWFFtRmIxOVJZRUd0TnR6SFh5WW1yZWFQ?=
 =?utf-8?B?VHZEYUlCNURJK0oxK1gyQlMvSWJwaWtnRmtUa2pQUE9jekdpbFNmVExJcFpR?=
 =?utf-8?B?S3RtUGVRcHE4ck5PWUxtVVVBcmRyWFhpQ2Vrb1ZSOVVBclVBbHJVL29MMkJx?=
 =?utf-8?B?a0dMalBtc0M0T3JUVTF3VXVFWGZJMEdjVm5TeDVwQVRmakVxVEJrcG11QW1w?=
 =?utf-8?B?c1g3VDg1dFRFMFoxRmt4YkJZbUxDMVlGY2NtQUxhYUw1Ni9aOTI1aUlIVUZS?=
 =?utf-8?B?cmRpdyt3ZEY5SGtJRnljYnNKMG92dmEySXFSZ3FFRlNqRlRHeGY2SjhGL0lh?=
 =?utf-8?B?K29qWmNjaEczRmZwNkpFZDVnM1Fpc2w4amNFaDlNbndmbVhqcmVWV2hNZDgr?=
 =?utf-8?B?emNpbFMwd2VycTFHMWdMNTNONVRGeVBwTFdRRHdqaGFDazE3NVhqTlNwdWNq?=
 =?utf-8?B?TG1RMTFIRHlYcXhWZTRyS0NsdDJtUUNLWVZDSmZ1ckNXZG1Wbm5yMHVESjhR?=
 =?utf-8?B?SGhRZysyWW1SM1BOcXpPVlByWWZNaDdkeWF3Y2doT0s5cVlWVDB0ODcxTlhS?=
 =?utf-8?Q?JIK+1r1hMStnxmMh5GEHGL7LI2PmLbwD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3g4S01NNnA5Y0lEdzFFTTRLTTlFZGNqaU9mU1M3OW9ldWpNUlZ3QUlpVmh1?=
 =?utf-8?B?aWMxcHVQU3JkVzQ1NE9EL0pPNkVGdGw5OWFnOEhzKy9VNzZYazNDWnFYQ3E1?=
 =?utf-8?B?RGVXTUdVVWh5SWVqSU8ra3phd2E4ZUJpUUxmYVVMdElBdWIrL1dUdXFvQU9U?=
 =?utf-8?B?YlRBKzd2RVl4RXE4d09UK0ZXeVNZTk4wTEYwVFJNSklGVm1QVkFCMXU1amdi?=
 =?utf-8?B?bVdQZlFMQ1NrWk1KWWI5UWx2SEhTb01DeC8zRU5ueG5RZTRvc1pLYnRZeDBi?=
 =?utf-8?B?dmg4VFc0Mit6YUp0NUtuU3h4aUFmdEYvTE1ZRDVIYnNmTCtUVUVmbmd5UWVY?=
 =?utf-8?B?QzFEM1NTS3NLL0h6TTZ1d3d4cTBSQ2Z0MW9WT2QyQUdyWWYwR0RRZGwyVjVD?=
 =?utf-8?B?V2lMS2hOcHU5VExYZXdkM0lJN3RpUDFDNkRVb2d2TzhjSUJtMmtycitGMm12?=
 =?utf-8?B?ZkFvbmNQN1V6OUlQNVJaNUtQcTVRaW1Ra1dUYmg1dHZ1M0NJdnpoUVNKbE5H?=
 =?utf-8?B?YTk2bzFIUXZrYVhWWDRCYk5aWDZnWmpHZ1dEME5lcDc3ZUJVYlFIcGFhN1Jl?=
 =?utf-8?B?TXJySEVneXJpeHVyMW9Nc244L1F6OG9HZUlVdFJtUDFXL3VUcmdTZ0EyVVd3?=
 =?utf-8?B?WVYvVU1YWTBFbU0zdEVHYnBQYmg3MlpHbUNKcU1kYnV5SndiVmZTMGxaa2Zs?=
 =?utf-8?B?UU82RWNhWXRnb1F0L2hsVWpiTGZ1d3VJaHRZWDBjNVZDU1NJTDRTZ0QrRGtR?=
 =?utf-8?B?anJWWUZyL3dYRUVQalBPSUp6U0pJNFltb2RGV1pXQUhEaVRnVUwvbFRwcjdX?=
 =?utf-8?B?b01PdW5LUjVDdW96bFlPVVZWVUZ1SGVaa0g3czFLMXdUdm93bzkxMU1ORUlm?=
 =?utf-8?B?akpXaWd4aklGNlRMVXNiSGIydlBFVGFDanBscFBCTUV0a2dNOTBWcEF3UGlL?=
 =?utf-8?B?bEo0M1ZPMmlna1FqMHl1cVQ1ZVJMQ1FTTTFsSS90OERHc2lVNXQ2K29mQkhN?=
 =?utf-8?B?aHVGV00yZmFoSmF4YmFYQ3dHSkNLRTE0TlpkZUREaUtlMFRXcVRHK3hUckhB?=
 =?utf-8?B?aVJyZXhUWnhpVzJoWGl2ZTM0UjFaMFQ5YWc2WTQ3Q296WW5BSTJrcHl0cTkw?=
 =?utf-8?B?VE5UMmp1OUc1ME1PZTFnaEc4K2hoM29ZWTdVbGtSMW5zUGNyUERjb3gwU2lC?=
 =?utf-8?B?czJTbitDWWdaODVNeFRQVDZXL1NBNk1sV1J6MDlLbzlQVHduMWlhNEhFd2Z0?=
 =?utf-8?B?ZXV0TllOUkkzakZ5WWZrVHJlVEdWalBVYTJZK25UQmtTUTJsRXFYSHV5NW5z?=
 =?utf-8?B?VWpIVllXb3U1RFNhMndXQlo1RlAyRWZWcHlNd2dzajNONGM3SzRFaFNraHdt?=
 =?utf-8?B?VmFQT3RyVUhzK1NZSkhRRk4xa05lOThmN2xhOW93eldzMDNuR29KUk9rRXFq?=
 =?utf-8?B?VXNLWGpWUHZrM0dUQXdrdUxuNDN3NkdTRStBSVc5N1gzQXY4WUo2TERLbnhm?=
 =?utf-8?B?cjZTcFNKdDRrYUpmV1h0eHVmaHF4MTVLRVVycUZHaXZZeVZRZDlFandVZXU4?=
 =?utf-8?B?d0ZteVV2QnN1K2hwVTQ4a3huTGo5MUZjQnBxZm9HUjJ3ajErUUJaNHExZ1Zt?=
 =?utf-8?B?WWx2UEVZdENFUFI3cU0vRERsOFhkNUh5RnBqS1U3cHVTdUVuUHh5NHBqc3pr?=
 =?utf-8?B?UjNxRXNPWlBxWll1VGRxby9CNFhCRVBPaFQwTlJZWVhHZ3RaOXI3WEhoUi9H?=
 =?utf-8?B?NjcwbVR4TkQ1eE16VVpjUXAxSlFEUERpeWRIS2lIanc4U3pwTUdaKy8zYVdI?=
 =?utf-8?B?ZTNTUDBmd2pwamlHK0ZuQnZxdTg4QTFic0EvcDJRaTM0bTgza0hHcngvQmtS?=
 =?utf-8?B?bCt0MVU4SmM1U0FGUWJlSWVTREphTkptOVY5aEhkSXFCMWx4UEc3V3FSUkpG?=
 =?utf-8?B?eW5YdlFrb01Dem5yUXljZjNlazN5OU92bXJNRXlUOU5JR0NSQXErMmdzVVJp?=
 =?utf-8?B?b3I4SWtMQVh4eThPY1lGRWtCRHZ3T1FWRUVDM1JYZnBLZldBUnBVOWV4RW9n?=
 =?utf-8?B?QWNrSDllbGp1cWxrRmZSV2x6cmVCdU1uWTBpR3M1ckV2ZlBRbjBZV0d6cjZJ?=
 =?utf-8?B?M2UrWk9iVjBiZUhFMHJLM0hqZjFKVlIrdDlaN3k0OVlLWTYwR3dJTWx0dWxJ?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2VE0oETVYYDBxQXhL5Cc8qYil4n9ndF1Thut1loZCHMiio8FG3WGxVknD3rc9b0pdRLsjqPK9bt6asvaxR0ot7wENw0WxeQMuTpA5H99t2c01qqOSkDFo69C/ERzp4vDRicjet+tGMZvxthoC8FrelQ3cgzH/61vuFDwzpmj9CiCn3AAMSXya+vikAPN3yPY+B64NLbQBRYaYA2FIfS9jQYjWtYqRcOILSr71HEYK+o97D3dIbrsOw9MCixJ5JGtS21gy+YvN/ZeIhaUm9S4Xjdt/oOGeVgRyd7Xt64m4eTw+hAAb/UwTDrHPKE5WT0418LR1asP6LWtFPl+s2NA1Uc/uVI8Zmz0zx2T8j/YvLoIC5BDZ7XsNXF+e+g3txDCS6Xe/+O7LK0Q70I0j35yceWjvTMs4crZj+rl2pyhn+8TlnUU+R+/wZG4l0I3zEMSKkYi/weHmWNxE2oNSdPQf3E2lw8ZzbpmvYiozrKicozP5FpazsCQijWmrKdOU9ShpSrFlEXAG7MtiknmzE1AMWU4txc1ByKHSjASfsHC8Z8NnzSlLta9qJxdsFw3AZIWJm9WROiJDV5VmGNKsJn0WlxEO0mF2m7ZFFjuY4Jlukk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d04262-fcef-4534-8f9b-08de0a6ade4f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 15:12:04.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VEBM83KBURtWt23rWputXyMKyCxy6d3Vj6lf9+AwOyQoZj3RJ14sc5l+4eJEk4MlM4lNscJo0WEDSh1K8Irya18UdYf0nYp8ro3txttv9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130067
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfXyPGkfap9k5Bk
 m8aHvKuWdfPkrk9yew2NY76QU8W9E70OTh/xS9u0oKpcXhnZtbKN+NwMN6tXEGvZWbxVKiOFRAw
 PhUBi9jxWoabYS1EUhsd1DMCOdgWcWtk5lxB+FVF4uW+RmPYQ/Evp2F6FkmVcrHthDiwye5ttiQ
 ArUSuwkddkcGTJ/OnxeXtgparjcelxcEBP6k0+cJxgOZoB/CKEfcScHF5SN3ezwu0mAkv9VXShv
 JzvVLZsQQyggkH69qrrhIMo71QXFm+5e8QD4n8ZUb9VB/BOtAKNE5wMog1PJB7/rXLjWbnPB3nx
 2ZFfZ+4uCTz8o12sKOVT48T8qdONr/LPjI8qgDmo/3C46AFgv4hb/DQwkzD8LW0JjJwGgUeCnbp
 7ORbuHT/IKZWY4gPwWOkz4NRvEfJtw==
X-Proofpoint-GUID: jrx0YTfAZoFvFkqoQVBV8Q0xgHK-fNns
X-Proofpoint-ORIG-GUID: jrx0YTfAZoFvFkqoQVBV8Q0xgHK-fNns
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68ed16c8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=uWPrMN-6LcPX8emCteoA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Queue-Id: 81D191C000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bx4dza88scqaub96ydth4q6scd7q8mhf
X-HE-Tag: 1760368342-26867
X-HE-Meta: U2FsdGVkX18TvIAWEZ8wZOvs/J9H9z5PETED0k8YFdNN+lkzdc5z2L6danUOIF3JD5m9v+/rb3fcgPH0sRALkuoBGnKvKONzaw9ZLWG2rqqlrHfiNzOhv2y/RzOJT8JdFHBdOBx2NRlA71wnPdJw3AwafDFsiFe3XuATyE1uvEwSwN7Cpuql+hGuK9QW2kjnhZeg/55XFQsJI/Lrx7pOnP/WGSbVjzWU0ZDC5z7hQuMBjDMGDBXlzyfDipJ0AInXwn16y2Ga3ztggc5nC/2iGPhZodeZ/NUdu1Ky5pHvWAzG90iwCQln3Ax4C1RpGmo2vLA3dTRbF6DdM73RtJlUrRnbJtvdPFT396t7v+gFUAr9G4O9+Ldul7zCbi0IKlzVMCYUiHuk5YWnlipm50TjfUuicUr5TS6qNY5NhZHgAw6r0KMryzbnZzqSGmpMP7q9K91uAyH508ENK6u8LSGhqkWSuk+V0hSdM+fRdmGFLSo1jzg+F6Z0voao4kmCXNFmyg0JyPGKeCjJHA9j0H+6smcmR3GXt3QkO2nMgI0/iaRl6xJZehZZwRSom1GJtyRUE9rQmEKZIBOGRybfFuz+aolQ1BPhDV9HE4ceBwqYtwzgV+E5Rh8WzFn2WTPcgyfb1Kk6ebi698WhkBnu4JnyS7lgN+6ne0fIxPS/wOFPEqA9yxQgviB2D5bZZh+NA1zpTFqUjywcNWqHWlJ8NDwhCWkbxzK/O4IoY/N19OvJivJd8uWXo9bIXPDR1uW1fvvO3Uic39gu/V4+8V8aCjAHloRnFJqQLSmKM6urzbXEUrOHREMVZpHdmWCqYOqfqK8Hn2P8XO1YuJiBCZh5VmtnsBF+CNlHLOWuPEHjYtTLPJRBJTPxL73SWSTrDbuHmOq67t0keV9MFjRs6aKlj4ny4c/HwDcK7hxT6HAvz1fwKvun5eoboBzOW6X+KeEIpkzDoVZ530nuwUsBxaTjd4l
 U0x+15+7
 8lKA2BrmQzpifrLqMJyJXSf2KBkcJ0peeogEySjzMx39CD66u7NglNuMgLifQxO3EdS6tuOq4GstejhfJp5krY9ra2VAUAbdCw9damgP9O2f7oes0gyZXls4/zWZQqJQWVjj4HUv/f4wylNOdqf0n3DIJxWAASE+1nylQM6OoQM6ZME70sfrkk/xQM3MJAOLqedUqTD4GHtYUzAJ5ectpKMfgoHJb/s1KU2mh5t2cvxru1bsubf7MnNV6PhDYbz4V+2i8ckwvDX2ZlE7MOZvOozDpm8FsMcKrxxaBfVnImcX2b+7/z1fs/tSpHL/RIS5hLIR4kCekVtdB8SSGurr4XJpwfol+jCVS4+CQZbeu5Vqg8kpDL5NEduYUqCqHhWh8ZvXKFrewcT1DgJohsbmO+Th2De1cwrxt2MnMMKzfm13Ji/VfMEa7eXHLwYrS1WfUIe74Dwsh+iqcGGWfnvRYHPBbyaVi5lIpewICw5XtxjP54jcEV55DTejt6TBxijUq2iOShv7kUtK0gHALpLUGwbBZm83nKNrSNLLv0RWVlM7Lul2bW7F9R6Ea5y5PO+z9UErv2sVYTMYSrvkyJdhWOhPuyiB4Vn1xFMBxA+aXPGswy6MB2SDMBwoLRUIPQbcofXj0xjZUu9XnuZy2gPWCNE77ZSKWlUge5jtkLEpttv22TcMwRjKgWq4rmZboYTfm6RlMj/+I/MRFfiLyjhT5qSzCzLxxuJ5Lwxhg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 8:15 AM, Kefeng Wang wrote:
> If the folio(even not CoW folio) is dma pinned, it can't be
> migrated, so always skip pinned folio to avoid a waste of cycles
> when folios migration.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/mprotect.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 113b48985834..51a28781de9d 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>   	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
>   		goto skip;
>   
> -	/* Also skip shared copy-on-write pages */
> -	if (is_cow_mapping(vma->vm_flags) &&
> -	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
> +	/* Also skip shared copy-on-write folios */
> +	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
> +		goto skip;
> +
> +	/* Folios are pinned and can't be migrated */
> +	if (folio_maybe_dma_pinned(folio))
>   		goto skip;
>   
>   	/*



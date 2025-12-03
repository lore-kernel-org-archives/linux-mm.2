Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1247ED1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 04:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702566B0007; Tue,  2 Dec 2025 23:19:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA8E6B000A; Tue,  2 Dec 2025 23:19:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1FF6B000C; Tue,  2 Dec 2025 23:19:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 443506B0007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:19:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8FE8C014F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:19:12 +0000 (UTC)
X-FDA: 84176854944.20.D616DBC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5B9B016000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:19:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=S3Azr5JA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xYVpVfBk;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764735549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xrf2eCiPyqDShlaLfYfCR9nt51ujVa9xtTpVnRMnvco=;
	b=yxHeQOpoNPcurGzPpEaeQQ5k8Oj07AyOF+peSucCg0buu6yUEGW41Y7sG6Zvl4FJllrUzM
	XR5gEVj3wSn4RzpE3Tm4rinaVm2WFGpIcSOh9lY7AqN0W8Zjra1N6Gz2x0CNSlRbtaEbkj
	cwYW78IQJg4Cz/XayqN7OoYs+/FXzNo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=S3Azr5JA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xYVpVfBk;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764735549; a=rsa-sha256;
	cv=pass;
	b=yk6jVU2BZI2caGhLg7U206tN7XMzrhAB/UgtxfGKEemIjtt0x4vyUwGQz74fENxqVqDQ0m
	LA2rkly/QEb/ZVOiqiQajSdMwqXyQhtK9REWf04ChrSu1xqV6ofZKfanRa3iVbMpcv/HVk
	++zfRjog3M7vzdL181SvFN6KbcBLe/8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B32vcjc1710249;
	Wed, 3 Dec 2025 04:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Xrf2eCiPyqDShlaLfYfCR9nt51ujVa9xtTpVnRMnvco=; b=
	S3Azr5JAzIjWNDwChp9dz1tJTNZh/dS6CTxtaiD4KDR7h5mKuqV4H738ndvTGvwj
	0yys7Bra5PZ0gU+3gGXbd+GmgpSMvsHPm9dM81GHXF7jnoGN8hATWptYKiFN+B1F
	TkyjTDpusJS2xvYw8M+NAkW7RdtQbJfLXmnJyU0eA6gUrDqpy0GraD7LAECE3KT4
	wVoJXgrONcfzlZ5Zo8zBzTOa9njSMl/Zr0Y+gMsdn41CbR0NfbY9e+DorYuLhjA9
	j7OElG+l/CaVj7lAubsnKa03uQEU3olA5rTe15oPMmY96VNYFVdWgWRZRrvn6G95
	ugvQJfIHXG22xhTV6oUTSw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7f24j6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 04:18:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B33iVC2011890;
	Wed, 3 Dec 2025 04:18:48 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013025.outbound.protection.outlook.com [40.93.201.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9m6v7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 04:18:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h7kRsyTa5XoET3q5HfOAtHALyzH92VPkX5H937p6CN6U8kwX8Dxhxz70akTwPZGBaTD12Dh9+RflE73/zms5ghAMGtzhb73ioOrqPTq/XYINBfLLWNDttoNNLZpaNmx7xuASrdnJ4Drdi2oax8BfrJEhtmFTOcbY/bfWMEcZmZpt0YKllgjzARnBJj0LwlwnXTUGGoHoM/sVmzDcM3xujf5WQ7LAo5RgGKNqcZgtgN6eubkhcukMDOS+38+AAqHUDpXhCc5XjuZNnZWZRZ328FhSk+3cha13lKb7MztspbDtFK7ooYSIZFQbp80OXLBQPAImH4c2WEGxUJUMtEW25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xrf2eCiPyqDShlaLfYfCR9nt51ujVa9xtTpVnRMnvco=;
 b=OPVzCB87UE8moQcH/XKispSUbhc6FX7LamnabPrIYqp7tV2JJqfytqf4z4MzEVMtoR1lKlBdrlQKP9lPOqsb3osbgmuNdU9RzZ8X1YW2FrpCgBm6wph4wMWditUAxRlBc2i1BOIPus1DlSQPqNEo2RZN+jZLCEnu84JgogPxxhkGPZHWtnyBDj943bpJsfLu/WlM2hFd4aEviXGa4cCpwbNMnuBaIzJdvuc1xhGO4yEDEVM/8mslXWFFpwg/BPRlgkNjemcPPNDagrFKdnTwe/deB4zTNNBJ2edgfLT+aJuQnRfFGg6vH48Sf+bdgUlF4h/qbuUrmhH0cH44mcbOOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xrf2eCiPyqDShlaLfYfCR9nt51ujVa9xtTpVnRMnvco=;
 b=xYVpVfBkiRDhPSiYPkC1lXQ9VBMSY1xcsISbt3IsVKI4Bh9R/+dJXCqgZoGhOx2GYfnFxVoPUY+R798itysjLKCr/1dDrbWVEO2eFptw4gvZR+4BTEFo3bOLt/OX9WwD7LN9AYR18QkcobF8VKEoleaWAoEkPx+6oAPjKAUjF3M=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DS7PR10MB5215.namprd10.prod.outlook.com (2603:10b6:5:3a3::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Wed, 3 Dec 2025 04:18:21 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 04:18:21 +0000
Message-ID: <693112ce-e6fe-4a72-beb3-d2b95f40cffc@oracle.com>
Date: Tue, 2 Dec 2025 20:18:16 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] Documentation: add documentation for
 MFD_MF_KEEP_UE_MAPPED
To: Jiaqi Yan <jiaqiyan@google.com>, nao.horiguchi@gmail.com,
        linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com
Cc: tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org,
        akpm@linux-foundation.org, osalvador@suse.de, rientjes@google.com,
        duenwen@google.com, jthoughton@google.com, jgg@nvidia.com,
        ankita@nvidia.com, peterx@redhat.com, sidhartha.kumar@oracle.com,
        ziy@nvidia.com, david@redhat.com, dave.hansen@linux.intel.com,
        muchun.song@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20251116013223.1557158-1-jiaqiyan@google.com>
 <20251116013223.1557158-4-jiaqiyan@google.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20251116013223.1557158-4-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::10) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DS7PR10MB5215:EE_
X-MS-Office365-Filtering-Correlation-Id: fbef693e-9f3e-40ca-ef4f-08de3222fea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c2xKSXZDNkQzKzVjYVN2dFRCTTlFMFFBTy9ER0dyOTduOHFSS0pQOTRSVkc5?=
 =?utf-8?B?Qlc1OUErZjFEVnlIQWIrL1VVUXJmc0l4VnRvRFd5T0d1WVdtMHYzSzM0NVVX?=
 =?utf-8?B?dlJXUFVJQ21IOXBiakpxNEZobXFrbDgwQjhrYzgrc1kxV0M0TW44cmFNZ2Ja?=
 =?utf-8?B?a292OXFOa1FwWFpHZmxXQjZQRytzajEyUVE3YTVPQ0d0Z3pMcWI2ckMvMEhM?=
 =?utf-8?B?eDVrQS9iUFFhTnBNNlMwSy9GTk9Ja0RYOHhaUEtEQUVpbnpQT1k2MXhaaHRo?=
 =?utf-8?B?b09obkJUVmo2aStBWDA1MThxcUhFSExPejVDdU1RTGVnYjFCdHRvR3piQ1pT?=
 =?utf-8?B?VXNQNE1aUmlYTEViV0lQSXVQakNKcU8zakJFQS9YZ3JWb3hLZEtFV29LV0Z4?=
 =?utf-8?B?b2VJZHdTdTdWbE1GY2VnQS9zVC9td3gvN1MzSWR2bzJCRjNXbGZOYXFTaXJ6?=
 =?utf-8?B?VlRNUXJvZm9MZHFFMElpWldvNjhybE9uN05ycWJQRlNRYkNoclVYQmZ2UDZF?=
 =?utf-8?B?WGNsRWpWODFURHlXUXRIMUl1UnF6b2xjYXFYTGpkcExPL24wdVhod2w5SkRx?=
 =?utf-8?B?b2dnTUgrRlRSOFNFZldxQUc2QU8yUXhiVVBPMzcxZ2gzUnFkd3lvMUNIcFpH?=
 =?utf-8?B?a3dlWFh2c2N6WXo4Z0FZdlhRY2REaHBzVEd5b3VENVpQa3lSZFAxQXhnYk1J?=
 =?utf-8?B?WFkxUlNUVEVmbEYzUVk5QkpURWFwRnhqajVDZnVlcWZJU0VhUFVGa1BNdjdk?=
 =?utf-8?B?eURRUDhnZ2htOVR5MW9JRURIZE5Wa2NGY0t3dkc2dTJGQkIzbENkSlRxaWVU?=
 =?utf-8?B?eThLWWtycHNNcnZsTE5VcWI1SkMySHhCdC95NEdVaEhMYlFQcURnY1QvcnNT?=
 =?utf-8?B?UVByZkJCMVZQRG4weDhHVE1RYW5nb3Q3Z05UOUFEc2ttTFhXKzNxY3ZnQWt0?=
 =?utf-8?B?QlQrY3YxajM0WXAya2JBdEsxNjkxRkh5RlA2K2JMbHJyQmdyVGpPci9sV1cr?=
 =?utf-8?B?SlIwckYvTHJuZWNEa3FEQlFDZ2RJTXB0T2NHeDBUVStuWTR6dVNnYmxKdm43?=
 =?utf-8?B?RldBeWdnY2ZCcmVENHdtSW5oM3EwWnVVSFBKb1pYQkNibXgvcmRrRHZ2ZUFT?=
 =?utf-8?B?VXRMdHdCTEN1bG1pdGNuTkhKOHVGbkp6U1Vqdk0ySXQzNjM5WUZDeFJkSHhU?=
 =?utf-8?B?YWJXRk1sVDZwRk5Ld3hPZHZlcXBuMlFheExYb3JCOXN0M211azQybzM2TG9D?=
 =?utf-8?B?RjJvM3hPZlZtN0d4UXhPL1h1NWd2OGVEZjRBcnpQQ0liZXJtN3IvZ0J2VFI5?=
 =?utf-8?B?MkhPVGhIdk5rWDRUUnNhMTM1NW05LzBqc2daZUswQmpKQXJ2NGZmdytJRGtR?=
 =?utf-8?B?bGZVN01zK3hiVlU1Y2h3bFErQ2hxeUVvZW9JREZPeldkLzg3anovWmdCK1Yy?=
 =?utf-8?B?QURUNzc4VThzanYyZkhxNmkzeUpkRm00M2ErNncvaTg1SzJNSGRSZUFCZTEy?=
 =?utf-8?B?aFNZdXZkS0taK2t5YVR5TGFmUFFFR2dRRjNVNjBtS1FMZ0pGVnZJZHN2TnVP?=
 =?utf-8?B?S2FGVkpBRjJvcWp6QXRWL2svY2NpUGhZN1AvM0VUNUxXYS96SnpxYnFKenRw?=
 =?utf-8?B?K1paSW9aWkw1SjRDL25BTXBaVy9nRXRhaWkrRXBpNVdtRnhEb0hMNUcwbDVM?=
 =?utf-8?B?YzFkZklhT0dxVGhibGtJUXE0b0VkNnprRmw1Vkx3aTUwWTk3YTZlSUpIUDVX?=
 =?utf-8?B?R0I3QjlkWm0vYzEvTmxEK0lMbE1Bc0IrSlF0OElaZFNOa1Y1dTdyMksrT284?=
 =?utf-8?B?ZDJOWHNlZUtLcW9CVElVUDdzVlNkZnZ3WHJKa21aUm9iRzRYRk56OEdNZllL?=
 =?utf-8?B?Q1N4RTltWkVuNnZYVm8rdXU2dTg0VUwwc3ZGa1FyZjV4dFhDUGhqOS9JWFNt?=
 =?utf-8?Q?YXq3VyCfa8PResgdEWb7RioQ9mpOKUfc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0RvdmlkSHdqMytrVU9PY2t4cWY3L28vZXVUVGt4YWVvQjdEWm43cUVyZ1lG?=
 =?utf-8?B?U212UCtUazlFdGZOdFZEOFUyemtJMUtUUUROb2dxUTRveE5oTU9UanJKM0Zs?=
 =?utf-8?B?MS9wNFErYWVmb0hwYnFCWGJCamJ4alYrYU1GZnB6VWNlOEQwLyttbUZlbjMv?=
 =?utf-8?B?NTVCZXJJbFV6V1NFUlNzNWl0ZWZsQnJiVEJpV1NCaU1YMTFCTUo3d2tmcFdL?=
 =?utf-8?B?K1VYR3hkN1VyZTMrR1ZzOVQ4NDNCQU9MbFRtNjViR3BVRHBybU1JNDBmV0U3?=
 =?utf-8?B?WE95Qy9LTEFrRXlYUGJUWTAwVU5HdUx2MEtybkhKYnZrdTZUS2hGSTBWV09Z?=
 =?utf-8?B?WGM1YmRxRTFwZXdwUnBZdExucU4xWEFUMXhGbm1wZTdsT0RsQnRqK2tzQ1hP?=
 =?utf-8?B?N0NwcTY5Uzd6Wjd0a1A2WG9wUGlQV2tWQUpBT3M3N3NUN2pFQUhoVUxwWksz?=
 =?utf-8?B?ZDlrOTZDMkhzUkVmOEN2ZXZRZExxMkIzV09UbENIOURYcDVULzdKQlhLbkda?=
 =?utf-8?B?S1JORkdaY3phNXBhRjVXeWk5dWRScnA3cVJBaERydExZN2JaQjJYSVNrSUFL?=
 =?utf-8?B?WGM1R1N2c1EyNjBDamQ3UmpCZWVPZ3ViWDZ5WWRpdXBybHNKazk5OFk5WTVN?=
 =?utf-8?B?QmZHL0hKQzZDNGM2aVFmOEVVVWJENFE4VkFKaTJZazhyRkJhbEZmMnIyZ2Iv?=
 =?utf-8?B?TDU4UE11L2lWdmpJMkJXYzhzOUF4ZmNZY3RYdlZ5dkNyUWZ5bVoxVkwyb1d0?=
 =?utf-8?B?cjI0c1RJU1FTY2lsN044M3EzMXQ4SnRkNEoyRmV2L2RQN0IzZG14UHRQZmhQ?=
 =?utf-8?B?ZGxvSU9uN0pGMXFMS2xqSWtoNzU0bzZLZWRwbWtiak1LaFdkN3RHRFpabVVE?=
 =?utf-8?B?cWdUMjRETUx5Q3pJeENRSmVIZmsycnNqbmRLNjVTV2w1aUVEeUpZcWVYaWZk?=
 =?utf-8?B?YytqZm9va0ZzZ1ZEdmtlM3NQNWt2Q1ZyYzJTMjFHRWxLTmFRdG9MTlNjNnlW?=
 =?utf-8?B?VGtBK0YxOXVpYzEwOEc4aDc4UjRZUW9takpIQUVYRHpYVFRaQ1RwdGFPOVdL?=
 =?utf-8?B?L3NtbGE0aG5DbDR1d0xGY0Q1d2JiTk9QdUx3MU9FVGhzTlpoaTlCOWorUTZT?=
 =?utf-8?B?NE5ubzhkM1ZtcUY2cXgxNE83NGNpclM1bFdOTlRZZXNYNUdyK2pubW9yeDg3?=
 =?utf-8?B?NUNYK1U1UzBFQ094V3BQRGlpaWZ6b0VkaVFRQVhra1dIYzB1K3BwckN2QUM5?=
 =?utf-8?B?bFRWSVpDSTZveFJEb2Q0QXNlSWZWczkvSDBnVDNxZjlKQVpyeFRBWk5hWmgv?=
 =?utf-8?B?SUtSc3M0aFl0WERzenkwdHA1alVCdVhZTjVSZVk3NFJFdnRyVC9VWXV4c3Z2?=
 =?utf-8?B?dnpTNmprV0JHNUJraFZ0YnNPM3FoTWxDZm5md2NCYzY4VElrOVcxekFlNmd6?=
 =?utf-8?B?bytKM2RzUlEwNVV2WDVkUmswRHd0UU1UWnRQS2owVHdacWdUbldjbm8rMnJo?=
 =?utf-8?B?N1JvKzUxOFlVMHBIb0UyOFJVc3NjRE9scnlZY21QcXdRMlJaVnVJVURYb2hF?=
 =?utf-8?B?cG9xTTJNT1NDMUZtRUNUa3B0elp0cS9WTVZHcGhhWGUyTFRNZ1dhRFBTbDZX?=
 =?utf-8?B?NS83UkphVGVqRkxncE1Mc3RBTlRwK29CK1hHSWYvVHRXYThBSTdkRHRvZkEx?=
 =?utf-8?B?ejBOUStFYmxaWFFjSUMwRlhicDZlQzhpclRnSnFxNGRnbW9SUlZQb1k4aFVl?=
 =?utf-8?B?dUVsZHRXQjZwRjNOWUFJQURaSkIxMHg0RGtQdzIwamZaeFByWCsrV1FTUmRI?=
 =?utf-8?B?VVRsMHl4bTVqVXNjMDRJWVBTSzJrdGJ0K3NVazNEUTM0b1hzbk1mdEJUbDJs?=
 =?utf-8?B?bURqOUNUWXlwNTdmRnZBbDNHT0IyTVBSTGNzajJlNHZlMG9WZ01yODJ3cnZw?=
 =?utf-8?B?YXhQVFlrYnBPQUJTb3F6akpOTE1yZXkzRjBZRG0yUDliOTZEQVA0T3NxQ1dS?=
 =?utf-8?B?czN3akZHblNaZVh5K0lRdG56c21UY0Y4RGlFMXhOYkZXVXJJc3NYYTUrN2px?=
 =?utf-8?B?RFRRLzdielhvOGNKZ0xWeU52RnltWnBFNWRaNlAxY2M0Q21TTFc5MFVSN2dw?=
 =?utf-8?Q?yGK5jhF8XO98rX6bB7ZaSs9vO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dln3m0EXaUrREwzolUI2gcNk3MQOEB+7UPnZUbj7CWBshKPdbCn0eyQUsBhBxlILN1Bl3q+Ym/2yUD6rsfLBhd8n7e5KkW2lypttdvUjKwXYsRHG2kjBujavWgLyI7WOKLyPcUm5EvOAgvVvZsVh2vnBBdOt7NTXpx6laM+hmhh7jNLZ2KoTIcMSLN7cM2e6PTMksP2ffmyt7iJ0HHi0T2RYnhOK1ZqcPfgfjqWouprDupQ6PkgXvTbYQ8KZkDiavzPN3WpAgD8J49xDQXbi0zLJ0GZzZtqttE1bRSyVNcywtb/0ZHiXqci/5UGPBRXYbU2LvJHuYs8M4XpthkAJwLfcbbjVrh6X58HzaGZAoN/fwh0EvpU115O6ariTHU0Rpjy5PghxEUeSz7Kx+EjVkSZPuxZzvK/DexngxrX23CLtg1vs8eo25d9UgkXgGZM7B4RvIL5GXDEngujup5n1Sh6LSOTO2ih/1Q23WCgb1ubq/S64zTjSGbVqx+EJUERxkMuNzfDMLUHDpV2Ksgms/zIT94HvF/l6hBBKbyz9P4/FAfLiiZ+mT2daGhk5uK/iXDauAxcCAGa8HRZRrR2y4CknZuGYiMgdIPu/wLnLYNc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbef693e-9f3e-40ca-ef4f-08de3222fea6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 04:18:21.7311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCQJJvB+WhC08dsLnVxg9auseKcbbMc8fBSD+4o18Hw5T+dEiNzqHVEFv2tJPpMp8/9G44+AJGHSG1yhcAgYHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512030031
X-Authority-Analysis: v=2.4 cv=QMplhwLL c=1 sm=1 tr=0 ts=692fba29 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=3E4yJ9fSZk8sK3EbspsA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: 96ofGPs2-hk_7r0lMCDmkaZIeX-WUjCT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDAzMCBTYWx0ZWRfXzzwSoBW0x+lD
 nvpvLnMlCpd3GooXd0pIhutyBL8ADvwoCj7OhS4K+pHAW2D5nl1PtPILB9XiATp6gyY4WgEqFXi
 mBz8ahZ6dxWIxpDIdCLAol6+oRofaz3Dnh6RKZ5Qlv+7De1scluvXhkoBdt5lwsDvKqLsm+X3iu
 nrWKPTnshtaq5CarZh0ndL9598FAA0b+So07BfCJWX1zmwW8zLJW0v5L0LUZvWj+OXxswqkJwKh
 r+xMtR4vaRHLDCzY9bH7MjIlgScmj+0rmimM2iU5mEu7G3K0VyNFLCU7EviGCaQGNznmGYE2Cus
 9tDs/ECq9rYPhcOpghH7F0d9t0dnmt82qGPxYOWZYvdL5ya8zrQuSDFf0qhCikshYGDjyILt8G5
 ToXSEGPULqmzTNjJP5YOWqy46O0TaZbI0fof9LycIM+mn9ty54o=
X-Proofpoint-GUID: 96ofGPs2-hk_7r0lMCDmkaZIeX-WUjCT
X-Rspamd-Queue-Id: 5B9B016000E
X-Rspamd-Server: rspam02
X-Stat-Signature: 5s3q3kdd7sxnbggy8a1cegbh3br4kyek
X-Rspam-User: 
X-HE-Tag: 1764735549-177096
X-HE-Meta: U2FsdGVkX1/5HiB15Ej/L2oQJgadTAsMu/9Ty/jEKKq6MqEjTD9I9lyisiQ/YnsO0NxgAkbtHL9bmkbwek+yl8BQO7ZFVPiAN1QZyxW95lFHnYcxWHF3/oxVXfrPtnUKkjURfZyPAqdbi6FvMOkETQqscPXdegc/F+znXgCTSbbalCz5wvQkY/+ue+a2pJB+LcUOQbkiH4e5MCeliq28fdir6aS4Zz2FpMBHkPJD2RdjVUVSMCm24B0xBY028XSwF8IAw7Zq2XH4HhvZlrwTfxgvRwt4tfLtoJ8iPJ68T7j/wRS49BtNPdXi0eO9llw9nJKXDR50nJU5RdPqaJ6tU5yx5Qb9qE5ZJiTJEfYOYdjljVSG0FegkvRmRexj1/RHXlyEbGZi7ZRHXoat38a4uBHuRbJ/v024bOOpS2K5nK3hwuKWzgm1WTJCQ+nD9UM7af5N5zK3CxGwOLTbOSIutnLGx4AFvfPtngXhEVLL0eg3kX5W2FLq/VWRwTfYrouSszlS+zPfhNz8joAhRP0wJtKiUjTgGm3KgaPFXa4pcaqTFO/NMu5PugtmYXAEuw26PxL+aySvD6l13iUuy9DSPXPZRa09bgFo9O4r7+PGnuSt+oRklC/IrRId27RVm562Na/oarXuAJ7uP0R5H07Pik7eiQ/DYiRVi5C+xatiCTL6gdIK1EnCmOdWLUVngFxGg8v+7waLRPhgyZWzpLp89AqxvEsKwwxMExoN//aKVzlHeoerF2b0tHm7JiuA21yeEKMqDpDGhHj9YnHY5+7ewjPK26a2acVajcoGgdbgJwTrohDzoFxAtNYEkMin5jNHe9WdjN1jgUA9fSaN/n8oY4nwFnlnCJEvyPePZqGg7neOzI9wsRY/lY89FaDmUf+N0SVf/mhr5EiWd8uCYXRURE64it1UvYjPTzAVN825DpS2Av53W0IexMleMCSkHEg7k+2y3I6/ZuNgPlkn+IY
 C9XQvqmD
 ZNzUp0B9B0JBxNzRzPC0R8uRt3VYNRGTc0wW84jnYzEL0PVBVbb/LiPxAOUOrEp2P5i7PByhLKtEpp+z1vzKNRRNrZS6okKus7mHOnHfr9I8QLTKw5szcbF+OWw9cr8kMPFDrvhteLf3GMraH4YyX50tbFulBsXx/Q/hESSGlS6Uncst9SS9k5e2VhAIUwvLMY1vfwzm15JmBRSGYwaAxVexa6H78OYmAs14DN/Le1mlV+0idULL1wqWG0r3fVi+4PlBNoJqnmHvBfZWqIp87nF2wvjXtEDekx7npqfzfCTIK592LkpiQ2Fjlz58hWx646se1teZbDlmviG1UX7LxXvLLvJB8FRPna/PErOdzODZyhoTLTCFfWpsAsNOvtwaaZ5glWJOhu9BSjgAjpwxyXg7fwM8Nl16/UDGg7JqhkLDE2x9/CNog/0qbeM1MoMgOA2nGeEGhzD8mzJ2k5aFcqsEgkFpf62vGtW9X/+BTWgeQTHNZyBBdKhIDS88NrRUteIptnblNZsZnDI/y7pBcCHqA7n+GvaDY3lyjDnwUdCnxuHASF2EsVPtXJZRmvFfNVSC2sjw7nEGjwUOZ06Mv1yzcNmBwKssz64gegHXBxZWLetxo7u2++tvz26xibVTzBa7T7N70VoQ4IA65zHdoX/DkrnbVS3C+zYAixjEbTHmjdyekhdODaCKzRMNNgAOInGWxkjqhBtZ1TraSxQYs7zfvn4b+0oQM2tuPYPoKjQAmSKT89l+wVeECUVJaEhuMHD/3KaC/+UDf6HSztxXdG8wmz4rraUFJLpTH+5alU21b0pyBjpP/OpPiLU49Io9yBnhlBAjS6Nfs1ns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/15/2025 5:32 PM, Jiaqi Yan wrote:
> Document its motivation, userspace API, behaviors, and limitations.
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>   Documentation/userspace-api/index.rst         |  1 +
>   .../userspace-api/mfd_mfr_policy.rst          | 60 +++++++++++++++++++
>   2 files changed, 61 insertions(+)
>   create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst
> 
> diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
> index b8c73be4fb112..d8c6977d9e67a 100644
> --- a/Documentation/userspace-api/index.rst
> +++ b/Documentation/userspace-api/index.rst
> @@ -67,6 +67,7 @@ Everything else
>      futex2
>      perf_ring_buffer
>      ntsync
> +   mfd_mfr_policy
>   
>   .. only::  subproject and html
>   
> diff --git a/Documentation/userspace-api/mfd_mfr_policy.rst b/Documentation/userspace-api/mfd_mfr_policy.rst
> new file mode 100644
> index 0000000000000..c5a25df39791a
> --- /dev/null
> +++ b/Documentation/userspace-api/mfd_mfr_policy.rst
> @@ -0,0 +1,60 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==================================================
> +Userspace Memory Failure Recovery Policy via memfd
> +==================================================
> +
> +:Author:
> +    Jiaqi Yan <jiaqiyan@google.com>
> +
> +
> +Motivation
> +==========
> +
> +When a userspace process is able to recover from memory failures (MF)
> +caused by uncorrected memory error (UE) in the DIMM, especially when it is
> +able to avoid consuming known UEs, keeping the memory page mapped and
> +accessible is benifical to the owning process for a couple of reasons:
> +
> +- The memory pages affected by UE have a large smallest granularity, for
> +  example 1G hugepage, but the actual corrupted amount of the page is only
> +  several cachlines. Losing the entire hugepage of data is unacceptable to
> +  the application.
> +
> +- In addition to keeping the data accessible, the application still wants
> +  to access with a large page size for the fastest virtual-to-physical
> +  translations.
> +
> +Memory failure recovery for 1G or larger HugeTLB is a good example. With
> +memfd userspace process can control whether the kernel hard offlines its
> +hugepages that backs the in-RAM file created by memfd.
> +
> +
> +User API
> +========
> +
> +``int memfd_create(const char *name, unsigned int flags)``
> +
> +``MFD_MF_KEEP_UE_MAPPED``
> +
> +	When ``MFD_MF_KEEP_UE_MAPPED`` bit is set in ``flags``, MF recovery
> +	in the kernel does not hard offline memory due to UE until the
> +	returned ``memfd`` is released. IOW, the HWPoison-ed memory remains
> +	accessible via the returned ``memfd`` or the memory mapping created
> +	with the returned ``memfd``. Note the affected memory will be
> +	immediately isolated and prevented from future use once the memfd
> +	is closed. By default ``MFD_MF_KEEP_UE_MAPPED`` is not set, and
> +	kernel hard offlines memory having UEs.
> +
> +Notes about the behavior and limitations
> +
> +- Even if the page affected by UE is kept, a portion of the (huge)page is
> +  already lost due to hardware corruption, and the size of the portion
> +  is the smallest page size that kernel uses to manages memory on the
> +  architecture, i.e. PAGESIZE. Accessing a virtual address within any of
> +  these parts results in a SIGBUS; accessing virtual address outside these
> +  parts are good until it is corrupted by new memory error.
> +
> +- ``MFD_MF_KEEP_UE_MAPPED`` currently only works for HugeTLB, so
> +  ``MFD_HUGETLB`` must also be set when setting ``MFD_MF_KEEP_UE_MAPPED``.
> +  Otherwise ``memfd_create`` returns EINVAL.

Looks okay.

Reviewed-by: Jane Chu <jane.chu@oracle.com>

thanks,
-jane


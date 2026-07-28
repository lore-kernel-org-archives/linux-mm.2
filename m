Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2319C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 18:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B046D6B007B; Tue, 28 Jul 2026 14:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5456B0088; Tue, 28 Jul 2026 14:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C1C6B0093; Tue, 28 Jul 2026 14:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6639D6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:31:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E679EC0438
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:31:17 +0000 (UTC)
X-FDA: 85039027794.27.DF2A008
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id E08E580013
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:31:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eCUAqXdu;
	spf=pass (imf02.hostedemail.com: domain of noren@nvidia.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785263475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+Scd2n5TqfFJ5Ss5O9SbqeoWLtSKDL9I2RkZVBlOcM=;
	b=GGNwg+IsSNzX6leOlww9KtvD0hshOnm1dYc+BK59A6U7d3RBERwarue2EG8rXWWVaRfCox
	k+9b2mko856rL5x3gCieOv8BJvNnXBWWQsjiIe04f79VlpkASdQ1WgBOWYP6sSReoN5LXm
	Wbjrk3gyGdZcg4qMTVAblDEyP9G1tNI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785263475;
	b=bJGHc9F4WYigxowAgV89CsIz9m96L6ZnBoTTYL9O16BwzwVvJvivPAbaLj8CxioAhn/dxR
	P6l1ViOF4kOmTnbA4XN7EUlXOHG48lz5xHCby9bb2lpJFrQtogVs99Zy41ggIoPFulQNdJ
	1+XTwpAk953f64wrYz5BoeYdQWATIZs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eCUAqXdu;
	spf=pass (imf02.hostedemail.com: domain of noren@nvidia.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmLOPVGCXO+cQLvCGlMbJmRIPYMOtpAIj+1Kx4DSEKi8yit4Yr5LY6b/C1K1XPRfD4RGV/1MW4xPr3vY1eayLIEvZ8XWHrTZpmj7OMSH2IlrRc92uY4fVdMjlAVUSM/YoGQ6fR1uTsOP/IdpFkkJ+juR3vDLCirQ1i9YGpQIgt6Lr5F8kggi63TIoyA3DeUOIYCptwZQ8INjx0m5t5eZuXn6exIdgqjCi++5EcugSDX+uz/fk6ar9JQD+QhqttcrUEFC8mCttEVF52m9Mz3skokSMTuG/KzlYZHuP/7eJU3BnjENOhl8vBUdeLQ2r+EHUqPf0yXmbY8k02XFfCN/uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+Scd2n5TqfFJ5Ss5O9SbqeoWLtSKDL9I2RkZVBlOcM=;
 b=bn/9S6bUQYHyAhrFofEdY5bbWbfrj6bgIm0iUpMpm43hVaaXchNg1U09fOcHaUEARhCZdkisQDt0iz8HWiCr4De61eY3LgfppQbXJQlH7/UWkYBvntc4X68+4u5JjrDouzoCGVj5BZM8wWLguzybIw2z4qrX4klegP367pVjI4G7fY3G5QXkYRoHW1xbWtzKrnPSE1l8rGcpjBsDO76ySiDhLRmVlQJiHWt+YdM/R0bFTWAFxxVDxOStdQGoec30aDz6Yu6qbHPAJNDawVFS3kd/AQkVsphjuP190N1gNt3EFoSWIqEfSisPXzk6TjL5q79BZXZwwhJNnfS25xcT8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+Scd2n5TqfFJ5Ss5O9SbqeoWLtSKDL9I2RkZVBlOcM=;
 b=eCUAqXdu3CF+gRPrV2MUjcEYHL92inKtKzIf0/4Sjwd8Ti9o9Hzjyp5ZUFF8iGtF2J9I7hs4QHZwpT5Qu59TQk/tHgPZTO85m+M3MhTep02npm7DGPifUFfxHUWbyMlg7awpQKpz2zavrhm7kCX2xt7O3wedvXc7eGvtSa6+nfYE4RcO4Qsxz7g5M0V43d3Rd3ME0H6pQvYr7DE2vLaOBeIZcptXbLn8EeQ4zNb06a6kS1rYUv1BhAUdcUIFy0GlMItvoFyy+9sHoexoMg8d43YMw6T9W4d9TZTnX2QOzIi0SgULx71soJDjOauJ4d8xjsNiUc7dVawk6znrBeLUTw==
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by MW6PR12MB8898.namprd12.prod.outlook.com (2603:10b6:303:246::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 18:31:09 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%5]) with mapi id 15.21.0270.009; Tue, 28 Jul 2026
 18:31:09 +0000
Message-ID: <69b16c76-c46f-48a4-982c-b762b31ffe74@nvidia.com>
Date: Tue, 28 Jul 2026 21:31:01 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/khugepaged: cap pageblock contribution to
 min_free_kbytes
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Liu Song <liusong@linux.alibaba.com>,
 Hao Peng <flyingpenghao@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260716173504.760369-1-noren@nvidia.com>
 <alopMtyPYdn7vDoC@lucifer> <8E9B69B5-0FBA-4CE5-B737-B83AD1FE52C3@nvidia.com>
 <amc0w1IQAhHND1Dr@lucifer>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <amc0w1IQAhHND1Dr@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0284.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::8) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|MW6PR12MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: fd5cf13e-60d7-4ec0-7b2d-08deecd664b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|4143699003|22082099003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	zWByyz4UTkYWRWdfbHa+nazzJtpkAsFbxQC0pvl0HogbaIVgOGGlFKOfrZq1nKC5tSDJTDOmrNcXBPMla5iXrh2dxP0XUm6LNP40C4zO4wquHEEdktrCEUGlrTjBt544V0idgYcmdplc7Ew6IYCTe1kQ384kothzJoVtGPNDF1am3WbdUzcxspSxYs+wtGrEFSs1qIKkIvRrqjYcyNlS/mte+C8akd3wG++W3u8aXIVxwz3jD+Z6eV+pUskVo8XwkcJXmLLZEFCS1D3vwR8PhgGAS5tY9mVhuS2EJi4XFpuGIUCIjwALTwBblQa9ilcgg6etxt9xjsIf1sJXidVnCHLm5lFKDfF0+w/K0Nb2KhsFlAZPLQSXoDh0xMZ0AcrN/fxAgIDWnXecPmuFP9qzG9Lyhnb+7/EDuRxQ5IH7s/iWi6j5i/mpOffiFLzzJgg9LCS22Onsk/zVX14NYRFEFfX0YY3xx7Pdvq5Gi+/sEPD6yu0HUrLj/QpzYhVpj97VJaQfFGJvjpIPuxb7T6jSm9dQBpBoNsGTDLX/NdDpfr+sCaEgyLYEwdiXndM12sZBVAD1S0AbdK2CKxmUqNxxFcGYiTpD1bz6pIXRuZUTEJzwypXNMU7r3C8ByD9J1cGWwIXzxruVntl5jmgynGWmPPKZOiogAx5KE8/Uyv6APTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(4143699003)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVBTdzI2QlppUmZ0Zk9IWkZibHJoVWdBalVreHJTa3JlaTdMU0ZmQ3pnUDFS?=
 =?utf-8?B?Ris0SVFPVlBESGdXOENqbUpVTUdpOWJFSTRoTEt1Zk90VXd4VHVqSkt0Rnk3?=
 =?utf-8?B?eG4rNGw0Vlh6c1FielE2dmRNdTZPMmFpeDNxbHVTUFlIcDlndjA5NTVNUzB4?=
 =?utf-8?B?L3lvRW9pNjR1UzgwY0lIaWxEMHV1V0JjU0NvbEdqWUR4NjRGUi9TdE5KSUx5?=
 =?utf-8?B?UzVoc2t2ZW9NT3lpeFlCTEN5TFhxMnY5V3JzTWhBbzdNQnpiUXlJbE16SVBt?=
 =?utf-8?B?cCtJRmphQzRwdHhMREJ6Q3NtNm5sUXJ1Z1laekJSaDd4ZGZ6aDQrS25MdFNC?=
 =?utf-8?B?ZTM1aWVsRTVrYzB2Zm9YVU9NcDBkb0wyc2ZmdFRXRXBHY3Q1WGloT2VDRnBT?=
 =?utf-8?B?V0pKNk94VjdiRVdvRC8wR3E1dVl6ZTFTblNLMmUvYWZiWndFcUphS0JFVDRQ?=
 =?utf-8?B?c0h0cDdBSk5wZUlTVGxIMEo0YzRUUkVSNVFCeHVTSmRQcXI5RmRqazg5QlZ6?=
 =?utf-8?B?cG1KdXdycnFzV0M2OHZYcHpEQTNsdlQ2MkIwTmxpWW1KK05BOGFPcDhFWWZt?=
 =?utf-8?B?a3lLQWhUMlNOMVRmdVk5NURqbTBIRGgzb0NLVUE2eUUwUUpybG5lay9IVjlt?=
 =?utf-8?B?a0F6UGF3a2pkdGcxWEJQY0VZOXhzaWd2MGdyMFhZTUFOZURTUVdmcXY2Q3ZM?=
 =?utf-8?B?elpHbWxjTGdsVW1iZEZiRkoyVDdPTElDdGNlSFlCRzEvS1N3OVcyR0lERnk5?=
 =?utf-8?B?K2czNFd2WkNadWllSXlBQjZkMmdPT1l4QXBVV0VHRURkaE1YZyt0bk9lYXRE?=
 =?utf-8?B?R2lDOWlsU0htMXg3SlpxU2FlS2dDVWhqSWxla3JHdnNhTnlESmR5UEt5S3A3?=
 =?utf-8?B?MHBOZmpiNXFEbDVibSt5ZU84MkVyb1dPRHpLNW5vbnNtV200eEV1cmVrejZ3?=
 =?utf-8?B?SUh6NGhQL1FFNEdFcHppbEZNL2dkYUpJTkZqM2xFUEhjN1dXaVowVFRFVU9k?=
 =?utf-8?B?U1BXU3VMUFFMdm13blZRMXlyazUrUnJaK25Od1NzSWpTQTB0YmQ5NHBFcXN6?=
 =?utf-8?B?c0FxYXRpNWE5U3hUdDZuVFFHVWZpdUxzc3ZKV1ZhSDdqQW1BTWVBZDQyRnkz?=
 =?utf-8?B?eHlndTlvcDJ0emRQNUFyczdJZXNhcGZVMkJJeDcrNmkydW9ZUU5mTzRPTFc1?=
 =?utf-8?B?UWJHcnIwRHduQnJuSDBjUnBIcVFOZEFkQ3hab1JuT3VtRHgzcmVPWWlLMVJO?=
 =?utf-8?B?NlVYcHU5QVpzUC9KNS9UUFRRMFV5Mng1Tk43RmpvSDdUcldWTzZSN0lMOFh3?=
 =?utf-8?B?N0pxc2pEdDRLTDAvRlBpUGx4eWRSeGJxdDlTUm5yNllQdEx5SXpyV3VML0lC?=
 =?utf-8?B?UGRGVkRCMTRMMjdkbVhnV2FuRkNoMFl4bWJtNFYrV0JOa0ozZC96ZGk0OFNt?=
 =?utf-8?B?Z3drZlpJOGNjRzVhdXZjSUhsZFFFVmFHclJMUjFkNHZ2b0g1MWFTS011K1Fw?=
 =?utf-8?B?TGZFajVhWllBZU4vT1g2RjByUXFSSlNsT2kzRXEvR0J0ODdxejBZN2tseXlT?=
 =?utf-8?B?MnB2clhNY3AxQ2pXS2FtRUlWK00yZ1dzTThLbjVPQkZDY3dXTWJlMzBOZHNk?=
 =?utf-8?B?aWhhcTBIVlNacTdZU2ZSWENsQWhpd3JEOGpQV1ZJc0xzWjdEdnQ0cHZOa0Ja?=
 =?utf-8?B?WjZUbDVqVkp3S0dJd2NtOExhMjFyU1dXd25VNlNnRFQrYlVWYjR6MGlFanRM?=
 =?utf-8?B?Wkp6WTcwanNjVzF2a25UUmpoMFhxL3QvajcrMmpxTUhvaldwYkpiRE5QSDg5?=
 =?utf-8?B?S1pSVzgycjB2TWs1VWpxR0QxTWNXZG1nOXlITWdiT0VGZ21ZR1IycmZldDZH?=
 =?utf-8?B?a1FSbEpYNlY3ZS9wS2J5UmYwQ3N4VmEvQzYraFpISGlFN1M5TGJXQ2lvZDJM?=
 =?utf-8?B?YmduMWVTZ1ljYUZJNEVIaCtHU0NVYnJITnFiUmRmYUNVSHNTSkMxSmhzVlZ6?=
 =?utf-8?B?c2NnR0ZRaGFWMEdBRVgrUmZIL09ic2wrLyttcjNSckRTODArRGNJNzZkaGRn?=
 =?utf-8?B?cnhhZHNxaFNrN24yMEZUcTYxVFE3MDhRaS9ZY1BHRm5DV1J5YnU4c0RmUXUx?=
 =?utf-8?B?bVRxdTRjSUpYWk5ZdG1HdVRFOFp0L1dUeEczeHJoanhSWWJGdE5CUnh5TVVr?=
 =?utf-8?B?MWhqVm44SU4xL1pwZFRNUjlQMEVCWjQ4b1V3NE9oVW1zc1phMUwyWk5jdmJ6?=
 =?utf-8?B?Zy9peTlqWkY2TTZPMGdPa2VDa1VFdDRQVndjSjBVK3hheHN3RWI1bGhuTE1Q?=
 =?utf-8?Q?b98PRDuX4VIuyL2Kls?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5cf13e-60d7-4ec0-7b2d-08deecd664b8
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 18:31:09.2700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgciHn1zFqXj7i1lEYytF7ADOAhFeasoBhZwIlq5GUuQaodTHqe/t1cxyRj0f7mnsF/LjnZKpgzWzP4AXsNeCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8898
X-Rspamd-Queue-Id: E08E580013
X-Stat-Signature: b685z8o9t6mfyumhxruqo9xupa5yas73
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785263474-572862
X-HE-Meta: U2FsdGVkX1+iroYwtNdEt7Z5j9dloz6vsl4hafAub7VB+uGQpBytzK7EMsR61ezdoDm01+J4/43s4c+v3tKw2SgUml/WGtDxrcbrdw/p+5t3QxC/WsmjVbMvuZRYjIIf5LYowhMDekrdlHWY9gZxH43BPG3Ke8TDoZeM6Q3lWE3iaTPLM7Ja2mWpfQ0V5SfRvUnqLnA3wBHR8MRopOsE1lmPyOYQs/VV2NNUe9LVM7tcdhW4uMe/NQXG+rQoUHJ+rcq9BPncpo1BSCcMpeR9MxlaVyFRE3ANLPkkfr3KTk0mldKKeuwcwbYaro+4uT5WpS7OJ/oFjwvMv5pznnjj5uEjaMSH3t6NbwONEeATOfr9p/2IzHF+8XwPOpfQIXl6l/vkh4cGAJLjsu9Av9K6rH2VspKxdIiwUAi9IgbqabxRJi3hhjqr+AVIemmqsFTnMePuBsOtVKb0tzlV+t/x0lLk1IVEpajm3hPu6Q0W+KMLsYSqMXmlCH3QUP18jWSFomabTdSkQFQzHhtZUyCw1dSnS6N1V9poigc7oYAbK3lpW0xQOE2tAHHeziyi4/iO8CMu6wmGs96UesQvQD1mbyBVYVOGow3m3qJ4QD3Ilx37dcRGAqSRSlWIVwnk7Z0rc1aP7qxCujHX1gzLeyntBUgYH+rR0fxiXL9GXZniVvmG0ZtknVG1oS3DTVz5KuE3x649Y2ce42FmqlBUrC4azqLhngpiIfWKoeUMgJDK3BQFvuBqXbIz2uma8c+I1II9dkjlVWm1RPgyCXJkWk8tKyGysgHeOaXFcTKe3wpfJe9OqHfLn+uB3tZIUb9BZ1vaL1QS3EkkUUvXKKNP+lFcQ+nRdxoVLYEt+bKu5ENczplQ+vxzDwHdbsWP9l3EDt55G2B7dqdOhqYPOvaV6OjW6+inEvHoubbBmZp4AMry4d4jP6N917nrpym3Uz/7Tu5PD+XLWpWeRpL4Adks3SW
 rbN+tcAf
 N/C2c21F5yccNRNyt2G5FpnDPIe20/EIBZkrcXANRuD3sRWEV9RKrXCeHXUXd1g6BqvQ1ZI7D7LIL4nx94kBUsUy5eQFSryYubYmXWmqZbXHAgZkFx6aJdBR0olpLyiuOBnTisa0y027FBSCGZ144Qd/7OKnoyzKEUpkqg2QOwYKUb0JH8YvehFzPtluKFiXJ98gzvYLFXnh+IrQgtxSqA9Wmy5dnOjYQGb7XcJNqkn4j5uBqg+i0rze6IADd3lyrS4ZEwYP7kGGkok0HUvHF042KLNlPTDZaNIbeHk6kg5jmwcqUgYL5WYs+Ike9523QXwaTTDeieBO66WvtRfNALzIZqV4U4vT41IoUGJg/tvp74qhTP5M24VJdSNIdlYZhc1RQgAj5fG0miO9dUATpF1YjQ+owoonE7phNmElsbenS2QXjf8eE17lpqQWaeF6mZBBP3fOTfavEWR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/07/2026 13:52, Lorenzo Stoakes (ARM) wrote:
> On Fri, Jul 17, 2026 at 10:58:45AM -0400, Zi Yan wrote:
>> On 17 Jul 2026, at 9:36, Lorenzo Stoakes (ARM) wrote:
>>> Maybe a simpler version would be to just attack the issue we actually have
>>> with it - it uses too much damn memory :)
>>>
>>> So maybe something like the attached? (you'd probably want to make this a
>>> sysctl or at least a defined value of course)
>>
>> The approach below makes sense to me. In terms of the actual cap size,
>> I asked Codex to check what possible pageblock_size and their reserved
>> sizes:
>>
>> 1. 1MB pageblock size (s390) and 11MB per zone,
>> 2. 2MB pageblock size and 22MB per zone,
>> 3. 8MB pageblock size and 88MB per zone,
>> 4. 16MB pageblock size and 176MB per zone,
>> 5. 32MB pageblock size and 352MB per zone,
>> 6. 128MB pageblock size and 1.375GB per zone,
>> 7. 512MB pageblock size and 5.5GB per zone.
>>
>> 1GB makes sense to me. 512MB might also work.
> 
> Yeah I felt this was a bit of a 'dumb' solution but ultimately if we are
> saying 'restrict how much memory this uses to something sane' then that's
> what we should just do.
> 
> It might be a good bandaid at least for this issue which is ongoing, well
> known, and painful.
> 
> I think at 352MB per zone and 2-3 zones for 32 MiB pageblock, plus reserves
> of 2*512 MiB for 512 MiB pageblock makes 1 GiB a sensible choice here
> overall.


It's worth noting that while users who need more headroom can simply
raise min_free_kbytes further via sysctl, those who wish to lower the
value can't set it persistently since set_recommended_min_free_kbytes()
may raise it back to the recommended value.

I think 1 GiB sounds good, but given this behavior where raising is more
accessible than lowering, I wonder if we should opt for a lower value.

A new sysctl for the cap could address this, but I'm not sure whether
adding one would be justified.



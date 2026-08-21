Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23FAC5DF97
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 22:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2D6D6B0095; Fri, 21 Aug 2026 18:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7506B009F; Fri, 21 Aug 2026 18:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959076B00A0; Fri, 21 Aug 2026 18:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 692686B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:04:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07970A028B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 22:04:55 +0000 (UTC)
X-FDA: 85126657350.19.4BBEE40
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013015.outbound.protection.outlook.com [40.93.201.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21693C0002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 22:04:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RLo6mzk8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787349892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyLoMlfXC1UhMM/+ouZWLhHVTXg32A3O3xRNJRgppCc=;
	b=wJ723ptnlQ2j5u75WOvWBEVZwwRQiOQSHi5GPdkyH/6k4HVOCoo1IdK+Q7YLdpmd2Pnqfh
	KzQC5W5XyXKZggU6ydgdMZq3JLL05go/zs0tcVuJBnTZbFGUUJF7BuMQ6SgCLMNhmhGyRj
	2j4lKK8q2D9Wu+yTcu/Y524waFr2MCQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RLo6mzk8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787349892;
	b=y16GjN0QMfHvuFNrrKvO2d7auUC6bYUx5qXM34sdZmk7+uuUgt17QS0oy1gFILdtcS/M0d
	I3dwoW/Zs03WOarbtO/5Kpk7hRGykhb/3cJMiZiBFyoSUpSzcJSzU4gvowi5zVPZlbI5DJ
	a478pIHypcOM+5BDgYQ2+1h1pZqUPa0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ufKUFmftBYVeIfr60L19LumT1BsT1DwHzbE42bKkg1aD2t1YhP84SLcYBWF6efVGFmggVy614NxyQF2RO8xSKVPSj7jko+fRi9/FONHLzRhRR8X8I/YM4X0haZOMpXLDcjAVKPI+d2IInYp5ITCBX324rLc60iKj3kcVyg6D+6GPXxn9r9zFDgvyQud3utlFViRXYMq1Q33q8rHAiP5ROIdgusRPC2+RtmO4lrGcze9DFo3YEJzSvFSkhEclsLnha7MSEV4w9jcpZc6u0LxadqPfahIHFrOX+G8SfhvvoPiYPBhNFyZfvlmGXvNYurY1IJYBaFaApVto1z4t419FfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyLoMlfXC1UhMM/+ouZWLhHVTXg32A3O3xRNJRgppCc=;
 b=CXnZCh8BX5oIl4bGCqfc3T2hYwFytXYxKBHA4XKeKKQ8kbkT8A7Ek4LsAzxgJ7G6JGqGbOpe+s1i018zuIXHaZDnWlMdeBdfTnvsjbj18FIXAHMUGdg4vmSbghymRv2jur1y9CkicqWXIx+L/w6ei3MzTwBmI67S8WVt+j7nlZATA/Cybc2YZV554eGqGHfKTZt0RFscqdGA8F5YNOv21eK60wQcOds/Q2BvvZeAgZU5fjN/jM9j5gWd+3gnGg67cSs6q0xXugKCzPSiDJGu6n6EgtnzkKTIxx9ETXbeHRbOHoCHKnJod73BTaaJGF50YNN3Px7fkSJPrUvsXrSicA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyLoMlfXC1UhMM/+ouZWLhHVTXg32A3O3xRNJRgppCc=;
 b=RLo6mzk84XtxO3Ew74RUvDbdLU3TfD5G1MPQg1TbNoW/09E2whdauzp5jggSNzWbu/ciZ49fVOj8fdM+j8ynlgtOzDwDIDPCVXt473QsVx1zAQ33xnEDcB1hxv98+KOzuAbZykCXnjn0ZdK7nc1NWFLesmLCx/IN8VLhFCrda79ghtyrhO2u2BszPH0MQ9xU2Doh3QZ6symScNL9a8qu6COfQ+PKMQ6ZJBvwd+s+7eSQc9s1+NLx/62di2S2An/aTcNRYO6/lyMikqinQftm8kzn/ZLApIwtlRMV9MUrTGMo7xdMgSntB4Xk3bMFViLK5/XRI8N7Lm8C3cvvC3vjEw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MW6PR12MB8707.namprd12.prod.outlook.com (2603:10b6:303:241::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.10; Fri, 21 Aug 2026 22:04:45 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 22:04:43 +0000
Message-ID: <fe9f0bb5-73e3-4509-951d-e529e37011fd@nvidia.com>
Date: Fri, 21 Aug 2026 15:04:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out of
 follow_page_pte()
To: Rik van Riel <riel@surriel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org
References: <20260811025157.1632867-1-riel@surriel.com>
 <20260811025157.1632867-4-riel@surriel.com>
 <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
 <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
 <3b8cb743-702a-4362-9abb-7c30e687c3c2@kernel.org>
 <ab1661573257d7755d5a48e4f9165ff22febba29.camel@surriel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <ab1661573257d7755d5a48e4f9165ff22febba29.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0172.namprd05.prod.outlook.com
 (2603:10b6:a03:339::27) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MW6PR12MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: fdcb9b23-171d-4d23-bc59-08deffd0346e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pybD9+Yz9cLw+EYsaYJyZX+vlIH77Fd5wirvPC47DzM5KuXXy27B8W+UEKpdn9QCQL4P0yeGgSOMr8+pymtQin/IpKj26JS5bTRPGEMkNI8FDuJ4x+emvoLKaHsMMUyGbL5YsArmuszzTGQT2shsUCpNFnbk218NKxa8FJk/g2eeTGPElPIwTuUgwxju7g/FBDybZ/poLf7ONfoffwrA5CN7YyDIOZArBNJO1iRQal+ysjcBCCdaGgUAovwa90FDJ//e1c9QAT3Z9hm2BgpzGlDaoaP7ZN81u4dhATN0DBQQHKvsN9+lXRxAStMJCuWWEQJndZbH2wJzqeSkmxoE4Scwx8mNuK1Ecjt5Uv/3/l7qkWmPOfyaDt4l56H5A0BeII6wls2I8qYLHgcprSJfCOe+ZUFgxLhjXxge2bHsMlm5mwqLgPkr3w7mDgB+ME+XuahdfZdji1rFfl0G3A932tUhNkqwrJdPsVZ+fMWo5joRhb34uVApjVC6ioipH2s+kFANTrTeV3dStUUvytj7p1leaAzKHViYNqRlWM1Cp/umUqd4+lRVQxxBb2xqu/SqVgYTPjMAsvo7ZDh5bsoISasA+UJSurgsSpUdQVN0t9uyOqw9Prwp7qbO6AUF1Bl+QHdfe8vsAHL1RBwWwdBYtZzi/NjiXPW7/F+r1JHjk1k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OCtqamV4ZGxsZFNoUkdoLzg2VVVzNHpYMWp0ZzRMK2tLSEhlMHA1M3ZYcW4x?=
 =?utf-8?B?WXJscVB6bEpZS3dibVBVUXVteHd4Z1NCbEdVOFpoSk83OWZHVFdLcEJvVDdM?=
 =?utf-8?B?Q1pRVnVvaDFHeC9LemVlcTlkNW5wYXFpVDVwdG5NMklKSXZYSi80K1J0cER4?=
 =?utf-8?B?OEl5aGY1dHFDMitOc2dQNC85SXZXOHF3U1JkdzdXTzFhRjJpT0x1ZGVIUTNh?=
 =?utf-8?B?YzI1anhGR2p2U3h5Y0ZyNklMY0JaUWpKT3Q4RHJWTE1nQjBuVnV1MVpsNHNY?=
 =?utf-8?B?RjBvTkNsMjlBQnlBT1drMVp3L2IreUh6T3F1T1hycTYyRDNwbzBKYjFKVk1r?=
 =?utf-8?B?M3RqazdnWVZGenEvekgxOXp5eU5VOGpsZHlhaXRkMk9rMzdRWXV1UGpzVUt3?=
 =?utf-8?B?dk1saHprTEkzM0dMQzRBMXF5ZFczQnc5eWZteWpOUTFDSFl1MjhBVnRTaW1U?=
 =?utf-8?B?SVMzQS9mcE9TMWxZOVJFdTB1cG9xQm1BMDJFay9yUEVNYnRwd1JESm43UVlB?=
 =?utf-8?B?akVyclBreTdTMytsc01BZnBpL1hVdjdtbUc1TEFYRDdsVHhBcGE4a3dwSks4?=
 =?utf-8?B?TGZNdmJwVy9jbkRPREdHcG5jY29rVkZTSkhWcDVOT0MwUFVDajBtZFloaWlW?=
 =?utf-8?B?RS9PelBmbW1PVjNXaWc0cklqdFRwcmJNRzZBaHJBZkxOYWxjYmJFWkRka1Y1?=
 =?utf-8?B?bEZpaEFEMVd1dGVqNGZrUWo2WHlBbnhWak5jeXJBSkxUSEtjYStXcU9Fc2FY?=
 =?utf-8?B?bENnNFFjZHl3L05sSDAzT0UwUzA1ckxFUW1LZDVubjlweUFzRmlmZUZrRkNi?=
 =?utf-8?B?VmZJb0Vhd2JzQVN5b3FucGdtWW9nL1ZpeTNkd2Y3VENrU2kzZHlxSHlDNWNU?=
 =?utf-8?B?ZDRIZDFqczgxTmlWNVlhMUlCa3pzQXNvaDlTOTVtb21HUWNGbk9mbisxRnRX?=
 =?utf-8?B?M0IyK2E4NW42eDViS2xvWTV5UnBpQ3ZxQnZNcnlvVzBrMFlzTDFabVFlMm1h?=
 =?utf-8?B?ZENPNXRUbjVvNUtNbkRmcWw3VisvWlM0UVpibzhJWm8zMjdsczNUaFRxS0hj?=
 =?utf-8?B?L1VCRzdCOVFaZ0lMV05renZzTUc1a3M2ZXFIRERUNVd1TTIvQzRyOEhhdjdY?=
 =?utf-8?B?VEZTVktiWGZEemphZUhyczZLaEs4Y2hqTkd2SFUxdGxGcjd3OFkya0FNSDhW?=
 =?utf-8?B?UWs3azR0NkFVME5RczhZNVFuOHhGcWRDazVmUHh0NmI3NXBOeXA1VnZpNloy?=
 =?utf-8?B?L0MxcHRwUXFpZlMrckR4Ykt6Z3UxR25Ja2lreTJ3YjZmWXF5WFRMVkV4TUov?=
 =?utf-8?B?bVQyU09xYU5PWS9WdVgwY1NCdFJaSVErb0h6MThJSFl6NkNNRVJYbkN3TmhV?=
 =?utf-8?B?T3NDRWFOdGljVDRabzB0bnVPazdIcHYvaXM0d2c5aDB2WW1ybUlaUzNoUW1Q?=
 =?utf-8?B?N1VMSVNEZnJ2Nkc2VzkvR0lRdUFEdlZRcG9hNEluVSt0Q3VpRkdJbk40a2NK?=
 =?utf-8?B?a0kxZk0wbjNBLy8rTE9tVWRXSURnOWdSQmRMOUVuRk5IMm5KTW1uTEJlNitw?=
 =?utf-8?B?OWdLTXZ2SEZUWFlzZnhMMEdGRkhIOU1aZnBDcytHQmdDRXprQ2xUbTlSTS82?=
 =?utf-8?B?RHdrSVRjZTBSWTd3QUwwVU4wVjRKSzNVYjR6UWdGaWZDYWZPV1MvWTEyQjg4?=
 =?utf-8?B?K1M4Unc3bWkxbXNyWUdZL2szdGk4dnUvNmxNVGVsZ1gyckhMNmZrOHZZei8r?=
 =?utf-8?B?MlZRL1BZYTVadjM0b0V6WE5hNXlSd1k5N1dKM1FTMXErNkFHRkdvNFBlbXRK?=
 =?utf-8?B?cTdUWTVyMW0rbVd6QTBZNVN6TGg4Y3lxTlAzWjhZUmdTc0lzS3p5a0ZLN0NV?=
 =?utf-8?B?OGRjTTltL1h1VXA3L0x5WkkxRXBIQU43azhqaVdHRmxZTHZTL0lyMWhXcEMw?=
 =?utf-8?B?ZE9wckF4SnVnMHZIM0ZNanhZclkvQUNxN2xqb281emQxUEs1ajR4SFo1Qy8w?=
 =?utf-8?B?bTFtRkloa0RGQ1B3MjZTQUJ0OVVmK0hqeCt5SWFTVDFrMjYwbWxRZ0xVNGdS?=
 =?utf-8?B?ampMM3hMRnRTUWlOVTNqTGIzVHBEcFpSbG11cHdRK0QyUlVVa2tweitiWUkr?=
 =?utf-8?B?ZFpXdWg3ZVRoeDQzR3dOajVHZGlBYmlXVkhIekVmQ1Fmei9yTGtvTENFWTVC?=
 =?utf-8?B?K0JXS3BUdmw4TEFJRFVYRUdCaVpjNjJ2eUFJc3g4SXdxWGRNRUUzeDdKTzQ2?=
 =?utf-8?B?RVlZRXgxcVQ1aWh1V2QwT0VMMnlJektUdkptNzVqVW05YzFoeVlLWWduSFdy?=
 =?utf-8?B?ZWF0T3hHUzBSYUJxSVhycW1sZmswWnVxUlgyNDhRV2VHQ3I2SWZRQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcb9b23-171d-4d23-bc59-08deffd0346e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 22:04:43.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mDQknKfRvY8Rirc8GoKy46gNvVRfEVUZtGX9mNW4Uey+ZH0NLZVQpA2FRf6lACRQT7BhX9KNsJ8axcJJ54Hbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8707
X-Rspam-User: 
X-Stat-Signature: r891f6uyt9c7heayngqrrs5z8cjo6d65
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21693C0002
X-HE-Tag: 1787349891-178546
X-HE-Meta: U2FsdGVkX1+++xcF8eTTuxwPTbFpS1tieuKSFVF6LTjTkCKw94I8ekNaTbA61rcNll0MuiR0nrAyK43vwas+AfBvi029hYn2bjY8tYh7Hv3z4QTwMjJMfH/CjQnZX3kxVs735gnA3jUwBke85A6xFxfTDg4xQuVGLLZm/vdpfsdjNh/aajj8Kl55j3PlBaSTSjRMMGwIniNfs/h1aWp1L6CZhUYgmfuNFIvkmurI7HQqIrquTfE7757Z2HkH4OTRGcuyr1BToVB4/Wl1SxKd7azIsPvsu+5lf0/yUt+qJg5NjXL9ARriQmMjAV/1V3X4GhPCSBJFIsKj2x+tCZl9qVML9j7zaGIJb1TJsh330x9tWfTW0RaC04pNKuIM/cGxPCUtgnq3T3RYt1/McCeeoD2sJmfXt+RxjLlaL3r5W5HWq0Qsim0hFTjN4RzgHlsWMGwmf4YY944xrQHcxFgKTDVszl+GOr6cNSv/JZs3ySEgDl4DiuYPhTa/19jvqBS3yWV/tusDrexrkA+qrIkUEL3nKu40C3vrfovEoEzTi/e1brJK4GB3AEI8t0vIt/LCl1CZZTh1ssFnDtUcXzvrIfV2kiz8s338uRzf7mmrDXPYKayG9aGfQCd00zdL1ONNW7MAXqGFfJnXncYlYUUcFMzyRCbRyJ/QWf38z2nz30NXpnztfG3zPNf91yriUnwNHNddEsIOfznS5JdcUZS6s1A9GImmUHCQo1DUdFCgjKr6q+fBAsqhpyUaUvzNyKlWIpXXtlrPGkPT1jOGIMMyvh/D01xtOKu/vcWeF8uHqRJ2cicBt9JX6pYMO8V3A7D9DSG+Mq9fEIKW3QiVV11/Q0N+/Wy2jgZ/h/Eifzos38L4qmq/DKJs8+8k8YDI6cduYYBpiHY/y34mzMk3uT7rqS27QsT2VXapuPC7WeQBiUwYcxEr5STEaFG27SUwpdzcA3W0gSze+E5fuVvJa9W
 hxEI3lQ5
 /vh2Zd+btIibtP3S3F+oqC2z8dvZ+U/gh3rQT3lMfj5kvorHVR5KpXnpieaETEzOXA4lfr4SvdXKL+9ebuKlk3raGSRhulcqLAB3PGqlZ//xCaclerEL5goINcTE5sur7HQaD3PwqKoFiPFKAe+/TWrngN69Xq0rw+CuTJmPpd6HWUptOM7Ee0yydXDlRIr8WobZSTtWONfTXxg1qdLBa3lv9+vbvKQHHwl0eFI6J/3yt4UoCUFZKpwnS81CxCILT0XxaPv81/Coo4dvHvvV8yYFGKjB+5WMCfdqPsjdbuGSbQ4in09YX5gghUN2kkXyQoqGd1PqASe2Pyirw/sQhVtIBIAzcEU8Ct+oKx3WnMbSWKkBE0YciZDK3sMCXpR0rM5zyY+eXb+F6ga8u51nbykRGBLU2512kw+21/J+Od1rx6jyHcu5IKSKEd86SA4LKaDFrvHdxcf70byEgeNzZlhaOuL7AxRroTw8fCfJ9S4HUo3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 10:38 AM, Rik van Riel wrote:
> On Wed, 2026-08-12 at 15:23 +0200, David Hildenbrand (Arm) wrote:
>> On 8/12/26 15:02, Rik van Riel wrote:
...
> 
> Thinking about it some more, we are marking the 
> folio dirty before (potentially long before) a write
> is actually done.
> 
> Doesn't that give the flushing code time to clean
> the page (by writing out content identical to what
> is already on disk) before the actual dirtying of
> the memory, through e.g. PTRACE_POKE is done?
> 
> Does the dirtying of folios and/or pages need to
> be done when they are actually being written to,
> and not at GUP time?
> 
> It looks like __access_remote_vm() already does
> that dirtying, as do most of the other places
> that use GUP with FOLL_WRITE.
> 
> A number of places use unpin_user_pages_dirty(_lock)
> to get the pages marked dirty at unpin time, after
> the data has been written into the pages.
> 
> However, there seem to be some places in the
> kernel that are not marking pages dirty when
> they write after GUP with FOLL_WRITE.
> 
> I suppose we need to fix those, given how
> sometimes they can pin pages for a long time,
> and do multiple writes over a long period of
> time?
> 
> I'm combing through the tree now to find those
> places.
> 
> This raises the question whether we want to
> call mark_folio_dirty() at all from inside
> GUP.
> 

Hi Rik,

You have delved too deep, and now uncovered something that's been
a problem for the whole time. :)

Specifically, "no, GUP should not be setting folios nor pages
dirty", because that generally needs to be done as part of a filesystem
coordinated set of steps. If the page is dirty, and the filesystem
didn't expect it to be, that leads to problems.

This is part of the big, remaining set of required fixes, that
launched the creation of pin_user_pages*() and related. Connecting
up the filesystems properly is yet to be done. And until then, this
is a real defect.

thanks,
-- 
John Hubbard



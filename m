Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535B0CD4F3E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 04:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E126B0012; Wed, 19 Nov 2025 23:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5E16B0024; Wed, 19 Nov 2025 23:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3F16B0026; Wed, 19 Nov 2025 23:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1296B0012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:37:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF39E16071B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:37:38 +0000 (UTC)
X-FDA: 84129726996.18.71A776C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	by imf28.hostedemail.com (Postfix) with ESMTP id E1D98C0003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:37:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=umfE+rJH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763613456; a=rsa-sha256;
	cv=pass;
	b=Uo6vLWZR19g2RBRvDHePSaw+TzFVLT01FtK/GoJPdpz1kA3yJmGNPiIIIT9yJE9S/Ttpjf
	7+TwxBL3OAf+73njZslcdyhPiFaaAZOb/DvO9Tsv1S6IiYB1viGORVzFGI2WS+hC1+6C5x
	dk5qa+ThTWhPXYd0HJSPIunpZa85BVI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=umfE+rJH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763613456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oqtx82teQ4T+j4XgB8UvCWiRTIcjVgdsRckNWVpzYVk=;
	b=vKuhIiNGn0cwMCMQtAAGFn4v7QC30HritFU8pcfNGpdD95CDjSnUKHmXiEQYbG69jad9ac
	dcprGQkp6Cz66ya6sz6ByhNJ/Nuy56kXnOemLqa835zFmtFf7nR17Bjph+3frw26BW8OHx
	IUSY4XErtfYJLjOa94KH9Fko13eDElI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+idRfXaewPiZ+3DaneqapHZwwutQ8XK6XrVzGAXY9HaKAGtVXftBjIQJIl+WnL6VfCbywHZ3dxCFxAqPFOQ+ycmceUtlPh8KU1UdAXaryIUF+SCqpiL2xBCWRjbqZNe4Zv4ZrvQvkKJPL3CVk4mlHHBmH+/OTvof944axMujZqMa4cF9ZfpiT5HFGxRMoieeYr9imVyxl4ghzjU3SsFNOKmHVW4xgNR9QhU4w3sYCNdGiXJurKiux+aC/zYLnchzPE+o4pmEkkZ3NqxLL5KvqS/JXVFv83whQoXALsgIjV8ZOYm5FYPfRYHYwATPbXCBvvgZJ4drodqTb5L8zGFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oqtx82teQ4T+j4XgB8UvCWiRTIcjVgdsRckNWVpzYVk=;
 b=ngToVQ+vdVWCDkTuKW6FFTmOovQ5CR4p+HXMkdpdkaiKuyxE8THsQ7qOqyAShADM6ttgDJyChzphzFV0kHZBc3OWBoFIyYHBOce5qjsOvztUtXWpK2/dO1ujdGo9cEdfdscr13++sArtjAIF0/fwB4XtKHcLPRGSueU8R61rlz/UGOXI6ksw5JCj3vzyZ+revtLnoU4+w8wiHLymLA7JpjJvPmInM61oxXqVYin7o5/APpfqMGMagMh6qExhPYJUfnMvW8mTlBinuFnVjANcTpLsvejU57hJTvhk4QkUHi4KJD027mkcjYN3BuwB6BndHtRc5pYMZLOk1ZMsQC4A6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oqtx82teQ4T+j4XgB8UvCWiRTIcjVgdsRckNWVpzYVk=;
 b=umfE+rJH1LCOSO5DZd0+MoYSk6sd27aXrEeNBLg62vfFaw0+LQ7/3DussUOik0bvd/Mxlxh7x5VuKUhNaQNadxDFHmSyeG+NMSmLXDkJBmN3ZjH3dkH3I/4SH0u600TGimYplcSxSIup2/MzGUMCmNNKM1VBYN8USTBxXbbHxQYCKe2NkhTadfpQ19dBmeBpbLjjT2OoxspM2tALpWiaRNEZktzVBx4/Oic32JTIePUxZEsZ0LeE8weWAXvyHgMxVaoz1BwEBBjBu7r8KjBaou34gpg2zEkRspEVKX9QM3B7toFy7UxQ86vAVz8ICp7CDJKFlpm3czMy6Wdww6Awkg==
Received: from SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7)
 by LV8PR12MB9081.namprd12.prod.outlook.com (2603:10b6:408:188::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 04:37:32 +0000
Received: from SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::ea7d:e30d:fd74:c9e2]) by SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::ea7d:e30d:fd74:c9e2%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:37:32 +0000
Message-ID: <29169e99-aff3-4662-a41f-aeb7979ca198@nvidia.com>
Date: Thu, 20 Nov 2025 15:37:25 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] mm/huge_memory: add kernel-doc for
 folio_split_supported()
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-3-ziy@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251120035953.1115736-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0039.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::16) To SA1PR12MB7272.namprd12.prod.outlook.com
 (2603:10b6:806:2b6::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB7272:EE_|LV8PR12MB9081:EE_
X-MS-Office365-Filtering-Correlation-Id: 055cc085-9344-4fc2-2475-08de27ee8503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0tQcWZRWXcwRGFBTjJEdlVOQ3hwdTczMno4amVucTlZeXprTTdlbkZVWGlD?=
 =?utf-8?B?cWo5akxUNTR2V0twWkhqeXI0dDNhMTN4NUZDRnF0L1BjWUdZUW5iSU42Q3Ez?=
 =?utf-8?B?NzFreW45N1M1Mms4Q3VobHFEbFJCRHNvU1dzbnhMeExxb013TkNuRXRvNTNm?=
 =?utf-8?B?MnMzY3ZWMTlLTGJsNlg1aHhLejVCVHlpZHRZMHc4bW9mdWhhRGIxY1R3R0Q3?=
 =?utf-8?B?dXgvN3FpTUloWi8wQkNUMUpsbk5hcFNZcjJsVjlTV1AxSEVvdG1GVE4wa1pk?=
 =?utf-8?B?ek1mTVFNZTBXMndSUFFaNXk4OWtCS3RWaHF2M3pXQzJlcmJRNENON1ZiQ2Uv?=
 =?utf-8?B?QWhxWTUzWTRtcyt3eUlaTXJuTzBja0E5YVRnVXR0UUFlMFJGd1ZrQ3dwWXE2?=
 =?utf-8?B?ZWI0UEorM25jZWducW5qNGRoWTR3TVA2NEVKYnkraHBjclRJWTBCbmwxenBF?=
 =?utf-8?B?c2xYZ205bVN1RHV5T3U4VUlxVnpIU2FBcFU1c1pLQW51eEN5eXBGTUhjWmN4?=
 =?utf-8?B?dUtHYnF1dzZIbnM5dGtReXpQZTFRZWdvVGdEZnpmcm5pMkVpRzZRR0hlc3dP?=
 =?utf-8?B?bXRnd0R2Y055WStocGl4bEloVFAzZ0t4eVNCOU9TRWxHY3VaSzBlQjRsdXVY?=
 =?utf-8?B?REhBVEcyaWRrdnEyenVzSVM0bG5DY0Nhd1ZOOGpYdEJJQk5sWGFya1pwejYz?=
 =?utf-8?B?OG41dFVnZ2RlOXlMMWxmOHhQMlYwc1JoSmIyeExVa2JNYzcwREpMOWcreElz?=
 =?utf-8?B?YnBtaE02bU4xVXVsSzFyR05CQjhMdDZTY3NlRUF0TFRqTzRxMFgzcEQ4QXho?=
 =?utf-8?B?VnExdThtNzFZOVhsc0N6SGZBdVJYOUFWR0VFdW9tVThBaXlLamZldzJnZm0z?=
 =?utf-8?B?LzJ6TFN1VElRaEUrWXlVNU85WUNVY3FTTVFrcFpteHY4NVRqMDFYYWZYNlNq?=
 =?utf-8?B?dnFZQWdIbm9zSytpdThta2dpeVR3NHkzWFh0WW84QTJZTDc4TVNYZ3lwdmZB?=
 =?utf-8?B?SkgySlU1VFpPV0Fqd1R4dzBTWHRuU2JNcDNNWUhxY2N5ekRjbWY3UnVFYWFv?=
 =?utf-8?B?UWVUcTllQTZSNmR0L3RVa3Rtd3VBYXplRDF3dkx0ZmF0TEUzWXRrRy9jWkRq?=
 =?utf-8?B?dDMwdEZVakY3NHRRQzhsNGFBbm13RTRlcWsvOWhXNC9XQ2ZGRHZQdlRkZ2pJ?=
 =?utf-8?B?N3lxUkErM3dXRWdiRGtsanl5emd4M2dJNDIwZnZwRnZWbjV0VTlveTk5MENl?=
 =?utf-8?B?QktKRzFSUEszTnZkWUhZTHQrcU9YYkJRTWFpN1JITzhTRVE4bmxtTjJRR2xv?=
 =?utf-8?B?RFhkdmNQTkh0aytTcks4ZEVOTmdSUjUyK3czY2tTanF5bnRqbjN1K05qeDhh?=
 =?utf-8?B?Vk1ocXQyUEIxREFFVkhPSDNqVnl2UldRcUFNVTNvbHhwL1NrQ21NVll1R09F?=
 =?utf-8?B?a2hQQ2lxRnZ3QW5PZ0VxUW8xNE1VbFRBT3V5STlibFBNdGgweWxBNG5KcGxM?=
 =?utf-8?B?VkIyVmFRZGpTZFZ3OXJrMzdndlA2WDJpK1RWZVRhWUc0cXpzU3hIUHVwN2U3?=
 =?utf-8?B?Tm5SR3VNaUt4OVUxekdBNUhzKzc0TWlCTThSMGZtakpSV0dEdHhoWTk5bmph?=
 =?utf-8?B?dzl2NnRJRldCNnc0ZXorUXlla0hMQVRMYXQ5UTdmUThta0NDUGZ3QU15aUxV?=
 =?utf-8?B?bzlqY1dCd1BzMUhtRmNDM0VnU253OG44cmViNm12TzhWUzFhSS81N1JObmsr?=
 =?utf-8?B?V2lwYTB5OG5qRTkrb3ZkaVhaZ3E1VzU4OEVwNm1IWXpGMWdxakhzQ3NRUTdC?=
 =?utf-8?B?WnExam1NVGFpVmd5WGtpWU8wbWlGeUFqMzVmMWxQaUNZdVZaN3hJSmhIVzY5?=
 =?utf-8?B?NG9yTFpjL0xNaWV1bXdsRTJqVlpwcGN5UDVqZ2JiejdIeGlWUjI3VGoyV1JW?=
 =?utf-8?Q?IxuhAO2ol8XodvzX70CAs58cEpD8eVW4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7272.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckhMSFIrejBDWmd0VGsrUWxteE05OUdXWmZKN1VzdkJ5VlhUelFsTm55Ukgz?=
 =?utf-8?B?NlZrS2FRcmJuajlEZFVVMVdzYlhBSU54aWlQZHlQeVFpcnJZaW84YzEyNUs4?=
 =?utf-8?B?R0NlNExSWXRkUkxsZnJYZVNFaHdONFhKMmgyelJCQWFYV3ZTMlRiYnFEQkxN?=
 =?utf-8?B?WUJUS2FZR09xM0tSejRJb0lWbm01Ni8ybm4wZEZlUmNrczZJL0Yrb1JwZFk2?=
 =?utf-8?B?Tk9pRnlFRzlsbEZLYXFZMWw2QnlWMEkvOFZtL1ZPWXgxenhBU0NRZkk2ZzhF?=
 =?utf-8?B?Q1RpbDkrRHQ2MnFESmExTmxFZ2dPS0R2WlJlT25UY2xmRDFYWmM0aHNFS2Fj?=
 =?utf-8?B?a0VPbVMyeTRaZCt6dmxJZmdZWlZHLzgxOTJxRlFCcnVkOGpianVEU2RYbXM2?=
 =?utf-8?B?QVFQK3ZxdlhTRDBtNE9vSDh1anVkUnB0OTRpVUh1OE5wNmYxclpVTzBVNWNv?=
 =?utf-8?B?Q09CbmE4ckNEWm13eG5ETHJjVWFERk9JaHQ5cWxVd2M0Z0VIb1hYS3JTUC9B?=
 =?utf-8?B?RStxR3JUV3A2UGNiekxPZDg1VHUvSVBkcFJRWkFBUXpNT24vbjNZR1kvcUpW?=
 =?utf-8?B?VDhNZ2drZVcwQlYzN3QxWUpFR0Y0ZVZ5bjVNeTc0UlllRGNsK3RzZVFld3py?=
 =?utf-8?B?UFZ6ZDBLSGdJTXJnOGhobGluOTBPMlo5bW5Lb3p2ZGgvdU9VMmFtbXB4aHp0?=
 =?utf-8?B?blovZ2VxaGtaNWpyOS9ERkd6VXpTWHpLYmRIWWc0c0M0b01aY3I4T3hmSElY?=
 =?utf-8?B?N3g2T0o5MFFNbCtlbjhIb1RCcEtWUDNjWUhtY3N1aC9memx4T0dvdjhheDht?=
 =?utf-8?B?amRKTGpJTjNVNzE5ejhEc3hVd3lEQ1BNcHNneDR4MkwrYVdGT2EwVlV5eVFR?=
 =?utf-8?B?aUQzN0Vmak1EOG5NNUQwSFJYR3Z0NUc1WTg0OTRCL0RKY2RjV2Y4Mmx1ZzBs?=
 =?utf-8?B?KzdoMm1TQ2YxVnZ5dExERVZ2RkdnQXd5VjRkLzNMd0ppaE9tcUhxbXNwNmJO?=
 =?utf-8?B?TlpNc24vYWVJZ3FPdTU1b0lqaE0zajFSclZlK1AzZGlSRFdIKzNaSmVNMFR3?=
 =?utf-8?B?QWZ5Ry9nb3BwMmNweUYreWprYm5SbloxWENoOVB4RVY1c01QdjNBQzRCdjRo?=
 =?utf-8?B?c2JtTEY1T29OTnp6ajdpclBIYUxpcEx6Q25BMEdvWHJuTStNR2VPcE1lL1dO?=
 =?utf-8?B?alNXWDRJTStvdVhuUnZaYkh0czgvcFk4NjVPeTZUL2JuYWhyMDMrS3kyTWV3?=
 =?utf-8?B?MjJpWGtBSmliSk1yRHR1MERZYnI4ZjdGMUJlMVhNUDBjU3FtNHlUV3lsL0M1?=
 =?utf-8?B?d0JCY2lIaUhlRE9kZTRCelIwRld5eGVqRnVhRlhXQXFVU2NnKzJGcmEzVlI2?=
 =?utf-8?B?VE5kbVJONWRJYW1VTmUvUGpBTzFKcUo2eHZhOUkxelpjZzNmMWwwNnVrTTZ0?=
 =?utf-8?B?bEFiYmxZTER3dVNYYXppcFVXVXNFZWhibzRodUNaWG9RaWhPcmJkTlVFT29Y?=
 =?utf-8?B?VG1RcndQanlSU1E5Q3ZJOXFESjhWSDQ0bVFickVWMWowak1laUh3dFVQL2J3?=
 =?utf-8?B?VUhwVUtwbmhBMjZVTm4xcFE1b3A3NzBQc1NQWTVNTGF3YmhyMWZsTlViRTI5?=
 =?utf-8?B?SVlaeDMrbTMvSkhmL1JSeUhyTDBzdTllVm5CdW80UkVwTHVWd3NMSFQwbms0?=
 =?utf-8?B?dVk4QzRISWV1UjkwOFdoandMTy82SnZLeWE4a0F6bVNaWTJHMS94NjFUQkJF?=
 =?utf-8?B?WUprOXhnR0txQUkzVDY2TjV3VGVESU9XdGk1M0c4VDZtSS9ZdEMzbHhtaGIv?=
 =?utf-8?B?cEN0b0FvS25zRS83cG9ha1crWGdma29vUVovQnI2Z1U2UzkwN2U0TlBDQ3g2?=
 =?utf-8?B?M0QxM1B4R0JGR2EzUi9DR1VtV3V0T0VaVEtrS0lLd0Y0aEx2UmcxVHNhb3U2?=
 =?utf-8?B?MmlRKzBaWXBYVGZwem11SUtMQ2J6aGZZMTB5eklyT2F2T1lsb2MvWjVmMDZp?=
 =?utf-8?B?T0RjSGZRNHAzYUFpT1FQMEVpUHVzckkreGFPcFRJMHdjL1dUQU5BUElVOHhF?=
 =?utf-8?B?ak1aMjFWQXBYdGRoNG0vMkdLdlQ4T3gzOVduZ3B3OFhGZGRrMmV6V3FnZktV?=
 =?utf-8?B?cW5jTnAyaThPMkd5eDBBTG9QbXZxQjExWmJSWXkvL0o5VTZhdE1OS3pIZzAy?=
 =?utf-8?Q?8B1vmSvjOTHLeiP/fBPyxQIeVMfmiIhtaDRn+NvKsG2M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055cc085-9344-4fc2-2475-08de27ee8503
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7272.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:37:32.1861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LpPRnmKSEw1zfgd9F+caIKttsMkfZ/scPmuvXdu7fKg+wIitqhEreqIWf3uqplO5QSt+BIXtShEaVT3C80fUiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9081
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E1D98C0003
X-Stat-Signature: 5qmiq1xicsrear8ee5qknm86oprgt667
X-Rspam-User: 
X-HE-Tag: 1763613455-864006
X-HE-Meta: U2FsdGVkX1/4AagS71tlnPqMl4bmnlr6MKnb1TyCGXPo4Y06hxusDpN8ApkQ9OmZ10zn08nbUSM276hZNDXIt2wPWh4A3rDhyk7mJYpS8QtZPhkEr4r6SE7MvSn2mDPAz3DlztDyzM60aVaxFzhGU6IK+HlhaX2Jv+u2P0RX4PLJNw6Gz1N/qXZKBrKWLEqqJw161GPUuC5NRLzxRARd4wdwleLy1JJj/ldGr4/0/QRZNTtnJ8PIReaa/h6DQX6Dp1S6sW0nPV8o86dfIShtTwWyzi3o3Bj7zm5q9cUEfQz7bZA8BoLF1+SLWOd9ZUF+gjUgL+y0XSA31RXwkxTT5Yipf6P9zN40GgbKjFI5yHiYS3b7aEMt3ddVqryLbP/nZjcwpJLpt1/Ro2c5Jwd/30A9OwOHmqrGqFXUI1tRLZGBRLy8KUum6WcLmh5mED8f4ugK7353ZaQ9sLo5aXWgHFdD/QQ8nZ2eqYSowxXNnop8Dkm36hJSg48oUDY1ETjio4FrUSjQm3J7jrvbySvXro2Rb3hdyPPySxrEG27h2tt93C6zPWCD/KV249c+9Zav0iiz6kmgsNM4fBn4V1f3dnm6BeIbAIUoK/f+VEZBjTi2jkpRLABf7mx4bCMG2jVvQ32VjpFHbJU1CAUV88r7LImJft2VULhpCiHhJy/CCGOEsFXDP4N+feQmBljv3110BZnVJpYWqMoWFySm8t0VDnu+9YWs4dM+U3wm71mQfbaGOO3BxhZU6CiLFJojsjfDlxwfw5oCLjc0pmP0NIvhn0KbLi5bkj+RwhqX0INtRj8K/n+tZ0BmdJoTikHl7tgLwjHHuqFKmk++ovJKhDZXcwtHZ9X3939B5rn0BYHvDZLn+UxndLhL+gKak4S0k6iJoVZPDpnlgUUDcHHJUUZvRNuu5bpYUJ5i4tvjtXyNk/yE57Efot4gpPd/rFuEB3RasQlQphDooeWEPYkctq4
 eGJfRlyh
 dtHoWCePIl1Jp2DIagb/7wfg2qRQcty5Z7P/Tuyz+rhjlc94hrqcyTnP5sE+QEyouLYMOpP8qB4QchW9ygg6Eu5SNMREt2Pt+CPndgF5bTrlxgDMYF+H5GidBt5CEcaAbzv5uU+oAKuyF+gK6rRydvCV+1UNweDf8wahMmFvHohi7eYmlTOvlKp6nocdeX7y+adGlGRXn3B4A1kKx5AjtLos+722HDkzpQx0mY/5bz0874rtT4D6JxIWARVJCS0JD09DIm5UYQJ/Gls+HVOJwbzHvlc8xFVbK7MTTO9J+9lErcK43bKIfL6hf2aEJgRXOD0etodTKVBuycIYxK3olDKkxKTVRFoH88m3QtnK6k+s4ZUP/ZZi2hrykIP5zjtDJTaRgtnV/9ZHYFmrALqOMZdk125XrvnvjagxRka0H3YrZUe+gKOnZ3w/1TxPSQmWGWzMVzqHTA9PtgGRAfIG1Ih3OerXd6e7DjCzJUk1V6nyuKx73w7AiypVf62HfTTmPkck+VJJarDVTUIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 14:59, Zi Yan wrote:
> It clarifies that folio_split_supported() does not check folio->mapping and
> can dereference it.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index efea42d68157..15e555f1b85d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3688,6 +3688,23 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	return 0;
>  }
>  
> +/**
> + * folio_split_supported() - check if a folio can be split to a given order
> + * @folio: folio to be split
> + * @new_order: the smallest order of the after split folios (since buddy
> + *             allocator like split generates folios with orders from @folio's
> + *             order - 1 to new_order).
> + * @split_type: uniform or non-uniform split
> + * @warns: whether gives warnings or not for the checks in the function
> + *
> + * folio_split_supported() checks if @folio can be split to @new_order using
> + * @split_type method.
> + *
> + * Context: Caller must make sure folio->mapping is not NULL, since the
> + *          function does not check it and can dereference folio->mapping
> + * Return: true - @folio can be split to @new_order, false - @folio cannot be
> + * split
> + */
>  bool folio_split_supported(struct folio *folio, unsigned int new_order,
>  		enum split_type split_type, bool warns)
>  {

Looks good!

Reviewed-by: Balbir Singh <balbirs@nvidia.com>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D0BD14894
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B721A6B0088; Wed,  7 Jan 2026 21:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FE26B0093; Wed,  7 Jan 2026 21:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDAB6B0095; Wed,  7 Jan 2026 21:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3526B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:26:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DCAA1A0554
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:26:05 +0000 (UTC)
X-FDA: 84307206690.04.A90E38B
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FEDC100004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:26:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mNOiaADv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.22 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767839162; a=rsa-sha256;
	cv=pass;
	b=0UUFgqXGKbcBPsVLWmr6JFPv20OvF0MGCB2NW0batTJqfFzEzZu+svsL6MjGAqwXpDFSpA
	gb0hNHLlFdlH5naChgiftoA+vxFoT6ruV9kP7dhCyTLFYho237k4r4Hjbso7LTtCgDNo2h
	ixxSSZP6nVjQ5AyL9rhZe3Gd393Zp5g=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mNOiaADv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.22 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767839162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57DvN6UJIs+CohwGzLLnk1LMEdSLHe8QdRthp2RT118=;
	b=AspTFzg77CcvzxjLNe5StFci1yMgaVgZi/2RY7tIcyxfo2YEErqiNRCEFTrOLov9FJAoct
	EWC3Cus5ZLYhrIKhHv9lwXa2QMaWkCeoxbNW/Z1mIHR+v3xlN4fDjtTYV752LiUVDYcDsB
	vDkbvf6k5q0mZdqJgbhvMPuUUCDh0G8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+cN1qtek+ycQpDmfcQgi4xpGT5F6qGZPviHMtoDZTt9pcfl0OEKbuY5eCL9t+6R+8CJxSAJGAPTi8igsFK0BvT+326OVw97HdM8jHTRDdLMhVmwZ+umWLmreHzYDDt9o/85xJeOnoo9s+4+/3yLfMVe6gIKOMsUC5cZIMNjhPBUKcW8mQSd7ujx6qcazSK1xydgrkmoWC5IabTc/05J4HP39CBNScSRhaXcYpCV6F8RnKf9btOJ+IhvfctbCBLsM5fe9HIkxDHpV4ICQN9bRD5ShhPhd1DHqBwlfbnzgvcP8z3JZ/sEYE0CvP4ZDJ82xbcXgULFIdTfvYVJ6zpWEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57DvN6UJIs+CohwGzLLnk1LMEdSLHe8QdRthp2RT118=;
 b=YpRU5u3nya+v+1yRBHnABEK7fH3b26kuwu+K1K8lbHm8vthgdXO3WwdvUz4n7sYfxlZRHUM7/UthxWr1U1OzICTtd72pCBAmIdETJJSCpaz0RZjkLjI5yfz5AXqgL/3aWgxAX6AOVhWtuwX6OoBeVi9vYXrLIHEmPDQHtYC/l2/AwLVvLeaont/9jrr2BjJfEw2/oZcM+QvZThBRXIyeG3iUZ6OBbHPQbDxp6ONGrGX+PDNJ2kdKl9yp/Oqk2+tASHeV+wnzyhPNw5e1muLwC/FD5O2J614h/bqSUXrLaFmpbnBA4eza3YNvB94Wp3CXKsg9W+Ch6dwbwDv8H7Cqzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57DvN6UJIs+CohwGzLLnk1LMEdSLHe8QdRthp2RT118=;
 b=mNOiaADvap5KJSdhyic/v0DC5vJF10SqQ390OrkuDAZ23nWK9FinMGtouuIp0CV9vavyFIBLEXIfgmpCa/508UUv+m5wCi6MDEBDc/B+nFjHX8HYaCc5rqdnMe2GZvpUsFAkUqTMh/hw6Swz/Y/oYiwqyTDMZjN/q21IhDBfMWPtbZMnKjV4o3XrHnBFK+qw21bBcHgLr09DlScOdKL5jg/K87sE6kxmFXUCAphN5/Uwc/YWTNNOcdVGYjPslzo+DOW84aBPOww0XtgUFDfDOxxZIAx6SH3Q2eWeiNAzTOwOfEh8v7RX5jjSJLqZeIoXn3++CobdJ+VBpkYnow7PcQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 CY1PR12MB9628.namprd12.prod.outlook.com (2603:10b6:930:105::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 02:25:58 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 02:25:56 +0000
Message-ID: <3586d8f1-a25f-4087-a987-162ccd97c25f@nvidia.com>
Date: Thu, 8 Jan 2026 13:25:48 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] Remove device private pages from physical
 address space
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
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <aV6nvCw2ugAbSpFL@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0055.namprd11.prod.outlook.com
 (2603:10b6:a03:80::32) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|CY1PR12MB9628:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cbc8ea3-072b-492d-2909-08de4e5d4127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eU1qNndFZFZvQndMTStIVGJFb0FNejd4NHdVTzJtU1hBQUhJQ1pBNTlMV2tZ?=
 =?utf-8?B?MkVwZC9paEhYK09jYnJPeU42dm8zUkQzT05TNTQ0V0xkNFpPSHV2ak1zL3pZ?=
 =?utf-8?B?Rm1oOGRqWms5QXFvQTh3bE52bU5KYjJQTzc1RElreTM3MCthM3N3d25LSkpq?=
 =?utf-8?B?cFFPMUtjd3VGdngrQUhwemREZjg5eTJPUWsyemZ4b3RJM3E1SEwyN21wUmNp?=
 =?utf-8?B?akZwUXhNVlpMbkd5dXhJQVJTWUFiSUFxeGlidTlMYVpmUkNHcnU2S1B4Mkt5?=
 =?utf-8?B?eWxFRFZOSm1Yc1I2akFvcnBIVW83NE9ZR2Qyb1duSVBraXNwWW1kSXVBa3lm?=
 =?utf-8?B?d014azJkelFQdTBXOEFoaVp2UU1rRWdVVkhvQlNJb0QvZEpENU9lQUFNQzg1?=
 =?utf-8?B?a05mb0RPMTlhWmFqWXM1VmV0MG4rTWEzSkFOYTlrMUhvdHI1L01aODRoeXc5?=
 =?utf-8?B?dS9kbTA3dW5aZm5TektIVmdHdXl0QTZoZG4wWWNuZTRoSEpzNzhrK3NXYVl4?=
 =?utf-8?B?U2JRVmxsRmRodnczbU1GbVUrWURLU25EMklWL0oxMnF4NWRtYlV2QlloQlA5?=
 =?utf-8?B?UHlmYVZTU3ZwWWt6bG1MdldWTmJEalZJRGJXSGF4em1iTFFrbFl3UC9hdmVa?=
 =?utf-8?B?UlRvUWgzbXY2M2J3UWc1eW1ucjVadmlnNDlWTmM3S0IrQ2VxUFpsREhJNHlF?=
 =?utf-8?B?RjFpVFVYc1lBemxQelZnaEVyRjBqYWF1MlR5S0FkVzlpenBocmZ2eEIxWUc3?=
 =?utf-8?B?blV0a3hZYzFXWFgxRnljdWNXcVF2K1JKckVlSFJOUFRoVnpyMlBrek5zZ2Ur?=
 =?utf-8?B?V0k1RlBlOGZZMTQrMzU1MTdIZTYzZC96TXlSb1N2bXh2Mll4UjJWYUZtSExi?=
 =?utf-8?B?VkpUMXgzbTEzdUw2dlRpK21LdjBpaGt2K3JTdk9Jd1REQjNoUnVTMVRoVVNG?=
 =?utf-8?B?bFBHUjI0UDFiMHR1aG9VODlENmNZVDRkOWpXa2gwSldLajBiQUhJRzFtV2Np?=
 =?utf-8?B?Z0xkNmFIRGE2RFR1MklkQStLaUI0QXFJck1mZHllbHFaUnAxTTI4QTJTSHQy?=
 =?utf-8?B?VHVqYlhiQlkrWXhNR2hhUlp4VEhkTW1rVm5XV2cwaHJoS2s1dk1MdTdQOVdj?=
 =?utf-8?B?cGQvYm5RV29ES0xYeUpLWHZxNWRyUjhvcG1qSnYxWGVremtZU203UXA1Umho?=
 =?utf-8?B?NDMzejhxaVNZa1puN3ZUNk9vLzhqS0tVUmZINSs1aDQxRlNHaUJwdWdmdnVn?=
 =?utf-8?B?UnR4V29WTWQ0Y0RUNFFRS2dMOTgvVHlZOEtqYVBIZ1YrZ0JFb3RwZFRRbk9Z?=
 =?utf-8?B?aGlGUHpyc24yUUhzUzVRK2xEZDJqTUxYVUNIR3NKL1QybzdJcWtvTzhhUURW?=
 =?utf-8?B?NHhqRnVIWnZjWXFQTnhrck1pUExtWEpDQ0xBNUJzZmlkWkVrRlkzMlpPNllh?=
 =?utf-8?B?cHZjWjlpcXRwYWR0UXpjU2pjKzdMVFZvbWlhYU1INmtwZ2dJbTM3STBOU3Nh?=
 =?utf-8?B?U2h6MlVmd3NYaCt2YWd4LzJVd3dodW94ZUFjdjA1MnVaYm9Ua1VWbEE3NHlE?=
 =?utf-8?B?TmQ0TWNTbnV1TlExM2RxR3kyMDNQVnVRSWFIajU0dnB5clVPbTR2dGhpTVpK?=
 =?utf-8?B?cG9EOXRGNGtKdmN4WkVKNTY4OUcyY0lVYlJBS25LRjJJbmVKWlJFWWFiUGRx?=
 =?utf-8?B?QWdjVlZyZ1NEaStvNlh0VWN6dzFNVzFKNFVUZFBNN1ZKdmtWQkJXUS9kM1VT?=
 =?utf-8?B?b3N4amVKR1E1SklJOWNXTTlpQnNYSFBjcjBNODZnZ1V6VWxrSmNGcTRDamRN?=
 =?utf-8?B?eHo5dG5UTGw5amR5WHNjNDg1bUQ2Z3FHK1hqeGRMaytWOGc2U0Fia2NmdWVh?=
 =?utf-8?B?KzJXb2M4TEhsdVR0MFpNa1FhU2lsUmh2VnFVMWhBY0FwTVR0MVhpQWFBNVJE?=
 =?utf-8?Q?8pX4/hnrA61co35K2BwEM5LoYuAnDcU0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2ExWnM5NTYrTVhvMi9MeWtKY2xMLzVoT3pITUFBQU5tSHJZUWExMlpWR1NY?=
 =?utf-8?B?alc3VVdGRmZEclFBYTBBVHRxWkRBZHZ6N2RCZTJDTUttSWY0NCtKNGdzeldE?=
 =?utf-8?B?T0lvYkN0eUI0Z2ltMXJPeHdyYUROZDJFRXJpbUw2UTZyM2x4ckNRWnV6LzA0?=
 =?utf-8?B?NXdpdUVybFk0SXEwV2dqR1ZRcUJUVFlFZkpjeFd2bTF3ZVJOVUpPbEkvSTdQ?=
 =?utf-8?B?ZGVQVGgzelNFdnhNanNMb0pvNXlsYTdnZWY1TkJuRWFHejA4c2RRNWJES0lY?=
 =?utf-8?B?Z3FyTHZMUk4yZWU3Smo4bWZtamdYa0pDR3Iza21CU25PWWlMT0RmNjY1bk16?=
 =?utf-8?B?U1EwdmZaMGw1U0FWS29CQ3Erc2ZRM0I3bXg1K2Vta1hHdlllMThWN29TZ0cv?=
 =?utf-8?B?WkMzV1ZnUlZZbnV0cW8vMjE0YWQ5SnhNeTdsb0RjSmxITDJPdjZoeDRncG9y?=
 =?utf-8?B?VHpKS3BaU3BuelJzeC9oY0d4MXhDYk5tTVlvbStsOU1vRlZMV3NQcmp0Ykl6?=
 =?utf-8?B?di90S2JmVGFldExiUE1ycmVFUHlhWGdPaUZoVVVIbHJHVmV5cWZDTVhka3BR?=
 =?utf-8?B?NFNZemxJenhRL1VaWkdVWWNwam1OU0htOVhGS2o3bFNPeXlRY095azl1TmxU?=
 =?utf-8?B?OTQ0UzBxUTVoRFF6VVZhbXh5VVZRZE8xY1dJZlNFS3RQN1U5OHIvK2dPYU1v?=
 =?utf-8?B?b0l0Ui82RUZweGV6QlM1YVF3OWNERE5qTWpxR1JqTEwralNGcFBQZEFyaERx?=
 =?utf-8?B?SHlONy9YMnRSZi9uWi9ZUTN5eFNwYzZPL29XcnUyMGFaQWZsdnlRVFJtM1ZT?=
 =?utf-8?B?YjgyV2toUHFmajkwNCs3dG5nSWdwRzhGcHE5QWpUdWh6V0J2NGdTWHFvVXpV?=
 =?utf-8?B?U2lGc3VjQ2s2VjB0SFdtUDBaUXF5NitwUGF0Q3IxT0xGZkY5VUowSGtIWFV5?=
 =?utf-8?B?N1ArSnNHelhjU3d0Q3FRcldkVTE2VUlIWkVIYmJUK2hRVzhmeXFTSFJzRzF4?=
 =?utf-8?B?QU4xYjZhbisvK2VSem9selY2c1AxdmdHU2IzSWpRTjBwS0Q5b08yK045bmdo?=
 =?utf-8?B?bkc5Y0dUaUU0WUxGT2VIalJvdXk4RDBCV3RWTHNkU3ZHa09OV0oxc3lvZ1Ix?=
 =?utf-8?B?bkd3bXc3VE5ueEo1bzdna3l4aXBPaG5ZY01hYjhxVkJxRXJ6ekFxV2NZZllz?=
 =?utf-8?B?YXRyWEpkMFpnUWwwY1RpYjZibGt2YUZ4aVBzdmRLcDlJdFMzVWdYYnZ3U2dH?=
 =?utf-8?B?M0wzL1B5TFN6WmVJcU9MTm54ay9lUDc0VWp5dTFkZEQwbTRHZ25QSkU2Kytl?=
 =?utf-8?B?Y1ZLR1BKMHUzMXRERnFGTDQ2Z0RmNnE1RXRhZG80SGFWYVZjd3MvTVMxZzI5?=
 =?utf-8?B?aDdVdklVUU1RZ2dlcnVIRndFSFJVOVZxYytBbXl1dFR1VGFzVmR5ZDc4U0pV?=
 =?utf-8?B?VG1RR1BCMURJenlaVDRVSW1pYUovVnNVbHl5eklCZ3ZHSUljNk1rN0ZXL1RS?=
 =?utf-8?B?OW5sV2wxWVcwME5CRkcrV254Z1pTRlM5MXIxQ2VBYzBJenE3VTdXODZEQ3FG?=
 =?utf-8?B?eW52WEFpdERnR2tBN3A4Z1hOUzdRc0wyYlNtVTZvVEE4OVYwQWRyZmNWQmdv?=
 =?utf-8?B?SnkzTC9vc1hURm5UNmgrOW1PZm15bzd2R0RnSFVFVzM1WmhzNm1wNFBBVm4y?=
 =?utf-8?B?aFQrNFR6eUpuZzFEaE1kVWNmTldjQ21EMTVoMVdtS3V1Q2I4L3I0cVVrZ1pC?=
 =?utf-8?B?Y3ZuczBwU0VKZ29CY3FPNWU4Z01RUEl1emMvUGtOM1Y4YkRvVVEzM096N00z?=
 =?utf-8?B?Q2h5Wm9QeHlPcXhPd0lPc3YrUDA2eTIxZ3Q3V1I0THptNjhIdGtRNml3S0VX?=
 =?utf-8?B?WHdXeEtPeDBuVXMvanREbll1M2loV2d5bk5EblYrWUwxbVM5T2o3b1htdmFu?=
 =?utf-8?B?NjRDVmxHdk5nOXBrRGhvN00vcUx1amNmM1JFREFMOTlYbWVKUitiZVNBSUtR?=
 =?utf-8?B?d3MxLzdYOGFMTDVjTmJhbldGSEtoWDJwakwzRmxCV213Y2t3WVJheVFmM2lE?=
 =?utf-8?B?WStDTU1oeW9IVHJnV29kTnVuRXhSaFBaU3hwVG9ISENDOFljMm1tWXFUVzl2?=
 =?utf-8?B?V1J5QW1rUER2WXp4OVN0bzJNblBOemhmTlFJd3dMTjNHUHc0bEcxQnl1ME9u?=
 =?utf-8?B?bHFRalpxV2UvejlrbkZjdWJ2b3E1alJza283b0xMQWVxeUkzWjh1VFY4ZFB0?=
 =?utf-8?B?YjVmandDazczUUhVbnhkU0E5UW80RllHeUhkSG9FdXJSUThmRnVxeXgzYitG?=
 =?utf-8?B?a0ZBald5Y1FHeDd5MEIzWjJxb0p5bjFvbWdmZUE5clM1enU0RFpLdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbc8ea3-072b-492d-2909-08de4e5d4127
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 02:25:56.7007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APmi5EievPiGVxE1O8iBqxGa7ALT2g3Huzo0GhfylqQAcxDuKrqeX8xzm7YYzBsRMmNPNTSxIDfg5Gu7bwPJUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9628
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FEDC100004
X-Stat-Signature: 45i361f49yr944jaa9ysn8wfa48nm7sd
X-HE-Tag: 1767839162-21335
X-HE-Meta: U2FsdGVkX18clXSGyEJGLgZiLonMAGJQv+tRA6HQ8j+u7qw2V+gzS0wB9nwAwNrRxHXQsbvsyR2aXV7PvEcfx19OTdcVYBaCkaKRlItZdbS7Vj2NY8qaXpww0a8QDuorw9AFMyEzun9OUJXOyEid7Jp0Fs0jXtb0gNgElhf8cshgXZGDoYl+fJ2V/LAd3+Gj/zQyAz7ITzk6w7jiCMrmjnQLoyAzxstt2kmu4bjbKeUU557+2P/v/4bIKCa7CVF78DrBkM0mWc+EvbUdQm4o9KBScBjmQ2hU+E++GB1IY8s1vSkiMeaYf1NF8r5GluFMVjgnmV323orqsRYy10BAUcuUWO4orOWYl8TtNeQJfDhQhDecngDPxvKhGS+otcBHiorZxmeoL6tYoRmd6lC2VH7+dxnuknZax99QpR2DZA45Uk+MY/eTWRS699fddEAF75yCxOuQP0zSkPGBCN2JamZnULHf/Wihg82xCs5gkwjJmcdGl0xoaE7E2iBsMcSaxhzsEPW04p6uY30mVlsKCYTQIwA4dqTJjdFAiC46z7HPIjk3ic+9uy5yPLo6C8E34QqdooqcrElKcNYjlTC73i7x7AEV+OXKUuM3QOzLd3gffmcj8oOg86CZMbSWAVgQt30V8Wk/tNvjlD6IaIu/+4CE57i50lv47KVAkvzjC3NmmozsjUjOU/7kAbkbFXordBWRHurII0klyG63FY+whI/1Oix5UXTR4GokDDhfogKWNfRLOyvY05kHFgOxFzX72G986eMeItJJ/1uqK5dTkilOq8VPg0s2jR1K236Qg9Lew0EB4iwG2fsdzQkS/6YpeHNckgbG27NSFN54mgTMYd3LpsxeIRgaWysbgL2zdcD970hbk/wWMfrdJPT9bz/qk/1Nxlz3iBQ2Uq1qMY9Lwf8TNhDNkln9swiUt+YF8bFrIjWYbSmQ3hniPFYFYb8d9LcNCDJmrqQhvLh1cqZ
 o1O7LkfS
 lC232puLwKolTxScfSCyaWf8caW+ho9zSJOEKl+vOUTMaU49urwCUwM+sR9DvOuBbHkuQ1Kz6O8NpvolV0lQAzjfPjDNhIl8tu4M0yQlXk88nwgPAeDDmoVT7Uj8K4EBnTDdY/xf1xgFiIvTJQstxSnGCSRf10p4lJWmSrst2ioCHN38tecsrl6eCXKckYE1BBnh1+0r0cn6CtlJhV+XOv7DADUjiSw6GMKEQqqDTq4I/lnM8FGXEtc5ee76FpLfVWrS2f4IfdQG2QxAQV3RZOqbMXHTYUhd84phBU4OKgy1hR/tZ+3rd2XHz0Kge4zlATAf1JEvRdwiOu81mKqCljB6kV7jgIvEV9SULyd/XPm6AC8486rZDCyIe48uHzCfPuJqd0yVq6RPs3BBmICs8ABkGWvC7M2oAezY0WLerZqAG+9KiQJp7PsJyLit9pAHJxLL/4nwmomUL0/x+D2IXbEMDoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/1/26 05:36, Matthew Brost wrote:
> 
> Thanks for the series. For some reason Intel's CI couldn't apply this
> series to drm-tip to get results [1]. I'll manually apply this and run all
> our SVM tests and get back you on results + review the changes here. For
> future reference if you want to use our CI system, the series must apply
> to drm-tip, feel free to rebase this series and just send to intel-xe
> list if you want CI 

Thanks, I'll rebase on drm-tip and send to the intel-xe list.

Jordan.

> 
> I was also wondering if Nvidia could help review one our core MM patches
> [2] which is gating enabling 2M device pages too?
> 
> Matt
> 
> [1] https://patchwork.freedesktop.org/series/159738/
> [2] https://patchwork.freedesktop.org/patch/694775/?series=159119&rev=1




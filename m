Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F96D262B1
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 22:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E53E6B0005; Tue, 20 Jan 2026 17:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4938F6B0088; Tue, 20 Jan 2026 17:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315BA6B0089; Tue, 20 Jan 2026 17:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FDFE6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:52:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3537160748
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:52:48 +0000 (UTC)
X-FDA: 84353843616.05.C8A348B
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010053.outbound.protection.outlook.com [52.101.85.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0154940009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:52:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bcS0WjQ4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.85.53 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768949566; a=rsa-sha256;
	cv=pass;
	b=MIUXwgPPGh1Oqjm5MPV4lUTmdsZUoB+DwZGwTM3NF6m0EJ2XF9vtE09wAnRtJv/apOsbTq
	cF/yZfPM2KPSL/i/OnV6e+aF0iQaWnDb1cmY6Mg0onL+gA8qx8MWNvPO6rMjBGupmf/pBa
	l37HXFZxPpnAkduufS0Qu6Yx60mZexM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bcS0WjQ4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.85.53 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768949566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkdCRvRS5do2LXwRxjf9V0NeN7xOg5Sbh76jblZc5go=;
	b=WiYDBOjmKejekJ6daa769g3eUlSkPWbydIl3H/nJd4TNd7yy7YWfUWGzTrPkwkxp/h/ne7
	QLbAKNgwF+ae6G7ag4oVtqh7+fo1/EPJV/1PZyZ32yk8RWzmXOZV5xxaZ3T0nYZB50Xzf8
	8DNuRiAQMa7RpOFWsSxw01ILwhtUmik=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLhfaodTiSVEpABLz9f6/AVw8plI/SHmXl42tGOq8xjC9fNwFj61fLIChyufbYYt1IspiykI8QxGToC/YxboNxhPZb7+5fRtIUSxnX/6lmNbypjFNBbngQ4OTfOsieOp9xRnbdEFZaMy654RkO+9C1m1/6jtq9VKDk5RdCbWc4WY+7QY/cU2TuShHfqsHopBAOxreLp+4n+sPvCJUpToKIsSB5kBsnq+KJR/KBYWo9ouFjYFEwm6ukkH3s03U/d+tZBth+gsNh60TDVHbDKpiy/C1K6NxPsI6wNs4kV6sWD2KoEA5Y5A9uSghFMYNqyCHTjHD7RX4GL0I3DZrFf/fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkdCRvRS5do2LXwRxjf9V0NeN7xOg5Sbh76jblZc5go=;
 b=c4tnrvGg7LgAHJuB0PqVLek17MtJaB//hlu/q9v1AqyOMX2vaToUyXJ6yUPsE7/GHQMnIxOCPCNyApHhKF7Kiod6ErYHOc5Ph74G3EQYBOiWIqwyWQZzB0Jpmq2oteUV93/yLsYI8e6SPPb3FX7lZ2Ypi6RFwoZplCC0pFRa99smX6vB2ZD19ibDLXGVXoUPWCA1mBNdDPXxtnulOrl4bugKBlaQR/o7uDzsBiZuR24BdxerDc+x0TcK5okG3PyoX0Ourl9GAyN6oIgSZfPGk6YMZa9Cd77+FBDQP+4XYtmk6aCM1YluYLpNnKgdUI7sCkcsbXimBCXvgf6ZCph/0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkdCRvRS5do2LXwRxjf9V0NeN7xOg5Sbh76jblZc5go=;
 b=bcS0WjQ4/xhf0woQiQEfFY+YVZRyUXSxsvVz+LM2oPA4z7H1oYGAOEMN/2W6Ut67YsTPnuz01P9GyFskQ7RYFHB22lD2Iq1G7MSwdFQFMVNzcYqthXTR3SgLJ2NXWhMWKnIEemEVUvEYzttKzVpiSgJZk0j1+82ZdS9fKBm0ZZ9I4RGr5t4g5oq9hNB6NHMwANXlFmMf/R+uZuqmIS9TQUl9lB5O+FE5DR4dXZqJcmw8TCwHAQ+NK9WpsSD4RxsQiW/cB82xh7qgd7OMVDXuOpqOvIiwp+K2BXC4iNLvDjGr9f64AlLoIPNO2SMgIEIM1wuzm8BvoXWfN4461+txmg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS0PR12MB9058.namprd12.prod.outlook.com (2603:10b6:8:c6::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Tue, 20 Jan 2026 22:52:38 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 22:52:38 +0000
Message-ID: <09a8d599-4612-4ee6-b71f-f2f356d4a14c@nvidia.com>
Date: Wed, 21 Jan 2026 09:52:29 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] mm/page_vma_mapped: Add flags to
 page_vma_mapped_walk::pfn to track device private pages
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, david@redhat.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-6-jniethe@nvidia.com>
 <FAA66997-D211-4145-A49A-8A21E0FA0376@nvidia.com>
 <e28edba2-889c-4590-ab2c-6ff377c36f05@nvidia.com>
 <4784318E-D6AF-471B-A2E0-8B04EC0A238E@nvidia.com>
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <4784318E-D6AF-471B-A2E0-8B04EC0A238E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:a03:333::28) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS0PR12MB9058:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d52bd0-3a28-4264-bab6-08de58769bfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmFkbUljcjRtclVzKzB3aDVxTDNYMkE2cGtwUjJsREthMVRLS1lYSEpIcjJT?=
 =?utf-8?B?NlNCdkYrNmFiSGxaN3hGM2o0bmxZK0owK1E0UjBwWG82b2FPOVFiV1BKcHpZ?=
 =?utf-8?B?QkVCcXQ5bHgzcHN6T2pSNTFVUWNqbDNvMndIQk1jdCsxcGdTZTVrenhjMzdO?=
 =?utf-8?B?MUh6N1Rxa083VkQ5TTlhcDU2UWZ0R04weW4wQlkraFJLeW9wNlVhY0JzV1Yz?=
 =?utf-8?B?WHBEZklPajYvQ1owY3FaLy9IbEZQTkt1cmpjVjNYeDQrMXBJU2Fyam5DamlB?=
 =?utf-8?B?cmtBeXVuV3QyK1VFZFBxUUpSL3N1enBqY1hKK0hnbUVLUjJId0RkRW0xNzBi?=
 =?utf-8?B?ZGFZL1IvdmNDcUFHUXJyU2hSb2JsNE5sSE9UaFdPVUdaZWsxSFFkQ2FYTFFR?=
 =?utf-8?B?SXAvMkRweHhBRnFkdGEwelI4N2IyLzZ4OVcwRnJrSVA4MDNuTEJZWWkvRTFp?=
 =?utf-8?B?UDEyS1o1Q1ZFYm9nTmN1aUloZVcxalgxRHFUeldxbXFLUndUNUUvUkRvcWFx?=
 =?utf-8?B?dEsvNmNyWW1xRkMzSDlTTzlJZ0tuUlJ6dDcvaE80cURsQlJPdlNkcGd0OEtH?=
 =?utf-8?B?bGRIQkdha25yUVROTFpaMHhQMFZUb0FRaXJVRGJXaGxrR3ZGcTBEN1Q3OWxP?=
 =?utf-8?B?QXRPUlBMNkxJMHVweDFjUlNMSFViQlp3YTVrTDRlVlBWTWNWdzJ6RVhLaUMw?=
 =?utf-8?B?QXl3d2tIc3BXVDZsQzRiV2xOVTV5c3RpUnRLVVh4TE4vWlJCUE81Uml3ZGhm?=
 =?utf-8?B?bkhBTlhJVXQ5Um1IZXNpZUtBdy8vS3d6Zm03cUQ1MklzU3dPckNQanRsc0NT?=
 =?utf-8?B?azlHSDBHaXdWclk1em9BRWNZU0FHSGpYRzR1bGM0d3llbmIxcytmSXhrckFU?=
 =?utf-8?B?UFdRL3NlRHNiVXZha1lBaHdydzBMczlrbTVheGRQckxrRHd3dGQrOXk3blJ4?=
 =?utf-8?B?bEw1bkV1djVnSVBqQnkwTi9oSGpEbUorcTRsbitkUkRTTUFMUmxWZWxZQ2VF?=
 =?utf-8?B?L2VzT3JGblNmR3V2Tk5ISTdJNldPNWxKRjJJSUx1Y1ZwamJleHZhNWFaclUw?=
 =?utf-8?B?bnJraVRKM3VMRnhKNjlsYXVDOVNqRXV3enlSS0FnWDEwZnJ6Q2hsL2lqT2VU?=
 =?utf-8?B?ejBSS1pYd3UxOFBtZ3NWeW05Qkx1b1k4WC90OWkzZ2JBZHNYKzBScmRYd0t4?=
 =?utf-8?B?U0VYUmZwOVZTcVFrNzV3MmZyOEVQZEM4TkNGWVVpWlFYSElwWkZnTG5ibTl6?=
 =?utf-8?B?OGEwSGh2Y0NDeUxWUXpPWHNqRTdrdnpaeWRFdFBwSXVsc0ZpVVMyT1VWSXFl?=
 =?utf-8?B?bm1NcWxhRnU0cEtmSHVBK1VnNTRScURyaTRYVElGTVp0bVRmOWFGOHBEdE1N?=
 =?utf-8?B?U1cwK1NLd2V5dWxRS08zTUZMVnNRMjRmcytoR2xjYnRVSW5WNGZYUktIK3pq?=
 =?utf-8?B?Y0ppQm83eEhpM1lEVDJyUlZodnBqdFhaSWlsRkNlUFFvSERiQ1lqOXpIRnVp?=
 =?utf-8?B?bGxwRjJ4aTZSUDRQKzIzT2Q3cVNwUHFZRzEvb0k5Qzh0bjVvQW9QY1NIalhx?=
 =?utf-8?B?bWJrV2NLZG5JcFkyYTdlZ3VzUVFJcE11RXlERHNYYmw3Z2lSU29mdXNuMG5W?=
 =?utf-8?B?L2xDd0RRRDdvUElwK2dWWWhlSGtLUmJCYzB1YkZFVUFrZ0VYc1R6N0FUb0Y3?=
 =?utf-8?B?bkxWY014L3J6K05rN2h5L0ZrWG9SZ1VCZ2N0b0hCVGdIZldqUFNacVJTb1J1?=
 =?utf-8?B?eitlVEtCS1oyemQyTTRDSlYweHVWTG5WNHV2SktrNnpTQ3J4aTUzKy9XQ0NQ?=
 =?utf-8?B?Ui9INkVkcllFZ0lJVWFDYWpKT202YjhNT1ppQ0I4dnJFMGRjcVlzK1dGN0RG?=
 =?utf-8?B?UlozWm1RKzN2TW4xaDl1VU0yMEw1bDhzY2YwWmVLSzRXbmNCZHlrekJpR1Jk?=
 =?utf-8?B?OGZ5VHVidXdBT3E1NC9URW1jWnZLVDE4OGg3REFEdWovTW5QRlNCQWN4R1da?=
 =?utf-8?B?emhNaHZmUXNkUU9ibEp3R2FTTHk0U2xnR1BtbUhJeXMxQXNMZFIyQk5lQUdJ?=
 =?utf-8?B?bStuOVZUUm15eSsrYmV5OXZDdmp3aUFDRTJJYXVMbkt1ZEZZVDd5dkpYbG1w?=
 =?utf-8?Q?XpU4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODNpbFBPbjkzZ011L0lQeXBvQkZSaDZZeGFXWXhzdEFIaW45YzQ2NDZpNkpX?=
 =?utf-8?B?Yy94Y1V3dnhnK1ArVkdIQ0daYTJ5UnB6UWhwNDE5Zk1yK3Iva01rWk92UW43?=
 =?utf-8?B?ckppeVplZS82a3FtMmpORVdFeER5L2o5dkM4YzV5RFdkNE8yWFAzdGdQaUFN?=
 =?utf-8?B?RFJ3b09OV3VXczN0WnJ5UStsU3JGN2ZnRCs2Rm80TUdBenpFUmwvR0pBbDRh?=
 =?utf-8?B?ZUZYekJ2anZNeU9iOExoTUY0cUgrNmUvaGRlUmFWYjdwR3N4aFUrYklJQ3pq?=
 =?utf-8?B?RmlWam83RTl0amlYbkp5UGxqRHJYWjlaQTVEM29iMW5mK2FPQlBkUlcrdE9K?=
 =?utf-8?B?RmRiUjMxM3RDM3VIL053UEdrLzJNMU13d01PN05oODhBeUQ1ZFhvVjhzUjho?=
 =?utf-8?B?d1dVSHdxelRyVk5xbGxSdHVQRzIzajFuREVQTHYyc2pDVmV4NzFIZnhzaFhQ?=
 =?utf-8?B?WWI0T2V2M0dwU2hXcjZCMThVQXpDWDkzWHJsSmcxcjBJZXczQytkMzdteHJQ?=
 =?utf-8?B?NnN5aExZd2s4clBqczZTcHhkdG5yS2llbUdreklxazV4SnlTemFBaGhqWEsx?=
 =?utf-8?B?cHFFT2g3VHp0dVB5cVJ4UytwZFIyWkIyYUg0OWZzbzQ1dFZiUlgwQ1h1TDZM?=
 =?utf-8?B?TnZhOCtNUU5RdzI1QS9UZnVDQTM5bllzcldqeEk0aEpEdFJmQkZuYkVzalVW?=
 =?utf-8?B?VEtTYWVESjlzWHRZNTBtKytRUlZ4bnNVSCtqd1RiSlZuQlBXaUYzM2FkT1N6?=
 =?utf-8?B?WUhlbW1ta1Vsd3ZJWnhIWityZEhWOHZ0ejZ1d0Q4R0Z4cWFvWU5iTTVnU21I?=
 =?utf-8?B?VnE0QURGMS9XcGs4RnVpL0xNVFZmNUJBNEhOV0xpL1MrRnZrK3dkSTRZMjYr?=
 =?utf-8?B?ZFFTNzZGZ0ZtK2FLVjd2SC9iRHVFV1FtUysxYk9NSURTeFBBZzVjbzA4cE05?=
 =?utf-8?B?Ly83QTN6SGRtT0RFUHVhRWVobGFxQVQyaFFDZGNHTnVTaWIzZlBPU0FBM0JR?=
 =?utf-8?B?dnBBY2RRREFJYXdrU1RLSWFMa0NzczViMG9OYmlwQU1EWFh5UVRJZWR6Tmd2?=
 =?utf-8?B?ZU9NYXdGd0g2TkdTS253TTVyN2lnWE5sRkVlZHVrNkZYWksyVGVuVE55NkhV?=
 =?utf-8?B?QXNYOGlhWU5QT0RIbjZXaHY5TEVocDlEY3JvYUlZVFRZOUNWRVd6U2RQclBz?=
 =?utf-8?B?eVo2dFNiVS8rdDlVaEVsaTdkRG9BWUlJK0pGS3E2b3MwckZXS1dwQ2s0MmZL?=
 =?utf-8?B?YWV3dVd2MlM1RTVnQkUzamJDZlZGd0R1emZDNjB3ZWdoUkNEYWs3b0dEZ1Fs?=
 =?utf-8?B?TUEvZGZTRmNSWk52a2JxV0dIYmw1a2FCOTBYc2tHSW8xMzZ2dGNrM3BlZVh2?=
 =?utf-8?B?SER3Ulhkazc4b0JIN01QWDk2dCtpUUgrem92SG5ybENWN0crT1dqcEVEZXVW?=
 =?utf-8?B?cnk4b1k3Mjg3eUFvSkdEVks4RWNiMG5tTDg0MlJHeW1DbnJCMUwxNSsxSVZ1?=
 =?utf-8?B?dVhCa1BFRm1TNHVHRWdHNGhvVEc0b2g5SUdxZmVhTnpsVmFuZ1lZR0NLOXB1?=
 =?utf-8?B?a2xqR242YU8ydy9tWHZub0ZaQm90cTlsUCtNaXJBNEpFd0YxNFI4RVo2SUdq?=
 =?utf-8?B?Qk12dkRQV3dLd2FxVmRTajdmMWZrQ2QvK21QaHhTU2xjK0JyYlhDb1RCV1Aw?=
 =?utf-8?B?UUNLU0NUeGJkdFVyd2VYOUpyZ1dxaitPVEtuYjFWMUJXR1FvWGQ4UVRYcTZp?=
 =?utf-8?B?OWhKcTJoWmhzcGdTMGF2MXFqNHE4V21aVGlYcXZWN01MWjFGZFk5Vzk2QmpF?=
 =?utf-8?B?dzY5cnl2bStZcXlnWHRpZlhtWXY4WHRycFlzeGhJQ25aSFhRYzNrcVNBK3VW?=
 =?utf-8?B?TXRmT3ZXRlNLTXFKdzlpNUlZNHh6S2dTSXF2L093MVB5WG05cDRoZnB1OHVv?=
 =?utf-8?B?aDg5M2Y4T1R1VjlERm5NZE45S2tFQ2czd25QbVc5ZnArMkFuWC90eUpvWS9q?=
 =?utf-8?B?RlMrYk9hK25xNmpmbzZFN3RjT0dja2s1RjI0R3ByOTBKZEhvbDA0cS9TbzRQ?=
 =?utf-8?B?RllQbVpMdlJ5SGpSLy8rYTc2WGxMZC9PS2V4YVFxWE5KRmhaZmtKSEp4Y0Qy?=
 =?utf-8?B?REQvaFVMTlB4QzlDRGMyanNjb1RRYnNZY1RuNUx5aXZnZFVIT1ZzRWVrdG1z?=
 =?utf-8?B?em9DTU9zMmtpbGFOTTlwM1JwVVVadjJQS2s2Z05acS81NWI1Y0tEY3UxdFVR?=
 =?utf-8?B?L1R2UXppWk1BWHlVRis4TDcyMTBhV203M09neW9CeklhVXRubU1aNXgydHQv?=
 =?utf-8?B?NXJLY3FORVNVaVhpWUgzK29zbjMvV2RaZWlqa0ppUDhvQ3BmVDF4dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d52bd0-3a28-4264-bab6-08de58769bfa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 22:52:38.0798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6SJvfEMRlA/jbIWJXuo9TeP1MeQgQmZ9QuTC5mWfGG3gED4Z6STedNhsXwRzTdOfeYdPfSzBYKfh0ceH2l+Nrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9058
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0154940009
X-Stat-Signature: zaowyifjry4j35equ3o59jju6xnqzu4z
X-Rspam-User: 
X-HE-Tag: 1768949565-442464
X-HE-Meta: U2FsdGVkX1+eB2uShB3zx8S9pOBQVmiiolbShM0Mv4qQIMuh6o6wVBYOnmUqALIyvvky3LGkGQBWFx9D8OFRk7PBxcGCb4sABfQ0Z0nz1896VIdeOcClCqC8xAq14ShH1CFBlJR7WShY2ixEft/mmFg3xSMYB3/LKsKc8iZGG3xC0XTbapdHwOz5j6XdKvhWQxHnENG+Qx30xv/fMemOH+Pc8b3ZCMmLL2OEFCysHry36jumqY46hmS6m4sBgVbnWvXJ6vA+rE1NnYcPdH08Y2u6ks5Y6XZYxSfuHgYIZBUbwlYA4bqLjv+rR9c5DWmHurEIee3CGsOp0tUPCpVTTmEDUTQPaO+bqrldr434aQ9zBJMSefHkhcuw9MmDtEDNX/3X3khQ5UERJKNd44rR9VOwmah9g2VhizUgO9e+56TSutXGQMNdJUyd/yYGD6YeiuLMWrwPpeq76kTkWl702Jt5mFellTPSWLirbL5pouKEiflK5kdw3WE+THojkdEMY2QkBrUxumQ1Nynhdxe7lYb461F+8z+G36SA/tUQqMB45Kz3sMEja+RtrzBX1zX2Bx8O4+pz4PfyKlGhJDmNI2KuxY753W57/7u7LYDI6R9mPftsaYwF3Q3Fx2DcoaXynlQdPb3chD8An1zf70yD8O0vWbdkEUs2CryygP3l5SpelnITmiTBU5U4dmQOcP/0FA3dMStfOCNv6IiETP6j4RqkcfP6lGtpfCRgbZMvfdTilAbfwAMWBEwwmZy/s2byDLAbhHBhXv6uN5r4kSpEe4OXUJ36UvgXKJErTaTSyw6XVuIqfTq1pMqHqOM6zDcSzUkD9hOggA1YL8bWyduvpjW5u3tWu7No9Zi3VQdrrgMv8Cv4gTIPLNvqMa9XtSL3zllhy0/o6e8ngGxok4vjsmItg5TiE99b1cvAdd7XJWS99IWx+aCSAFWa9plHdrro/AgoE+wIA9rw0c3LB3E
 tSCJ8BwC
 mpz1tVdx6zJMocl7YJpZsvsrQUFl+Euxxp7ixjpvhXlmfGxvrbnYlwbdk+ZxTzPPLN2tobIjetJzVm1Z1NsOJc2JYqSgdxA0CSwhzUB0fxGHftXDvROWZi1eraSBrnKmr4H7V/ieT0C9uFxbk0MrN5bmVBg+xegx9Ul/09VI8y+Tqzh3eSmPJE8uvZsp2U9MYQncoLqFQW54KCa9SyvdnVLHLKoV2iDVaBqEi/1qBSOIFI/f+weoZHaPzsnPIgchQwJxv/N7Bs6wfwDD/Ww405VzY741dJ1TFOgpa/n0n2c4fLNYka8K8S8Wm+lkbdqU8FNLiX4vGYockWp2nibtH6Q2cW0To0wfgywmTxH6OTjD13fS9gMfrfaA15dlvjlvFESyWmInS5wN855TqybRETyub46PjZs+7MtlbNefyp1epajndsehFxu93OAHmOEvUBxmBXJUEPnDibjcK/+5BMw1drA/m7PqRQlRA0sSV3ECwUAlC4BK6bfYY2x5Yy+BhU6U7p6z7IMi3JmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 21/1/26 09:49, Zi Yan wrote:
> On 20 Jan 2026, at 17:37, Jordan Niethe wrote:
> 
>> Hi,
>>
>> On 14/1/26 06:44, Zi Yan wrote:
>>> On 7 Jan 2026, at 4:18, Jordan Niethe wrote:
>>>
>>>> A future change will remove device private pages from the physical
>>>> address space. This will mean that device private pages no longer have
>>>> normal PFN and must be handled separately.
>>>>
>>>> Prepare for this by modifying page_vma_mapped_walk::pfn to contain flags
>>>> as well as a PFN. Introduce a PVMW_PFN_DEVICE_PRIVATE flag to indicate
>>>> that a page_vma_mapped_walk::pfn contains a PFN for a device private
>>>> page.
>>>>
>>>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>>> ---
>>>> v1:
>>>>     - Update for HMM huge page support
>>>> v2:
>>>>     - Move adding device_private param to check_pmd() until final patch
>>>> ---
>>>>    include/linux/rmap.h | 30 +++++++++++++++++++++++++++++-
>>>>    mm/page_vma_mapped.c | 13 +++++++------
>>>>    mm/rmap.c            |  4 ++--
>>>>    mm/vmscan.c          |  2 +-
>>>>    4 files changed, 39 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>> index daa92a58585d..57c63b6a8f65 100644
>>>> --- a/include/linux/rmap.h
>>>> +++ b/include/linux/rmap.h
>>>> @@ -939,9 +939,37 @@ struct page_vma_mapped_walk {
>>>>    	unsigned int flags;
>>>>    };
>>>>
>>>> +/* pfn is a device private offset */
>>>> +#define PVMW_PFN_DEVICE_PRIVATE	(1UL << 0)
>>>> +#define PVMW_PFN_SHIFT		1
>>>> +
>>>> +static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
>>>> +{
>>>> +	return (pfn << PVMW_PFN_SHIFT);
>>>> +}
>>>> +
>>>> +static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
>>>> +{
>>>> +	if (folio_is_device_private(folio))
>>>> +		return page_vma_walk_pfn(folio_pfn(folio)) |
>>>> +		       PVMW_PFN_DEVICE_PRIVATE;
>>>> +
>>>> +	return page_vma_walk_pfn(folio_pfn(folio));
>>>> +}
>>>> +
>>>> +static inline struct page *page_vma_walk_pfn_to_page(unsigned long pvmw_pfn)
>>>> +{
>>>> +	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
>>>> +}
>>>> +
>>>> +static inline struct folio *page_vma_walk_pfn_to_folio(unsigned long pvmw_pfn)
>>>> +{
>>>> +	return page_folio(page_vma_walk_pfn_to_page(pvmw_pfn));
>>>> +}
>>>> +
>>>>    #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
>>>>    	struct page_vma_mapped_walk name = {				\
>>>> -		.pfn = folio_pfn(_folio),				\
>>>> +		.pfn = folio_page_vma_walk_pfn(_folio),			\
>>>>    		.nr_pages = folio_nr_pages(_folio),			\
>>>>    		.pgoff = folio_pgoff(_folio),				\
>>>>    		.vma = _vma,						\
>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>> index b38a1d00c971..96c525785d78 100644
>>>> --- a/mm/page_vma_mapped.c
>>>> +++ b/mm/page_vma_mapped.c
>>>> @@ -129,9 +129,9 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>    		pfn = softleaf_to_pfn(entry);
>>>>    	}
>>>>
>>>> -	if ((pfn + pte_nr - 1) < pvmw->pfn)
>>>> +	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>>>
>>> Can you add a helper function for (pvmw->pfn >> PVMW_PFN_SHIFT)? It is impossible
>>> to tell why pfn does not need >> PVMW_PFN_SHIFT.
>>
>> Sure, something like page_vma_walk_pfn_to_offset()?
>>
> 
> Just page_vma_walk_pfn(pvmw)? Since the code is comparing with pfn.

Sure, that works.

Thanks,
Jordan.

> 
> Best Regards,
> Yan, Zi



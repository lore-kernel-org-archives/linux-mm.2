Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98ECE81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE3A6B0088; Mon,  9 Feb 2026 09:45:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B49F6B0089; Mon,  9 Feb 2026 09:45:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F246B00B5; Mon,  9 Feb 2026 09:45:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E74D6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:45:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF27EC08DF
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:45:11 +0000 (UTC)
X-FDA: 84425190822.14.72033C5
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010011.outbound.protection.outlook.com [52.101.201.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94859100005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:45:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sZdKfOZz;
	spf=pass (imf14.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.201.11 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PATAWPUhyTyWC7YwS8LPM2pk2IekMYmU68xJvaN0BE=;
	b=o7tdszE0EOyGEfe3fjgsJgafaj2LFhcLj1yCZI/eDdWTRyhZl4RaPWeJ6uYED4h4wwO5bB
	T1e7XVY8dAA46ooe6RtbhyQbIz+JBk3IpoiBHVxAdQuQMNpoQOHu5T3NT9ltcFCehSR6Hb
	nTM5lJpnYMhgI2/FHHuZHHfB6bPQfC0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sZdKfOZz;
	spf=pass (imf14.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.201.11 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770648309; a=rsa-sha256;
	cv=pass;
	b=h8JPsfEFXjh+mWnL1QrIaLYGLxCzs5rGMywIv4fbQY5tqIj4fLINVn0m0kI7Ll42xc2hax
	sHhI3L1zfsbXkrtjNT1T0VHh9r1TaMc4Ckw74bPNoDCA+oLcSLxvnB19L2IaONTjY9Kup7
	gM00T507OlopR77wROH4HWmCYM3SdVE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Caiyo217Uc8xjdABtA0aLsfScF7+6qFFsa9tSrbIJbrXigL/crzzZR30Hg0FyW/ygXZUk/ggnWRfVzvYBzcwOag07aEK2cQqdLyVUjHTddI8qlrnG4xzHsDuQUB2L4T6Uk4wqTj5L93aGMCSfbyeoo21pA6Ze6U6bmk308qImnH7R4XatshSKtyiuoZbf/xFjTSCN+LAWqdWQC+BUd+cag7o2Svjm0h+pm/GI79gEe56W0wpXFEhQRj+lIUrU3tZFTotSVgHnyxFFm1a4V7GtAQc+BXDz+zrfSHQSPopUCzWspHO9IGueafKRwEZH4bQbMh+dx2WY0ys1+SqyHpqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PATAWPUhyTyWC7YwS8LPM2pk2IekMYmU68xJvaN0BE=;
 b=PA0bT8nS5BY8f7frRiT1WsMLLnQVmUFEAFEyRpP3s1AjWTVl5ZUDIzX8pWQCBPwTq4pR1DguVsB6XMUlNwbaSd9zUp9WqtFECYT/eaebC9tPbT2IBlssAaV2tQBcv14rl+bSJ5HT2SSMl0eGzDAjtLHfrO9VputGftT2bZMB6/aLzQ8h0MIQKI8/c1RmxtHoI3Q5RdkKUcFuNmMpQmbpm92UBRPR+hBt6tjSo93+HuAIYjuH0AvetC4pB1EpFUEKK4E83ux5Jm0SGwC+qs0ao4J2kXbu//K09GOJgk/wtDtvUKrw4VlAYm7x/mLwKsvvs8KYWwA2daDKwTTrTQzOTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PATAWPUhyTyWC7YwS8LPM2pk2IekMYmU68xJvaN0BE=;
 b=sZdKfOZz7FOA8C6iirSotSHqPdrfV1Y8lbTybqYFWI1yc3KAYr+GGAtazDz0NE10cdxsy9gBk0uonNhdzWoMx6/bhl/F8T/puRFxxIOWdd52zczhrougSaEXYbk1T7qCRrQY1GX613uuT6mo/hXY0Lo9ZrU1nGRixVLVjGyssyY=
Received: from IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10)
 by CYYPR12MB8702.namprd12.prod.outlook.com (2603:10b6:930:c8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Mon, 9 Feb
 2026 14:45:04 +0000
Received: from IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2]) by IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 14:45:04 +0000
Message-ID: <410040f0-d7eb-4a35-9e4b-54a3517a5cfe@amd.com>
Date: Mon, 9 Feb 2026 22:44:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] drm/amdkfd: Add batch userptr allocation support
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Felix.Kuehling@amd.com, Philip.Yang@amd.com, Ray.Huang@amd.com,
 alexander.deucher@amd.com, dmitry.osipenko@collabora.com,
 Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
 <da75eadd-865e-41fe-a86b-ed9d9aa45e5a@amd.com>
 <8ba8e4f2-89f2-4968-a291-e36e6fc8ab9b@amd.com>
 <f296a928-1ef6-4201-9326-eab43da79a84@amd.com>
 <38264429-a256-4c2f-bcfd-8a021d9603b2@amd.com>
 <451400e6-bbe0-4186-bae6-1bf64181c378@amd.com>
 <0eaf1785-0f84-45e5-b960-c995c1b1cf1e@amd.com>
 <a31082ab-e0f9-45ea-9a8d-cfdef39fc507@amd.com>
 <648e06d1-b854-466f-bf13-0c36ee2c36a1@amd.com>
 <9c7ab1b2-1a78-43d7-b4a7-5bc561158380@amd.com>
Content-Language: en-US
From: Honglei Huang <honghuan@amd.com>
In-Reply-To: <9c7ab1b2-1a78-43d7-b4a7-5bc561158380@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:4:186::14) To IA1PR12MB6435.namprd12.prod.outlook.com
 (2603:10b6:208:3ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6435:EE_|CYYPR12MB8702:EE_
X-MS-Office365-Filtering-Correlation-Id: 8271c1c9-307a-45d3-b787-08de67e9cfbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|14052099004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RldWUUJWTm1VeHJmTXgxVjJ4R29qb2ZUSjgrTWNqK1dpdktVWmwxaXVab2tZ?=
 =?utf-8?B?YkNEeVdEV3JsTnBvZDlOQ0pnUmUwcTlrbjRMemtQU0pXSkxPcWNGRE5KQmRt?=
 =?utf-8?B?T2xiV2VBOG9MRFJDZS9ROEdlS2l1dUprQXJ0bkY0WWYvM0txOVJsc1Q5WEVG?=
 =?utf-8?B?NWhUVzR1d1c5Y1B2dHQ1UDIzenhYRjJLMXRNYngybnE1TDMrOTRDM3NNZHAv?=
 =?utf-8?B?WHppU2NIRnRtWUd6RDZMeVRHOFUrejVpQU1FTEZjN1RHOVg3dTdnbUhha1dL?=
 =?utf-8?B?VkszdlgxaUY3TDBWSnZXekFuM3lUUUZuV1ZFM09hdEh4MFVWQWZTSFA2OHI3?=
 =?utf-8?B?MjlFcGZEL2MxZVNLM3N1bXhIZWFBejFpM0lXK3Nab1RHMlJnMGVDNWxhUlJB?=
 =?utf-8?B?cDE4SE9ES2VCdXpDZno5bkt3V3pNMkFhZGViQ0N1MHJEdXgzbVcvV1g3bXV3?=
 =?utf-8?B?V1dNSmM0UWF3QUp3U0xnajE5QktOenFEcFVkbTFEL2dkbW81L2ZPMjlZVXZF?=
 =?utf-8?B?STd4SEJWaFp4S0J0ZGR4aHA5NnU3REFzdmNJVm1wSlAwUGthcjhiUnBUbVJF?=
 =?utf-8?B?aTdNQkovM2NqZkhYYUFoU1ZlcHY1K2JEZGFQdXhVL1YvUExQcWFjU3FUK0NC?=
 =?utf-8?B?UGUraXdDajcycU5YWDYwNFpEUlB1dytiWnd2VE1Pdi9HbiszbkN4Z1JVWHdi?=
 =?utf-8?B?cUxEQXVsVkhLZXltQ2ozZXhUOTAvSnVYVUZBMm5VN2tRYjFHNWduWnNLWXFV?=
 =?utf-8?B?UTBtNUdjYUgvK3lnTytGL3BTWVh5ZFhyU05zSHlSelp5Q2Y3WG5WbVFYMFUx?=
 =?utf-8?B?MlJaVXNEMHFCR3E0dmxDSXZPRnJsSC94QzJPTVFRUmlrQ1N4anV6R0l6ZVI1?=
 =?utf-8?B?SFp1RU13Q0FtSVg1UUVkNVY1eW1RcUREWlJnWmM0aGJ5SVQrdzBIM3NhN1ZM?=
 =?utf-8?B?TnFib2kwTVdzZUh2QnoxeVBVYklJTnFnQ0tYMmhDdWRnSVNVcTRJK0JxSmpJ?=
 =?utf-8?B?N0FkdEdwK2IvcHlMZlI5UVpuYjRkNjQyblJ6VS9vS0w3NWMxT2VKcWpXcytq?=
 =?utf-8?B?aUZwYlZqbjU0eGdUNDc2UThia1BsUWdhbDFVVlp5dmFGU0NubXB1R2ltbVhq?=
 =?utf-8?B?SWZ0VWFUaDFsakRzcHFpS3NmUHdnUVdFbXFZYVZib28rVTJoeGpBOThFL1JF?=
 =?utf-8?B?L1B5Zm1NOS9GME5teVFjWU0rMkRaVE1FUEQrY0hTOU0zNUlja2NyYkllTGZl?=
 =?utf-8?B?YXZZRzRCVW8rYWVjYURwVk5uTURzNDVUZ2QzYzN0Y2krQS9SOEFVZk4rVEZj?=
 =?utf-8?B?UjhlOW1kTWNWWlZNeGl6UGpLL2ExU2xxWjhEdTVScVdBZ1dLVkhibFg5akRT?=
 =?utf-8?B?SVl3OWoxWG50RWhSS2xVTXIvODFoQTBlcndaSGhIQzZSZDZuWm45eDlvcXUy?=
 =?utf-8?B?YmpYNXdYeTQ0c2xncExZcVg3M0g4cHltTTljenhZZnZsNGtodTJXZzQ4WWhB?=
 =?utf-8?B?L1VqZlNydFZVTzZQaFpNOUw5dlhSNlZHTEd5MUFxVmpYekQ1NHQzZGpWZENj?=
 =?utf-8?B?SXhRM1N1K0pjZnhJL3JqQVRBeHJpM3JKSy9acnpOWkNWd2pFWmIrRm1MZDdW?=
 =?utf-8?B?ZzZFUTN2L2J6WCt4b0pxMktOR05LY2tRK1VheGEzbVV5bzVHVWNLeEI3TFlo?=
 =?utf-8?B?QmxCdjFFTnhnUDk3WSs2aWtIZ3o1elBuSmJGSnBLMXRvS3NmTis1NlA1TUZM?=
 =?utf-8?B?TlZ5ODBTN3VWUkxXOGhRRTB0dWFpRnBzREsvWTA5bExvWmFSMXovdDY1blRE?=
 =?utf-8?B?azhqa1B2Qzhrb3F2bDVUSHJ2V0xwTDNjQkdwWVBYakdvdEVMSmduMDhRelRS?=
 =?utf-8?B?UUZhaHduVVlDbFFQVTRuamZneE1JK3pkZ2lrcks4YWhiZlFscE9qZjJHUHFC?=
 =?utf-8?B?Q0EyZXBoa2JCVjNSWjVZbm5mUzNxcEF2bU9JNWhIOGZkbmxwS0Mwd0VCL3lF?=
 =?utf-8?B?NVZBUmdxZk5mcTgyL2tEWUNGL0RCSnJKMExRUTMzckM4UjdJd2dVbG1jVnZr?=
 =?utf-8?B?SXZrUyszL0xBMkJEeWlZcjZRN1U4YzhvMTN2c3ZqV2VoU3FtYmtLRUpibjlH?=
 =?utf-8?Q?YPd8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6435.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(14052099004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amp1U3ozL0VJM0VrUlRzd1lCV2RWTkpzSmU4UE1VN0VodEdicnkyanh5UnA4?=
 =?utf-8?B?ZXNnRGJkSlIrWFh2cHluNFZqSGJ6SG9oS21TR1plZlB2LzV0QnQzMzk0VnNk?=
 =?utf-8?B?SFJlZ1g3WitYS3NNT3h3WEhWQnZ6V3czNzVQbjBvVHppUEZzSHQ0NVJhc2ZT?=
 =?utf-8?B?MkhXUENWOUVtUCtkZFZaZjFXM0VpdDViTmUrU0QweUI1UnJ2dEhlK2ozekpF?=
 =?utf-8?B?MUYvUGEwRUhDeVdUdk94eXFrR2pnSGRUZ1hlcXJRbDJ1ZUxYMjUzT2VSSjBO?=
 =?utf-8?B?dTNsMlBkRVJ4dGhaRURlYXhwSElzaXFMd29icnRSQzBPVGdXYmVCN2RzNVp5?=
 =?utf-8?B?TmYycnhoNTFrcktDY1hkOVM4NUNyUVd3UUU3Y1ZqQzJQbjc4aFJuZjczTEVj?=
 =?utf-8?B?NWNaK1NmNlNWb1lnKzZXcnE0a1QvcSsrS0VucnhXNXU1ODVPcTNCRGZRODFr?=
 =?utf-8?B?UWd1VUlNTEZ5Wk9OK25DSmF1MGw4NExuOWZuTmUxRjZDZlF0Y1g0UUxLbnNU?=
 =?utf-8?B?c1BDeEdFMGFab1FNNGhxY0twOTBBSmxOajVkMGQ0eTRUditQZnhJdkEyRG5N?=
 =?utf-8?B?clhQWVFOZTRrMGFZRnV6K0xsVFgyMG41dHk4WGNuOXV4bFVGaC9ZbGhsemYy?=
 =?utf-8?B?VkpaUFc3ZzN6MHdSQytKUFA0ZGtzbW1obUpiMG1VZURXcVdnN3JKRE13ZXQ5?=
 =?utf-8?B?eldBWkdxeEl3SDNBRXd2LzR3S1liK0NBamNYSnpxQXdzVDQ0bFYwOUlQbFpS?=
 =?utf-8?B?VTloMmMzK3pPMmVtOFZGTzZpRFNETjNjSm9ZcVNTa2Y1bDRUZUY4cTd1OGpP?=
 =?utf-8?B?RnZ6ZDFnS09yRm82NkJPQ0RGSXVJQTZJdVFETW9mellJQzNwalAyMUFOazFU?=
 =?utf-8?B?dTVjbjZ1ZUFTYnB3allxdGcrTXdZM0owS1Z5dElSNlRkZFFPNk54U2NsQTUv?=
 =?utf-8?B?K2Z2dXBoSXd6TVRDL2F0Qm5PLzRzZHg0UTBQMVNsNVlrV0NBZXhpTEhjaVh0?=
 =?utf-8?B?bnh3QUV6cS9RcmsrempRZHMxQ3Bqcmd6SWxqVkNlTXRSZ3hKTFkwQ0RaSXhW?=
 =?utf-8?B?d3JxTForOGxFQk10TXZUenhYalVMcDZ3TCt3SVdidTdMaUhMVEJZV05HOFpY?=
 =?utf-8?B?cDFoV1NWQVA3akZUbzFoRFloK2hVV1RKVko5Nm5QSWloalZVNUpSYlJ6WjVn?=
 =?utf-8?B?SmMzMk93K2daTVI4M2NwNlJRYzlhcit5ajBhbFJ0SDhva3JEeWhQQ3JlS3Ix?=
 =?utf-8?B?dXhTNnd2YnQyMmQrbDM5UjA0VWdEMWY4MCt3WkJSV2txcm5sd08zSDd4TFp2?=
 =?utf-8?B?MkdDK2IxYzZka1Jmd25KK2Z6Uy9mYkV3blcreExPaUh2bXJZeWVXbTFNNnlB?=
 =?utf-8?B?OWFmc0ZpOEV5MnI4WmU2RzI3T1lVUjQrQVoyT3h5dDVvMUFDYTN2aHRYSG1L?=
 =?utf-8?B?WnJwbTZoRFB4R0VCVWV2V0R4S3pMczl6VERzL25Pdi9mc2lpWUZ0Snc5dWpZ?=
 =?utf-8?B?Rml2WjhNVGw3Q2liY3h4UU5LYVh4UUxUc1JiNVJmaGNaUlBXV285ZjVhVkVQ?=
 =?utf-8?B?Q1JjVDNyejAwWW1vV2h0Mm1LamtDU2FoZ21oRTBLSXhYYVFUY3h1cUlqVy9G?=
 =?utf-8?B?OE91cU1ldllsMnFJZTVBNkoyM0lhVTlyMjl3emFzV3hLM05EQ2pwOVhvUm9n?=
 =?utf-8?B?NWhKQi8yeUtMcTNIK1JLRG04TSszOWpTeTZwU0xvejM4UjNHTFNSOVBiTkpP?=
 =?utf-8?B?anFrSkgyL2hUcHQvdE92ZnJjOUFkSkFJTDVoYjM1bHNqWVlvV0w0OEFDYktw?=
 =?utf-8?B?WC9wMGVtWUkrNlkwQjVzVm1MK1pXR202SjBNUk0xVVFza1RhNUNRczdaRmkw?=
 =?utf-8?B?R29BQ2tOa2wxanhvQ0NJcTFEdDg4MElGZG9kYjBoR1FIenBJQkYvS2dIdnhH?=
 =?utf-8?B?Ynl0aVc4MnZnUlc2R2cyOURJV3RGcktBU3ZUVHhoNFl6YTd5akVnN0NDRUt2?=
 =?utf-8?B?RWp3RjVRSUpmMzZxQnRQVW8yTWtpMStMaDhxak1jTFNlNTRtMjFCMUdNUlNj?=
 =?utf-8?B?VkZvVkIvK0gyVVJhM2VrQnUzWUJ4WjF2VHVuUk4yV0lFTDBaQW9UWFNGK3N1?=
 =?utf-8?B?NEljSW10Y2lUWm02aWtFd1FpcmN2QitieWpxSmhNRnVMWkVldGNyam1zaEhI?=
 =?utf-8?B?eDZsZUdzeS92TkRaRm9sdGFuVTZqaWFMdlNsYUtXdmRnMFVwWUhrbW9RY01F?=
 =?utf-8?B?eHlsWDFtVllKcFNqRE5PdjhucStZWlkvd1NqSEs0L0tzOGlubDZxbm8wckpv?=
 =?utf-8?B?SzMyQWVCVVNjZUtVeDhBNHYvcldVbjU2KzQ4Vm5rNTZoUEJRUmJGQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8271c1c9-307a-45d3-b787-08de67e9cfbc
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6435.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 14:45:04.5288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKowL3/VEU0Y+KXfoOA0f+IXzQ3x6FzMlNEkMca0qvurLSb4tM1ovfCbSxWHCWSFGLF/2SxOOtfs0irky4YkIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8702
X-Rspam-User: 
X-Rspamd-Queue-Id: 94859100005
X-Rspamd-Server: rspam07
X-Stat-Signature: 7qafmc9auk9o8dnmw4n1mdg39bhoc3dh
X-HE-Tag: 1770648308-449490
X-HE-Meta: U2FsdGVkX1/RzRWvmwQ/1i/Dhs6IYyr66bwF46NSZuzWuOvUdpj6QLWkvmj20DinM+HdZopscFCUbmYZorMJXNhXZ+Pi26wARiY/Mk4DbP48uCT5ftoRnN6PgSLgIs4m0GNNq79NL4BJ88gvCIH/7zAyhs7V87PONp8pDCmphDag8WydaCm9hxwzu4B6s54KEqp42Ow12ao18kR5CLGGy14ksuc44j25fPpVTQcqburI6Nd0grMXIvkVOpqvFTkar4twqWekj/coXdnT8175krXSIEkA5TK7OEU6SB+ZJg6kvsdYipBWy3aWHuT8Nk/yEcbHV90l/EiUOd/Z4FOwo5GmDfWoYQcmLzIWo/y5Fl7mBayjXR2l7Jyj/hh2gZN9iPrWi5VC0iXMSxCcWIHcH4LbRr2JwBDOdRf6XkkIXCF0UVCNJTP3EU3OEEbtawX1gAnsJb7ie8Dbb+d0e52kIvhlB2KuWcInaYPxoG7yKbdmcgr0DX0lM5vsx0c0eCuF3XPUdUbE5L18BUpH3WfassjPwO7OnqXNesjCXpkh79iKXvMjkAr+19fX6UkmF53GhM9ouSTsUATqipoN+8lq7Gn40vSFxbV02fKYnzWzy3j7rZVO2lbfyoeSOI9upBcD7bxbwTTXKNmHJfcC21vAt8hdX46lSBcG5Js+FfzKodGjuRBVKGtpz9BjPHvdPty++gvzHuYB1okNwiHWpCSk1OLHfV1Xn0a6JQNGQ+7gJnCVGfNUeODxTdUEhblYRPATwQYQl7UkSVqGf2akVZc2DglS4qYfCirBhMTg3P+LCHu45Joud2Y77nFkGtyKgoF+odxUuY7jbhyaMs3xQ0kE2sfCdbFRzfLNDSmv25Gxff+PahaderF7RYfi/B6/3jtrZuVTkhgX5dOXoUjkxr/pCduzP1bOpOxfw6051+z9j19sTIRy7CbXoXwKU382Y4Yo3dfyeBw98CBAu67Z3sg
 UH4OTAyt
 CmhfyLuPJJOhoIO7SGm3DXT3RprJhwRk8SZYO1/3iRSlCv7r11bd2vZmOr5Mo1xW3GOSQpP8YKHkhRNUr1YnJ9nskERAqGvxagzXH55QspAqclG7RtoNn3JKKILxefg6DqFWRcU0Nb9gtY2x0DZbZieL4iRNTWEkpyUBDIfBQITAHoytPg0/+AcuN+a80nuiuAActfNRi3FEHFR5PeROwKgcm1vHqVFXTA9pkrmoJofKi21bR77G6t6gE77GqzDGC721iujY7MKnZLbiZlDqZR24jYnDYEYuY/lmqy0obP1Yr7j9Hs9GuskgpeA7/V60XwsOf/jVB5rzp1niJliVu9Evv8HmKWnZ/N9kw28vdLut2PpsndgaOul0VgQ+ewz2YOxQzgpY0XpXC5hK8KAH5tUbtzCI5oQc5rhXGxe+N2zSiPCRld84311iHLOD72ORVuEYMbpMmfWgY+pLGZvZ4GWRXioclxledftXUJBqg03tjllr/QT9CeQ//7yGzNXoq1M31naAzuoV5VFQTSRAmbtLALhF8rzGW/r6TTP+GvHrnTcvg63m6W7ZYVOIjPCBqoQ5bhyFRxc6PD+RghXzmzBc4gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



you said that DRM GPU SVM has the same pattern, but argued
that it is not designed for "batch userptr". However, this distinction
has no technical significance. The core problem is "multiple ranges
under one wide notifier doing per-range hmm_range_fault". Whether
these ranges are dynamically created by GPU page faults or
batch-specified via ioctl, the concurrency safety mechanism is
same.

You said "each hmm_range_fault() can invalidate the other ranges
while faulting them in". Yes, this can happen but this is precisely
the scenario that mem->invalid catches:

   1. hmm_range_fault(A) succeeds
   2. hmm_range_fault(B) triggers reclaim → A's pages swapped out
      → MMU notifier callback:
        mutex_lock(notifier_lock)
          range_A->valid = false
          mem->invalid++
        mutex_unlock(notifier_lock)
   3. hmm_range_fault(B) completes
   4. Commit phase:
        mutex_lock(notifier_lock)
          mem->invalid != saved_invalid
          → return -EAGAIN, retry entire batch
        mutex_unlock(notifier_lock)

  invalid pages are never committed.

Regards,
Honglei


On 2026/2/9 22:25, Christian König wrote:
> On 2/9/26 15:16, Honglei Huang wrote:
>> The case you described: one hmm_range_fault() invalidating another's
>> seq under the same notifier, is already handled in the implementation.
>>
>>   example: suppose ranges A, B, C share one notifier:
>>
>>    1. hmm_range_fault(A) succeeds, seq_A recorded
>>    2. External invalidation occurs, triggers callback:
>>       mutex_lock(notifier_lock)
>>         → mmu_interval_set_seq()
>>         → range_A->valid = false
>>         → mem->invalid++
>>       mutex_unlock(notifier_lock)
>>    3. hmm_range_fault(B) succeeds
>>    4. Commit phase:
>>       mutex_lock(notifier_lock)
>>         → check mem->invalid != saved_invalid
>>         → return -EAGAIN, retry the entire batch
>>       mutex_unlock(notifier_lock)
>>
>> All concurrent invalidations are caught by the mem->invalid counter.
>> Additionally, amdgpu_ttm_tt_get_user_pages_done() in confirm_valid_user_pages_locked
>> performs a per-range mmu_interval_read_retry() as a final safety check.
>>
>> DRM GPU SVM uses the same approach: drm_gpusvm_get_pages() also calls
>> hmm_range_fault() per-range independently there is no array version
>> of hmm_range_fault in DRM GPU SVM either. If you consider this approach
>> unworkable, then DRM GPU SVM would be unworkable too, yet it has been
>> accepted upstream.
>>
>> The number of batch ranges is controllable. And even if it
>> scales to thousands, DRM GPU SVM faces exactly the same situation:
>> it does not need an array version of hmm_range_fault either, which
>> shows this is a correctness question, not a performance one. For
>> correctness, I believe DRM GPU SVM already demonstrates the approach
>> is ok.
> 
> Well yes, GPU SVM would have exactly the same problems. But that also doesn't have a create bulk userptr interface.
> 
> The implementation is simply not made for this use case, and as far as I know no current upstream implementation is.
> 
>> For performance, I have tested with thousands of ranges present:
>> performance reaches 80%~95% of the native driver, and all OpenCL
>> and ROCr test suites pass with no correctness issues.
> 
> Testing can only falsify a system and not verify it.
> 
>> Here is how DRM GPU SVM handles correctness with multiple ranges
>> under one wide notifier doing per-range hmm_range_fault:
>>
>>    Invalidation: drm_gpusvm_notifier_invalidate()
>>      - Acquires notifier_lock
>>      - Calls mmu_interval_set_seq()
>>      - Iterates affected ranges via driver callback (xe_svm_invalidate)
>>      - Clears has_dma_mapping = false for each affected range (under lock)
>>      - Releases notifier_lock
>>
>>    Fault: drm_gpusvm_get_pages()  (called per-range independently)
>>      - mmu_interval_read_begin() to get seq
>>      - hmm_range_fault() outside lock
>>      - Acquires notifier_lock
>>      - mmu_interval_read_retry() → if stale, release lock and retry
>>      - DMA map pages + set has_dma_mapping = true (under lock)
>>      - Releases notifier_lock
>>
>>    Validation: drm_gpusvm_pages_valid()
>>      - Checks has_dma_mapping flag (under lock), NOT seq
>>
>> If invalidation occurs between two per-range faults, the flag is
>> cleared under lock, and either mmu_interval_read_retry catches it
>> in the current fault, or drm_gpusvm_pages_valid() catches it at
>> validation time. No stale pages are ever committed.
>>
>> KFD batch userptr uses the same three-step pattern:
>>
>>    Invalidation: amdgpu_amdkfd_evict_userptr_batch()
>>      - Acquires notifier_lock
>>      - Calls mmu_interval_set_seq()
>>      - Iterates affected ranges via interval_tree
>>      - Sets range->valid = false for each affected range (under lock)
>>      - Increments mem->invalid (under lock)
>>      - Releases notifier_lock
>>
>>    Fault: update_invalid_user_pages()
>>      - Per-range hmm_range_fault() outside lock
> 
> And here the idea falls apart. Each hmm_range_fault() can invalidate the other ranges while faulting them in.
> 
> That is not fundamentally solveable, but by moving the handling further into hmm_range_fault it makes it much less likely that something goes wrong.
> 
> So once more as long as this still uses this hacky approach I will clearly reject this implementation.
> 
> Regards,
> Christian.
> 
>>      - Acquires notifier_lock
>>      - Checks mem->invalid != saved_invalid → if changed, -EAGAIN retry
>>      - Sets range->valid = true for faulted ranges (under lock)
>>      - Releases notifier_lock
>>
>>    Validation: valid_user_pages_batch()
>>      - Checks range->valid flag
>>      - Calls amdgpu_ttm_tt_get_user_pages_done() (mmu_interval_read_retry)
>>
>> The logic is equivalent as far as I can see.
>>
>> Regards,
>> Honglei
>>
>>
>>
>> On 2026/2/9 21:27, Christian König wrote:
>>> On 2/9/26 14:11, Honglei Huang wrote:
>>>>
>>>> So the drm svm is also a NAK?
>>>>
>>>> These codes have passed local testing, opencl and rocr， I also provided a detailed code path and analysis.
>>>> You only said the conclusion without providing any reasons or evidence. Your statement has no justifiable reasons and is difficult to convince
>>>> so far.
>>>
>>> That sounds like you don't understand what the issue here is, I will try to explain this once more on pseudo-code.
>>>
>>> Page tables are updated without holding a lock, so when you want to grab physical addresses from the then you need to use an opportunistically retry based approach to make sure that the data you got is still valid.
>>>
>>> In other words something like this here is needed:
>>>
>>> retry:
>>>      hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
>>>      hmm_range.hmm_pfns = kvmalloc_array(npages, ...);
>>> ...
>>>      while (true) {
>>>          mmap_read_lock(mm);
>>>          err = hmm_range_fault(&hmm_range);
>>>          mmap_read_unlock(mm);
>>>
>>>          if (err == -EBUSY) {
>>>              if (time_after(jiffies, timeout))
>>>                  break;
>>>
>>>              hmm_range.notifier_seq =
>>>                  mmu_interval_read_begin(notifier);
>>>              continue;
>>>          }
>>>          break;
>>>      }
>>> ...
>>>      for (i = 0, j = 0; i < npages; ++j) {
>>> ...
>>>          dma_map_page(...)
>>> ...
>>>      grab_notifier_lock();
>>>      if (mmu_interval_read_retry(notifier, hmm_range.notifier_seq))
>>>          goto retry;
>>>      restart_queues();
>>>      drop_notifier_lock();
>>> ...
>>>
>>> Now hmm_range.notifier_seq indicates if your DMA addresses are still valid or not after you grabbed the notifier lock.
>>>
>>> The problem is that hmm_range works only on a single range/sequence combination, so when you do multiple calls to hmm_range_fault() for scattered VA is can easily be that one call invalidates the ranges of another call.
>>>
>>> So as long as you only have a few hundred hmm_ranges for your userptrs that kind of works, but it doesn't scale up into the thousands of different VA addresses you get for scattered handling.
>>>
>>> That's why hmm_range_fault needs to be modified to handle an array of VA addresses instead of just a A..B range.
>>>
>>> Regards,
>>> Christian.
>>>
>>>
>>>>
>>>> On 2026/2/9 20:59, Christian König wrote:
>>>>> On 2/9/26 13:52, Honglei Huang wrote:
>>>>>> DRM GPU SVM does use hmm_range_fault(), see drm_gpusvm_get_pages()
>>>>>
>>>>> I'm not sure what you are talking about, drm_gpusvm_get_pages() only supports a single range as well and not scatter gather of VA addresses.
>>>>>
>>>>> As far as I can see that doesn't help the slightest.
>>>>>
>>>>>> My implementation follows the same pattern. The detailed comparison
>>>>>> of invalidation path was provided in the second half of my previous mail.
>>>>>
>>>>> Yeah and as I said that is not very valuable because it doesn't solves the sequence problem.
>>>>>
>>>>> As far as I can see the approach you try here is a clear NAK from my side.
>>>>>
>>>>> Regards,
>>>>> Christian.
>>>>>
>>>>>>
>>>>>> On 2026/2/9 18:16, Christian König wrote:
>>>>>>> On 2/9/26 07:14, Honglei Huang wrote:
>>>>>>>>
>>>>>>>> I've reworked the implementation in v4. The fix is actually inspired
>>>>>>>> by the DRM GPU SVM framework (drivers/gpu/drm/drm_gpusvm.c).
>>>>>>>>
>>>>>>>> DRM GPU SVM uses wide notifiers (recommended 512M or larger) to track
>>>>>>>> multiple user virtual address ranges under a single mmu_interval_notifier,
>>>>>>>> and these ranges can be non-contiguous which is essentially the same
>>>>>>>> problem that batch userptr needs to solve: one BO backed by multiple
>>>>>>>> non-contiguous CPU VA ranges sharing one notifier.
>>>>>>>
>>>>>>> That still doesn't solve the sequencing problem.
>>>>>>>
>>>>>>> As far as I can see you can't use hmm_range_fault with this approach or it would just not be very valuable.
>>>>>>>
>>>>>>> So how should that work with your patch set?
>>>>>>>
>>>>>>> Regards,
>>>>>>> Christian.
>>>>>>>
>>>>>>>>
>>>>>>>> The wide notifier is created in drm_gpusvm_notifier_alloc:
>>>>>>>>       notifier->itree.start = ALIGN_DOWN(fault_addr, gpusvm->notifier_size);
>>>>>>>>       notifier->itree.last = ALIGN(fault_addr + 1, gpusvm->notifier_size) - 1;
>>>>>>>> The Xe driver passes
>>>>>>>>       xe_modparam.svm_notifier_size * SZ_1M in xe_svm_init
>>>>>>>> as the notifier_size, so one notifier can cover many of MB of VA space
>>>>>>>> containing multiple non-contiguous ranges.
>>>>>>>>
>>>>>>>> And DRM GPU SVM solves the per-range validity problem with flag-based
>>>>>>>> validation instead of seq-based validation in:
>>>>>>>>       - drm_gpusvm_pages_valid() checks
>>>>>>>>           flags.has_dma_mapping
>>>>>>>>         not notifier_seq. The comment explicitly states:
>>>>>>>>           "This is akin to a notifier seqno check in the HMM documentation
>>>>>>>>            but due to wider notifiers (i.e., notifiers which span multiple
>>>>>>>>            ranges) this function is required for finer grained checking"
>>>>>>>>       - __drm_gpusvm_unmap_pages() clears
>>>>>>>>           flags.has_dma_mapping = false  under notifier_lock
>>>>>>>>       - drm_gpusvm_get_pages() sets
>>>>>>>>           flags.has_dma_mapping = true  under notifier_lock
>>>>>>>> I adopted the same approach.
>>>>>>>>
>>>>>>>> DRM GPU SVM:
>>>>>>>>       drm_gpusvm_notifier_invalidate()
>>>>>>>>         down_write(&gpusvm->notifier_lock);
>>>>>>>>         mmu_interval_set_seq(mni, cur_seq);
>>>>>>>>         gpusvm->ops->invalidate()
>>>>>>>>           -> xe_svm_invalidate()
>>>>>>>>              drm_gpusvm_for_each_range()
>>>>>>>>                -> __drm_gpusvm_unmap_pages()
>>>>>>>>                   WRITE_ONCE(flags.has_dma_mapping = false);  // clear flag
>>>>>>>>         up_write(&gpusvm->notifier_lock);
>>>>>>>>
>>>>>>>> KFD batch userptr:
>>>>>>>>       amdgpu_amdkfd_evict_userptr_batch()
>>>>>>>>         mutex_lock(&process_info->notifier_lock);
>>>>>>>>         mmu_interval_set_seq(mni, cur_seq);
>>>>>>>>         discard_invalid_ranges()
>>>>>>>>           interval_tree_iter_first/next()
>>>>>>>>             range_info->valid = false;          // clear flag
>>>>>>>>         mutex_unlock(&process_info->notifier_lock);
>>>>>>>>
>>>>>>>> Both implementations:
>>>>>>>>       - Acquire notifier_lock FIRST, before any flag changes
>>>>>>>>       - Call mmu_interval_set_seq() under the lock
>>>>>>>>       - Use interval tree to find affected ranges within the wide notifier
>>>>>>>>       - Mark per-range flag as invalid/valid under the lock
>>>>>>>>
>>>>>>>> The page fault path and final validation path also follow the same
>>>>>>>> pattern as DRM GPU SVM: fault outside the lock, set/check per-range
>>>>>>>> flag under the lock.
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>> Honglei
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2026/2/6 21:56, Christian König wrote:
>>>>>>>>> On 2/6/26 07:25, Honglei Huang wrote:
>>>>>>>>>> From: Honglei Huang <honghuan@amd.com>
>>>>>>>>>>
>>>>>>>>>> Hi all,
>>>>>>>>>>
>>>>>>>>>> This is v3 of the patch series to support allocating multiple non-contiguous
>>>>>>>>>> CPU virtual address ranges that map to a single contiguous GPU virtual address.
>>>>>>>>>>
>>>>>>>>>> v3:
>>>>>>>>>> 1. No new ioctl: Reuses existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU
>>>>>>>>>>         - Adds only one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
>>>>>>>>>
>>>>>>>>> That is most likely not the best approach, but Felix or Philip need to comment here since I don't know such IOCTLs well either.
>>>>>>>>>
>>>>>>>>>>         - When flag is set, mmap_offset field points to range array
>>>>>>>>>>         - Minimal API surface change
>>>>>>>>>
>>>>>>>>> Why range of VA space for each entry?
>>>>>>>>>
>>>>>>>>>> 2. Improved MMU notifier handling:
>>>>>>>>>>         - Single mmu_interval_notifier covering the VA span [va_min, va_max]
>>>>>>>>>>         - Interval tree for efficient lookup of affected ranges during invalidation
>>>>>>>>>>         - Avoids per-range notifier overhead mentioned in v2 review
>>>>>>>>>
>>>>>>>>> That won't work unless you also modify hmm_range_fault() to take multiple VA addresses (or ranges) at the same time.
>>>>>>>>>
>>>>>>>>> The problem is that we must rely on hmm_range.notifier_seq to detect changes to the page tables in question, but that in turn works only if you have one hmm_range structure and not multiple.
>>>>>>>>>
>>>>>>>>> What might work is doing an XOR or CRC over all hmm_range.notifier_seq you have, but that is a bit flaky.
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>> Christian.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> 3. Better code organization: Split into 8 focused patches for easier review
>>>>>>>>>>
>>>>>>>>>> v2:
>>>>>>>>>>         - Each CPU VA range gets its own mmu_interval_notifier for invalidation
>>>>>>>>>>         - All ranges validated together and mapped to contiguous GPU VA
>>>>>>>>>>         - Single kgd_mem object with array of user_range_info structures
>>>>>>>>>>         - Unified eviction/restore path for all ranges in a batch
>>>>>>>>>>
>>>>>>>>>> Current Implementation Approach
>>>>>>>>>> ===============================
>>>>>>>>>>
>>>>>>>>>> This series implements a practical solution within existing kernel constraints:
>>>>>>>>>>
>>>>>>>>>> 1. Single MMU notifier for VA span: Register one notifier covering the
>>>>>>>>>>         entire range from lowest to highest address in the batch
>>>>>>>>>>
>>>>>>>>>> 2. Interval tree filtering: Use interval tree to efficiently identify
>>>>>>>>>>         which specific ranges are affected during invalidation callbacks,
>>>>>>>>>>         avoiding unnecessary processing for unrelated address changes
>>>>>>>>>>
>>>>>>>>>> 3. Unified eviction/restore: All ranges in a batch share eviction and
>>>>>>>>>>         restore paths, maintaining consistency with existing userptr handling
>>>>>>>>>>
>>>>>>>>>> Patch Series Overview
>>>>>>>>>> =====================
>>>>>>>>>>
>>>>>>>>>> Patch 1/8: Add userptr batch allocation UAPI structures
>>>>>>>>>>          - KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
>>>>>>>>>>          - kfd_ioctl_userptr_range and kfd_ioctl_userptr_ranges_data structures
>>>>>>>>>>
>>>>>>>>>> Patch 2/8: Add user_range_info infrastructure to kgd_mem
>>>>>>>>>>          - user_range_info structure for per-range tracking
>>>>>>>>>>          - Fields for batch allocation in kgd_mem
>>>>>>>>>>
>>>>>>>>>> Patch 3/8: Implement interval tree for userptr ranges
>>>>>>>>>>          - Interval tree for efficient range lookup during invalidation
>>>>>>>>>>          - mark_invalid_ranges() function
>>>>>>>>>>
>>>>>>>>>> Patch 4/8: Add batch MMU notifier support
>>>>>>>>>>          - Single notifier for entire VA span
>>>>>>>>>>          - Invalidation callback using interval tree filtering
>>>>>>>>>>
>>>>>>>>>> Patch 5/8: Implement batch userptr page management
>>>>>>>>>>          - get_user_pages_batch() and set_user_pages_batch()
>>>>>>>>>>          - Per-range page array management
>>>>>>>>>>
>>>>>>>>>> Patch 6/8: Add batch allocation function and export API
>>>>>>>>>>          - init_user_pages_batch() main initialization
>>>>>>>>>>          - amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch() entry point
>>>>>>>>>>
>>>>>>>>>> Patch 7/8: Unify userptr cleanup and update paths
>>>>>>>>>>          - Shared eviction/restore handling for batch allocations
>>>>>>>>>>          - Integration with existing userptr validation flows
>>>>>>>>>>
>>>>>>>>>> Patch 8/8: Wire up batch allocation in ioctl handler
>>>>>>>>>>          - Input validation and range array parsing
>>>>>>>>>>          - Integration with existing alloc_memory_of_gpu path
>>>>>>>>>>
>>>>>>>>>> Testing
>>>>>>>>>> =======
>>>>>>>>>>
>>>>>>>>>> - Multiple scattered malloc() allocations (2-4000+ ranges)
>>>>>>>>>> - Various allocation sizes (4KB to 1G+ per range)
>>>>>>>>>> - Memory pressure scenarios and eviction/restore cycles
>>>>>>>>>> - OpenCL CTS and HIP catch tests in KVM guest environment
>>>>>>>>>> - AI workloads: Stable Diffusion, ComfyUI in virtualized environments
>>>>>>>>>> - Small LLM inference (3B-7B models)
>>>>>>>>>> - Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
>>>>>>>>>> - Performance improvement: 2x-2.4x faster than userspace approach
>>>>>>>>>>
>>>>>>>>>> Thank you for your review and feedback.
>>>>>>>>>>
>>>>>>>>>> Best regards,
>>>>>>>>>> Honglei Huang
>>>>>>>>>>
>>>>>>>>>> Honglei Huang (8):
>>>>>>>>>>        drm/amdkfd: Add userptr batch allocation UAPI structures
>>>>>>>>>>        drm/amdkfd: Add user_range_info infrastructure to kgd_mem
>>>>>>>>>>        drm/amdkfd: Implement interval tree for userptr ranges
>>>>>>>>>>        drm/amdkfd: Add batch MMU notifier support
>>>>>>>>>>        drm/amdkfd: Implement batch userptr page management
>>>>>>>>>>        drm/amdkfd: Add batch allocation function and export API
>>>>>>>>>>        drm/amdkfd: Unify userptr cleanup and update paths
>>>>>>>>>>        drm/amdkfd: Wire up batch allocation in ioctl handler
>>>>>>>>>>
>>>>>>>>>>       drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  23 +
>>>>>>>>>>       .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 539 +++++++++++++++++-
>>>>>>>>>>       drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 128 ++++-
>>>>>>>>>>       include/uapi/linux/kfd_ioctl.h                |  31 +-
>>>>>>>>>>       4 files changed, 697 insertions(+), 24 deletions(-)
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 



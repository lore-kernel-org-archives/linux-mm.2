Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA398CFA768
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150336B0029; Fri, 21 Nov 2025 12:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100956B002A; Fri, 21 Nov 2025 12:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC0C6B002B; Fri, 21 Nov 2025 12:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D226F6B0029
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:01:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 784641A05FB
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:01:02 +0000 (UTC)
X-FDA: 84135229164.10.D00E7FE
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010002.outbound.protection.outlook.com [52.101.56.2])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6562F20018
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:00:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ekbz7vpO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763744459; a=rsa-sha256;
	cv=pass;
	b=vWNSwceyZLQ+3VhTYLF1vJRJ1xwSVyt0Xcdj+K/D21eakrxkDIwOpQVFoXqnc8jPZpif0h
	RQx6jJrtBbcVsCA94mLsFz1CiebjIZwSWNv60/lKIv2yX8C4hoNiSICLEhfcqqEM9WmAgD
	Q0WbO3lyyGQd+qZAD5al9quJmmzdoxc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ekbz7vpO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763744459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IX2UVRkVx29X0i4xLHxlZJ6jdiqGwqP5W1ANVlp9FAw=;
	b=gH0+aKdk3Cb27Mx+g1RDwprA4x7BU0bYC2uOXrKDWL/tGeBZl9HsXYVCIdVw40OiXS3/va
	YP15XjmKFNP0LHNWUQFn18lsqgJ5E7pdna1OoNXWPOX1DhxFLuOYw7w9F2ttjCj2dlVqnB
	I8UgOyMCr4teRycNIi3fJUD2K6kqnyU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=COB3R4t5LcvVRAc+gMkRu8bcpWfvYI+5xgPT0edLC/FBDW8dR4tKo9Mb1vL+3e6GMuTdPnWpgUUNZ4PBopb2zD4z/GevAkpXcKRGv0LgQSuRzjMSNGNNV2CD5RJbzja9ZPRCpdsy+1OcAKR+xtyOHTk7ImInpzLtnb493HGIQV3Xad4UpiUcjDhD6577e5QpdUfx4B07DjmBzGMyLLpU5pWqki08sY3eVKQQDkBT9uxjbc++/JyVvYcN/yI/k2c32r0DiCICLc4ez4cRu8KODeqok5mF3+5sjaTppgcJkQ+OLsUmhCf2uOD/rlG412NKaFGcTmo0g6UUQb2IIUImaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IX2UVRkVx29X0i4xLHxlZJ6jdiqGwqP5W1ANVlp9FAw=;
 b=sxuE+DZrFz8uTSt92tFItveJ/UHYhaVlwpUFu7hiaCWhRfJ6WOYRCzLFH/BJ2BOHCQqiMnJvGa8OkK+czrL+QoAuFaiBf/BHOWMxvKkXBWaduXnJpqeN9HFF8+6B/AYQE0gFZAcUz2yomEqAmqrWnxz/VnZzpd8fcnb9bNwRz07mBw+dPBLXUV8UYAit4IP4J/yO4koPYp3KIc8CDrGxzlgEmiwuJf6EWafgpJrhxkBhQzG0xJL8yOilTIl9dflItPCeclY4VDYDfSMhUttaOBTeGModCjf3opJVckRVmtr8T+I+VXFfTDB4h8akQUKbLSwoYamMO3gFbLv/98YI6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX2UVRkVx29X0i4xLHxlZJ6jdiqGwqP5W1ANVlp9FAw=;
 b=Ekbz7vpO70ihz526Jtfa9HG8nBDRAQmjbqoi/yoDympHApsgfR3+A9rbUVKoKTrFm66dFUH80oCc8P5hRWS4ofS043UKbaVzRqtjNbHCVRlGFqYM8aLx142mNt4hujRWOLZCiYcmRBmsz1mVIn4Dpy3rXPLOsLGSraM4T22ytUB6AYKInJDyI2cDhneicUZSrI9coW0uCa0kTdZrQJWRsAkl9s7bspJQX+LnXtRctysaV67LHuCoUdS20xh/LWvirLoqlRUuqoMfcy197upXBsghx/yGi1dEtYCERSTFSHrdE/NkhyJRZrs4gTjiSHg3sYmXF39r+leB8CrliE34sA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7372.namprd12.prod.outlook.com (2603:10b6:806:29b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Fri, 21 Nov
 2025 17:00:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 17:00:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Fri, 21 Nov 2025 12:00:51 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <31B02667-2F69-442B-AD91-6C0A7823BA05@nvidia.com>
In-Reply-To: <20251121085034.d8092d312da961b23c33a22c@linux-foundation.org>
References: <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
 <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
 <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
 <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
 <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
 <20251119005248.ddlbhokgjdmlkhkr@master>
 <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
 <20251121090048.3n25tjhusu45xpoo@master>
 <E7C2F025-4CA1-4739-8661-343D60D82F7C@nvidia.com>
 <20251121085034.d8092d312da961b23c33a22c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:52f::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 137194c6-75cf-4895-d0e6-08de291f88aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEZBUllHYjBBWDNtRzVvTTljTnVuRzVPS213UDZPZnBEejdkeVA3TlZGUDRq?=
 =?utf-8?B?SG1vYkhZTndDU0RnK0pQOVNpN1ZFTy96YzJXbzZCcXloRmVMT3lBaUhrRUdw?=
 =?utf-8?B?cFd6VDJnbnVZNXhSc3hMZ0p3dHV3SU9zQzY2d2lwOFdpc2VDcHhJZGNycUJK?=
 =?utf-8?B?UTNZMlBBRThlODRQaTBxZWcwTmRUdU9BWVYxMVlrSHdHLzZqWG4rNGk1Y2ND?=
 =?utf-8?B?YWxtTWpBMXNOQzNIemxNQkNrbHJha0xBRXYwUys3LzU0WERkem5NVUVQZmNT?=
 =?utf-8?B?QzMxMjljTnJHVlJiVGxCRHVjVHZkTkE4Mm5oSlJjV1k0ckgyb0dZRjVnaEdw?=
 =?utf-8?B?Y2lTVWZxZGFTY0YwaEJGYU1SRzk3UkprQlNlKzl1bXhPZk5CT1U5U2JkUTVr?=
 =?utf-8?B?Ni9PVGhDTDM3WDJvUEtxRHNvRFh3TzE3UVNvTEgvT2orRDJGTWVLbE1zaUdI?=
 =?utf-8?B?SDM4YW4vcklNaEZicDhxMHFoVWJyeDREYTBxRzB6ZW11V2Vqd2J0Qmw3Wm5w?=
 =?utf-8?B?SS9wUlVTR0JFZVJhRDRDZkd2cCs0eWNlUHh0REZLOSswN3h6ZGZxWmZtVzRN?=
 =?utf-8?B?RVFyL2p6S042MHlGR1cyUTlrbVRZOXJJZXBoOXNJRkg5aDJtVzJyWGl4ZEFO?=
 =?utf-8?B?NXBoZGNPU2hTVzJtdUwxSVl5S1UyWllWUmtTd0p3c0RGNngxTHVGWWw5OHRx?=
 =?utf-8?B?RXd3UTNTbDNVUzZRVkdWUGNRSU5DZXBCVnZETXhCRW9wUkZ4YTlHZzZvUkNG?=
 =?utf-8?B?K3VLTlpsdEpyUFI2MklvYW1uaFBpTitBMENuYjVnWFFhT3VmY0JJcm84ZEM4?=
 =?utf-8?B?UzJhdXNheTkwM2IvTml5UTZTQ1ZxcU9XZTVoaHBzSW9WOEZiTGlHZ2JrbWU1?=
 =?utf-8?B?U01Edm8wRGEyaFE2YkdIZkJqVUFaM05Zek01OWpJUXRuUHFQbW40MmI4UkNS?=
 =?utf-8?B?bWR2MGZOTHR6SUpaZnFKTUc4blY2Zkh4NzB2ZDVqUG9OMFVmL3hyVFF2eXFj?=
 =?utf-8?B?VWRqbG9HR3V2aEE5Qk9rbXlxMG5ERTNrdmRsdnBBR3BPajVNNy8weGZSckpj?=
 =?utf-8?B?N2ZDWk9aUTI4TittdVZVVCtGczBtc1pwZzRabzBXZmpnaVhzTytRckJQdkFC?=
 =?utf-8?B?TitYNlFYS0NXWk9DVDl1WHBPTlMxa2UrdStkMDZiZ1czSTlvY2x6VmhKRlZ5?=
 =?utf-8?B?YjRGNkp6L0FlcVhnNjhRQ2dZUDFuR2p6RTQrbjZWMDRTV2RNMDd4R1E4VGp6?=
 =?utf-8?B?RzFkblpLZXNQR3d1UkV4ZXRwK01va3hnZ3p4cUVUT2JOYjhzRXpUMkx4eStO?=
 =?utf-8?B?RkU2cndoRWQ3VzJ0UCsyaEpIN2F2cU16N1ZMS0RCaUxpU0pJUWthRHJpdE5j?=
 =?utf-8?B?N2hRVGRxQ1FDVTNhaTcrNEpNcmpYaklmWS9FWVZFTTNzb3YrRnQ2SkZ0Y0dx?=
 =?utf-8?B?azZOaGNnWklNZDNSL1JWd3VHcUZBNWdFRmdRcjV0WFppR1BrWjdCREE1ZWZj?=
 =?utf-8?B?M0JjV291MHNaRlJtcmNnRlVwS2RkeTAvZitXajFPVlNYc0lEZmsvUk9FQUI2?=
 =?utf-8?B?bGFlRCtuNjJBK2hvbUFubWpxenNpK2RjZGtkeWpaWGFZUVNuNUVMRTVVLzF2?=
 =?utf-8?B?SlZBb2RCVkkvZEVhVXhSMFZxckw1c0w4NzA4bHNjU0gzdTdSTW5QVHJ6Nzlp?=
 =?utf-8?B?Z3ROR09tVC81NEN6L0dsazI0UFhnajlHRHRLMW0wK2NDQjN1RFBKZllPUHJF?=
 =?utf-8?B?MGNSTkMxeHFGZ214RENJbDByWmNhQkswY095R1dzaE9nTkw2c2hHd2tneGUw?=
 =?utf-8?B?Y1ZoVmYyeVBlaWhuRllCTU55L1d2dXhIOHVPdHdaaml2K2lWL251Si9qK2kr?=
 =?utf-8?B?dm5mY3pPdFRMaFhJWWtKRk1sMG9aRVdWMElmS21YUzJSK0JNUnNGNXdGYjVn?=
 =?utf-8?B?SFFyS3B5UCs1cTFydTJZQlR1TzNTWlFhMTF2Y0V1Q1p4ZjRiZzR1ZjNHRU1O?=
 =?utf-8?B?dk1XV21zWmxBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1luQUhZR3BETXlwMThONy9QYnM3dkJZN25INk84b3MyOWR5aS9oSHI2NThs?=
 =?utf-8?B?NjVKVlJLenluT1dDOFFMOFIrSkhSV1BQTW9qaUVLOExJYkoxQWVtc3VieFFk?=
 =?utf-8?B?c05UR2IyRWN1YlpxZ3RUeFV2NjdvbVNHWHhyYmlGWmVoNnhHMUd0Z3NRTndT?=
 =?utf-8?B?Vkw4T3V6dnNPYUhqNW1RdjcvWlZpSnpGVWQ2cktrRGJwWWNsV05tSGw4aDdC?=
 =?utf-8?B?TWZZc1NzanJjSm9uaU9IcWp2aVhXSGJEV0FOREw0cDhlWFZVbGNBWWVSQXAy?=
 =?utf-8?B?T1RFUmdXOHAzdXVaaU83cFhwWFdVOFhvOVNZZHBlZ0lvWXRHTXk5RjY4U08w?=
 =?utf-8?B?aXZ3MjhPanVjZnhnQUVYQUJsdTdmam42U2dpYVdlM1ZKcG9UeU9MblRzWjBT?=
 =?utf-8?B?VzNnVngxMkY4ZzU3WWV1TlJ2a1ZQZU1aam55alZudFFrVWxLdVpzeUJtTTBV?=
 =?utf-8?B?Uk1ZUHJlc3Z3bDFCSHRqZUZXTHVJSTNIZThHb2pEazF4UlBkdjJZL3JHR29o?=
 =?utf-8?B?VU9RQ3Zpa0RjeVlSZ2ZhcG93d0RCOE1EWEJHQTkrM1c0S2ZTZk9JMk5xRk11?=
 =?utf-8?B?ekJON3AxWTk0N21XNVlWeXVSakVCRWlPYVd5ODNwZm9abW9OeUdLamN1QTQy?=
 =?utf-8?B?eWxtMmpRSmxHdGN3Ri9jcU1SSFZqamViTTdSb3NVVW1KNG5KcWg4eEZOY3JF?=
 =?utf-8?B?UVdpcHpwejYvZDNLM3FEcHYwV2wzcmY1QkhrUUxPZjVMT1NKdnk1QlEwakJi?=
 =?utf-8?B?V3ZTVWNnclozaE9lbjZVMEVtV3RObUZEZW1jVWJBY2pQeGN2SHJlaEtpcUJs?=
 =?utf-8?B?LzhqclYzUFlnbjY3dnNPMjFDc2ozeHZkbXdUWmlCSmx2UEJzWWlRb28wM1FM?=
 =?utf-8?B?enArTWs3VHBqWmJZMlJIMVJicnVYcGxCV2tNQjUvbWV3eXZJdllrTmViY212?=
 =?utf-8?B?bXZxZjdTQnNIL1RHZURObTBTdHZPR05yd1ZTemxBL3o2TDluS2lJUTNLbUNo?=
 =?utf-8?B?dy85Zit2WjdRQUJYeHVETGVJQk1TSUM0WXkwenBxV2RyNzcvazMrd1RlS1dZ?=
 =?utf-8?B?cDlocit6TjBuV3lWc2FuTFk4ejlPa0U0dGVwY05xWEd2RXRqRXFaVFBzOTNj?=
 =?utf-8?B?TEdnRlpmMzl2Nk9pVlhINC9JK1cwamg3YmFEb0hhakpicjRWSzVZUmtXOWRr?=
 =?utf-8?B?V0NTa1gwcW5jNWdCanJCa2pWVThoVXhielRXQXpNeG1YeXg2cG5CMnNNVnNE?=
 =?utf-8?B?NGpaOHdSNjdXVjlua2NuOGQ0Q1FtaEpNMzMwTFVUbW82QXgzamI3U0dpWjRE?=
 =?utf-8?B?TFFadDJmQ1QwNXNQcy9lODA0UWJybytwZ3lUUG9rU2FXc3RsTytDMGpwZnhj?=
 =?utf-8?B?OTI0bysrV2N3dGU3cS82Rk9IOGZpcmVoM2pqeW1mOFZCblRGY1ZRVmhzNlI5?=
 =?utf-8?B?VXdBNnNtOVh6RVViZ2kzU1YvTTAwVWdVaEoyYW1JeDIrMVp6YVQxSnNVdDNY?=
 =?utf-8?B?aUZTMGEycmlYTFYzeWg4VFI3U3daNXhWcnluZUlrbVE1eTZQam1adDg3L1Vi?=
 =?utf-8?B?MWxTd25VTS9PQm12TEgyM093K1BiK3J5RzkyZjBHalhTNlV4OUxOc1FkalB6?=
 =?utf-8?B?cFhmOHZaeEE0eFFicmNZUjhhZVdTYTErQkVRSitJMXNWa2tEV3NVR0NBNDgr?=
 =?utf-8?B?dlVXOWd2NUFGbE5uVUMxVlF5UW11blZQNzdsNGtGZ09oTGpJU3FnSUFjejBX?=
 =?utf-8?B?ODZpUC9EeHZjelRadW5kL0FkL0Y2S3Q3MHBWbVR0d0loWWZ0ZG1zeVAxSzZT?=
 =?utf-8?B?bm1rTitOVkYrRVU4TFViWWRONm44blNZMlIzQnc1bTFDTzJPM1cvSGpYYVFr?=
 =?utf-8?B?Vnh1RmhYM3lkbzJsV2laL0R5dEl4UGY5NXlTRW9vM2Y4anF4OElLbUUzWUl1?=
 =?utf-8?B?SFNqeWU4N3ZLMkZYNlVWNWtzcFlVSzJhRWZXL1plWGVTLzFpaG9GZ0ozZ1RE?=
 =?utf-8?B?TkJldmxqeHNQcTQzeU55MXpLY3NvQlJIdjg5YlpiUmpUSzdkNERGQTF4K2hL?=
 =?utf-8?B?NkhoTFhTTG1OclpUUDBvcU1ld2g2bW5qTVFOZ1J6Z1hKR2poOC9NQXl5TWNT?=
 =?utf-8?Q?k+fgWdBGXy580/VxGDwJUOvqA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137194c6-75cf-4895-d0e6-08de291f88aa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 17:00:54.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnBSWNcdA65/rdbdMyXrV00QEDEN7W0pN958EZpmqotyPQ+do0eBYqe9iqzKi2XA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7372
X-Rspamd-Queue-Id: 6562F20018
X-Rspamd-Server: rspam07
X-Stat-Signature: taq8ka1eji4pwzecug44qgm6opwqeust
X-Rspam-User: 
X-HE-Tag: 1763744459-643110
X-HE-Meta: U2FsdGVkX19c0o0vPLXbJtAZtywqPxEXC5HoKXlGpusDyralRVofkVA7ngnw5goazh5YdAcmlr0ta9q8DDTUfvOCMmvXbuMAwyObj1CvcJSYbdNK9g/jcUUb1evg/hSH1PlygU+IuveJhAac+h7qT3nePCVXNNfOLT/dqunVqaoY3aPCAmL1aWcK9MXAzeYxNwFL2tCKUjz/HazYO1/0A7o3FQEXids8MEiQtWC2h59vqcMWv0O9Y3QKLPuoPHhdEzoENf5WPoSnL107xWzBjRdpWq6MClNFLTcAIwUobfNEM5btFRhEW/u9BGlttp6HOP2Sj5KgJpPMeFVWRRimZ+WIBkb9r6Ue4/Ks2PbBEo7xQgxk9EP4pnsXC0FwgUP5vRSxnEKHfdVOmUDGuDIH9BXnv3WsY5EU9VtLI/cSJsma+Lt2rWKhMf8UTQX2WlMTi26m6AFQNY7VpNhgp/+17fAezXrS3QRvEbONjIfA5NRWgbqFE4ZGOR12OOdz7u80lutGkh+2Amf9fIc3CQOqTincD9Ux1cmiScE6eRhFAvhFRjD39K9K+XicGft2u8KAvBIrkui269+gnTYxYdnxoTGkQ4VTl/KBvrgG2izLD7y8kbKclPAFR8Dwsdaof7c9b/3O9E4ifJKmTkzhv6eU1TATQXesrcaXwzGyjdjbMbYmWWqxScT9e8BrYCtg01reLDtyNTqPbSTQ/IXR6BrWA+8fieqm/LSpVPHXYwet9V1LkDYLjPFGTTv6zBaTzaAPG7y0Rfm6H65X0YHajmAaOGe8v12Gw07HtOxVV1/xNw/uq5+VDLK+LE1KmwYT9CP7YZH7UQJykkMsZn7Vou7dFry8yfSFeuViMOd9N923RWbTKkGNZzuVfptIlIzoyITqTgoMJlw3EWAJ8jsilngUFqd1KLxqV14o9EmvJuUXr+B6rwUdusGJbGAJrdAGG4NMjkxvh9QtbXiAE1cbBD7
 fhBgTU52
 G7BeBtKrMYhBKLwakBj4JyMuaRLXVy/owoepDEJxideUWr0tZAx4y9tExxVmwwlFaJONLvyhBBiG4mQXA+dkRt00PSQMcUeT8kbSKykFKXgx+WGFFwNHJuyrS5M+bxKSROAViyv+TOfI5RRK6/jLF5RvsGeZON2Mz6W5q4FCUfhU/RynEgAlWRx1RX7znDHntzw91PhZhpyCQOvqV+TUAJllqEhCpd7nEqhVtOjfEF2RKa3SFS5YlQ+k+izWGKvpGBy/7GHMeSuGjzuUxJcx8rcu8tPuKgNiZFvkC7ZIitZaU+ObfUwrfuiQWf37pGk7/Y/e4V0ZNJ44ksFtF4y59UMbUIjpGBgYkY1X3lHDCvxAlztkEg/o9qsQbF2GBRM8rPFSbsH3/+kEAZa36fk81Y3Ozr2fQlfmPZOZ3aC0xxHzxWc6squ5D+6V8bkTCimMbX/J6ZGK5QpzTVVkSz3sD+98YFkck1m5A6t+31d5oX1kcRfSH5uGsIpJioXcLjQ4bRTOODtP0DcYeCG4Wuw/dSk7EVDQxh7A3LQ100OfBOxG9hf0ExmnNVX2ZVH40tREBetWIyEgBJdzD53w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Nov 2025, at 11:50, Andrew Morton wrote:

> On Fri, 21 Nov 2025 09:59:42 -0500 Zi Yan <ziy@nvidia.com> wrote:
>
>>>
>>> 2. A further cleanup attempt:
>>>
>>>  https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com
>>>
>>> This one is the related mail.
>>>
>>> I proposed one version in
>>>
>>>  http://lkml.kernel.org/r/20251114075703.10434-1-richard.weiyang@gmail.com
>>>
>>> But it is not proper, will do follow up work later.
>>
>> Please refrain from sending more patches related to __folio_split() and its
>> related functions until the above hotfix is merged.
>
> You're referring to
> https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com?

Yes.

>
>> I also have an ongoing
>> cleanup patchset[1] and want to get it in before any other changes.
>
> I remain unclear on the status of this patchset.  Is it considered good
> to upstream or is additional work required?

I am still having a discussion with David Hildenbrand about it and hopefully
get it sorted out soon. The reason is that the above hotfix is good for
backport but future user of folio_split_supported() can still dereference
a NULL folio->mapping unless they check folio->mapping != NULL beforehand.
I would like to avoid that by refactoring folio_split_support().

Wei’s further cleanup patch can come after my refactoring by just moving
a code hunk above.

Best Regards,
Yan, Zi


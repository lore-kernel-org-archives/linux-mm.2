Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9419DCA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 16:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7E18E0006; Sun, 14 Sep 2025 12:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7FD98E0001; Sun, 14 Sep 2025 12:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D472D8E0006; Sun, 14 Sep 2025 12:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC61C8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 12:39:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 781B85A4BE
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 16:39:11 +0000 (UTC)
X-FDA: 83888415702.27.BD6D79C
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011065.outbound.protection.outlook.com [52.101.70.65])
	by imf25.hostedemail.com (Postfix) with ESMTP id C5EC5A0004
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 16:39:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fM9tYPKj;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fM9tYPKj;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf25.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.70.65 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757867948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0ypV0WFIJZ8g1mwT/qZWj9EpyadAr+9hS8qDCMhN7o=;
	b=xmK7L2XVQAs9Ceqpxna7hAe60c2dsY/7K9jCk3zddmsEcxPCqaYwmVDoX21aGFCk/3SUB9
	7CMkwLaU+1h0AimCAD6l/w0i5d+gxAuWB/wmGD5E09rmKqMrNaTLGwv6VTsvp7VXZ+u0a7
	2bcatE5EXQYmzXLjSP0H7GEPHgPWNKU=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757867948; a=rsa-sha256;
	cv=pass;
	b=Bnz2yZ5omVw/ty5hfd03300Okmiyba2Jhy/0o6wEqN5XYwVhXPZJkKdSbFY8fzIwV/hdzD
	k8Hv5l0/0SJGn4GY4iseLWO8uGiHHnvcLZzzWpaRcbzptdA3oXn1ELudbZ9bTi3+OFkZsk
	aQAFHHwP/8GymXQlVT9zW4wjryX4hX8=
ARC-Authentication-Results: i=3;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fM9tYPKj;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fM9tYPKj;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf25.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.70.65 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EZNhlq11kJ8FErnhtkNAbnNVyj4qNX7AWb5pmkWv6QmSoaLCOo/18bjfSDf2InxIXrGu39cFw4W1m79X/NGz8Vnm4LQDyqSUkkHVhTSdK1Hmcaf3oNXmknX+4GX6mM75bn9pnaAR8e0lp8E12rgBvJG24em9ci0VNOD591e+GszOdhV0mVs9Y21xmgnZsSgRRIk+xz+xfDh0dzsoeuRDYS6nwGS6cERp7M7LjbCzKQ8+iZTZHe+LN/kJ6iTdKa8KVXJ5b95yRvVDV+yoOrHHXjyLzv2DdhLt62CYe7g4ISoD9VZyEqW7qK1fXdFYpCEzR8V5du1LWN65tUiOpXaBQw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0ypV0WFIJZ8g1mwT/qZWj9EpyadAr+9hS8qDCMhN7o=;
 b=uLOil+OZYv11AfhgYhyTd7jL6KOJq+iR2urcBXIFQ/+X5XD0YZaaEWtjZq09W1SMUB6aUX+U6EYpSlcIm3Lfzvo23G5avngL2Ln85rYMquar/bDwMzelHHCfei4KoIJECw7PSOLiBDkuy9QZFZJ3IjbpB3elTFnilCJt1e1fdKw31dVwzRoRDzpqk/V5RWR1Hi8md77CQddyB8tevOnNJRf5h84kTjD/48mwyPdh/m+j5Uqg/cCCx7u0eCrox/y0p+86ySTGGyfRve2Ixe4fF7BT0Mp0yEg3i5HXh534pGoisRydhkoApvqpPoosHdUrs24fExOg47kTb+j/R1hiVQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0ypV0WFIJZ8g1mwT/qZWj9EpyadAr+9hS8qDCMhN7o=;
 b=fM9tYPKj2V8qvdL9F8eDb+4KOjsxwesjl0N+ntjajUpFVvKbgjIzypmd886BkqiV6ThF6HXltr3Ql/EtAdsY1LgtWsU7mS3vAALT/gmQLW8yVsMqcoJxCAT9Kx6/V3cmC6gH1LvL8QYJqeVCNkSUJUbWfLQAMK8zqcWf2UR6i2k=
Received: from DU7P250CA0006.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::21)
 by AM0PR08MB5396.eurprd08.prod.outlook.com (2603:10a6:208:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Sun, 14 Sep
 2025 16:39:03 +0000
Received: from DU2PEPF0001E9C3.eurprd03.prod.outlook.com
 (2603:10a6:10:54f:cafe::5a) by DU7P250CA0006.outlook.office365.com
 (2603:10a6:10:54f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.17 via Frontend Transport; Sun,
 14 Sep 2025 16:39:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C3.mail.protection.outlook.com (10.167.8.72) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via
 Frontend Transport; Sun, 14 Sep 2025 16:39:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFc5Gnj1Y71/MaQ4g6uzRjQ2trYBvVw9oy7f6mlh2uJFAZtzPyJJK7FYGqTQRyhkGBnLwnMK148idXtr8g5o19hNJLlxTvw0X4hhq3XjU07WyFjAER0kwtBZTbXwRCrRWC23Ps/2jJPeweYKG8jcX4+wqd3QA90t7TPgcm3yovgC/RAptiticwd1VzhVCWAoD+JiQ4xxHAboTzJczZD9MGipt4Y0ngHExqwcpWZGfVxY0pt7icrWjWnkHINKyosOkhT2/eI3k7AngxN+r6pMGiiAxhjR6BkgG63zLS/rpNj8jhcG2pCbk8+ieDlPjK/halLtyu4dL1RrK27xeLez0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0ypV0WFIJZ8g1mwT/qZWj9EpyadAr+9hS8qDCMhN7o=;
 b=W2RunIOE9usBKW8cb3VcKIEHLkTMDXIhwJJcgW07qYOHlC6VlwsGQbuQ0CKA8dODQCopWQvakHO5Z2sSUJnL6+Lti33/TD4GjapEbdJYn9KkPRPa9UQxUVA6ZTNW2BdXz1kL377OYhTwO19hYGo9GwQFGfieeWl8bmH2Sq2wgsZB3/iAMn1VLv/uLUobaXTY6iQkUNTWHZjYCtUpQimzHl8y89cSE4YtfD3/W/nBjOle/mDwcauSBrfA6puWhdSQDiG/GDj2YS/RZTrrrvUaDytBLntxWVMNHJZwQIeziirL5tZmVi8XmgWZqy3ep6Y5i8s1ntR20ktRtflTytSx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0ypV0WFIJZ8g1mwT/qZWj9EpyadAr+9hS8qDCMhN7o=;
 b=fM9tYPKj2V8qvdL9F8eDb+4KOjsxwesjl0N+ntjajUpFVvKbgjIzypmd886BkqiV6ThF6HXltr3Ql/EtAdsY1LgtWsU7mS3vAALT/gmQLW8yVsMqcoJxCAT9Kx6/V3cmC6gH1LvL8QYJqeVCNkSUJUbWfLQAMK8zqcWf2UR6i2k=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS8PR08MB10347.eurprd08.prod.outlook.com (2603:10a6:20b:57f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sun, 14 Sep
 2025 16:38:30 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.021; Sun, 14 Sep 2025
 16:38:30 +0000
Message-ID: <e2c6f52b-23c3-40ef-99d3-325a0a3cb4d4@arm.com>
Date: Sun, 14 Sep 2025 22:08:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 2/3] mm: clean up and expose is_guard_pte_marker()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Kairui Song <kasong@tencent.com>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-3-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250914143547.27687-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0201.apcprd04.prod.outlook.com
 (2603:1096:4:187::23) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS8PR08MB10347:EE_|DU2PEPF0001E9C3:EE_|AM0PR08MB5396:EE_
X-MS-Office365-Filtering-Correlation-Id: aeab617c-8b20-4d59-968d-08ddf3ad36f4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?S2RGQitjcGhJVnVnT1N3RnVIWjluQVJ4N083SkgyNVI0d0ltWSs0T1JIN05V?=
 =?utf-8?B?Y0kvVGFPZ3NsbmZ4aG9idnhjczJXc1preDU3MDZHTURZMmdlL3R6azkrOEJw?=
 =?utf-8?B?ZW94VGpTWWIwM2MrbnZBekJ6OVBWUHpjZ3plb3lFOElhZFVoSXo0Y0R5bEVB?=
 =?utf-8?B?alBONHNLV3FEMnBEQWQwNHZ1OVhJOGdxZk8vN2xmOGIwcEhKRDYwamxEVWxM?=
 =?utf-8?B?d2s2N2RGNG5PU3hyVjFaVmdWU09HV2NkUkhscXdVMDNsTGtoMXM2dU55Z0Rv?=
 =?utf-8?B?MktXSUNvaUdreENZUWlJeHcwQWxFTUZkQm9mdkxHWkVKYkNkNzdadit6ZlA1?=
 =?utf-8?B?SE12TGVjakU4ZkxMTHBqbkxoOVJtRldiTGs3OHFzK2RVSFU0TEpFbVZ2bFdt?=
 =?utf-8?B?K3RSTVpsa0NTOVUwSXFvT2Z6QjB3Q2ZUdzNvL2ZodnQxY1YvUmpSbzQ1dTBM?=
 =?utf-8?B?Mk00M0YxbXFPWWdGS2V2Zk5PaWJwM1JCeHpFM1dlWWJ3dG0vbVlzZFdzRFVG?=
 =?utf-8?B?cnA4Y1FMYXg2NmhIUnFpWmFkTzI3aW85NndWU0VCNGd6OStLQUdKS29DcFFC?=
 =?utf-8?B?enlzRGxMNWlFdXoxckwxSGFGeTEraWVuLzdwVEF6SWhac3lKYlhFWVRWejIz?=
 =?utf-8?B?VUR6QXRGc0FqN0ZZbTRkZXB1S01rMnJSUlRubWlpbWNqSjRLeXpHVTlqWDdw?=
 =?utf-8?B?UUE5WFNSS3lXcVh5M3hHbnRtTDUzLyszdXV0NzlpRTIybEQ4Y0NCSjJLTlB6?=
 =?utf-8?B?VUtrSzM2TzFodHJzbTQyb21HWXF3RXhtcUMwcTNoUXZqczVFZXhWWFpDWFRX?=
 =?utf-8?B?ME0wY1ZQQUwxQjFFMFdabXR1S3pSc28vN2NteE15SWJkQ2h0QTRReENjOWhx?=
 =?utf-8?B?V0ZLR0J0YW9WbTdXbW9TdmtLcEQ5aktJTnJNM0tqaS90Wis0RDNzSkdvbUVJ?=
 =?utf-8?B?UHpBZ0dQV0tsTEcxZ0ZXVEwwenhnWjVkTU44SFJCaVBJbDN6RzQvWTJFTVVi?=
 =?utf-8?B?TUpUUms1WEhkVHNPd2FONWI5V1hNdXp5dm1EZVFFaHdHQTFWQ1JHMkRYOWFG?=
 =?utf-8?B?dTh1Zlg4M1pOVENGa0lBR2NKOXRZMk1JWE5KZkFnM3I2VkYvVzBBZ3RBSmpl?=
 =?utf-8?B?NFc5bmNsb3pXek91NUhNQzdEYWoyRncyZElDOXlNWjNYSDZuaE5ndk82TUJw?=
 =?utf-8?B?TzVnYkhJV0s3NnRVTmUxaHRYK0JVT2JNMGN4QlBRNnR5N0k0RklRNy9HSHdR?=
 =?utf-8?B?aS9VdWN2ZE5DTW1veHkyN0xXYWsxeUl1QzF3bXNIZXE1U2ZSTXlYWCs0dWNF?=
 =?utf-8?B?TE16d2szei9mT1NGczMvanBsNVd6UVhRbTByWHorVGt6VEF1bDlXSEhtK3VH?=
 =?utf-8?B?MGk1Vjk3NjE2TGUrZHB3bUpxWVU5RzdzVUZpTXNLOGpaakJCSTRRREJVSHEv?=
 =?utf-8?B?OGhnOWk5SkNRZzV6cHNDdS9Lb3dVUk9CSlRGLzgwS01va1FsblJGVFg3RDgy?=
 =?utf-8?B?NlI1Ylk1MWhhWkdqZ1hmUk45OXVoVXlKUk1UWDk3VlN5YitiTXRBMEpFL0sx?=
 =?utf-8?B?YzFTQVE2U0xleVkxR3dISnJJUDUxeklhTXBNN1FCQm94Q2xUYlVWemRaaXZY?=
 =?utf-8?B?T3hRY1pYSkcxdWFrWVdRT0lLMngyZXJGa1h3K2pLMVpQaDR1Ylh1VTh0Zzln?=
 =?utf-8?B?OTJqV3dKRlJibzBsazFyVDF2MVhaaFR4T3FhOVdZVEVSL28rMUl6TmFJaEYz?=
 =?utf-8?B?bkpVdmJXc3ZCSXIwYk15QU5DendLQTlBQ1VrUC9vUzNsOGdZR3U5UitSWGRL?=
 =?utf-8?B?dmZPc1NaeHVvUFJiemlFeGc4U1JhS3d0TnN2VjRqYTROQkdSMjNlOVRQTzNu?=
 =?utf-8?B?R3lvSDJMWEFadGFaRThoaXY5ZWdzZVdwbWttNkd2eFVibzQ3SWtRUzVRLzZr?=
 =?utf-8?Q?MufcD9/Ce8Q=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10347
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C3.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0411506b-b636-487e-be72-08ddf3ad2307
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|35042699022|36860700013|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2o2ajVROFpPaDJISStMT2NJaXAwTHpyS2k2Qm5ORlJNK0p2eitEWXZFYm1K?=
 =?utf-8?B?SFlQQzhSS1ZFbUJidHdtakVLRHNuS1VxQ1NGQnBTUHhEQTZzY3d3Rlg2TmFn?=
 =?utf-8?B?N1E4WFNHeGdRRWczRlF3L05oSG9vaHhWTCt6clh3OW5ESU1ZdXBtbDBTdyt2?=
 =?utf-8?B?UGkrZVUxYXdRRWNRQXdhbmtOR0tHRDFpbzBFcVNqUWRhRlZJRm5CTVBkL2o4?=
 =?utf-8?B?NUlRd3EyUHkxUEI5eUczaXV2blBjM3N6d2tCakd1Q0Q2Vld0Yy9oTFhEd1po?=
 =?utf-8?B?cFNsTG5qYVdkd3BXVTBrVUVRMWxCbERSNXk5bEdQVUVORUJaOUNCN3ROUVpJ?=
 =?utf-8?B?aDhNS3FhWDdTRlkzeU9yd1ZIRXhWcFRLNVJBK0JLdHoyaG9iRTk1eU4zaHFX?=
 =?utf-8?B?R2RwYjZRczdMbEFMaGJucUo1QjNlelBHR1ZuTENucEhLZ3E1cEZwS3ZxMmlZ?=
 =?utf-8?B?c2ZTTUV6SGd3ZjVmMW1nMTRaZjZTUUU4RUdrWHh5djk2Y1JEQ3M2ODUyWWtS?=
 =?utf-8?B?a3pNeHZjdnVMQmxkSTY4Zmx5MDJUU1lvbGg1WUZhZER4T2xmY2s3TzUySzFC?=
 =?utf-8?B?eTk5R0ZJQzh2Yk1lTXN2N0hsbmJBa0JTNXVONFpHbklHbXdoTHNoZEx4Q3Zz?=
 =?utf-8?B?OXdQMGtqNnhGVDVyVGlqUGpqd0VPQ2IybDN4c1h2MVlMSnRadnlHNytMSUt0?=
 =?utf-8?B?MHZNK1A3RGZOVklubkJtOFFZb0tFNjExMm94dWxmVzVBS2xGSkYrVEhIaFJz?=
 =?utf-8?B?VmxLLzJvdDFsdk1wcGF0QUl0TTdrWGtDNVZvYnBjS1ZlOVk4RzU4Q000ZlBU?=
 =?utf-8?B?VkJEN2UvOGdGdTVVNFJoVmhTUHNMV1pxQ25mRHgwTVgwZlBwd2s0cElydHpQ?=
 =?utf-8?B?NGhkL3ZEZk5ZKzhIajhCdTNQR3RYTFhZMFNRQTFzbTgrYk1kV2J3a2hjUmk4?=
 =?utf-8?B?QzlocWN6QVpLWW9POFAzV3ZNWHkvbk5sQWg5V2NSdE82UlRNSU5yNzNVeUI4?=
 =?utf-8?B?TkNTdWJGM0xWdVJxU29kYUFEeUdsYy9Fck9uUnU5clFaLzdhbzdsRlIxdFUw?=
 =?utf-8?B?eDcxczY4QWJZVlV5TDRpVG5ON1o5L1ZFMkxJeHZIbzByRkxRS0gyTnFDb1VZ?=
 =?utf-8?B?R29lb2JuWVZJbklCQXBFdC9mOVB2VC83NVRBci9qVHdFYUgyNUVpYWhTOXJ1?=
 =?utf-8?B?Ky9HSHA0MGdrVW44K0dXWVI2aUloK0FCWjcwTEt5dmwzYkloam5LblFEUnhE?=
 =?utf-8?B?WU0yNy9uV29uejZiWjhkRDgxbW51TUNITmZBSzdjTGN3K3pydld2cVcrY2w5?=
 =?utf-8?B?TWFXZm1raG0yL3dZbTR4OGJNdnEvWEFlRlpIV0RmYVpxSUF6KzFQckkxODBB?=
 =?utf-8?B?NzBLQVp3QXhQb2hKdTVxbVpkaEdpL00wZ0UrU1FBbkZDNnNBeS9ISlVBRGl0?=
 =?utf-8?B?bXZHSXBlNmhWemVYaS9ubXZpQ1J1Vml1QnI1bURuNmFFa0s4R1B6MjZTNGtR?=
 =?utf-8?B?R3NJVko0T0dLR2htamtJbUNtNWJZb21XN25wQzE5d3NTN0I4d3RlODNWTnlN?=
 =?utf-8?B?aSswelgxUmZoVVRmLy91N2loNlZwRVNPYm16bDYzWDY0cEpMNHRETU5UeE1L?=
 =?utf-8?B?MTlxYnpCTzNvcWV3VnpQVzVhZEFCWWxBRnR6VDM1cUtrTlBQWkJoY1VET0da?=
 =?utf-8?B?OUV5ZEc0bmRiUEk3Z09saVRLbnplMnREaTFxa1JuVXl3MU5pekFSTndtQyt5?=
 =?utf-8?B?M1EyTDU2WkNsUFRGM05NNEtuV3luUFJrZXJoQnUrWXFpZjRncEpncmhkdDN0?=
 =?utf-8?B?aHRFNnpEMjVEOVhWYkE3MGc1dUMwQzZJZGkvc0hBNXlwQ2hnOFNwVGw1aDdI?=
 =?utf-8?B?SnhkbUUwL3RYSzhuZWxmTElPTjZBamc4WDZUSUFCU3dzZnR1TjB3Q1kyckR6?=
 =?utf-8?B?NmdYZ3FMS2FWRHRnZWhQWldPdjAwUjRBai9Tc1JsMUxvb2hta3dEVzJUYk5M?=
 =?utf-8?B?bDlhZ2x5ZUdEUHVUdDRwelRlZGk3dnhXaGhIVHNUT01XcUkzY3VTeFd3dlZP?=
 =?utf-8?Q?u6/sHY?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(35042699022)(36860700013)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2025 16:39:03.2380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aeab617c-8b20-4d59-968d-08ddf3ad36f4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C3.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5396
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C5EC5A0004
X-Stat-Signature: a7m5hct9wf8pyg9go4nm8btoa919uiws
X-Rspam-User: 
X-HE-Tag: 1757867947-257747
X-HE-Meta: U2FsdGVkX18hV79gwUoE3VphP0q9/ekODVapA+sZsJ1tbVRKW5oH1BrRvpgRqxb4ciMvUubhexHdcFiL19siUutCCnGP5v85/whMrTBbl9MF2Cb6W9Hx4Y2B4QgwGJwBoP9hcm9pI1LyTW+WwhL+9rucZMe2LO6GDNLajV3afuHCjmMzVV96PFiI2bi0aELr3K1olzdFhM7o8Mve5Olah2BUQHm8mTqpYvBuCwL6faYkmfuGvkAE1jAMSiGrb8I/fV8TaWEfu2hti/sjhPbMjximWuTvcGgQvHZbgIT4PPDLQOh4tjG+8WaR9jcV8n/3Qo78gbMTDx6c/m+64klE0QPIyiMlghiVPR9xVmkgZynRfzuaQ6XgDOd61ozJDl+MbmZGFEvQpyq+H1UNus6yGe8Wftl6DOK38rwk8U+yw3O6yspnNpBTTNE2jvEQaEeT5mDu3XtVRKBwK7nurqGXcJTn7OuH50jRsdDQ+VFAER4ihUjkuDHxuoMscNTNwn/9Zm50w3LL/H7r4wbG77sDsKDhRU1OKNOWKuLuJrh4vwXjFDtvOq9gEgR0JTrDWMlzeeRdDcarAXNI9pHfefn82+hHrHCPv2kf3aVIbFdgBZ17vRL4Hblhqbvjwq6c5hJQVK5UE2jsNTKAwpVufLjlUn5Ny6IBsh4etv2ljXl1nC7XUPQeF9Y/Q7d+99Rz6y8llgu1vQ9Gykkp9jB4EbjxjSkQo8ajF3v/aIiFwlownqxMGFHKV5/SsghjHN96C66Wrs7xVKapkQuTE1K5W0C2ZBz10Vbkc6A503nQt6ozva60KkPrgJZNE4vbfWyCOufvfwH1ldF5PzGnwOnCNMKKXwJT83tJ61alm421Ca2TlV3aJcICdB72VKVB8XICYNnt+EvaEJ+ntImYdWHEs4ZvO7at1cmXjHmXPr6xaPrmFG6aEsuToBvOgnkqj66A63U4Iz/h0Gq2wR7DQcnDoRc
 2CNDiWC0
 groDPg40bNebl4CleITqLjCPzT9B1p0aswqfhdMXPIuHfVNWAQeiiAOoQEO4paxsJVuyPJZbbTnt+zQG+eg5Jml6i6GwCVhBSqni1+z8BpbvbhcJ75QsGZAoLzQOygrASFbkbHHHPHd21kqnkNBHqji3Gs17Fq66lmydagBSB6OLR3ThCIGxUESHWF6TRKOnIDUW0fsA2SMRC4RxRjiNtjO+1NwoC3bI0jOmiEKEV05ocZsaBsKo7ooseNwGNL7eKjIpVsEVChf8HvbNE8Y3JTPWBl7mAA1sTsPDe4ZXDExrk5KjstHasOOPY5E3xoCJyrsJPrLnEgFFS1RttkkAx0gRlifqbILx9zMzqAevTm6gz8tBrlRSDnpQp61KV2faaDu3ZFTPAzwpKJE+xxmJHgJzDO4NYUaa4Fh13BQO4G82I4RJER8sfEpTATKgkZMuO8cn2z4ChSA69Y+srWC+/YP9Jp2unsnY31V7h6IB0/ImInTQFFWSrbefz2GpnH9Sj5nDVYDGKYCZKpHxLG8bY6o3pnor+ImWPGTnq08fPCS1Vf9xHSSmRvluvHktV2ICOXGu8TRDU3Wy7R+r54VsenL2RyQvdnPpeqAUhcX693UOv/noG86lkZaIfxi5QDvludy+npcbFNN137rY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/09/25 8:05 pm, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> is_guard_pte_marker() performs a redundant check because it calls both
> is_pte_marker() and is_guard_swp_entry(), both of which internally check
> for a PTE marker.
>
> is_guard_pte_marker()
>   |- is_pte_marker()
>   |   `- is_pte_marker_entry()  // First check
>   `- is_guard_swp_entry()
>       `- is_pte_marker_entry()  // Second, redundant check
>
> While a modern compiler could likely optimize this away, let's have clean
> code and not rely on it ;)
>
> Also, make it available for hugepage collapsing code.

The movement of the code should be merged with the next patch.

>
> Cc: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   include/linux/swapops.h | 6 ++++++
>   mm/madvise.c            | 6 ------
>   2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 59c5889a4d54..7f5684fa043b 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -469,6 +469,12 @@ static inline int is_guard_swp_entry(swp_entry_t entry)
>   		(pte_marker_get(entry) & PTE_MARKER_GUARD);
>   }
>   
> +static inline bool is_guard_pte_marker(pte_t ptent)
> +{
> +	return is_swap_pte(ptent) &&
> +	       is_guard_swp_entry(pte_to_swp_entry(ptent));
> +}
> +
>   /*
>    * This is a special version to check pte_none() just to cover the case when
>    * the pte is a pte marker.  It existed because in many cases the pte marker
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 35ed4ab0d7c5..bd46e6788fac 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1069,12 +1069,6 @@ static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
>   	return !(vma->vm_flags & disallowed);
>   }
>   
> -static bool is_guard_pte_marker(pte_t ptent)
> -{
> -	return is_pte_marker(ptent) &&
> -		is_guard_swp_entry(pte_to_swp_entry(ptent));
> -}
> -
>   static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
>   				   unsigned long next, struct mm_walk *walk)
>   {


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E92C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9AA08E0002; Tue, 22 Jul 2025 07:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4AED8E0001; Tue, 22 Jul 2025 07:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12A98E0002; Tue, 22 Jul 2025 07:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B27C8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:06:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A1DF1DA12A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:06:50 +0000 (UTC)
X-FDA: 83691622980.17.F03DB60
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013054.outbound.protection.outlook.com [52.101.83.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2896C1A0005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:06:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MGMtWmIZ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MGMtWmIZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.83.54 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753182406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/smGhozUKh9Sn4umKEpeiV3rcrzopNO7Negpfjy0zOA=;
	b=Q2Y/6kY+3MXXXt9F5iYqBymFtPF3Hzm5+BLiAj/O333BULx0RWLadxYiiGxAYqhuF8d5HN
	l1UtJWGTqmYqu4VFL6jP2wLZvlC0l+T08Drd3e/jz8EO7l+W1eJ6kf3RFx5fRMeTVNEa2z
	2HpiQLurRqB9mpQdDJ+0KZNRr+Kmq/4=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753182406; a=rsa-sha256;
	cv=pass;
	b=SyFtu3LSUzj40uestKLxARUrxEKVvp0TG1oJs9KgaAa6XTax9XFU4o02N/xMZMmpa2wvwv
	ay3FILUY7QNLtxNbF4s9ii7gdzColvamxLli/R0wkaO2s8bJgr6cyHswGZBlbdiGxiKqef
	UAZYzEL4fKTTZ7Xw1cE76R9lZ85OFgU=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MGMtWmIZ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MGMtWmIZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.83.54 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OZvDw7q3OdpKHOiM7+7DSdRtuF4HDGElmW6wWPOQTkKvISpsCBd0gaE+uLC4q2/lDYPPtuO5aJEuJ46XW1DvOLjMKfilufBe7TFxVibeEdWxkCJZhdzAEWJuuPwmhf29PBgM2KBri0WwzcAAJkwyqoZpqbttZdxutkkzgpnyfFaLzueQ40p76uuDrzVfcmGGCrT/2loGWE+jjNvo6g0pgc/w2h5xd96cILwEAoM+OnFvYF/trE3fGSbVyN3e3j1YGe9oPtq1soT/xWJyTKXiz7oGHrru0oAhgKltmbs1Y+ANpf8j9liKJaeS3/Hq+wSgKWkyK61NwEeqQ1mer3f7qw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/smGhozUKh9Sn4umKEpeiV3rcrzopNO7Negpfjy0zOA=;
 b=NSp3lo6OXJv4/T6OKeJ78pJSk/R0ATUX4KvDgc/+/TTfGVjPSNLPzEjKWMVe0GABe4+OSMEhnSd2Sm3ADMMJ9j0UjkRtBBG+GzzH+viA6pFYMYtEQVXoLqOt++4zTYK4It37I+XUkQGOhP2OL4phO6mHEen+ZlWCrll2dePA30AVYebD7ZQ5tN69pmOs7PM/Xjid5O+Vq5ZxQEiTFAzBoYUT1Y8DDHYLic7LzgPnTB9Y31dtVyyGC9+uclC2Q/Cow8jxgiaoZ1/C5scxOrkC2K2slJnDXtjX7NK8vtH0POvU2AM0ljDrQ39T0Xt99f5xmlE51LCo7zyVxm8StdK5xQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/smGhozUKh9Sn4umKEpeiV3rcrzopNO7Negpfjy0zOA=;
 b=MGMtWmIZyjMBUARJP8qzdqAtPkgDuEBqbFZsbIutcs0xIRLuuYmagxhINzDlEVQY1MEJNJzC2YmjsrX8acKm+EK7PGbZ9oD4DXLrKFu92YzcyPkZ0q0pcJJa3E4RLx0YwSqKAJ6wz+bRRvbiRnB4k6Zyto0r5lO/ShKufuFqd3I=
Received: from AM6P191CA0083.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::24)
 by GVXPR08MB11010.eurprd08.prod.outlook.com (2603:10a6:150:1f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 11:06:37 +0000
Received: from AM3PEPF0000A798.eurprd04.prod.outlook.com
 (2603:10a6:209:8a:cafe::d2) by AM6P191CA0083.outlook.office365.com
 (2603:10a6:209:8a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Tue,
 22 Jul 2025 11:06:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A798.mail.protection.outlook.com (10.167.16.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.20
 via Frontend Transport; Tue, 22 Jul 2025 11:06:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVVSsMSZumWFrulmO+GmvEaJ3yYAf3qyEe2PFX4xdYCfhBgao0faVGxMa6tCjTHLwlhlyfiNRr72RAI0gSUIlguV5f3iZSVMJO/31ZemKpSEvG+f6yN5vZecc33YOf5p6fQmK+5bVJO24UNU6SUC4q9eCLYKfhLMcCa3mcpKvcepIpsg8C5gp1oncSQH60+gDhNoQN/Rrs8La+cPKAbJBj620f2ikN/KaVulDbIsozzHsO9gbmIj7tW1wtYn98wQFsiGWNHglVqCOWtCOObzyl8Isr67uj8uOubVHvuyXE7mWNisnNdpPlJtJDR/83dB3MmAskHwdY3jdEfOd2S6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/smGhozUKh9Sn4umKEpeiV3rcrzopNO7Negpfjy0zOA=;
 b=Los1TM2AUzMVMextKR2NaVs4ddsBDDnyKL0TwQYLO+l47ok5adiJAT/UQL9eWSSXZK2O0UUwnVQTRySizTG+9hEzUxNPkGWjG8zKkRCxIn+Q3/QTySbI87j4KRatPacBdxDPihpisG4grcXviegKWApN0qIHoJkrHnS44NQTduPFLnbQqHDNKYCO8P7y9UAlbHYeAzE7i3OaC+5SQtjB3PoMgCPY76sS+JXTmAJI6n5PpiuNHNgMPXWYv+iqpBRFQMGgQYv+etofBEOOrIqDa2JH3iXJ+SWjaEweDuj/ERwRcmuoFL9C2fa2lc9IehwMsO8+8rFuEu3o7zBAUUjIbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/smGhozUKh9Sn4umKEpeiV3rcrzopNO7Negpfjy0zOA=;
 b=MGMtWmIZyjMBUARJP8qzdqAtPkgDuEBqbFZsbIutcs0xIRLuuYmagxhINzDlEVQY1MEJNJzC2YmjsrX8acKm+EK7PGbZ9oD4DXLrKFu92YzcyPkZ0q0pcJJa3E4RLx0YwSqKAJ6wz+bRRvbiRnB4k6Zyto0r5lO/ShKufuFqd3I=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DU2PR08MB10264.eurprd08.prod.outlook.com (2603:10a6:10:49b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 11:06:02 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.8964.019; Tue, 22 Jul 2025
 11:06:02 +0000
Message-ID: <476c1978-af9a-4d25-8e5c-02f23de0b5b4@arm.com>
Date: Tue, 22 Jul 2025 16:35:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/7] mm: Refactor MM_CP_PROT_NUMA skipping case into
 new function
From: Dev Jain <dev.jain@arm.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, david@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-2-dev.jain@arm.com>
 <CAGsJ_4y1rJ7Omv-8ADk-cZdkAA37bxOxaeM3-vpz1MMaT_G04A@mail.gmail.com>
 <d0163616-eacc-4ca2-9816-c577e710c5bd@arm.com>
Content-Language: en-US
In-Reply-To: <d0163616-eacc-4ca2-9816-c577e710c5bd@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DU2PR08MB10264:EE_|AM3PEPF0000A798:EE_|GVXPR08MB11010:EE_
X-MS-Office365-Filtering-Correlation-Id: 86e6d9f0-bf01-4b18-974a-08ddc90fd342
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?OVAvRHNObEdJdzZRMUNLL3VrN0ZBWmpkNEx1clgzTExzUUxzVytidUpjcGhU?=
 =?utf-8?B?Z0xrR2xyOUdYc1V3ODNPMnBlVG1KZlZ2dWZrRGRyVXNEa1JlRDRmVTJ0ZTg5?=
 =?utf-8?B?NkZTeEg2cGdiMTNFdE0xTUM2WC9ra2twMXgxYUZzVjNYSDRCR0ZFYTkweC81?=
 =?utf-8?B?eldLd3lUNnJXNzByc1lYNnBFOFpSWURNeW9sVVNnSDN5MUR4Vk40NUdJb1ky?=
 =?utf-8?B?bG1ZTVlhZS9IaFNId29xM1RrcCt4YUFZbFZxckkrL1FXMjNQREQzdDc0aUpV?=
 =?utf-8?B?OGFnS2pRL04yd0EyZWx1azYwVU8zUStDcC96VlBKY1ZnZ3BTUDI2d3R2ZFVv?=
 =?utf-8?B?NmFQbGplZFZrSy9WY1BpcUtNVFh5OGNqUEo0MllkZWVQUlErU2JFdjYwNkJJ?=
 =?utf-8?B?cnZDWCszenRRSHIwSlU2ZitoRDFLaDJHRjg2QXA1eFlHTnd6bXNRajBiSGxX?=
 =?utf-8?B?SVk2OFpVV2p1K2R0Q2lMcHpMZGRXQ2c3N1N5Wm5Qd3BSOWwxSEdoL01uU0pL?=
 =?utf-8?B?R1Q5dXhUaklWSDVXazZHMC8vc2FxZ1ZTWGhOaTgvaFZIWVRFZ05TM1Z2Ritx?=
 =?utf-8?B?UDZ2ZXhnQkYrZjBpcE50ZmtpRko4Qi9uNGtnTjRUcDIwRldqK2d6MU9jZEt6?=
 =?utf-8?B?RDBDRVV2bCtkdm01ZGU3MTc1NU8rWFJIY0Q5bXNGNStwaEFZb3c3Mm43TlNQ?=
 =?utf-8?B?Q0lyZ3BVelpldGM1aDliN253OVBrZFdxb1pOeEIyTVpzTW40b011ZlZCUkh3?=
 =?utf-8?B?WkNYYUtBQ2RMMWVKTStST3I4Qk1JVmRSY21oZUdxRm1GeUJnRXN2M3FmWnhB?=
 =?utf-8?B?Y3dsbCtGZXhnYWgweGFyMWZXV0M3cHl0dVhra3UvQXd2Ynh2TXZjd3Z6Z2hS?=
 =?utf-8?B?MERTYzRiSGFiRm1lRkloUUxoakRPVkZ4UnBCZVZ5ZTlhT0tpR2RjdG14THA5?=
 =?utf-8?B?a0RFb2JETHdCZjh4dytUZVRyUmRxWHZQSG1aRFFCemRZSTFlTkdVRlQvTGw0?=
 =?utf-8?B?U0Z2ckNjU0VLYlBFTjN1T3F5SlFvVEJmZzhTRXNUdklyemxxZi9leGtjUktv?=
 =?utf-8?B?c21FZFp5VnVES3pUMkx4OEE5Vnd1WGNrVWllTm96MlNKUXV0Wm9TNHBYY2Nh?=
 =?utf-8?B?cTdNTnRYdS9ScDdtOVZCOXE0cXdTcXNlTis2ajBEcThFM3lHSkpzK1ZEd2xs?=
 =?utf-8?B?T0hEQkk1MGFEUGJwYlJINXJCRm55bWJHUXBsME1wNDhTMndvMjN0RXh3TG5M?=
 =?utf-8?B?ek9VRTF2a0hYV2g5bGRtV1g2aEJWdFpUTlZnK3AwK2VpMkZBWWVnQ3RJL3NZ?=
 =?utf-8?B?VldLYkNuaEd6Q2pKMDRHQWcxVWFiWllmS2lVaUx4YkRwc1IrVWRnZE9La3BJ?=
 =?utf-8?B?TmdBWmhKOW1sM1Q1ZlVsdVNxY2pDMzlIOW03RkVMbytyL1hLVVczT0FJZ09v?=
 =?utf-8?B?T0xzR1BaSTIrempqb29OOXVwdTFTT3ppK3pLdGVDQnR2Ylg3eE91dzlyWGdh?=
 =?utf-8?B?NUFlMHQ1RUpSRWdHeWlEbUFXSVF2bUlqU01iblpmVXk2NjhEcS9yOTZad2hy?=
 =?utf-8?B?SGVkV1lNdjV0UWlRRzQ4YU92NHBlNSt4R2NIYTVVM0VDeWFBRG5nMU9pdGtq?=
 =?utf-8?B?V2NZVE5hcWo5bUhiaVlEcFk4VXpoUGJRM2tJWUNKbU9ia0VvcTBHUHZHSzV0?=
 =?utf-8?B?dXN2allzYkVvRDVReEtEazFzL2FWak8rRUIxNVUzRm1OQ3NpM204YXJ0SkN5?=
 =?utf-8?B?TkMzWTdOZjVmS2xFT0xPVTF1eXdVNnNuRUVxOWY3alY0cGpkQmpaR29POFJE?=
 =?utf-8?B?TndYRTk4WDdtUFBOMTJCb1RjUk5UbmRDZ1hYL2ZIMVFLaUVuRHNGcDlhSWdV?=
 =?utf-8?B?eHNDVldWSExDSVVSMFhSUFZkckpLUmR0ckFSZlk5RWtWNWUzSFBiWjlDbHRV?=
 =?utf-8?Q?f70uO0BrT18=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10264
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A798.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eb3cb385-4134-4ab4-69f4-08ddc90fbf0f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700013|376014|7416014|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkNpMWV6cnZqRVpJbTM3TlA2OW9LSTNXb0krMmV6TlBMZ2tWZzhkRExGOStD?=
 =?utf-8?B?Y1ZBTCtyMTRkbWx4TWluTFRHdm51MnpqMEZNcXF4ZEF1MGhGbGNEeW5uaWti?=
 =?utf-8?B?Q3AyZ3dVZEdxSkpMdWxyM0RBZzVJOVVUbDdXWGxqREUvQTQvcUliUk9aRlhE?=
 =?utf-8?B?OUxXSUZKV0d5VTJpYVdIdndqNE9RcThLVEJNTWk1bEcwai8raUFJbHEzdDRI?=
 =?utf-8?B?Mkp3Yzl2YmphaW03V3ZtbEFtaWJFT2E5RFlpU2pNb0JFSFZqYTZHRHl2SFJr?=
 =?utf-8?B?bWpLMkFEU1dhTDVGTFNIYS9BT1V5M1ZBVnJCNlZaNTVCb1FRc3ViNldmbDVX?=
 =?utf-8?B?QmJ2RkxNQ2tHNnBLbDFYVWhuVFZydks4UVordmhIeEMwSlJKcWJ3MmVLS2o2?=
 =?utf-8?B?QjJ0RVozaWk4ZTdwaG1nSE5VZUhDWXlhNDdWOUh0K2dVblJrby9RRVMvTjJP?=
 =?utf-8?B?M0FndEdnQW5LQXFheXFxV1VYa00ycXJSSC9EUFNyZENWT2hpeDdHR3IvRkU3?=
 =?utf-8?B?aUtTdUkyVFkxMjNGS1hLQk9oMWRZbk83L1BtY2JnVTB3dzJ4a083VzBlcFZI?=
 =?utf-8?B?dzk1TXlLUG0rUlRKNGovZTJqNVJRb0lVMUV3V1NYZU1sS2tkYmxURFFBT0Q2?=
 =?utf-8?B?ZU5Xbzc5QWppaVQ1RnI1MmdDNHgzTXF5SGczamc4aDdhZHdnVlhyclJDbWxv?=
 =?utf-8?B?TjQwRkdQbGljWTZtSkprYmJMSzRjYkovZm5kZHY0ZkxkRjY4b1dYeVZVazNl?=
 =?utf-8?B?S0kxYzBoaWJVQTZSZEdvZUw5RkhFaXpOVTRSL1hLMTZmU2lMWjdSaHE5R210?=
 =?utf-8?B?QTUzRkIycFdWb3Ewd0IvRGdTeXEyNUZGYU5vNWlDU1pCVG1LUFJEMDl4T0VQ?=
 =?utf-8?B?d3kyc0xsVUJQZ2ZZTExoV2FOQkV2NVRKcHdkb0Z3N1pRSGtoMHVEdEVVRVha?=
 =?utf-8?B?NlB0OUlsU2NsY2xxY2kwbHNxUi9DS3N6U1ppazBzMmNGeVdFeW9YczRYWU14?=
 =?utf-8?B?eUhZRmhJb3R6UmpXOGJvMlZIYzBkaUNjRW54SzMrNnBkL0EvcDJ0NG0ydjdx?=
 =?utf-8?B?elJPNkMrbUphOWNXd0FCRHVtdUJaV1g2dWNzWkFOTkM4TjVSbjlKM01UVFRR?=
 =?utf-8?B?eEFoMjQ2azJvelQxd3AyVXRDVVZ2YTJXOHlIb3dJOWFlSkdzVElSaGd5elJQ?=
 =?utf-8?B?T1lld2hqN3VxeXlUeE9HMFlDYlNld1VpdUllTWl0QU9EZDNUdzRBbUMwRmUx?=
 =?utf-8?B?Uy9jYzl0ZGprRWRXSmcwYmdvZXM3d2lKQXRnanlFSEZ4bGZRWW9JQlVtSXhv?=
 =?utf-8?B?ZHIwc2hPalBRb3JEdmdzSXlYVTA4ZjlPTHBaZHdVbE11K1QwTmQxeksrUDAr?=
 =?utf-8?B?U1duTGtFcmgzbDU1RmtXZnBEV2I1YTQrczkxUFIxazJ3MFNoYnpHa1FOWXRM?=
 =?utf-8?B?TzlXcTluUW1xcmo5TWJPQTF4Z3JoR0F5U0lEWXZWZTY4c0htTHZUMU9jMm11?=
 =?utf-8?B?NWs1MFBsc2hsV3NCQmRCUjBMOWNUbHQ4YW9hZW4wMnNjNlExN1NrTkJycFEw?=
 =?utf-8?B?ZHFHSnVWR2h6dThhK2xtbU9OeGhnN013SHkwb0cyWTd4MlM4K3NWaWhYNTNv?=
 =?utf-8?B?YUU1N3VRTTN0TXEwS2pXOURrZTlwTjhaQzB3K1ZmdVBaZUdZN1pRcEJuS05X?=
 =?utf-8?B?MGtkV0VyU2ZUTnBpaXVSczE4bWtFcllvT1pieHZoNTBuY1h0aE9wdGRjRmxJ?=
 =?utf-8?B?MWROYW1ueEhhRkJnbUhhQi9YYmQ2aStoZzJTVzJaeGdvaVozZlkvanBZZThu?=
 =?utf-8?B?cDY3U1NXN05nYUZvU0VyR1pyOWpvMy9YQ1FqZEkvUmRFZVpMenJPZHlXMlpl?=
 =?utf-8?B?TTdqMjBCakUxTk5LWmxoS3ltekdaZUt0c1JLR29aV0tBVE9xaW5kMFVMUTVG?=
 =?utf-8?B?ZnFxRk82T0hNQXhuUkxQREZJZEszd3U2c29ISzhLNWZWSElyUmtUR0V6MzEv?=
 =?utf-8?B?cTFkN3ZvUWVWMkJEZ3FlYzliS0VhTzhtdHFGMGVOSEZ1SDN4QnZjTzlrWjVT?=
 =?utf-8?Q?qSmLX0?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700013)(376014)(7416014)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 11:06:36.1645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e6d9f0-bf01-4b18-974a-08ddc90fd342
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A798.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11010
X-Stat-Signature: iat86aep3fmtc5uhjqafg3mhjpaizzt1
X-Rspamd-Queue-Id: 2896C1A0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753182405-3847
X-HE-Meta: U2FsdGVkX189Qecx3N35blf0wqzfVvM9Q5luJyAg1Tf2eZiePY3TNGVOPHXH8z2TRva+7A288gECnrzk29orbVMcIEXY310gpk1tY9TogbkzV5PZSqv/LjaV/lRoZk83Sjtdg82XPg4uA61yl/EVM5dW2EucbqZMlQsldaE5vdvyDrVWAAY84RhMabUYEHNGQm+TV7gOel3LeFOYQ/JDw+Fc7Pz6td0QfWac9DqpjjG54qPkVFL7AvWII/NVCCD8DaWZP0YbNFQcJEBDP93Raxo1OkmYuvA+vM6Sz4Zd189qIkhjpsQDf9csAdRPmuKrrX0kJztHN9Z2BC3VQgyHtZun4JMbDebqI4yl4XsThzVvyqLJLDYMwmlIjCC0b6kFFLY7NraPkzs7b6m0PC+Zchhalv+uLREpNgTJC87vJzkR1z89LNlOilVozoEktEN/ZEmficUBuweSu8VynpmNhl6Gz41EBhKIKRAugZBzbfNeIyzpT6e5FphTkDudPdj0LR+qapceyIOE4Bekwt+ToRGSNGUfzUBOVimnoMJDUG6KBWS2lviVyUJoT6EVVYXKvHCC7fuj3ygAXn6sLG7oZDblqdeyzo+8YAkUxs3nrAcomw6NjJQhsNXg1GdqT99qMTdPSRB5awDO/fCz2yNBG9zl1zSVToSEsZciGLoK8iaC29tnTP6vafkrSXsq1A/3H1OcY735R59zfCR3MyTXvLCVfjqPamPQ0utaCsb5U8ZazXMJQspFW1+JrtZuvBjGIloaIBwyEghs7zBF+rlp6AtrH4WOTO10yR2Nd17P3xwZ19E6O1xYoxqqXoWGPCoEhccQMecUIHAhzQRPZ0f2WSKN95V5z9ph2atppjybMKzfE0juZ+80aT7hrAXtthGa+Qaf2kjB8A7cRWY9IfUCvcCWnARd/NgDnPnNUF/dDiThv3FuVaVWC7FU28Vb1KNWQpMXSkCC6uAQRAh9Esv
 hRz/oiOL
 ffOdaKVCMXpKfeI+hpSevRModTrq1ykPaeXS8ljzZEd2SOjHC22LVl/jxI/gIq9MwkiaGN8R3q8X+10FHdOyoR0FqK1RpT/Ex9ka35EnBwJ0wMKMWC4PLVtKBMnzcFaUSh0UDaIAV4F9kYQmCiqfno6QD0UTOTbMJ4TQOoBkzbc/vaT1qzi4GbwDmueHaR5xxo/u9gCb9CuQxX5hMsGvZgylfo1+Aa+VNL6d/6itGXpus+grfpJ65OXXa7i/qltU0P4xo2f8qx3dNcKdmHliYXCa7S0vH37h2swoAyqE8cFSmzhmdUUYAKB9WWv/xgt6FOOvgoLCTdnWNTw2/Ntdt0AenfEbB0u5sFXopclu7XiS90uTivIlYdgU4LUsLS8hIyXyLmbInR/V4saZ+bcNPE+AILbW8FHsmhdS+agxOZvSJsyz4b74G+GIJi0tbg52B4nSoepH8YAExt8/zoMrIJPIsR9BiVSS/nC1y0LoqVJ5OxR8gkXOECSBrI/3vo8liw1kPQ32SgFYjS0bma767WdIhb8mBP7VvYsas87qogPQkO8g1ErS8okB+IhWJqTfqCna/QmbYjVo6ytaOL7iWbX3MIC8WEfd1S8HR8tJp4DF/10nP/K0o5foxYiZcC6cm3WM1rMEuT5UK2PH+RdAHz4Xa8Cb9msyRNAJH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 21/07/25 9:14 am, Dev Jain wrote:
>
> On 21/07/25 5:14 am, Barry Song wrote:
>> On Fri, Jul 18, 2025 at 5:03 PM Dev Jain <dev.jain@arm.com> wrote:
>>> Reduce indentation by refactoring the prot_numa case into a new 
>>> function.
>>> No functional change intended.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Barry Song <baohua@kernel.org>
>>
>>> ---
>>>   mm/mprotect.c | 101 
>>> +++++++++++++++++++++++++++-----------------------
>>>   1 file changed, 55 insertions(+), 46 deletions(-)
>>>
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index 88709c01177b..2a9c73bd0778 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -83,6 +83,59 @@ bool can_change_pte_writable(struct 
>>> vm_area_struct *vma, unsigned long addr,
>>>          return pte_dirty(pte);
>>>   }
>>>
>>> +static bool prot_numa_skip(struct vm_area_struct *vma, unsigned 
>>> long addr,
>>> +                          pte_t oldpte, pte_t *pte, int target_node)
>>> +{
>> [...]
>>
>>> +       /*
>>> +        * Skip scanning top tier node if normal numa
>>> +        * balancing is disabled
>>> +        */
>>> +       if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && 
>>> toptier)
>>> +               return true;
>>> +
>>> +       if (folio_use_access_time(folio))
>>> +               folio_xchg_access_time(folio, 
>>> jiffies_to_msecs(jiffies));
>> Nit: I wonder if this should be moved elsewhere, since this isn't
>> actually about 'skipping', even though the function is named
>> `prot_numa_skip()`.
>
> Agreed, thanks. We can use prot_numa_skip() only to return true
> or false, and if returned false, we can call folio_xchg_access_time.
> I will wait for 2-3 days for any more comments and respin.

Since Andrew has already pulled this and we are quite late into the

release cycle, I'll do this cleanup in the next cycle.


>
>>
>>> +       return false;
>>> +}
>>> +
>> Thanks
>> Barry
>


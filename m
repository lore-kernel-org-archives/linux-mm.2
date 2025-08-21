Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD30CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3071A8E0005; Thu, 21 Aug 2025 11:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B75A8E0001; Thu, 21 Aug 2025 11:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1326A8E0005; Thu, 21 Aug 2025 11:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F392B8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:36:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A62BF117816
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:36:41 +0000 (UTC)
X-FDA: 83801167002.13.8BB3D6F
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011068.outbound.protection.outlook.com [52.101.65.68])
	by imf23.hostedemail.com (Postfix) with ESMTP id 03964140002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:36:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=j6nYiQeJ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=j6nYiQeJ;
	spf=pass (imf23.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.65.68 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755790598; a=rsa-sha256;
	cv=pass;
	b=a4hRy/kS65s2jfmjQn02V6DAdk8x1F5Qwg6w6BU6s71D9VdvlUW9dMbfH+tNq837yk29Gc
	zzRFMqtyKJuC3i0rfkwF9liYghOlEL2mFEUht9NJm1uHmz8ee7eJzItlJJU+vgdPZ1NuGo
	eMCYiSUUjco+E1pvEYUsF07LgLOOWDQ=
ARC-Authentication-Results: i=3;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=j6nYiQeJ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=j6nYiQeJ;
	spf=pass (imf23.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.65.68 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755790598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OJHGaA6PgbCvECs4l8FrIYWu2DdfypJZ0ErP1z64kE=;
	b=fbhZuhaLWSojAsA1h5qtgOU1ARrAHa0ui1xQ0wS/K8WVvQnzbzwXeApkYd+8lRcFJfvzFb
	Fd0YJoWFfDWO6R22zmvLP2XGAjCJG7GVKg/ZtUiUW5x6fBk0qmOO8QSVcVs77EvIIUE99p
	PnBiNpNKrMf7wYXqX6O/jVft18THiqk=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SEYZcc5rGHhVrycRx3yyiCFqpEVOMaXRB3oyjsH6eXgVyxk+6N+2A8A5he+V44gGGaN/FutBPGuNoYacOVHhCmqjaWkGDdtp1qd8TsdP6LLGz1vUrJKoIExaGGsceblRVr6JhstfNiQ7ECpplefWZ+5IbslJjKCflDSbCU9DbTDZlpT/e+HY7ONvuwD2aNOWjEdsV72evvkf46RJ5YFL9cALVxwN7T/655utIXJw+kYzMF/bPzIpInsyW41zqzm0EMI1J5gbPviohAM6hRUzpJmw7WxbXJfSwyI+bBRwZ6sR/IvxubBADUMtaGDHcWa3JLAO1k/cgcFSUbJBI2Fxvw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OJHGaA6PgbCvECs4l8FrIYWu2DdfypJZ0ErP1z64kE=;
 b=kEPOwjUZ86ZaT6xRUQQ/L6XwLT0XA7c278+44x1cL9krZbfDxOH1LNAY+LblZtAjLRa9G5PwSar2Vrqok5m/cw36FjGyU4xReVVne+ZojkMPbjjKfOqR4nTstTlZsy2Uurcvj1bMmgOiHpaX7Krn65QN0EBgJHaViuoNU9xHkNGPC6VyIjfJDpsl9KGrxIO4T+H7DnqRBM5e/TB/pfRjsdcdFqupkeWzd60Auuan/tB1mF1N+u4E7su9HiZ9ZZmcvkyiUE7naUKUScjP6JP98PSplcYUQD1GnafXvDgvN6e5zI4Mq6fl8pkMWnkEgn2/xC8zalJQoNhtMbJa/alqZA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OJHGaA6PgbCvECs4l8FrIYWu2DdfypJZ0ErP1z64kE=;
 b=j6nYiQeJfldbRDuYQbQ3WcXWRpiITmLdHmcbV7vAPdz8ybrRiB62HhjtRixfr4WiPlsQOqDNO4i0GN1uFm7Dae1cK24ExVL5SExoN+1XKh2afsUhsHe0txDesQs2iOgz9TtUOaLTUdpiA34XjcOe4c7W3eGcUgrgm6y7SdK3ubo=
Received: from PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::18)
 by PAWPR08MB9664.eurprd08.prod.outlook.com (2603:10a6:102:2e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Thu, 21 Aug
 2025 15:36:34 +0000
Received: from AMS0EPF000001A7.eurprd05.prod.outlook.com
 (2603:10a6:102:11e:cafe::84) by PAYP264CA0013.outlook.office365.com
 (2603:10a6:102:11e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.15 via Frontend Transport; Thu,
 21 Aug 2025 15:36:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A7.mail.protection.outlook.com (10.167.16.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Thu, 21 Aug 2025 15:36:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/bMRkQhoNluesAPsnZUzgyDzCKnYDyLpSThGaMRc8cJmWcqC6mrhxNpwD2ckMPDh3Qv1pP9Ev5o5v0aAYC8J4L5dsRNOzG0CrFQ5CCAqtthpK2qBBRW0mmQjGTsMFDJ3xWEdBDtO0x7ZOnSc+AM/BX/3ts2q7906ayVQgCn+SuS6rdKL0E9RlwyelEQbRyFhiOyoF4lg5K45YnKFpzYHD62ghI9pY7z66T9UaiClIM4eauWrAbZjrs1Fqydps8hFSbXGjOQC1EMMzqn8FOTag4Eo1vK93HfesTl14UgEBdFtxWboMNT3pEZ46ijUo3Ho3NyomuYoIZrj3qKZ1Jvxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OJHGaA6PgbCvECs4l8FrIYWu2DdfypJZ0ErP1z64kE=;
 b=o/HC37B781GhHfwTE173bhcUReZyIjgO5351YMTb5xqNk4JJavuHKmsNvKCW4O8pxKMzH7MkONPV9pLHXloNM7ngL13Q8//GkOlDq8gG3jgVJyXUGQOR1UrQe9CNdOAB/dXIGIijErje88s6UqvwvTWJV5dJqRROuJDEKw4ACEX76kOYmM8aPg3jFUHsgcmiKe7qX5ZsJMj4BLgWBWBKSPrnSNVwwUGI5rZWeQhd+wlh6pV9sMfvwoMvWwA9XuEZCx5L6pdguLeiuTCp7Wy52F45aPCRD0siqfndbsuMwJwUwcxw1S+8+Jm+f5kgHHPNhD6pED7/IDRa6dQzSO0AjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OJHGaA6PgbCvECs4l8FrIYWu2DdfypJZ0ErP1z64kE=;
 b=j6nYiQeJfldbRDuYQbQ3WcXWRpiITmLdHmcbV7vAPdz8ybrRiB62HhjtRixfr4WiPlsQOqDNO4i0GN1uFm7Dae1cK24ExVL5SExoN+1XKh2afsUhsHe0txDesQs2iOgz9TtUOaLTUdpiA34XjcOe4c7W3eGcUgrgm6y7SdK3ubo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PAWPR08MB10090.eurprd08.prod.outlook.com (2603:10a6:102:367::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.27; Thu, 21 Aug
 2025 15:36:02 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9052.014; Thu, 21 Aug 2025
 15:36:02 +0000
Message-ID: <4836d089-a7c7-48e2-9b95-38e1eaccdee7@arm.com>
Date: Thu, 21 Aug 2025 21:05:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: remove enforce_sysfs from
 __thp_vma_allowable_orders
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 kernel-team@meta.com
References: <20250821150038.2025521-1-usamaarif642@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250821150038.2025521-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MA5P287CA0020.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::8) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PAWPR08MB10090:EE_|AMS0EPF000001A7:EE_|PAWPR08MB9664:EE_
X-MS-Office365-Filtering-Correlation-Id: 3128edb9-1fd4-41f3-a481-08dde0c882ab
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?U1hkQjk4MkgxNGF2eXFCWFc0NEJrZFN4ZVhjamkzWW84MzhNQWMxc29EaHlL?=
 =?utf-8?B?R1RqRnlGMmw5bFBISkxUQXh6Ylh0VnlHZmU5Tlo0TjFxa0V2ZTJJY2FSTHhh?=
 =?utf-8?B?c3Y3ZkNLYWNXbU5NNlZYbXdBaVFkTjVWMUozQ2FEUDkxcW5ieHQzcDJmVnJq?=
 =?utf-8?B?UHFTYmN3TGFlbm16KzZkejBPeWdEekttQUN3WEdnTXNDY0NvZWppQW50aFc3?=
 =?utf-8?B?Q2RmS284dGtqM2xhVGI1ckl1WVo0TmJpZ09hTjhPaG9RUEljeExtd0ppd2gr?=
 =?utf-8?B?UnBINDFMeTVOTjZzK0xINnkvVFMvRjh3dW10c2tlK1Z1OUd1K3k3THlEOG45?=
 =?utf-8?B?cmp0RmU1TS9pWVljblJZdU84NEdyVmpuaittbE5oaisrNGFhTXIrQitMWFMz?=
 =?utf-8?B?ZXdBTXNmc0RkWnZmQnNNODg5d2l3Yk9ZN2JTSUJBU0drNFJSdzBhRE5HbmVM?=
 =?utf-8?B?dXlNcWpMbDRjb05zQ211RVJsUmlZYXU1eGROdWREYzRPaStHcFdWT2xaSmhs?=
 =?utf-8?B?cHZaZlp5eGNQV1ZDSURNcHFKUVBxcFNSMFJNR0V0Zzk1OVA3eDV2WHI2MzF0?=
 =?utf-8?B?VXcwbGtGSVhkejhEd1NxYzV0VWlsZnhFY2lvVkVtUUt6cUVNb0VvREQ1U1Uz?=
 =?utf-8?B?YnV3TVBmbWEzTnRub3dITVhFMEtQdWdEcUtmRno2L2pBc0tKenMzd3JTdlps?=
 =?utf-8?B?NUF1U0FDNkt1aDZ2VkRHSWR1VnN3VUxZdVp6ck5sNWVuQmxHQXJHbUFyQmZR?=
 =?utf-8?B?OEwxeW95SWNsaUM5U1BBZTBiWDlJMXBLMWhBU3F6RHpXNGJUVnNpSnY5RzZh?=
 =?utf-8?B?N096ZTkydjI5ci80elFzZGRRcEZkNWhya0ovZ2xGWEEwVGhsRER6U0NZY3Na?=
 =?utf-8?B?WXdOdTg0bnJRTis5Z3ZRTjFyZXRPU3g4MDZHMzZKbHI2R3lHNzV3M09NYnls?=
 =?utf-8?B?SHo4YkRnNENKanErSDhVbEM4WStLdWhXb0dtOHpjVlRnN0VWZUlmVkY4OXRz?=
 =?utf-8?B?NVNrUUYzSFR1cDczN1pkcFRna2drOVRXYTZOOHdmMmtpTjZ0bmxtcGxvZmww?=
 =?utf-8?B?SFNCTHowKy9EUXVESlY5WktjNyszMmNjV2k0N3duMWxnS0kvejBpNWpjOFB2?=
 =?utf-8?B?YTFPa3k1Y0tma3BlT1JVeW5TRUFycWp0QUdJb0g1am0wNm43c3RYMElVUkN3?=
 =?utf-8?B?RFBkUy9YTUFCcjV1c0pnNXBHMzRrV2ZIRUFybGhhK2JRSGVLeFR2VTRCamRs?=
 =?utf-8?B?eGZmVUQwT1poWkphemJub1hUZXg5akZTVy9xSTJIVmFMazBGV1VBdDFLRll1?=
 =?utf-8?B?MEhMYTZYN0txWEFpT3NtelNlZ1NsQm9kTHZwOXpIZWFuRVo4U2Zpd1ZTSG9S?=
 =?utf-8?B?NFRXbndkZEU0OGovY2pvVCtrdElaYTk3VldGZXVJTGllL0JWT3J5Tk1zdWFI?=
 =?utf-8?B?YndFUDc2L0tTdmlFaXZ4NXZsZUJ2SVJlWUt2S01tVFFOcnlxb0FZMGpkcXVo?=
 =?utf-8?B?ZTkwLzZGOHVvL253WFRSZW01Y0c3cGJKMnplbFlwdTVNMStSMW8yakxlSWZQ?=
 =?utf-8?B?ZVNteEJGUmYxM2E2cTZUVmRwMXJDWnhEMXU3QUpCTGFXZHZ1M1ZLTlQ3S1JP?=
 =?utf-8?B?QVlVNXBlNUsvSmp1bCtPeUdpR21RdTVuZHBKMFRTQ1JaZVlxR3QwSk5xL1Vj?=
 =?utf-8?B?QXB5Q2MxZmtXK1VVWnlYYWl6Y0xyYzZHWlpqSHRPbE5KdUhyUC9PWjdCaG5l?=
 =?utf-8?B?SVUrRE1mVGJsbVVnSU9MMUZJQW1rWjJQZFJlNkkyYlBzU3N4WU01Wi9BbTA2?=
 =?utf-8?B?QkYxUXU2blh0bzlzTTFZd1NaTWhwUloxaHRsL0MzQzVJbWxmUmxKSDNONUU2?=
 =?utf-8?B?NTFaZE82VUk5RWpBMUpHUFdkWnZIT1llSXVOcHR1VERpaDh0RWRJdlk3ZTAw?=
 =?utf-8?Q?yZiaOQ5W94I=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10090
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f1d0df41-1bff-45f5-e0e3-08dde0c86f05
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|376014|7416014|35042699022|36860700013|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGVVR2xOMkZnNk85cFBROWlOOGRSNWt4RG5jNW52UG8yTndHcWJ5ekhXR2RR?=
 =?utf-8?B?ZXVxS3JCeWN6d3dBenl6Y0MxNTBGb05GeHh2U2tMTHFYWW5raDk0SnZNQW03?=
 =?utf-8?B?Y3VXTmdtcElGd21IcXkzSkVFLzBhUDJDUjNZSE5uMTh4WWFQK0FGMWJoSHdr?=
 =?utf-8?B?NGQwbjgzOTVNTDZMQ2VIRysvYllVcjROSVdEb1hMWXdaWThuUUpEbkZLWE5G?=
 =?utf-8?B?RkRWMWxRMTVTYzhodXdJKytVWjNkQ0JmZW5wM1VVUnZ6UnJJL09qTlFNbThQ?=
 =?utf-8?B?YjFQeU9QbitWTjBsbXVxK2FVUWYvTWxjZ1gxZVdRQ25FUDlhNUVjYnFHOXY1?=
 =?utf-8?B?bFVmc2MreHVmRHEzL05sdTlHTUxMT09pNVk2d1pyYmNrYlpiOFAxRVc1bFd0?=
 =?utf-8?B?TmNlWU1zbGFKbzJxWDM3eFdONytKQnRNaS8wVkZnOHg2OVhLNkNYSkpZSk9m?=
 =?utf-8?B?S2tPWUtBUFJKSlBmUXczcjlLamp1b2VmcU80eEdybkZ4VC9HbGNMeWFHRi9j?=
 =?utf-8?B?eXc2bjd4NitsTUZCS1pQWXBlc1lqMWcxTWhWeWRoN2Jta3cyZnlkQUpPQTdT?=
 =?utf-8?B?eWtZMHhublFpclVoUStmRmttelV6Nm1FUjl6aXFzTlcvNjROd1Z6bGlSUklU?=
 =?utf-8?B?MEJYWUFUaklSeUpuMzQvWjcxOGU2T1NmaWIwUVg1dEVMUXJoajNObTg1eFdx?=
 =?utf-8?B?YVVmTm1tVEx3bDMwNmtJb29rQ3VKL2RBWGl2UkhpK09VNWhUT1JrSFY1NDhL?=
 =?utf-8?B?SlNHY3RBNklqZzhTUTAxTS9NRUU2YVpZRDlhQ3pONmZrRmVrZTRvdnlYVGZ5?=
 =?utf-8?B?NjMxN1lTWHluaTdjazhENEIzZ0hxbk8rV0VWUjRqc0krTloySU51NEIzYkpp?=
 =?utf-8?B?TEkwMi9NN1lVbzQ2VncwVjg3cTA0WDZFTllISEdza1NHQkt4NFVmQUpDV0tQ?=
 =?utf-8?B?KzdqVlg5bHRVOUVNTm5Ud1h3Ni80VEVXak56d0JyeXVIbGtmQkc1eVV5UTJF?=
 =?utf-8?B?eWUxSmhNSXNLdVVoNXUyV3BWblhQWVcvWGZjbi9UeXVObDB3VHVuaE1DMkcv?=
 =?utf-8?B?VzNXQm1NZ1I2aEc2OVZXVXZQUVIvSGxrcjFHTHZRMzJJQTFOUk44RlU3MVBG?=
 =?utf-8?B?Qko5cmhlcElnQVE1ZFVEbksza3dFSUR1ZG9vRjA2cWd0ejYyZjZ0S3B6N3R5?=
 =?utf-8?B?WE5qajlnTXRnajlzZ3RCNVdYRDM3ZlhITzNOYURRcXc4NlY3SGZrNlMzY3NH?=
 =?utf-8?B?ZEd0L1pUZGo4RmFlcVlQTldMdEhhTjFLQzZ1Vk9yV1pTSWpIMFVLcFdsQ3JX?=
 =?utf-8?B?T2M0MVhNaDFpQVA1TE43N09NMmJQQVlhSHg3dUxiSTZxYW5Xc3A2TlIxb0pO?=
 =?utf-8?B?aHZ3N0t1UTIxS3JDZ1dvS3ZpcUtKY2MzZ1dLT1VRT002K2VqUVRmM2hJaXR5?=
 =?utf-8?B?Q2ROSFhDWVFKL1dwTzdKQUxtenByUFlwbUUrZzRvdHRnR2QwRFBUMUI4VkJl?=
 =?utf-8?B?eEFDajREYmpsQ1czKzVhNFlXTHRST3VKZU1IZytyK280REFxZGJ5Nk5BMkg1?=
 =?utf-8?B?aEhZQ2N5am1tWWp0L21QRmdKcHUxSTNBeWRQTFVvMnRNUDNzeHJueEcwYnQx?=
 =?utf-8?B?VzdBWENKYWRVdGdwNGZLK3NMVi9adjVPZkFZTEZaREhkVEFpcjZSdGlmZTFH?=
 =?utf-8?B?SXZwbm1LSjhBRWc1c3ltYU1QQXVsWUxXTHdwVUdnWlo2SG1MNjh2R0dESUtP?=
 =?utf-8?B?Nkp1cnNmZzk5d3k3M0dMblNsWXc5UHJPQkRVOFY3K1FneWhtSm5aY0hITVI4?=
 =?utf-8?B?dzJmU3FvT3NJbGxuNGNlUGxCeERxWU9tYXVBb0xsNC85QXNtdmlJZnRVa3dw?=
 =?utf-8?B?QTRyZFI2RmRNNVRPaDQrcXcvNDU2ajV6RitNZzgzbm1zY2N2eGtmZkdXY1BO?=
 =?utf-8?B?aDcreFlmZzFib2JyUVFoSFF0QnMyM0VwUGNsUVQ4eWNxd05NSVRzc1NmZlg2?=
 =?utf-8?B?ZERXRWF5eGMyZjNPUEhiY2lVblRPRDYzQlFaQ2JGVGtFMHRYWjVtSjhhN2RX?=
 =?utf-8?B?Z0Y5M1ZnaTB1RVFXQ3d5bDBSTkFqZjZYR1Qydz09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(376014)(7416014)(35042699022)(36860700013)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:36:34.5947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3128edb9-1fd4-41f3-a481-08dde0c882ab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9664
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03964140002
X-Stat-Signature: u8yipqmw5nczxmm6191yzqiaan1ofbi6
X-Rspam-User: 
X-HE-Tag: 1755790597-362276
X-HE-Meta: U2FsdGVkX18xe5s1nMm1bW6PMoFADo36mEBBQAI1QYV6oNSIsyrFvpx82GsTXm3CT9qJqBCagUfNcnVbly6dIJWgH62N0D/g1f+7kLZC9zpLMC92qQy5oVaAuXpHdFftxAqskCrnMcyM6sCBnQXT5E2P+PmKRBHswzjTLZQDyhxPyuC0LMqQFHbDqnYGwu2EBIc93BZCFj5Xbk6pkbf+7tfWYffr6hLpniceZhzP61aoqQxLZP9MJPr24KEQML2zDKmRzGNDwVpa7FwbE2QAxdd1VTu1xEJxFN0aro1/zSonX0IPB7GdpZC4QB1c7PdlN2xGHiJ1wVeCRAaFx2CFSG6muYflUOSzjQzjCKg6NVGnmY/BycO3qDXLu+zFprxMeU+Bn+CKao+JS0wvw1M3rPFp9eLXSggwht1Xvtjx4Roymh42yB/IQU8qroFQC/9Ynl/3CFACDBSPTIipaxI8EhBRFb3ppgseRub0c3LzHcof5S9eXrMKI6cQRf1M0M0gOPNNDAAEawe0jUbtSWQtlY7rCmBmMRh8enxG6W29a3wte2xaLmWSRGpPGXaswljDhfLrAGD5o0w4BVU2V/Y1CrBLbbWuoEVlvZKKHpWH+tjURVk2tCxcbwSw+95kHPiWbaMAGokpT1M1NFzMzUKqcKJgx1UQto7K2ZtLskFacMyYMI6jypYSCZK8SXbKWGfWldMMeKEU9IHEosTr9H+nCxQx6XTt4Lbb2AjMhtqq2tPXUPHuKmYyQ2vTjnwH4BlfvkK4cb2ny3KqERhopVCy6QxlV04Mqp51+2bRQWRTgrxmyguEp1MWtEAGeYwGWNL++e2YI8w1EB23kUgIEXHUaC50POO0ti2K/fNnFKiFxd7aQR13shqC23q+yRSlv3W64c196G7sZ+bw3m3Ep/S5EqF9WP1oA9kNjlj7uy9umNi0rsQl6XgfHfQyKI9iJutn3XiOU6gyQaxhMha6G1C
 PJMQjxCd
 Y7DDxFJfv9Xtm68sM2va08rc94c1S/KmEs5m6IJDnr0UXr1NkcVRq3jpHHFhQ9ncBFKuJ6hcslMDCExhPYJYepugMDOIa18htuvUcrYFcmnmV94rI5JbeFEEM3THihidD1feG9i5yy7Z2Vbngypk6Zor0PIeGT+P1HNRTNP5BRndFGlLDBWDt10nv1LMj58oT9QWAQjYC0/9KYCV4d7s9K/24mjHwH/67o84Mxw58Vr2Y/yhXQglBNLyE9u2mziv1gP9cn361B1HrKee6OPypYEfQvMUizYCyk+nx8nOBBgwcbRY3E+J3iCWK8BdnNjF/bxtfIYZRK5mKMmQ2+je206htVZMalVSyGj/Q7VQaBRvfi/GySMHwf/D8LgwYMaF5k8iwJ/XxFn+P4RPcC4Tnjiu8ptpmOTRB0EkkW6x7ERMSZjv2dLt/l2w/QVFlFC2rl61lvj22iKmYML5Pb6Gom/cNxYccXcc3o9xgVnHKSnWmbUgxwIyMdLefTrdLP7Xeqz+z47vh87JWj+PfgD1EVOoLiljuNF1NnmLU2b8YH3RKXzg4XJ7LVFyP0D59VRNJZBnQ/R2BsvBIWLp9rX/rH2d62Be1l0iIXsyyHOtcPRd90xH7A5FpXbyuH5YxwPmmKULi3e62v2CF3IzgpHqiUmte4IYUFklA58XHO76xkehEJzVNXwvkFFY/o1pziiTuEUl+v/RiQcBIPzQq1yCI5e6UWsTpXQI1NBpkyrcpb6FXql8e+iPdQkDHt+4MiZByHmvM/GgalHZ7x+BZLFfKVqJRxzEXDLQW/Y65aUWq/pwnsuZtirGr7GWaNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 21/08/25 8:30 pm, Usama Arif wrote:
> Using forced_collapse directly is clearer and enforce_sysfs is not
> really needed.
>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
> This was agreed upon in [1]
> [1] https://lore.kernel.org/all/cd99f0f2-260d-4494-bbf6-99daec3e0683@gmai=
l.com/
> ---
>

Makes sense.

Reviewed-by: Dev Jain <dev.jain@arm.com>

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B108DCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556B7900118; Thu, 14 Aug 2025 04:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508B5900088; Thu, 14 Aug 2025 04:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38089900118; Thu, 14 Aug 2025 04:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F991900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:52:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6AEB16056F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:52:00 +0000 (UTC)
X-FDA: 83774745600.09.3CDB480
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013030.outbound.protection.outlook.com [52.101.83.30])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9EC4140003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:51:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZjdJkM84;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZjdJkM84;
	spf=pass (imf09.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.83.30 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755161517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Y4JpBUHraYNVqIAFLYjX/tz8rTXKywlsyDbHNxzFVg=;
	b=CEH5WWYgyNatUFseMKBxRDWwSYH4Pb/H/PVSrA0oCoC3ZEuDcRyZLIkaPSCk9jKvmN37Ay
	p7U3AAOlzJ8Y78wesGaIuPhz8ryBU39j4ALqDL6E2nRH+ni/rn9rhK5Jh8Z/lTt2GCLIBL
	pwM/hsShE+7d36dyE/fTpA7OeMqz+Bs=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZjdJkM84;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZjdJkM84;
	spf=pass (imf09.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.83.30 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755161517; a=rsa-sha256;
	cv=pass;
	b=3NAQdrzHfvA/2AOyKm95Y0B+veMKEEp+iiNPcuupWuFrjTZmXrWoXWi+C9xEcwJlPV7wjB
	+vqzf4uzhJjEIfHiYACobVYyXZU0hM1NkHzrYGIneL1cxpoPKiXFp04raRMgwaC3vpsokx
	qZxZ3ZgtgOnd370pA5J+GgCxkeayMYM=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FXJBEZxSCfCYztv6Ecjg3M6GVIpirk1p8o8B7mrflPes7qb/J+gW6xpo8x86k5uMJRD2qAhJCfOLoD9CN5n9BAYJVn1ayxukv0a0cpHPLVpLfaDBD81wWVOUEWe41Gmcvl6Ft13TYZKzYZjilJDaoPpha+Y6A7DIYh3SiAl7S766TLj9eBRzkzEddQiGMH3fPmBl7FzsCxy8B39tmkQG2E5UEJ0PzDDjhDsznB60TDZDNXRurucre15ZUQnoLdrzT7yNPGEnZ3b1JLOre/YYQTIwomQbQiZ8o5wnm/zFOwDVX29MjGBED7muVSPtzVY/SvX1De2bsPSelieH/DVmuw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Y4JpBUHraYNVqIAFLYjX/tz8rTXKywlsyDbHNxzFVg=;
 b=Wwfv5NlYdWdD8CVEs0O41LYvrF5eoXS5KkqA5upjye3dLaZJIBbNhv7o+zV+WEq9J4Zy2z75JijLMwyH2dxjr+n73X+wvll7TN8XQaa9skb/hxbJik/BAT6HrrAvYVs7HbRZoRluMidRUi4DdI4yiK565S9LbuO9gi4S5sBtRoE+IxePY9MguKWh7aoro7c1aDG5HZVhcXlWiNPac0gscbxFVuf6CTLm7EdRq4IaRKbEjyeHqPaZ1HhEg2xaPmtV+4DIMHFHyNsQS0D2trRslD80mMSm9U+tzrguLEK+85F+xiQQijHK4PfL/wXcH9EILXee+ls2dk4munGtCfaQrA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Y4JpBUHraYNVqIAFLYjX/tz8rTXKywlsyDbHNxzFVg=;
 b=ZjdJkM84JGgsbga0huLUMcTtsurBLe6NonrW7rLTyxjy9N2zCc4DdnCL1QlAf6pot6GaLUSlPmo2zqYtFPz8koAzCj3H3EgoCBU/dLlg4RVe5RGNLA47mFwbOi/+UX47tddS/61/ThiyjwaT0t5EYGNILObeyY92g4xJzFX6sCQ=
Received: from AM9P193CA0017.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::22)
 by AM8PR08MB6561.eurprd08.prod.outlook.com (2603:10a6:20b:368::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 08:51:51 +0000
Received: from AM3PEPF0000A799.eurprd04.prod.outlook.com
 (2603:10a6:20b:21e:cafe::bb) by AM9P193CA0017.outlook.office365.com
 (2603:10a6:20b:21e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Thu,
 14 Aug 2025 08:51:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A799.mail.protection.outlook.com (10.167.16.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.11
 via Frontend Transport; Thu, 14 Aug 2025 08:51:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J4GG4FsX+RLQSlOpDJ9iwbJJb/fc1IrdwjlcblJBJzYS6d/krxa629Fgpq95BVD6IjpWKY9eMCOHWk38kIG/0aHtZwFfKoVSRueI74bXdPRwgHpBVAJJhkaePoYe7cKpXTt2TnDlg2Ri8zVjvt8t5UmKWm19z+uWcQv3u/pQa8nrS2PruHHxpAC2oBfn6lLA0/YCzqPAFk2nsCk3asHNKv1qqJxJMxYCCEAtfbWlbAS8RpHzM9uVW+kZMm6ggDN6+PADLmnR1g3EwFTksNqvJDVz7W0aQPvtsX89zQW0zIWnncytTPTVEANkMI63m1fjK8QsUVtT0nbUnYei08PM4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Y4JpBUHraYNVqIAFLYjX/tz8rTXKywlsyDbHNxzFVg=;
 b=bIxjdJoILSmC+C0GTbgVYKRSpOj9YZYS+JpmO1QsWCy8HSoDdQw6KMnOVlRAkeJ0AnhJ8perJj0LT44AYZbK1KQOGWGoNoroSSaXe6rojm8cqBwYiw/0XvH0vaBCvcqQ9xHO/+qEdFcMf6xO6uYjl8G53wVq+FGKJZ3F7Q/P2YiK9y/2jLh0txI9Amj5s3ZtxqCZ8TDlYUbQKT0XlNO/j26hbvjvJo/WY5Kwyp4jaAfKnrTB0l071tgU+lIea+cSgbHx0sR9nrksyLp3rJT80I6cP+l9QngbFNcE2+9Rhuc4wol5Ko4uA4QSh/WD9GzcIZFEVb1OuNiI9COlRjnkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Y4JpBUHraYNVqIAFLYjX/tz8rTXKywlsyDbHNxzFVg=;
 b=ZjdJkM84JGgsbga0huLUMcTtsurBLe6NonrW7rLTyxjy9N2zCc4DdnCL1QlAf6pot6GaLUSlPmo2zqYtFPz8koAzCj3H3EgoCBU/dLlg4RVe5RGNLA47mFwbOi/+UX47tddS/61/ThiyjwaT0t5EYGNILObeyY92g4xJzFX6sCQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB6668.eurprd08.prod.outlook.com
 (2603:10a6:10:2a9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 08:51:17 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 08:51:17 +0000
Date: Thu, 14 Aug 2025 09:51:14 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: glider@google.com, Marco Elver <elver@google.com>,
	ryabinin.a.a@gmail.com, dvyukov@google.com,
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
Message-ID: <aJ2jgqKYL2C6bUjC@e129823.arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-2-yeoreum.yun@arm.com>
 <CA+fCnZd=EQ+5b=rBQ66LkJ3Bz2GrKHvnYk0DQLbs=o9=k0C69g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZd=EQ+5b=rBQ66LkJ3Bz2GrKHvnYk0DQLbs=o9=k0C69g@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0498.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::17) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB6668:EE_|AM3PEPF0000A799:EE_|AM8PR08MB6561:EE_
X-MS-Office365-Filtering-Correlation-Id: f0fca48f-f4f9-4fdb-47b0-08dddb0fcf9d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|4022899009;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?K3pDcG53cEx2Q2RnQWxRVldPSmd5SXpMeHZYaGFlWUp6T25lNEtsUi85T1Fs?=
 =?utf-8?B?WFY2M0xiTG9TMTVrdmd3cDViY2ZqZ1h6VklUSENZaG5KaHQ1VUxmV29URlBJ?=
 =?utf-8?B?aXV6Qk0xZTk0QzNCcGRIbHhTMUpGbVR6aDZWbmR5aFFlcElETk5kQjd1eWNx?=
 =?utf-8?B?bktqSEJYWEIvMzU1VjN3aG1XM2lsbHFOeUJsOG5ET2dnWDRMT0RQTHlIUCtQ?=
 =?utf-8?B?R3UrMmdZZDl4eUM3Tm5Nanc1bWFTeGpySGhqN1R2L3hNN3pzVVkrcXZIUWRI?=
 =?utf-8?B?UVpEMzJvZTBodGF4MzlZMzcwUGN6TjUyM2FyT0w5TGJZbXdNMjJiK2FScWRM?=
 =?utf-8?B?ODd2NTFBWG9XeU5hLzU5TWRQNkwvL01PbjlVUzhzYXJBMjdMMWVQWUh3TmUz?=
 =?utf-8?B?YXRLZE4yMXJGbHlFbVR2dURsaGN2Q2lRWDhGZTdzQ0RUMUhGMnVvMXVrRVNL?=
 =?utf-8?B?M1lXNS9yd0lDQzF1ZmJlTGE1ZzUwMzREc2ZnYi9BYW9SeXc3OU5pRDl6djJi?=
 =?utf-8?B?ZVJhZExHUUEwZ25yalpnMGZwQnNSYTRuTTUzT3NWbGE4d1UxR043aTFXKzRk?=
 =?utf-8?B?Rm5VZS9QVGhRMDRsMGNYZGF0d3FxYVd3U21NTHBXTmg0aGQ5RU0xaGRlaUh6?=
 =?utf-8?B?K1FySnYwdFZPRTBrOWk3anBrdkdMTW1IbG9lM1ViM0d0Ym9rd3VZNG05YXBJ?=
 =?utf-8?B?VVNDWkF5TFEyRGlqRmUySWVYU2tQQ0lnb1lleVVsQjg5Q0IyaWdWM3pMVk90?=
 =?utf-8?B?ZThHTjVCWFR3eDBpdmw2dVJZZDkzS2p1MjlmQ0JZUnRpdTlXczNySVR5RXNM?=
 =?utf-8?B?R1IySGZZSkRtcUZqZlUvT3ZSdFpkVFlDN3pzc1hRUzlHcDRHSWpIb2dkcUVL?=
 =?utf-8?B?WnNicjdYdFlvR0RXcEJ5YXVrSk5TQmE1WXdzZXlOejZicXJCaW9VMVhNN0Fs?=
 =?utf-8?B?SU5aM0dsbVpDZmhEZ1BuSXhmbGk2SW1PbTV5blBLUFFVN0NJUHl1ZHpGMjUw?=
 =?utf-8?B?cFhoVU1hWHZ5UEd6M1hmUjBxdkw3Q29DQXFIRTdrQ0NGVHRpS05kMUo3WmhC?=
 =?utf-8?B?bFJsRFhrZk1QQUMzYUFjN2xybjI4b3FNRWlQaEZadnUxNit1dDhXM0k5VDcz?=
 =?utf-8?B?VHZIS29yell1TVhOb0pMTGlvaHNRNlZFT0JyT2pxN0VVVGVXV0xxcnhnNFoy?=
 =?utf-8?B?MTRpMjFMOFZsKzl5eDBCZk53bUdtcGNMakc0R21UZFRQcXVyeVFibENITUQr?=
 =?utf-8?B?WjNCbWcwanI5b3R0Mm9vWkUyRDdZZVdkeklVQU81NGp0cFViMnRjZHkwekNh?=
 =?utf-8?B?RWhaaHA1OHlMdjdRNEpXL0pzR0prYmR1MGtqbUZrTEhhQjRuUjVPZDY4K09D?=
 =?utf-8?B?UFVxdGxmTmIxRnBzdndhb3FGbDlLaW96bHRBMzhNcXBGOHN5akJXSEhtdzAx?=
 =?utf-8?B?TUdMSDZWUFhvZGMvNUVPeE9odFI4SGlQY1BHcmZqK1BuTWNCUlJaMXBjNEcz?=
 =?utf-8?B?TnNNZ0RLaDYvMGtNbmx3WDRmUTA5U1lFMkVBN09paGoyV1BPUnZqSmttRDAw?=
 =?utf-8?B?Umhmc1lFekRHQklaWkJNN0J2UVhCdmVON2N3enpBZzExekJIQ3FzUU8yWklB?=
 =?utf-8?B?dlZNRm5sUWVlSzYxZzVCOE5pZE96UlpnNys4eHEzOTl2bzNab0daOUJEcmhO?=
 =?utf-8?B?MW14LzhjcldxaWtnMVFmbmU3MWIzY0lGd1VYa2lVeHNlMFQzMjhHWWFpcXEx?=
 =?utf-8?B?VjJ4L1hEemkvZGI4QlY3TDRROHExWmxpb1ovMWxIY0cwbzZJcUFsWnc4RG1E?=
 =?utf-8?Q?ZVH0QEIGjQQe14jhvFAmEyUdQaUkaoSaW4VVY=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(4022899009);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6668
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	23931878-1818-4808-6071-08dddb0fbb44
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|4022899009|36860700013|1800799024|82310400026|35042699022|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c05xWlZuOERMVG55TE1BaWYwZ2VsM0RuK0FIeDk1WHVLd1d4d0tsZ1RpRjZV?=
 =?utf-8?B?dFZCdUY2NW9HRmkwV0FRSEU3NDBhMHVqdDRKamhJckJQcU1vUVpmUGNWVys2?=
 =?utf-8?B?K0Ntb01idGhHWGx3T25rMkVwY0NrSkdqaVloQXJJMVVNckx6Y0FaczVaZUhu?=
 =?utf-8?B?WFYyWFZXMGJIMyt5czJuYXFRKytJRE5VRURQL2ZLcmVwYUFFbWFuWTM2MU9y?=
 =?utf-8?B?QWhTYjRsYjQyMEJnT2gvZ1ZGNkF5djdzdEdTVVFtanV0Q2xVRy9CN2VpNFZn?=
 =?utf-8?B?QkJrSzFjaUhOdkd3OGp5bC9qNkF6T3ZGMytrM1IwUmZXOUhNMC9iRE1SeHYx?=
 =?utf-8?B?elZWSGEwY2s0S2pLZkhlYWtNbWZ4Rml3VndZK1ZrNjd3VldYUVIwMlR6dytj?=
 =?utf-8?B?Yk9GeFZHN2tiQWwrM2lmQkFISjN3QVlFUGE4TytpNzhramxPMXE5UklwVk5Y?=
 =?utf-8?B?QlI1K0ZncjdNQjdVcXNjSm56U3R4d2lPbDIzVTRlaVFKdFQ3YlpTTm14YVRP?=
 =?utf-8?B?UnV5QmlJN0dlMWNrbWxDT2F1MklWMGNVR1dDbVBhVlNRMHdCb3loYkNGOTM1?=
 =?utf-8?B?bkNtTXRSTU1nL1ZPL2cxNXhWS2s3U1NKUm5OcXJBN091TE11VCt1VFUyTFlK?=
 =?utf-8?B?V2g2a1RlR1R3N0lNaXFNbDkxN09vWExiQ1JKQTMyem1wSVI1Y2J1NlR2eW1S?=
 =?utf-8?B?OGNXYVIxOWEzenJQQ3J0VnFDNllyQlRXNTZXelBMclZ6Z2M4cGZOem42VFJq?=
 =?utf-8?B?WjY4b3ZDcElLQWFYMCtvVmhnb1VpM1hkUmNBR2RvVzJ0djlDUjZETmpNLzZO?=
 =?utf-8?B?em9qTlhDODNFTFZucG4xd0xscVlJUEM3blpyd3hQRFAvUGJjaitQU3ZjWGRl?=
 =?utf-8?B?NnpLdkNjN2RuT1Z4WVFpR00xRGpaS2dSVWZ2MmxZbFlZd3Jka2hlLzNpRTNT?=
 =?utf-8?B?dFBKbzhTdTd6TnprOG1CYy9sbVVua0NSZmNIWlF4RTNjTWVpWFowYXI4bUNI?=
 =?utf-8?B?MjhMTlJHRzNKem14Q0xGU3FYNGRiTnVJTS82eDdYZHNZV1lpQXZPcTJUSERC?=
 =?utf-8?B?ZGZQQ0RJRkhHZmhXZVdYQWZTTTlQVUJnSnlaRkJwOHVEN01pejlHSmxPSWN1?=
 =?utf-8?B?U1NnZkN1QVVXYllTdFp0UmF2ZnFtYkFGYXFTTk81VXBsWitPUTZMVFVaM1RF?=
 =?utf-8?B?T09PYlMxZkwvTnRDZ2RLS2V2VFgrdFRNbHEyUjlKaDF2SmxXdnRsVG1Wa2Nx?=
 =?utf-8?B?a2pQeExQUFZzYmIyNXdRVXZaeHFEak1EQTQwWnlRbU1VRDdzLzBlaWMrRmpo?=
 =?utf-8?B?aUdEUWFyNDZ2WnQ5SnVpSHlOOVM5ZHZiMEV5a3JtSTErY25IYzdmZ3FZWFJl?=
 =?utf-8?B?R0lFOWtsUGEwMjMzWnF1QnhkQkZ0d1o1dG1FeFZ3ZzU3eTdHL3o4NGNRTUN3?=
 =?utf-8?B?dlVZTjFuY2NDeWRMaW14Y0IvV0Y1RVAxYS9EOXdmT2R2QnkvQjJSM3RyK3N3?=
 =?utf-8?B?TmNhK1ZvRCt1SDlaMTVnRmhqeUlncGo4cDVtUEo3UE1yNGxuaXNtNG9SVkFo?=
 =?utf-8?B?aUZGQlRnT1BVYStlUlhZWi9KSEZ4YXlNNUFPUWJ2dVdIMUNUNnZTRU9wS1B1?=
 =?utf-8?B?K1JmVXhlYzE2T3Q1NmpiZUFUZHpYa01oRnIrVXJIRHZ6M1QyY3hQRU5ZeTJO?=
 =?utf-8?B?dzVzdnB0QnF1Z3pxQnpzcmpGSjl1RGtWMGNycnNXWFZFY0t1U1Q2YlV5ZTBD?=
 =?utf-8?B?SFo3WEVFdXhnQWtOOHpVVmh6V09VbFlFYWI1WmNXa3AybjJwYmo3aWVsWGox?=
 =?utf-8?B?UU5ibFJ6Ym40NkliRzZ6YnlZeWNuN0hXN2lqeEJEMEtjclExZ2VOT3BvNWhG?=
 =?utf-8?B?WGNvTGRTL3BtcHFENUdXSDhBMWttWlIxRjBJeWhKWjJZTGphbm96RXpzOGV4?=
 =?utf-8?B?R3dKME9ndVVZQk5wa3BOc0tadE1xbXpmZXo5VkJSRUdib215UGg1Q2dyQzZr?=
 =?utf-8?B?NWJ5V2tTZHBBPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(4022899009)(36860700013)(1800799024)(82310400026)(35042699022)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 08:51:50.9757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0fca48f-f4f9-4fdb-47b0-08dddb0fcf9d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6561
X-Rspam-User: 
X-Rspamd-Queue-Id: C9EC4140003
X-Rspamd-Server: rspam06
X-Stat-Signature: u4brqpdpnek6a48sadw5s1dmkespzxk5
X-HE-Tag: 1755161516-124813
X-HE-Meta: U2FsdGVkX1/RYN+yse6Zt02mGOvRncHQGRVCLnydxS1uH9kSggX/nQuTb3+pi7cm5RHZLWn0Xnim32KFqeYAOUjtSOxkKKV6ggdCi6wpfUUIRkmBX6aAy5xSlNiW7Ia8H+oIo0RYvKodyelgSrEn6L17KN+E1oISOAvUvVm2FIvq/fhGJRnBc2RvnoouuvQ5QolwKgIrFJja0uVCyZmOTo4ibo3MfJ/Zkg8pFWXvnV7t6QSS9fB/VAsNT6J8JXYPp0cpEbJ5RwtcpRe5I2tSSmRVkzahFCJ4VmSdfsP9FX6PGcJz5SIDTtJiS6VwnLKfvFFJ5qco9wywlQnv2OCVMUDUFyD+kF9vhqeQvUmGCqGECmvv9YYGiEJF0LD+LEB8OzEQVy+fxTeErbDyY8MnyUQisftLuKzU0oe4FkRBmXA49YHqjpiRHXxLL8dxvDoUjumSl5uG32TAVQ4Rk3iQtwkZizQ1nend6msmMr8Tj7/dMEhGYgF0RlY6sLYyodz8ItH5H/QwEBaOhbVGK89vlcEY32xa833jOzD/ifwmYW+IULD2CaSES+H5Iv5Wl0hzmUoq4KqsluxCM1FFx3GHQAJw37AWpdBr1WhuZgknopyoJOSBbGwoG0Ac72hO83RnX7Y1rwlHBfFU8Aupbp0gxWITG8/x35+/HouPVirJ/NSnQTc+EIui/6FDgG24wdbCObcLY12DOo/De2L5dwdU+ybtbP7BlnGZP4Y96I8e2rYKmDtE3b4xWbuGt6+aFPafbIF6LN1tc1oJ/IYxXPtMrlUc4fnmZk5SypX/h7QZpErwk/7NdvMg2jQ7RdfIl1kXp9RV+jW1bhSELtivIeC2UHSicAoVO0udQfIdQ6OaovhxtDVYKFkwne6Ls+qVVeIKMD/ZK8G/d+lEDTWUpinTZ4UInNOhkepZbfpPE+ZZS0fX+9FqlSHGW/pst6SyyvenfWf1ZJ+BNVxgxFoENYl
 Vj8yjniD
 5pq5ZdXaNlhTVzNTXEBlGC3g+/ft3o6n1W1DVw7ymnSWugH24dvirFJAfkIZj8oJF/t58S8WgfrV7bhiKs+tOujeFxLBSPTr2ZZZm24P6qAFXdzSjaxr9uglunuwTV10N/WNn5SH//V1rV7VcKDeJCncfjVep6DPoAYNTwA9dyXq0WnToy+IBjhmmCCvo2kTrs7t7jJ+5V/rHC5AfLXVfqWSj3hgCe88+neubiHhdk7rTw5cs4dSnIW/5zt+CIcRIGdf0bXPvg2Q/l393CaPxBtjL2Adfj/p3NBxK+pxp1mfCIwXMe2rpazs8LlNKvV8wiNw7Im6vBmY4s8GXqc6iduMuv4BH7rtSzqtGWnODP+00QoUotPZaVpfr3EnZdQyBZAEI7axn1WZ6Qo+BZNZLGG5hof1Ivw0Lam7uih9dttn9yqJXlw8zbynf1VL8OzImhDV8RCFIHJ+1SQg5pDDfOsOR3MS0BosvIAla7Xuh7OspIjHq/ehMRcpsYDtsdwEakrJCHs9HsgbZI18Q36Jx/kWDazkyaSRVKx1kxLwqIjxqrwkLFptFsFT6xR/UfJFTgK6kz/cX9kDWnWAaGYHaLiCW/WVSUxiEEyI3c0LWmgv3GL5NwxDtVxQEM3lK6jsMR2nPkmYJ8ef5d7i4OPoaShOiB3NZ7sV7kQOSLqQogldRnmajfRvcSKarxEgVj6B0aE9ci1ucLbRlvgOY4YwDB4yX7pqaxSCXulUxzD9ADWE1Du/gTHbTB/oGkAroypdg2HGcuk9iZSd1gCagULVEtl0o9UxJD+/1yT9gRec7m1dQpcyayMnjSrbuNZrC40L9cGPaesQViYbheEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,
> On Wed, Aug 13, 2025 at 7:53 PM Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> >
> > Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> > raise of tag check fault on store operation only.
> > Introcude KASAN store only mode based on this feature.
> >
> > KASAN store only mode restricts KASAN checks operation for store only and
> > omits the checks for fetch/read operation when accessing memory.
> > So it might be used not only debugging enviroment but also normal
> > enviroment to check memory safty.
> >
> > This features can be controlled with "kasan.store_only" arguments.
> > When "kasan.store_only=on", KASAN checks store only mode otherwise
> > KASAN checks all operations.
>
> I'm thinking if we should name this "kasan.write_only" instead of
> "kasan.store_only". This would align the terms with the
> "kasan.fault=panic_on_write" parameter we already have. But then it
> would be different from "FEATURE_MTE_STORE_ONLY", which is what Arm
> documentation uses (right?).

Yes. it uses "MTE_STORE_ONLY". but, write seems fine for me too.

>
> Marco, Alexander, any opinion?
>
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  Documentation/dev-tools/kasan.rst  |  3 ++
> >  arch/arm64/include/asm/memory.h    |  1 +
> >  arch/arm64/include/asm/mte-kasan.h |  6 +++
> >  arch/arm64/kernel/cpufeature.c     |  6 +++
> >  arch/arm64/kernel/mte.c            | 14 ++++++
> >  include/linux/kasan.h              |  2 +
> >  mm/kasan/hw_tags.c                 | 76 +++++++++++++++++++++++++++++-
> >  mm/kasan/kasan.h                   | 10 ++++
> >  8 files changed, 116 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
> > index 0a1418ab72fd..fcb70dd821ec 100644
> > --- a/Documentation/dev-tools/kasan.rst
> > +++ b/Documentation/dev-tools/kasan.rst
> > @@ -143,6 +143,9 @@ disabling KASAN altogether or controlling its features:
> >    Asymmetric mode: a bad access is detected synchronously on reads and
> >    asynchronously on writes.
> >
> > +- ``kasan.store_only=off`` or ``kasan.store_only=on`` controls whether KASAN
> > +  checks the store (write) accesses only or all accesses (default: ``off``)
> > +
> >  - ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
> >    allocations (default: ``on``).
> >
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index 5213248e081b..ae29cd3db78d 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -308,6 +308,7 @@ static inline const void *__tag_set(const void *addr, u8 tag)
> >  #define arch_enable_tag_checks_sync()          mte_enable_kernel_sync()
> >  #define arch_enable_tag_checks_async()         mte_enable_kernel_async()
> >  #define arch_enable_tag_checks_asymm()         mte_enable_kernel_asymm()
> > +#define arch_enable_tag_checks_store_only()    mte_enable_kernel_store_only()
> >  #define arch_suppress_tag_checks_start()       mte_enable_tco()
> >  #define arch_suppress_tag_checks_stop()                mte_disable_tco()
> >  #define arch_force_async_tag_fault()           mte_check_tfsr_exit()
> > diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
> > index 2e98028c1965..3e1cc341d47a 100644
> > --- a/arch/arm64/include/asm/mte-kasan.h
> > +++ b/arch/arm64/include/asm/mte-kasan.h
> > @@ -200,6 +200,7 @@ static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag,
> >  void mte_enable_kernel_sync(void);
> >  void mte_enable_kernel_async(void);
> >  void mte_enable_kernel_asymm(void);
> > +int mte_enable_kernel_store_only(void);
> >
> >  #else /* CONFIG_ARM64_MTE */
> >
> > @@ -251,6 +252,11 @@ static inline void mte_enable_kernel_asymm(void)
> >  {
> >  }
> >
> > +static inline int mte_enable_kenrel_store_only(void)
>
> Typo in the function name. Please build/boot test without MTE/KASAN enabled.

Oops... Sorry for mistake :\

>
> > +{
> > +       return -EINVAL;
> > +}
> > +
> >  #endif /* CONFIG_ARM64_MTE */
> >
> >  #endif /* __ASSEMBLY__ */
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 9ad065f15f1d..7b724fcf20a7 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -2404,6 +2404,11 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
> >
> >         kasan_init_hw_tags_cpu();
> >  }
> > +
> > +static void cpu_enable_mte_store_only(struct arm64_cpu_capabilities const *cap)
> > +{
> > +       kasan_late_init_hw_tags_cpu();
> > +}
> >  #endif /* CONFIG_ARM64_MTE */
> >
> >  static void user_feature_fixup(void)
> > @@ -2922,6 +2927,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
> >                 .capability = ARM64_MTE_STORE_ONLY,
> >                 .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> >                 .matches = has_cpuid_feature,
> > +               .cpu_enable = cpu_enable_mte_store_only,
> >                 ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
> >         },
> >  #endif /* CONFIG_ARM64_MTE */
> > diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> > index e5e773844889..8eb1f66f2ccd 100644
> > --- a/arch/arm64/kernel/mte.c
> > +++ b/arch/arm64/kernel/mte.c
> > @@ -157,6 +157,20 @@ void mte_enable_kernel_asymm(void)
> >                 mte_enable_kernel_sync();
> >         }
> >  }
> > +
> > +int mte_enable_kernel_store_only(void)
> > +{
> > +       if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
> > +               return -EINVAL;
> > +
> > +       sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
> > +                        SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
> > +       isb();
> > +
> > +       pr_info_once("MTE: enabled stonly mode at EL1\n");
> > +
> > +       return 0;
> > +}
> >  #endif
> >
> >  #ifdef CONFIG_KASAN_HW_TAGS
> > diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> > index 890011071f2b..28951b29c593 100644
> > --- a/include/linux/kasan.h
> > +++ b/include/linux/kasan.h
> > @@ -552,9 +552,11 @@ static inline void kasan_init_sw_tags(void) { }
> >  #ifdef CONFIG_KASAN_HW_TAGS
> >  void kasan_init_hw_tags_cpu(void);
> >  void __init kasan_init_hw_tags(void);
> > +void kasan_late_init_hw_tags_cpu(void);
> >  #else
> >  static inline void kasan_init_hw_tags_cpu(void) { }
> >  static inline void kasan_init_hw_tags(void) { }
> > +static inline void kasan_late_init_hw_tags_cpu(void) { }
> >  #endif
> >
> >  #ifdef CONFIG_KASAN_VMALLOC
> > diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> > index 9a6927394b54..c2f90c06076e 100644
> > --- a/mm/kasan/hw_tags.c
> > +++ b/mm/kasan/hw_tags.c
> > @@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
> >         KASAN_ARG_VMALLOC_ON,
> >  };
> >
> > +enum kasan_arg_store_only {
> > +       KASAN_ARG_STORE_ONLY_DEFAULT,
> > +       KASAN_ARG_STORE_ONLY_OFF,
> > +       KASAN_ARG_STORE_ONLY_ON,
> > +};
> > +
> >  static enum kasan_arg kasan_arg __ro_after_init;
> >  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
> >  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> > +static enum kasan_arg_store_only kasan_arg_store_only __ro_after_init;
> >
> >  /*
> >   * Whether KASAN is enabled at all.
> > @@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
> >  #endif
> >  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
> >
> > +DEFINE_STATIC_KEY_FALSE(kasan_flag_store_only);
>
> Is there a reason to have this as a static key? I think a normal
> global bool would work, just as a normal variable works for
> kasan_mode.

Just for align with the other arguments.
since the kasan_flags_store_only is used only for kunit-test,
not called in any other place, this optimisation is meaningless.
It's fine to change as global bool.

>
> > +EXPORT_SYMBOL_GPL(kasan_flag_store_only);
> > +
> >  #define PAGE_ALLOC_SAMPLE_DEFAULT      1
> >  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT        3
> >
> > @@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg)
> >  }
> >  early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
> >
> > +/* kasan.store_only=off/on */
> > +static int __init early_kasan_flag_store_only(char *arg)
> > +{
> > +       if (!arg)
> > +               return -EINVAL;
> > +
> > +       if (!strcmp(arg, "off"))
> > +               kasan_arg_store_only = KASAN_ARG_STORE_ONLY_OFF;
> > +       else if (!strcmp(arg, "on"))
> > +               kasan_arg_store_only = KASAN_ARG_STORE_ONLY_ON;
> > +       else
> > +               return -EINVAL;
> > +
> > +       return 0;
> > +}
> > +early_param("kasan.store_only", early_kasan_flag_store_only);
> > +
> >  static inline const char *kasan_mode_info(void)
> >  {
> >         if (kasan_mode == KASAN_MODE_ASYNC)
> > @@ -219,6 +246,20 @@ void kasan_init_hw_tags_cpu(void)
> >         kasan_enable_hw_tags();
> >  }
> >
> > +/*
> > + * kasan_late_init_hw_tags_cpu_post() is called for each CPU after
> > + * all cpus are bring-up at boot.
>
> "CPUs"
> "brought up"
>
> And please spell-check other comments.

Thanks.

>
> > + * Not marked as __init as a CPU can be hot-plugged after boot.
> > + */
> > +void kasan_late_init_hw_tags_cpu(void)
> > +{
> > +       /*
> > +        * Enable stonly mode only when explicitly requested through the command line.
>
> "store-only"
>
> > +        * If system doesn't support, kasan checks all operation.
>
> "If the system doesn't support this mode, KASAN will check both load
> and store operations."

Thanks for suggestion :)

>
> > +        */
> > +       kasan_enable_store_only();
> > +}
> > +
> >  /* kasan_init_hw_tags() is called once on boot CPU. */
> >  void __init kasan_init_hw_tags(void)
> >  {
> > @@ -257,15 +298,28 @@ void __init kasan_init_hw_tags(void)
> >                 break;
> >         }
> >
> > +       switch (kasan_arg_store_only) {
> > +       case KASAN_ARG_STORE_ONLY_DEFAULT:
> > +               /* Default is specified by kasan_flag_store_only definition. */
> > +               break;
> > +       case KASAN_ARG_STORE_ONLY_OFF:
> > +               static_branch_disable(&kasan_flag_store_only);
> > +               break;
> > +       case KASAN_ARG_STORE_ONLY_ON:
> > +               static_branch_enable(&kasan_flag_store_only);
> > +               break;
> > +       }
>
> Let's move this part to kasan_late_init_hw_tags_cpu. Since that's
> where the final decision of whether the store-only mode is enabled is
> taken, we should just set the global flag there.

Okay.

>
> > +
> >         kasan_init_tags();
> >
> >         /* KASAN is now initialized, enable it. */
> >         static_branch_enable(&kasan_flag_enabled);
> >
> > -       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
> > +       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s store_only=%s\n",
>
> Let's put "store_only" here next to "mode".

Hmm, I think it's not a proper place to print store_only in here.
I think it would be better to print log related store_only at
kasan_late_init_hw_tags_cpu() like:
    print_info("KernelAddressSanitizer checks store(write) access only.\n");
When store_only=on.

>
> You're also missing a comma.
>
> >                 kasan_mode_info(),
> >                 str_on_off(kasan_vmalloc_enabled()),
> > -               str_on_off(kasan_stack_collection_enabled()));
> > +               str_on_off(kasan_stack_collection_enabled()),
> > +               str_on_off(kasan_store_only_enabled()));
> >  }
> >
> >  #ifdef CONFIG_KASAN_VMALLOC
> > @@ -394,6 +448,22 @@ void kasan_enable_hw_tags(void)
> >                 hw_enable_tag_checks_sync();
> >  }
> >
> > +void kasan_enable_store_only(void)
>
> Do we need this as a separate function? I think we can just move the
> code to kasan_late_init_hw_tags_cpu.
>
> > +{
> > +       if (kasan_arg_store_only == KASAN_ARG_STORE_ONLY_ON) {
> > +               if (hw_enable_tag_checks_store_only()) {
> > +                       static_branch_disable(&kasan_flag_store_only);
> > +                       kasan_arg_store_only = KASAN_ARG_STORE_ONLY_OFF;
> > +                       pr_warn_once("KernelAddressSanitizer: store only mode isn't supported (hw-tags)\n");
>
> No need for the "KernelAddressSanitizer" prefix, it's already defined
> via pr_fmt().

Okay.

>
> > +               }
> > +       }
> > +}
> > +
> > +bool kasan_store_only_enabled(void)
> > +{
> > +       return static_branch_unlikely(&kasan_flag_store_only);
> > +}
> > +
> >  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
> >
> >  EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
> > @@ -404,4 +474,6 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
> >  }
> >  EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
> >
> > +EXPORT_SYMBOL_IF_KUNIT(kasan_store_only_enabled);
> > +
> >  #endif
> > diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> > index 129178be5e64..1d853de1c499 100644
> > --- a/mm/kasan/kasan.h
> > +++ b/mm/kasan/kasan.h
> > @@ -33,6 +33,7 @@ static inline bool kasan_stack_collection_enabled(void)
> >  #include "../slab.h"
> >
> >  DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
> > +DECLARE_STATIC_KEY_FALSE(kasan_flag_stonly);
>
> kasan_flag_store_only
>
> Did you build test this at all?

Yes, But there is no place where directly use kasan_flag_stonly,
I think I miss it. Thanks!

>
>
> >
> >  enum kasan_mode {
> >         KASAN_MODE_SYNC,
> > @@ -428,6 +429,7 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
> >  #define hw_enable_tag_checks_sync()            arch_enable_tag_checks_sync()
> >  #define hw_enable_tag_checks_async()           arch_enable_tag_checks_async()
> >  #define hw_enable_tag_checks_asymm()           arch_enable_tag_checks_asymm()
> > +#define hw_enable_tag_checks_store_only()      arch_enable_tag_checks_store_only()
> >  #define hw_suppress_tag_checks_start()         arch_suppress_tag_checks_start()
> >  #define hw_suppress_tag_checks_stop()          arch_suppress_tag_checks_stop()
> >  #define hw_force_async_tag_fault()             arch_force_async_tag_fault()
> > @@ -437,10 +439,18 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
> >                         arch_set_mem_tag_range((addr), (size), (tag), (init))
> >
> >  void kasan_enable_hw_tags(void);
> > +void kasan_enable_store_only(void);
> > +bool kasan_store_only_enabled(void);
> >
> >  #else /* CONFIG_KASAN_HW_TAGS */
> >
> >  static inline void kasan_enable_hw_tags(void) { }
> > +static inline void kasan_enable_store_only(void) { }
> > +
> > +static inline bool kasan_store_only_enabled(void)
> > +{
> > +       return false;
> > +}
> >
> >  #endif /* CONFIG_KASAN_HW_TAGS */
> >
> > --
> > LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> >
> > --
> > You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250813175335.3980268-2-yeoreum.yun%40arm.com.

--
Sincerely,
Yeoreum Yun


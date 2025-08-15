Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE6CCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75DEC6B00F9; Fri, 15 Aug 2025 09:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E84F8E0003; Fri, 15 Aug 2025 09:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF236B0109; Fri, 15 Aug 2025 09:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 453256B00F9
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:52:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2A8D815AC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:52:31 +0000 (UTC)
X-FDA: 83779131702.11.398BA17
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011000.outbound.protection.outlook.com [52.101.70.0])
	by imf07.hostedemail.com (Postfix) with ESMTP id D6CC240003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:52:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=h+yk7oRL;
	dkim=pass header.d=arm.com header.s=selector1 header.b=h+yk7oRL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.70.0 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755265948; a=rsa-sha256;
	cv=pass;
	b=dIQEtz+WNGi6RbHncY3Zmn3ls89Oruyyl6msVbyTm5LGRALpmkZmZMIVLZH10v1yFHhlt7
	oiPFjZ7YsI3bHLg3snD2Roixg9SfTdyuGWmZMbI8ZUVReRXPLwtHNwbPj5JZlPCiOR32p4
	9DU5DM3z1Bkq1T3EbH+6jYl56T0rgZk=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=h+yk7oRL;
	dkim=pass header.d=arm.com header.s=selector1 header.b=h+yk7oRL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.70.0 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755265948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCRhv/I68s4f62iqEFDB0hO6yTgdfs8DgQ+YMwzm/Ps=;
	b=umz4yxjUiRkq3EAEh5wgPIVgDmYc5OEezRuOQY8Lyprfq0l+LMhbfS7LyxRpqjZVZSf7Aq
	ceBDSODDH41vfvmu0Hsm3UC70hu1xUF4tPLjj54Alsioo8+DJzaqEVqbqCZc7mgQPHB3sn
	AlvYa9RWEal1mzf4uNjvqKRyWgDUHY0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fH7MOu+iwXh7k3qGfmMfAx4cIWUnCy2smeTdC7SsCFUvEAJZnEJ8FN8gcd0J87diMeEdDLDEJUskWX1DZ1mz7C5IZ9WJOl3Zfl293j52wfi35SU02AB5L57iC8Ns8bBkGHknbH965OiCusz2EZd2CfwGmh03lgB8recuK7FyfGz86ykMw/GzDLNOonqa4jQvGFPIBLLFxUxzNn+h6KVtN0izN3kypwypmoilzb4iiKjL0vTWlLl0mAQnBumaakFu7ju9UKUYBiWMewgb25zxw1IZwAHeo3cGFVSkHmt6q9I9KQ8d96r++yn+eirSOl/drVeHg1VCmJEWQwKqQXw4gg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCRhv/I68s4f62iqEFDB0hO6yTgdfs8DgQ+YMwzm/Ps=;
 b=FxXRH4uwTOWzFk7wFmj/JF+47RA7472UBkQXbIpuA7v+ZnPq4ejfapeej07cV+paVRiqCZCGIxAsqiE/TEVjZsUHsgjwPuHIHd5SdSin440kMUPk0w7okGP0YVxHPM0fGD4yahIj8PHoHHk3vDp5VBY22OduRQBMUhKjbDR7k9K6YYlRCqlU+apRuttcVA+kxPWjzx62Kh2ar/0IPfjowRsqBEALORteALyovj4p6QXtSv7zmFavQ7+qYXtZJQNoNfiEKxpAL9hg+HE3FMO1mOq41LLrXXrWcrK6lOzgrkfjESgr6JJ1Ne5LiUXiz+zNgUcnxTTj6CfUO26ARMXZLQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCRhv/I68s4f62iqEFDB0hO6yTgdfs8DgQ+YMwzm/Ps=;
 b=h+yk7oRLVRIO67Xp6aL13KyF+aT9rJ49oskce/kp609JjN/mK0WrWCQrOpI1HirBDIC7EPhwT1ZIXCsyXD+f2PcjAMEp31F7vUeoTZBHKux9CEy1eDwDec5Xxh9z249WlXvgUxlVlxty5xE84TnqThv3CbqqhIKm4qPOZtHh0o4=
Received: from AM9P192CA0005.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::10)
 by AM8PR08MB5604.eurprd08.prod.outlook.com (2603:10a6:20b:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 13:52:22 +0000
Received: from AMS1EPF00000041.eurprd04.prod.outlook.com
 (2603:10a6:20b:21d:cafe::ec) by AM9P192CA0005.outlook.office365.com
 (2603:10a6:20b:21d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Fri,
 15 Aug 2025 13:52:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000041.mail.protection.outlook.com (10.167.16.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.11
 via Frontend Transport; Fri, 15 Aug 2025 13:52:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBxmEKYS8OeQm2X/f+dRI71HytlQuc3HBepbnrRT4YX67aExfkkq7k+EU77U3qj5IWAMNw/iGrrU3C1r3gCC5qxE7LgeOQr1iys2Du7VPREXVIjiCoMz5oh3N7ICBj+LrhzAJ9ynPFjwzNkOCgAkCnAVR8QSD1TmcnHwNNHoBdqF2IckUQWxk3v3BXkVuycRVoYGSEbTzkV0e+GPx/KlzYJ5Bo/iLz6H7wWBls32c7fM4FDrTI2lniJNAQezv3rRmhnfw/WwMC8NKrA/ZEcJy0J4bo6A1M4hCV8sjeRrY569vjJBYSDZTSJcjhbBWahc+4wt1r79Oft4SE/01bTPYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCRhv/I68s4f62iqEFDB0hO6yTgdfs8DgQ+YMwzm/Ps=;
 b=yq++zZsdO0/tGjvGRxAM8Q0x2KhGEUbfza45SBJ62H5lkZgyJtHEpHjD6d02XpCBikir14WrHKCdxmNNtCt1SNSPdmDy97vb1yH7PFUZ7s0uHVfY5a37DMi96SJAShj55MMJlqyGMstkWL9p8fUqRiWPT4gc0g9gWICJ9jUgLI29do2w3QsqUW3hxrh11MHxUD/bF+treuKFa8fKd/hMLfW+B7BZ3hhrNEs2961YH5MLSONhumoiTJ6uHcYTkw4zR40zzg1OEtbrvu9CFPXWYySzKwYxS7wK0WI2glTj+EAl0zFs6NR7tWQM5iYPAJapmyOfC5qmazcdQDuCebviCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCRhv/I68s4f62iqEFDB0hO6yTgdfs8DgQ+YMwzm/Ps=;
 b=h+yk7oRLVRIO67Xp6aL13KyF+aT9rJ49oskce/kp609JjN/mK0WrWCQrOpI1HirBDIC7EPhwT1ZIXCsyXD+f2PcjAMEp31F7vUeoTZBHKux9CEy1eDwDec5Xxh9z249WlXvgUxlVlxty5xE84TnqThv3CbqqhIKm4qPOZtHh0o4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB11148.eurprd08.prod.outlook.com
 (2603:10a6:150:1f4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 15 Aug
 2025 13:51:48 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 13:51:48 +0000
Date: Fri, 15 Aug 2025 14:51:45 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
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
Message-ID: <aJ87cZC3Cy3JJplT@e129823.arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-2-yeoreum.yun@arm.com>
 <aJ8WTyRJVznC9v4K@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aJ8WTyRJVznC9v4K@arm.com>
X-ClientProxiedBy: LO0P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::12) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB11148:EE_|AMS1EPF00000041:EE_|AM8PR08MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d954e59-041c-4523-915f-08dddc02f496
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?enNsclhUSjl4UFNHcU1mTG5wVGRIUzZFMEpFdFFDb01MRGhibG9rN01IVHA5?=
 =?utf-8?B?dFdUaGdqV0hxVVR4d3psMW5Xdy9qMDFUZjg1Y1JMMTY4bUEycmtGYzV3alZI?=
 =?utf-8?B?dU9vMWd2ZW9FVk1RcXF1eGRKOVF5V2VDYzdYaUhidFA1dTBGVXlzMWVPMjhD?=
 =?utf-8?B?dVVpMEVpZ2xmUHpNL2Z4N2VnTGZQZGRMTVJCOXdnZmZ0Wng2NENXa013cERm?=
 =?utf-8?B?VlRpeTNhQ1cySnlMWkg5cFpsOVJlOEZoR2dnYVpOWS9Rd0x5bjdsa2Zabkll?=
 =?utf-8?B?YmFFQXpFVFVOcVh6VDlmdHZKUlp6eHVNSDBHZXROYkRybmk1ODByaFAzdm9h?=
 =?utf-8?B?VG8zbEkza1l2V1ZHYnhhWG8rVTkvdnF0Y3VJSDk3VFhuQkNTUGREMWdvb3BY?=
 =?utf-8?B?Z0xCSUlQemRDMXZnZUV1aGoxRzBmekhpN2JkOTBLSThQdnNvcDlVKzRUdmV1?=
 =?utf-8?B?b012VCtRT1M2aHdhbXFmbGdRVUZ2d1dOdXFQeFF3M1JZai96cStJRm9qL2hn?=
 =?utf-8?B?MEtVamNBUmVrN2ovc3ljbjlvMHpVTmg1aXJFdGFCKzczWGJBbHlCbTlpWVlZ?=
 =?utf-8?B?bVMvZlpCM1BvVGFhTFN2VmVFRk5Fdk1xQTM5MDIzTTRFTm85eDVNOUFXTUQz?=
 =?utf-8?B?c0NLTXRZUXBybnBMUlR3d0Z4UHp3eFBkOXQ0NTNFUzZTVDhOUTlKbWlIdmNK?=
 =?utf-8?B?bEZBSHVoK01OdlhyL1ZXaDFNTGJuc2dDTG4vVGlDREEvTCtDUmtrU2hvckhV?=
 =?utf-8?B?RUJtY0dBZCtYQXkrMmx2UFVIZTg3T1Y0K0FJNTB1NDg0dURxNERHNGwzemtG?=
 =?utf-8?B?alpkMUVZWGowSGNEVGN6Um5renFNN0xQZHk1cG5Pa3pCNS9kajlTZWsvd1E1?=
 =?utf-8?B?a1dkVWtwc2dOZTlUbDlRVU80c3JhSkVNbGI3WkkrcEtjd0V2NnRUSUs2QjlH?=
 =?utf-8?B?c2E2UHl1MHRpVHo2WHUxZU1ud0k3aXUzcVpvNThKQkdlemNjbWhiSWpVenZl?=
 =?utf-8?B?dEErOEtrQk1mVTFUNEZ1U1B6YTRpaWcrVGMwemRVdk1qd2lkQmxVR29Uc25N?=
 =?utf-8?B?U1VKNlJ1ekpKR1ZJYlFiYUp4a28wTVZuMnc4SU5IcTFNZmtYSDFMUlE1UmNn?=
 =?utf-8?B?bEhueEhKN1NCMlVLb0t3aEdwY1o1OHZadGord2pZTzRxQy85TEp5MVAraU5J?=
 =?utf-8?B?b2pZa0pnV1FjaEtVM3BvTFMxU1B6NytCQXZaSnd6cHlzTy8wT3dMWFRMN2dX?=
 =?utf-8?B?ZnFXM2UzZVZUTTNydTlXaUsyWk9oRzhSK2JEWXVMR1RkNSs1THpadXRLS1ZB?=
 =?utf-8?B?VWNINVprOHFUcndNNExYa0g5NGxqdG5sSmVKczR3ZzBCczhONFJVK1dUdk0r?=
 =?utf-8?B?bm9zbEIzMmJIVDhEM0owQ2ZtMC85dEo5c2tscDNZSTQ5RHNZMk1HZm81Q2xj?=
 =?utf-8?B?VXh5UE5USS9qaFRINjNNU015UGtHS0VHbjczQ2Vjd1Z1NUhRMlFIQXdjaDRO?=
 =?utf-8?B?aHFsSTJEMXlIOU5BQitPWEMvRTRZR3FGTWdBcTc4aWRGOS9Lbkx2TzZSdGxv?=
 =?utf-8?B?enNhRGNleW1nWC9nSDVITWg2cnlIZUVhRy9jeWlyOHI1S3o3RCtSRjdhdWw1?=
 =?utf-8?B?RVdKdSt3cUZGcmtzWC9ub1c1T2x6cS9WdGVUN2E1VElpeit4cjkwa3NXZFJ0?=
 =?utf-8?B?VmhuRXhEVHZqL0hrMkJ6bi9OenNXaks3M2pvU2xCWVI2Q0FVNHRya01iZ0Jq?=
 =?utf-8?B?cjJJV0YraUk3d1NxakkvQXUxZlJuVk1SS2R3aEQ1clRlV1Q4WDc5Uks2d0Q0?=
 =?utf-8?B?dmV4NjJQNzAycXVIKzJxMEZHSnRMTHdSS2RHQjNQVzhRT3hnaE5HZXdXQ1A4?=
 =?utf-8?B?dVRhZVcrOVBvSDB6NXNnSGlSZkNmdjJHdDU1YW5oMnB5anpwL1NJMXg5Z3Q5?=
 =?utf-8?Q?bx8s58GZ8a8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11148
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d13cd2f1-336a-40e6-a752-08dddc02e112
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|14060799003|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clRIaUtpdFExVjRNOHBObW1zR0JhZWxCZ3dmNy8wZGpBcG9nVFRtV0NSc1k5?=
 =?utf-8?B?WTdvWVFXWnBhRmQ0eXVmMmtiYTMxSzRBZ3JsN2NxUXBzL2NZSzEvUzdGckx2?=
 =?utf-8?B?Q3M0WTVyeEIzdmREUFJta0JwVlpHWDlUdVk2emp4VVZHWXlBQllnWDRtZmtV?=
 =?utf-8?B?azdlTnBYTnlkbWc3S1ZlRHZ5NXg3b0V5NGY4SlN1bHd6WlUyOUNTbVRVWUto?=
 =?utf-8?B?RTF6QStUZVB5L3NHWmZMK2IwSk02MmgvT1N3T05vb0s1RHBRSnpHTGpaejNG?=
 =?utf-8?B?K0dxRXdoeDZqS0lpbkdEV1RNUElmSm00WUxoMWE1Y1h0L29NS3FOYkRCWERj?=
 =?utf-8?B?SHF6NlNqVHo1aEw5UldRRmV1V0FMYm95Q2J4bTlYdDJnK2lsNmI4eFZTaElK?=
 =?utf-8?B?NzZadHo3OWxMWmtrSUNBUWU5d0k5L05nd25ZdjlyRnR1UWNzYTR4bk9FdG1i?=
 =?utf-8?B?c0xVMTVUSW92cFJTQm1OQmlhdERlYlB2NmhuNFpkUlYvL2ladVBETE5jeDNG?=
 =?utf-8?B?b1ZsZXVZNHNBeE1WeTFLRTZzcFpsR2h1RXZydlByeEE3ZHVzcVRXQUdvQVB3?=
 =?utf-8?B?Ynp4aHpQOW1ua2h3TW5rZG1XclhROFV1WjI2MUxwbk9tVWVlNWNKSVR3UFdi?=
 =?utf-8?B?TmltZ2F3WVkyRzhSaVJvRjg3UUFOZk1SVWRsT1R0RUNGMEx5MmZNOGhxZG90?=
 =?utf-8?B?Z1hxY00rek45Ulg3Qmg4Nmt0SEJDTEJoZ3JLU2drY1BFNzdMUkdNL29EcDBQ?=
 =?utf-8?B?UG5JOHVrMUFFT2pCT3RwRVk2VzlobVhab0VlUmR1UGJnZ1dBemk2TWxPOTdx?=
 =?utf-8?B?aERmT24ra05sTGdQOXRGRExzYkFlOFVGaUNPb2d6enhERmU2V1R4SnlMTXda?=
 =?utf-8?B?amY2WWFIMGpqbWpyOC9mZjlSL0FMdmtrT05lUWRQbHkrQURWM3d2cnNqZlpT?=
 =?utf-8?B?RnVzT0pKYm9pUzU4MUhCYzV0SVNUMytSQmZUWGlpaHg0cDY2WG1MQkxIYmo4?=
 =?utf-8?B?TUlkU3ViT25tL0pSdU02TzBBYURnR1pWcWU4ajFySXBIWmxPWGdCYko0eDg0?=
 =?utf-8?B?aVJVMU5ac0o5VlcxUlBsL3V5eDUzbGswRmxsVXAxUE5UUGc5S2l3T2RRbG5n?=
 =?utf-8?B?akNrTlpzdngwc09LVGt3OGYvdDFPQy9DbVVOTmxaNkFnYzAzbHJTNHdrYjJ4?=
 =?utf-8?B?dEdHeDZlcC96b1RmWmRqR0crMG56ZUZZVkdsWXZyVkZHVWlHK3RYaEJ0ZHlF?=
 =?utf-8?B?a3hRZFFvUUc0azU5TzZDMzlwMlZ3UDduOU1xM3UyM0FlTU96TGJDZkFNaXR6?=
 =?utf-8?B?dVg3QkxGeS9NNGxaQW15ODIvdGp3cDZ1clRIbEgxN2FLSnpLV2Y2OU8wRkx6?=
 =?utf-8?B?d0tHVCtKMVM5RWpaMlBPTVRuZ0xmalpybkxoZFZ0MHIzUHFBZzRpWEc0bW4y?=
 =?utf-8?B?UUpMMHhiM0VXczdMalg5Wi9XRlRtWDI3OUwwcVZ2Rko3eTloaVJXaGd1N3hm?=
 =?utf-8?B?dXdYK0dvUUY5Rks5dnZtTS9ML3NVZEFiZ05nVnpYdGJoTi9QN1lSdndxNEpt?=
 =?utf-8?B?dEt5d1JEUFZBcW1WaXlidE96OU9aSy9nQ3BCbnN0bjFzZjVMSTJTVmFCREd6?=
 =?utf-8?B?c1FBL0czVDlkL1libk1WS05uNXhNOTRGMHg3b0s4MkdqRkYvUlVlNldFUmFi?=
 =?utf-8?B?VlRIYzUvQSt3VUk5WEwydTU3UDJoVGpqYnVIM0p1dHRIMXFON2wrUklaN05H?=
 =?utf-8?B?WTRrN0hGL3RILzF5aTVZV3J5Q2NST2ZKcVAxTDZGcFZtODhwVytQeDNSQllY?=
 =?utf-8?B?Q2Q3SXFFZk16RFJjMEZKZW9TbzJ4V0p4VENScHdzYlNSWll1RHN1SjJRakxU?=
 =?utf-8?B?NUoyY0d6TUNqS2c0THZweGVtdS9pK1AxeTZSS1JjaXFNcjV6SHpBT3ZkRTEx?=
 =?utf-8?B?WStQamloN2szaEJ4bFdwVTRqdm1yMHRvWUNBWkNEZlU0RGRlR0tpVWFnL1Vm?=
 =?utf-8?B?SHFqKzVoajBXaVJJZk5ZbHhVTmZub245Q2lnVGwrT01idmlzTWtJMnpybXJM?=
 =?utf-8?Q?82UWTb?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(14060799003)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 13:52:20.7028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d954e59-041c-4523-915f-08dddc02f496
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5604
X-Rspamd-Queue-Id: D6CC240003
X-Stat-Signature: dbrq89mwnxzyqkhxotecdtjo8e79kb1g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755265947-336509
X-HE-Meta: U2FsdGVkX18Q+vqPbXHVGCQCM0pXjYRufO1XGgBUZa+kwNsL2Aj3yUjHBtKH+waRbk9L6P6wQd21q9lw8VeRUah7PjvJ3NBS/0H9DM88XGmiiKcIZKPFJHhZ7drKwlMI4ikBN1LiEX8fVV28TaohdRL1y05RjyrItWi1p9vTP2jNxDaWy6pWoP4CoSqjayxVE4/5v/46MXAstC4hH39QSKI65u6tKzxI6JfTqu+XyPsknTHrdTQYyYOX+R4DsIWWCg0ClVL7jI6DPOr+l8oTisB2sRob6kR0iiciaB7OmLUe6l8Wzn0QyND3ql/sec827jCSDPev03VOrhKqJqYNhKSISsEXTvbWPhfB05QnFGIrzYGIxG4zr2DUfG4FytuU0Ltd2r76c9IwomZBgHu/xpM+cNXFYtrlG870WdhE71sc+ozasHY+13gOGIdhk9cXYJdCsLFWev0Iq0EcLLp+MPYuZy/pd7zdiv2Dt0E0Fz9zlqhKrGwVMUEFiA/Xvb/aK/x9Xsj4nUVKeaDcIj5pF/OoUhjC6IOHS/abyBJMn6k5O0IYlvKqo3OeJiWWfLliGp12Tl3F7UaegKq7XCteugRMnrNtp5Q4ywM+8tGyRfbR8irKrfBtYp0eWVzCzjrY7ab5Bj9F5amnRerYVVkXQeo06JtvQYwofjI2ADvQr7gKAZZVGo3/ClBgZ+AVrCyH9uZ2+/zOa5UROnuuwenGtOjqk6dmRw3dUs4v/KjQlS/Q3Avs+rZMLCkkAS4Xu0T0dyjQsmQUK9RE0klOHKVuAxaDmJJZqEhkwT26OwZb/6mMnCb6fkWUzi0hZ8u876w4fijzwQwNSWefr7o8JAeDUzqKr0ugJ8akzTsrhf0Ey2tCKxLz17CRtCHjzwTicbBcSS9fI1YvSithL8tqfA6wwmEzshn8XG0irtumhpWmkCY9nnaZ6Fspw0Co/xhbZBA0kq614Ky7T7DzB7Ccahp
 nh9Ir5Pe
 bUHOZOT4mKfU0sVascD4TBSnAuvtMOIzOHp54wNUi8Jbvxm9GW9n7v2PZD7HPHXKuX3gM2UCj2mnI5wmIe0VrE3HJ+FIXSsqr8tstH2z2F/6B2LxnX92Pb3VrxEIpTombCnm3FksXtp8PmGdcuWzzFtOlmZm2SMsOpfy4vpeDW8DRsiLEwls1B/L1ss9kU1G1uhuqNqN7/ahF2DVXah4mMTnGsPRXjUFCjSKhEx4V0k4Vwe67iG+YUn8W1nqya8wno6pvifNY6nh9ySwKrzjZoGtwIYmxaUQJqvsUeGmbH+Jl39lH7HQbQtP41Hrl62juBycIBiP8lNB6ZTyXfdI27tENke8nSPOHjKXWw4Z6Fwkh3EN7zjYtRos3H/vzQRPAgHGij6kabvtIRHNCTUuKyVN79+nJdvoqF5C6juGIDTJJFD+ReIgWLQsim6xNJr4pkDOpIdOvxufsdwSWtiL4zZ+RjGCbfapqL3PXRN9i969eQFb/jziaGISsHpO9yECXwZ2nT8H/sCd1w4C8tlbi65/P4lbkU/tCx0YUAir3caeFigJtFiekExCh0b0O8Q9xjKUPkydcTCv96Djfc8kScpW4ugn2ObnTlkRH1CGlnAX9k5PKe9Ijv/dWaPBnyiFFG/qivqXRMooBw2/oS2hyu8OUzBPIUwzm1mKoztUusxg1bHVALiFbXG47kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Cataline,

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
> 				^^^^^^
> This won't build with MTE disabled (check spelling).

Yes. this is my mistake. I'll fix it..


[...]
> > +int mte_enable_kernel_store_only(void)
> > +{
> > +	if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
> > +		return -EINVAL;
> > +
> > +	sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
> > +			 SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
> > +	isb();
> > +
> > +	pr_info_once("MTE: enabled stonly mode at EL1\n");
> > +
> > +	return 0;
> > +}
> >  #endif
>
> If we do something like mte_enable_kernel_asymm(), that one doesn't
> return any error, just fall back to the default mode.

Yes. I'll change this.

>
> > diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> > index 9a6927394b54..c2f90c06076e 100644
> > --- a/mm/kasan/hw_tags.c
> > +++ b/mm/kasan/hw_tags.c
> > @@ -219,6 +246,20 @@ void kasan_init_hw_tags_cpu(void)
> >  	kasan_enable_hw_tags();
> >  }
> >
> > +/*
> > + * kasan_late_init_hw_tags_cpu_post() is called for each CPU after
> > + * all cpus are bring-up at boot.
>
> Nit: s/bring-up/brought up/

Thanks. I'll fix it.
>
> > + * Not marked as __init as a CPU can be hot-plugged after boot.
> > + */
> > +void kasan_late_init_hw_tags_cpu(void)
> > +{
> > +	/*
> > +	 * Enable stonly mode only when explicitly requested through the command line.
> > +	 * If system doesn't support, kasan checks all operation.
> > +	 */
> > +	kasan_enable_store_only();
> > +}
>
> There's nothing late about this. We have kasan_init_hw_tags_cpu()
> already and I'd rather have it all handled via this function. It's not
> that different from how we added asymmetric support, though store-only
> is complementary to the sync vs async checking.
>
> Like we do in mte_enable_kernel_asymm(), if the feature is not available
> just fall back to checking both reads and writes in the chosen
> async/sync/asymm way. You can add some pr_info() to inform the user of
> the chosen kasan mode. It's really mostly an performance choice.

But MTE_STORE_ONLY is defined as a SYSTEM_FEATURE.
This means that when it is called from kasan_init_hw_tags_cpu(),
the store_only mode is never set in system_capability,
so it cannot be checked using cpus_have_cap().

Although the MTE_STORE_ONLY capability is verified by
directly reading the ID register (seems ugly),
my concern is the potential for an inconsistent state across CPUs.

For example, in the case of ASYMM, which is a BOOT_CPU_FEATURE,
all CPUs operate in the same mode —
if ASYMM is not supported, either
all CPUs run in synchronous mode, or all run in asymmetric mode.

However, for MTE_STORE_ONLY, CPUs that support the feature will run in store-only mode,
while those that do not will run with full checking for all operations.

If we want to enable MTE_STORE_ONLY in kasan_init_hw_tags_cpu(),
I believe it should be reclassified as a BOOT_CPU_FEATURE.x
Otherwise, the cpu_enable_mte_store_only() function should still be called
as the enable callback for the MTE_STORE_ONLY feature.
In that case, kasan_enable_store_only() should be invoked (remove late init),
and if it returns an error, stop_machine() should be called to disable
the STORE_ONLY feature on all other CPUs
if any CPU is found to lack support for MTE_STORE_ONLY.

Am I missing something?

Thanks

--
Sincerely,
Yeoreum Yun


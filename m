Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B927D5E14E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8066B0089; Tue, 16 Dec 2025 08:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB876B008A; Tue, 16 Dec 2025 08:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A356B008C; Tue, 16 Dec 2025 08:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 903996B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:26:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3070B8B1EC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:26:33 +0000 (UTC)
X-FDA: 84225408666.14.6183780
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013019.outbound.protection.outlook.com [52.101.72.19])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5150540005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:26:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KJwaYwJE;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KJwaYwJE;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf04.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.19 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765891589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKRa2Kn9qqWS2qWyaOnyDCSE1akw10h5w05UXg/AlcE=;
	b=0P8V3/HfqoDt5ImuyInHNBp8TGH72O7HQMBu8aVCfGMMyybtk2dBOzZATyvQ3whI8SLf+N
	MuUxObnfP9W69bwi/BGyKoEOdjBrtxpAbtwmmELJ1c66j3setxA6FsxT07tyEfTEbd2LQC
	TZSt5uhVyudmEFgBaQEkyLz/b7+S54A=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1765891589; a=rsa-sha256;
	cv=pass;
	b=Kb5oIiXxs8BV6ldUVHj8Yh+qFTRKSD1RuspFETXe5FwHYIWQMtbsEVoFYK6PEijTdx6IMc
	poA94F7yeetm4QUNUXHK4UI/vlUrwjRGtscuHwvMRPEAo5XDLdEw8uNev/v8wjtaDRQb4K
	GSck3yjRf7wAtLXG8ZW1GwzFZ+/46ok=
ARC-Authentication-Results: i=3;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KJwaYwJE;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KJwaYwJE;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf04.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.19 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KYrXHfXkkPAfXh7ERQGFDCk2t0alDLpl1PfhrZ0738CuM9SRvkNxtlBUCIiIrPmWhlzuR1g5W5AyjKKmg4o6c/FhZ3Yufis5wF1GPzUVLV97v1mZx2Bk+pKYiaP5fkSm15ir3Y4bimzL90SAB3T3PthDqHMZEURzT97Jgkb4jciCblREbCqN0Lx1ecz4vRJT1rgunHuCEyOVz4qoTaWfD1fQ1ANavkV8+1+HDFuq38fk8gXVGZJ3Mf5P2JxtBjzUloPXLg9yIjeXRgLVEocnMmlk8I/GLOXmdOAk0a3RMo+fW5nuM3CKTtHMEzAqxZpJnGjfyGb0ei7qmDwQ27v23w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKRa2Kn9qqWS2qWyaOnyDCSE1akw10h5w05UXg/AlcE=;
 b=ts1vBIS1uc1slY/RZUAphwVtcjQjlM9/JnglK3f9IduTsD/eREcRb1BWE7ZSWkHDGDBdj+GKne8Qap3bD3mQEpAsrpDm19NGlai9QFFwm3ywKZWhzGUnL8DTREhDVwUTfiR7gyv/NtcYEv7dIkXgHArdElv6tC5y3LtVePh9Un0saVwjjUHWzGhMhvJK+zlqzgqY1ToFriaKw5iSf1egKOdWt5GYBSao8j2/Puoftc2s9LSKHZapaO7S8elZi0TttBenaU4F0yzvwdIh9drttqU4f3RNrpsVOZJRnJ4ysJYVSyG3HiMG6mJ1Uyn7+KIuwx8uD50qOxwDFdpGB7Ox+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKRa2Kn9qqWS2qWyaOnyDCSE1akw10h5w05UXg/AlcE=;
 b=KJwaYwJEK7h6kAu43tuAZ+mGaMH+J3l3fPLDKEhoAXDBwCGQ4/xGndyzpjBcSnBazAvP2ehtwSSX5sHFOSehNa6ENKEfzKfoiBsJ0fo2jlYCzHJYoZ20sTlkWFV2t31+FEim4m/qyvtVxsR8icdZvTOdBeiCjGAwK2UNDOlY/3g=
Received: from AM9P250CA0007.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::12)
 by PA6PR08MB10594.eurprd08.prod.outlook.com (2603:10a6:102:3cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 13:26:20 +0000
Received: from AM3PEPF00009B9E.eurprd04.prod.outlook.com
 (2603:10a6:20b:21c:cafe::c2) by AM9P250CA0007.outlook.office365.com
 (2603:10a6:20b:21c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.12 via Frontend Transport; Tue,
 16 Dec 2025 13:25:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9E.mail.protection.outlook.com (10.167.16.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Tue, 16 Dec 2025 13:26:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9aOq9+LiBzGYj9MN17XvO314qe8vYUp8qbwoa6WGmXZ5jJMGnQholOUqE/AtODRaKpqnxQ3bII4cFqFE1Tq3tRddstnjb52zd1a5mUQSTLyeuJGdylVjyJGnxKbRyqT5hbERFn8NMUzY9MB3OBUpeJBiN8STNLxEjXEisFsQ7+8VCSkNz8HefcKw0JyYDIRDDeUpEVU779c9f3uRDXkG/UqPYSMQG+IxOL2LvjKGx9Wo4ixUuj5JsUorAtC/ZjoBM/ZIEjTZz1jzfTiOZFwk941BTr2MKUe5RYVlQfj+BcoS0eQGnLWheF9734BGggrlm9Nr25bXbczGpfp+CNtig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKRa2Kn9qqWS2qWyaOnyDCSE1akw10h5w05UXg/AlcE=;
 b=EdrhmcSaG+ppuAR8zZPew+53T+6f+s4o9zhF+vAZDR4KAJLd7Uj8rF7XNLHdwbYmFMkwdz+XegkLeHC+Prd75j72SaSswR1WhMqJBDdcTK3hHP46wREr43vbGDVWcrJyBxXfXZo8KeLY9Gu580DNPP9ssK/tq9Q4W5+WioNsL/Cb51qzvcFRLz9saB15PUbGrJ3m8FITiUaR7ZXabUBAlrsbZa4Tgm/ugmwbfQYmyselkIZPPaL03WlyP/UfGCy/dYFynQrbAW5etzDk4RdHYm4N++6J5iOqvU8H2/7qoZc6bG3XPY3dJKEKOnGOlqE8YeGhJkmt4SQRQTdiq7H+lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKRa2Kn9qqWS2qWyaOnyDCSE1akw10h5w05UXg/AlcE=;
 b=KJwaYwJEK7h6kAu43tuAZ+mGaMH+J3l3fPLDKEhoAXDBwCGQ4/xGndyzpjBcSnBazAvP2ehtwSSX5sHFOSehNa6ENKEfzKfoiBsJ0fo2jlYCzHJYoZ20sTlkWFV2t31+FEim4m/qyvtVxsR8icdZvTOdBeiCjGAwK2UNDOlY/3g=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DBBPR08MB5980.eurprd08.prod.outlook.com
 (2603:10a6:10:206::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 13:25:16 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 13:25:15 +0000
Date: Tue, 16 Dec 2025 13:25:12 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, song@kernel.org, yonghong.song@linux.dev,
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@fomichev.me,
	haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
	ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
	rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
	ryan.roberts@arm.com, kevin.brodsky@arm.com, dev.jain@arm.com,
	yang@os.amperecomputing.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while
 stop_machine()
Message-ID: <aUFduAz0BxYFQtc+@e129823.arm.com>
References: <aT5/y3cSGIzi2K+m@e129823.arm.com>
 <DEYOI8H2OESD.1H56D3H8HKILB@google.com>
 <aT/WOAr4osoJWaMS@e129823.arm.com>
 <DEYP7JSVTB9D.3EFN2KEHH3O79@google.com>
 <aT/drjN1BkvyAGoi@e129823.arm.com>
 <DEZK5U2YP6I0.27VJHSVK14646@google.com>
 <aUE8bwUVa6jSUft1@e129823.arm.com>
 <DEZLRT59S25H.2YWTZ2G0TN3HV@google.com>
 <aUFKAdPY3zTlPmnr@e129823.arm.com>
 <DEZNBMBRM5M2.1974FFAQ13G5E@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DEZNBMBRM5M2.1974FFAQ13G5E@google.com>
X-ClientProxiedBy: LO4P265CA0176.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::16) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DBBPR08MB5980:EE_|AM3PEPF00009B9E:EE_|PA6PR08MB10594:EE_
X-MS-Office365-Filtering-Correlation-Id: f6eda159-bc0e-4f37-3b53-08de3ca6b30f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?bm01OGV6dTl4SkJTamVhUDBlMkJXaENuK0FrWmlkSnZDTXFGemhoSml5Y2or?=
 =?utf-8?B?d05CMzlGSW0xRDZyemtlMHM2SExtL2N4YVh0UGJQTURsNmFqRHlnTDJvTXNU?=
 =?utf-8?B?TE9sRUhhOEdQVmV3bXpSR25DcjhGaTZzL3FBVnNxUk1uMEhqdHBmOEk4L3E0?=
 =?utf-8?B?bXdReDBMeStrdjZER0swOGxJY05VdXA1T0ZrOTFXVE1lRXpxZ1pHR1BuSzBB?=
 =?utf-8?B?UHJkNWFPZnhhTnRVVnY3b0hPWlM2S285UjY0ZkpteFNDVTYwa2RjcFNuMEtX?=
 =?utf-8?B?UXZ4bHpjbGx5Mm1zR3pHdlo0VG5HcW1aaWZmUFRZSHlwYTNReTgwd1pBQUw2?=
 =?utf-8?B?Y3V3TS9RVWFrOUpTNjRVZGdDNkc2NXl5NnprTUdiMGdkazhWNUgzLzY3THp1?=
 =?utf-8?B?bC9SYW5qK1ArZ1ZyT0hmK0V1RUdaMWxPTUZldmpFTmxiOGhxcWVjcGJ5VE9h?=
 =?utf-8?B?OGhSdzF1bWpvYWwrbTdBZWZMOVN0a0puVkNERWlmejlOS3p3eEVGdVVDMklO?=
 =?utf-8?B?YzdkeGpJSjFTblJqblJMd203Vzk0QUNhUG44TzJPSDE5QkhBL2JwaHZqa3hp?=
 =?utf-8?B?VFp0YUtUdlhMQm83dTFPZFg1bFRmdFJxLzRzSGczVW9NL25ocGhHcnN1dTZI?=
 =?utf-8?B?VXFuNnhGdUhHamVaOHlLaWlIalk2cnJVWG4wUkxseEMxbVM4eHYzbm9BVUF3?=
 =?utf-8?B?cjVlSWZKeHRoTThKVVBTYjJ2YzdVdlRuMmJSM2ZUSGE2dWZwV3AyMUdCOTA4?=
 =?utf-8?B?TzBnMW9vVUhXR2NzbVdjY0h1NytWL2V5NlVUWmlMamtDL0JyYWxjRVZsQ1Fi?=
 =?utf-8?B?R2o3Q0FNc3o1cTZaczRxaHd6dE5kUzdEalNDR21Dd05nUVU2UDBMSDhVb3cy?=
 =?utf-8?B?N3RnRkpJSGdRZU5QY3VDZmFFZHNmREpLWWM5anJLa1BSTXZRT3ZCRVc1MnBq?=
 =?utf-8?B?ano4MWdXR2s4bVQ0WGFKLzNCOXl6eEd2RVJ5dHZmVWlma0duWGp4MFpwdUdY?=
 =?utf-8?B?bEQ1anFlTkZDcTNOckYwbFh4RmkwWTdBcms3WmdsR0toaWZ1UWV3cDM4N3dQ?=
 =?utf-8?B?QnUwMTdGeVNlT3BwN0JFN1VmVlBSTkp5VkRGWEtoTUQ1eFUrSStyanhrdDVl?=
 =?utf-8?B?ZFFFWFp6RkQ3ZUMyQVM1U2lNNHAwejJDM1ljS2o4SVU3L2wvYTRGM2F5S0c5?=
 =?utf-8?B?bzVqOWROcmRnVVZNTWN3R0NHRllma09ZT0ZuNE1KRnpoVzIyNWlsd2ZjTnRp?=
 =?utf-8?B?L1I2VjhESmFKRFN5cHNHbGJYa3lzd09iTDNRSkV0bFk5RWZKbk9jY1VYOTE3?=
 =?utf-8?B?WFdMZnduWWlXOEk1M3BZRS9uTUlQSisyaS9DRzF3U3dINHgrbGhPMmJ2bXE1?=
 =?utf-8?B?emRxWkdwaDdITy90RHNFT3Yvc0ZuS2dGZEdhNGc3Skl1WWlwRTVXUFB4NTdH?=
 =?utf-8?B?YXVFZXVrK2VZTkRrMWhzdTN2U3l3K3BnMkVqQzZiMXIzSmZHSE1oQnBTdnR1?=
 =?utf-8?B?cXZDMGRpVWltNE95WEhsRjc2eER2TFR0Y0dmOWNyWTZQaThicy9RajJGSEQr?=
 =?utf-8?B?N05hYUtVNnhTOCsyUlNBeElxbmxwYTZoRllERFJURDBNaGUxTU5WZ3Y2bE1v?=
 =?utf-8?B?RmJuNlVVR1hPZDhvRW5OZXJKd3ZIM3l0TERpS0x1OUR2ZVA4aFhBTVpoLzlv?=
 =?utf-8?B?aWc4bmt0OVpmQVdrUjEwUDdiQkx5cndpQlV0a1BHZ3B5cFFuZ09aTm8vU015?=
 =?utf-8?B?L215Qmw3N0pONk9FSEx0cTBpMGI0aithSW5saTFpVEI0OW5hcVRpYWZtMmJ6?=
 =?utf-8?B?VjdqMnRMRzdSN3BMc051dWF0NXBmTmZPZFFndHRUdDVPQlBDdmJRSHhqVGtq?=
 =?utf-8?B?bU94L1l5eUN1MFRYMHNlc0dDRE9VY0FvcFFobnU3djRybkl4bEtTMGF6VXNK?=
 =?utf-8?Q?T+B8LuhBhJKBJZWvzufq0lAlnl9Jrtr0?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5980
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b9764dfe-a923-409f-d282-08de3ca68cab
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFU2WGZjL00vRTRtVDNzUG1DVk0yVUcvWEdlVjZqem5HR1ZERHJjTEcvaDN1?=
 =?utf-8?B?bEduYlEzTXBqK3prTjdJM0d5RVVUZTg3dXBtMVY1OXNvaCtLeFN3bGhVK1BB?=
 =?utf-8?B?WDJkTnhLRUQrSllvamREckRuTHcwZEdYenAxUkFRVEZ5TjVVR3JSSjFSZjN4?=
 =?utf-8?B?OG1GcHpaSzA4VjQ2YnlNTXpNUWhDQVhLZHQ4TzFwdHhBVFY4ZHNvTGR1L3NZ?=
 =?utf-8?B?RnVBRVVuVlc3K1puSWlERS9nSU1xc1RxcTNDdGt2RmlqOEVnNE9lam5rTkIr?=
 =?utf-8?B?OGx1cjM5N21QV3gvUzZrY2M2S2VoSVY0ZHF1YXVxYWF2eUxWNGVWVVhIT3pw?=
 =?utf-8?B?Rk9OUWhnVGY4bm9DdHQ4cHh0ZnZmWlRTYjFjeGsvRWJIQnpTZnUrMTJ2eHdo?=
 =?utf-8?B?RWRXY1RaaFR0SkZKRDNpcEpjbGNKdmxWYkFFRWN0QXdVUFEzZW0zT3h0c2hm?=
 =?utf-8?B?cmtISVdET2dZdFNKM0YyM3NBd09hTnRVU0FzWjUwV2FsMGphUExHQzdVQklX?=
 =?utf-8?B?anIwMjU2SXlaN1dJK3ZmcldsVHEwME5ZbzZDb05NTnJ2L2plRE9vRnpjRWFI?=
 =?utf-8?B?eTZOOHZHNk5OZkdnZUZwV3RaMVA3NFR4a3dGRkNaRk1xY28xaTBtNDVkZmlp?=
 =?utf-8?B?RVEweWwwMHZHY2dYeTRDYVQxYmN2aEVTMXZrWkRmUDlpQWxndDNlUU1wNEVM?=
 =?utf-8?B?Y0dyZlNlSTdIME9IUVppQW1lNE5KZlR2S0tHRlNkY3VVbkhOczdWeGY4TEZs?=
 =?utf-8?B?U0lHNzBWamx0N2JNSk9jVXNUbVYrUmx1bGdpcC9JN0ZwSWZDbEFoWTBCYmZ3?=
 =?utf-8?B?Q1V1c1NHa2JOUEpZNmFab3hBdm81bmVpd2cvclE0d0pidlE4a0k0N3o4QmJ1?=
 =?utf-8?B?ek1zeVA0NCs3S1d0V2tidHRUbjZhV1BsTHFzSER3VlNWN1ZPTjR4bkJ4czFV?=
 =?utf-8?B?cWwyZGt5YldkQk5PNlNSMXJMYnNJNm8xMkNncGpWOGcvenhRQjhPYkhBSTM4?=
 =?utf-8?B?bGhvaWpNWXNtQ1ZrNEQ5eEFoOVZydkEydGlkQXh4NWduL1MvQnBPTWVGaXdO?=
 =?utf-8?B?VEl6ZXNJZ3gwQWZQOWlZbnNNRGJTbHNJMW0vL3NJQS9ueUZicStTcE1yK1NZ?=
 =?utf-8?B?cFlISnU4eWNkT1luKzBsYk1oWXFiRHZkdHF6Q2lMOHV2ZzREVExPNFJSRFlR?=
 =?utf-8?B?dFFRWHJtSURTR0tEWU15MFA2UHk4d2RMU0xMOHQ5WkJxNDJHdjJpWHNsdWpW?=
 =?utf-8?B?TTRiSmVoV0NPR0xkMUxzRlhZTThhNHlZMFVseXhBdzVoTmhBa0VXazY3VGND?=
 =?utf-8?B?SVp1V0ZkaG4rT1hzUUU0UU44WlBmVHQ1MXRTUkVOWUpDOWNKQWJCVjVaa1hm?=
 =?utf-8?B?M0dLZTBmeFNoclJCZU5LeWtocXNHNTd1OWxHTnMyRGpuVlRPbnQvUVNWSkZ3?=
 =?utf-8?B?ditjeStyOHhxMDVqR0dXeURudlBIbW9EUG5yd2VlTW83b3Nud2RCUURCTnJP?=
 =?utf-8?B?VkRvUzJ1c2xtd1kvT3NWeTlZaDI3QnRleXdkZFFiQTllYTVQL2laU3cvd2hr?=
 =?utf-8?B?YnBhd09WNllTYXQzNSsydXAyUTJ5Z3cvY1JMRzlUQzRwdU9mRHBMT29OYWpi?=
 =?utf-8?B?RVh0dlRVTENwYituc0g1NXZOOFlsa0l4WXBHanBMLzJrRHJ6bjZaajcyRWtV?=
 =?utf-8?B?ZUlDQzRmR2tNMGxjdDNlaXZNM05NZDZFeFBSYjcrd0xJS0Q4UkxCWmRwYlJn?=
 =?utf-8?B?M3VNVFRvOEs3N3ZDaUM4NC9MeGMyZzlCRy82aStHMi9teTdFeXJDS3poUmdi?=
 =?utf-8?B?bGJYV21rNmlRUmNDZklOYitxN0VpaEVoMU85cTBmRGZjek4xL3dVaFM5ZW9I?=
 =?utf-8?B?VkZyWndzUi9ZQ1hWMHMwYjViaHVsWm9mME83bkhrR1ZkOGVBUXZTL3JRRThX?=
 =?utf-8?B?OHRhakozU0NicGdHMFBnUFVTR2dGTDkwbzM2ckFHYkpnN1VHS1VyWGRBdzMz?=
 =?utf-8?B?THFOQlJrK0hQbHBHMDNkcGhhbTh0d1A1R1JuZVpmNWRtY0ZkSW9SSDNaQkRz?=
 =?utf-8?B?SXhFZ1BHb3FCQzE4N3JWWXVncHNUOGpOMkNDMHhKRkowcGJtZFh5WFEzdHht?=
 =?utf-8?Q?pq0k=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 13:26:19.8924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6eda159-bc0e-4f37-3b53-08de3ca6b30f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10594
X-Stat-Signature: ga41gerdikzszw7iym9dwawneicih98e
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5150540005
X-Rspam-User: 
X-HE-Tag: 1765891589-273867
X-HE-Meta: U2FsdGVkX1+MFmYLcr7Ab8AO20naunnrvNDTlNz4UoE8Hjcu6+c19MiTAq1SW+3b9y+PWnPZ0jgewt60UXaDhut7X3Nmf5JxSgvdy9G0/lg1xQPsSpwQwqrcBFSFz0rH6ko5dsFLHWkB3KjbutjujTNO0i4jE/nE9HE0c3iZWMbNW+NABonKRtDEykE4zqQ8M6x2Z2WTRW3AjVqepbX0r5h7xM3BPIb0MspJtJKorUE5Z4/2Vto6u7wpAoZ8zpZ8UDlBKKJz/LOnYzXoOrHNGQeWWal5OpZCBLq2PzKHZ5Kq58CBVpEJHeh9O2c2wVz8cHvou5UnwVk78KGRS5paAN+UpJJk5cO62oejQqlU/NBaEXVeEFV63qE78AcolpppZIKKatJwlroUYbNiRBdZ+nrJBXlqWsksAwUDSBh6AhhrA+W/GnLlogp8sI8i2FRtRqg3KEwdoDVoZB8C6Agc7Vo8kCVfj9cIKn+iulYObQ+JnJNsw9nHMY+oNjp5J+RCxTD/QIDGhN3rUPgSUwRqCQ0v3JRORbN9tBCKcvh9bG5XsfYktlHgL4ggElePHbtil7YFnwFONNT3O1FK8GDZCKDPRmWxgfyvm0iyn4vO8rJfJt7HI9dqZLqikJn5SsOOgQSckGq80wYIZEr7Y/cjRT2jGU9mOwL37rjqgtoeYB61uHJcX/Ja+n2XOMLEnYazbSe35lS8hYBYudYwcUqcxvaCF/BnPgy+pxT/7JHxtecta4xcOE2C+r84QQsmVfoV01G2gfRGOBRI1GwIwUj17gEb90owhRohTF2/UoEr+vTlCUIzdcHuCmR1qhzONP5fh4yDZghfyF/5Kldn+k8+26OLmrlF3d3nnt4N1oul8S995pE6JVewFJMMVhe+I/SZH+5oJT39dX3iPrkJunC0dnozMUFjqeRPAJHfkYKUhURJuFV1G4r3NjFC9/Z3oT+/WMnCq+C36w6ALgpn3pW
 mmdOPXOZ
 wU8Nck9j2YIOWFVVGGCVMU1mAt47nKAzmJGRFpSvPysMtvkhUBWN3t3dQQuX7i6TxYdLBcS+zOnfTRIIFQxXkaBfNX/dLaruOW3GHms1J/2ngekNzVZJl+uCQRb/pp2tPMEMPXtWXXOlwuFWRgRpqt+aSuA86liQ515tZW+O1zOFu5N/KE8QWFN8D1Vv5lt3+ripe4FmczwBaN4ayVOd8HkiHIx/lW14KBWzMrqZvLpUb2XXDB0GsHZSB/T+D2eLDxtduod57DPhozK7xyxIB3Rr1elDPiAQ6CNDVySuOPHSlSJwXxBCj0YVfOVhkZSOi/tml5oceqFtV0sZbs0rRHcLUxk7flk3OUgKykE5nBu7facGu/+MS11eLMIdZaFJkSAs7og4h+4RDbq5pFUofHaTJQUSW3XixrZjXsCXbt4WP8mNR9VQ4wv2dCMndtdMPta0sLI2aFq4EP1VNLXEHSckP9/YiEgKfaYhWmM4BzOEJoIrgAKRtkc2v7yQo0oopkZFttZHuwMGAHgViUVeP8OoQDJ2+P4tFfmEZNxngt8C2U9XquTqS6wLoJHeqFUDaafmSJje9/mlj9DK6kxa3dZJM4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue Dec 16, 2025 at 12:01 PM UTC, Yeoreum Yun wrote:
> >> On Tue Dec 16, 2025 at 11:03 AM UTC, Yeoreum Yun wrote:
> >> > Hi Brendan,
> >> >
> >> >> On Mon Dec 15, 2025 at 10:06 AM UTC, Yeoreum Yun wrote:
> >> >> [snip]
> >> >> >> Overall I am feeling a bit uncomfortable about this use of _nolock, but
> >> >> >> I am also feeling pretty ignorant about PREEMPT_RT and also about this
> >> >> >> arm64 code, so I am hesitant to suggest alternatives, I hope someone
> >> >> >> else can offer some input here...
> >> >> >
> >> >> > I understand. However, as I mentioned earlier,
> >> >> > my main intention was to hear opinions specifically about memory contention.
> >> >> >
> >> >> > That said, if there is no memory contention,
> >> >> > I don’t think using the _nolock API is necessarily a bad approach.
> >> >>
> >> >>
> >> >> > In fact, I believe a bigger issue is that, under PREEMPT_RT,
> >> >> > code that uses the regular memory allocation APIs may give users the false impression
> >> >> > that those APIs are “safe to use,” even though they are not.
> >> >>
> >> >> Yeah, I share this concern. I would bet I have written code that's
> >> >> broken under PREEMPT_RT (luckily only in Google's kernel fork). The
> >> >> comment for GFP_ATOMIC says:
> >> >>
> >> >>  * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
> >> >>  * watermark is applied to allow access to "atomic reserves".
> >> >>  * The current implementation doesn't support NMI and few other strict
> >> >>  * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
> >> >>
> >> >> It kinda sounds like it's supposed to be OK to use GFP_ATOMIC in a
> >> >> normal preempt_disable() context. So do you know exactly why it's
> >> >> invalid to use it in this stop_machine() context here? Maybe we need to
> >> >> update this comment.
> >> >
> >> > In non-PREEMPT_RT configurations, this is fine to use.
> >> > However, in PREEMPT_RT, it should not be used because
> >> > spin_lock becomes a sleepable lock backed by an rt-mutex.
> >> >
> >> > From Documentation/locking/locktypes.rst:
> >> >
> >> >   The fact that PREEMPT_RT changes the lock category of spinlock_t and
> >> >   rwlock_t from spinning to sleeping.
> >> >
> >> > As you know, all locks related to memory allocation
> >> > (e.g., zone_lock, PCP locks, etc.) use spin_lock,
> >> > which becomes sleepable under PREEMPT_RT.
> >> >
> >> > The callback of stop_machine() is executed in a preemption-disabled context
> >> > (see cpu_stopper_thread()). In this context, if it fails to acquire a spinlock
> >> > during memory allocation,
> >> > the task would be able to go to sleep while preemption is disabled,
> >> > which is an obviously problematic situation.
> >>
> >> But this is what I mean, doesn't this sound like the GFP_ATOMIC comment
> >> I quoted is wrong (or at least, it implies things which are wrong)? The
> >> comment refers specifically to raw_spin_lock() and "strict
> >> non-preemptive contexts". Which sounds like it is being written with
> >> PREEMPT_RT in mind. But that doesn't really match what you've said.
> >
> > No. I think the comment of GFP_ATOMIC is right.
> > It definitely said:
> >   The current implementation *doesn't support* NMI and few other strict
> >   *non-preemptive contexts (e.g. raw_spin_lock)*.
>
> But this phrasing sounds like there are other non-preemptive contexts
> that it _does_ support. I would definitely read this as implying that
> plain old preempt_disable() is OK. I don't understand what those "few
> other strict contexts" are, nor why the stop_machine() context is
> included in them.

I think this phrasing seems to consider non-preeptive case for
the priority or schedule policy but still make me confused too.
But What I worth to say the stop_machine() -- exactly the callback
context (stopper thread context) by stop_machine() is
the same for raw_spin_lock() case where
explictly disable preemption by calling preempt_disable().

The reason why raw_spin_lock() context couldn't call the GFP_ATOMIC
since it explicitly disable preemption by calling preempt_disable().

stop_machine() callback context -- stopper thread's context is also the same.
when it calls the callback by stopper (see cpu_stopper_thread()):

  ...
  preempt_count_inc();
  ret = fn(arg);
  ...
  preempt_count_dec();
  ...

preemption is explicitly disabled like raw_spin_lock()

So it seems to include in "few strict non-preemptive context".

--
Sincerely,
Yeoreum Yun


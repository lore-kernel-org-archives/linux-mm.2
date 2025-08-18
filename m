Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0497FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 15:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E198E001F; Mon, 18 Aug 2025 11:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E348E001C; Mon, 18 Aug 2025 11:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF8E6B00C7; Mon, 18 Aug 2025 11:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 366766B00C3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:19:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFF4711890A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:19:29 +0000 (UTC)
X-FDA: 83790237258.30.5122414
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010048.outbound.protection.outlook.com [52.101.69.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id BE2DD180013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:19:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p7o+weha;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p7o+weha;
	spf=pass (imf06.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.48 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755530366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTS9hpEJ+eQ4sLhJlgnGrJXo1OC+sGhmXfr2U9313jg=;
	b=dc/4Qw92yqJltL+sAzLzJo7X8TpjcEcROJFB1iVR7B1j3iNyLfWYRLwAballajp3OXtHLa
	duY8+llKDRSAcln/eZJKojUCngO5DnVh2we63bBXqRsp9YcjME3XIfjOBQowgocVZSE/0z
	4nmkg0sYosR7ohrZR806E9h/QpKlkdY=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755530366; a=rsa-sha256;
	cv=pass;
	b=cXXU+pkKMmmSF5BSo3g1zCpGgQa+agMOevatXpw/Ki4I66svBzXIDNSOorwZsLG4hiIZGI
	Da/HTIj2nzSpaZ7JHpRodZ9veou3ct2QVzD1cxJ597nyEVZGhzD6fIO5stdwQRsy7q3nga
	cDX0Xdf6DKjrs0zIx7Y62GxHfna7YDY=
ARC-Authentication-Results: i=3;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p7o+weha;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p7o+weha;
	spf=pass (imf06.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.48 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CDayKrZI1GbgkQT3ezYfpZRSsN60P67IA1DuB4fSv1BURyyVHwEeWCNDSHUhdtyRaZU18Vk/qtpWYYVZIds0PIFOThURSFu6gvn8WOS3hgDiQodV3VDcHP8uwCsFUU5axqLTfX55Zphz66Lya94YrNMB31tgak0IrsT1dYsahHHKlbAOFIc99KOxG4fTZOK7p9SFifeSg0VfS01Vww3/qlBBgoX+5bgjFRSXKW+EwW8gxbwfQc/Sx4LVQrpkNjX1LnFIJajJnOJYdvk9UigDPh7AzLLWGo4ylicRAe1lHrqprJ3AsufV61Em3kQRWGwiEJ4LZ8jzyvFASlV0sokd9A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTS9hpEJ+eQ4sLhJlgnGrJXo1OC+sGhmXfr2U9313jg=;
 b=kvWK3xyRsiHiUh/B+HOcTGc75R8FH7XiXTALBC6/AHoZFceFEtgMIqQkiLzfGs2usejRKYctugnkKa9IPyZYo9ugST4k5aFG04HBMNWEhkCfli/N/q1S9pCga/TPinIKaERHaUWylDApKJq9u6GJ7HnOY1EjJC+xr38XVZSqojVfli+VMdkjpeBMPbbRIOe/t1GzZCfsRUy2DN11ShJVTzEJHpIg8DKEJqZFCjG4/8PbSpMgOkW32iGZUUDbI/jrL53iCGdhET6fGvUS+8Wd44/lOXqiXAp8JSqIS9evnXyWg5P4lGTWSBJmUDmjIx6etJOwHslhdH0v7p8vSGuZkQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTS9hpEJ+eQ4sLhJlgnGrJXo1OC+sGhmXfr2U9313jg=;
 b=p7o+wehaPH8bL9FQjFT2r9hXlLryCe/e5zquwmiu5Kr8rOCmpBVS6+qHkJx1rceNjDb/D4cwKWCABabYNsCdcWYgly6go6QACZfF+kKnTT0EYXp1EYl2aBJCtxeQJ8d05p7CiO6V4p5zYcUneQhkUQTREXG/eePhNLxrfNb24hs=
Received: from DUZPR01CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::7) by AS8PR08MB10172.eurprd08.prod.outlook.com
 (2603:10a6:20b:628::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Mon, 18 Aug
 2025 15:19:21 +0000
Received: from DB1PEPF000509EE.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::61) by DUZPR01CA0076.outlook.office365.com
 (2603:10a6:10:46a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Mon,
 18 Aug 2025 15:19:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EE.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Mon, 18 Aug 2025 15:19:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bBSNP68isgZVcR96KfbJ/ud/JLOz8+at9fRi+UKhq2QXtX4KnTETLdUPLV/7escwiLdTbV0Wi5VGdgvdJ7t/VKcYDErxZRcEF6RRsUUaNuHYGiyOtpvrnKth0zD4x2VgO/F73VUfyaVP2lf3JxU7/pHyZSpF7Y9W/FJyosDwbsJ/zbDVF0G7uKvTlH7EBRYdELVcAc4cNbZs+Qj9CoTxI1fmkPaSojCLY/a/toqiTTve3ntjubuFBIdaHznZ+OJRaqEkMEZ8lJxA8j/ueO3FxwSnNfkmscDrq3xgw3ekODZOrer+FKcAZlGrrCURlllDuWDduIsm5klMjo4fx+I36A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTS9hpEJ+eQ4sLhJlgnGrJXo1OC+sGhmXfr2U9313jg=;
 b=ncyB3q4XwbNRQ87GJhI20N2n0WLLH524Md9TFJBShyejpm+QccLJ6iqGjRoTCjer1GrnpCGz9m1QBLNJrwDCyUvBAHhBZTmZiJA++zPrFqXvU+FckDod7WbJolQ1V7Fx2JiN3yty2xCFLreDotWXUj7Hw31j212sHrdiSCx1hRCfY3F2tpFJRhhdUyN3CAbTMZg7VfqMtQc7tEOC2QO4btO7AmT5DXc/BQLhTdATDyEbREVqckmSOsKZocf17aAibP07ACfpqBGpMhVkFMpSXrI3fxvpyhZrA8xwlzXDSQYaOjsGl99XRT5tCWp75tgThevTe90eek69KxY+SXG9kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTS9hpEJ+eQ4sLhJlgnGrJXo1OC+sGhmXfr2U9313jg=;
 b=p7o+wehaPH8bL9FQjFT2r9hXlLryCe/e5zquwmiu5Kr8rOCmpBVS6+qHkJx1rceNjDb/D4cwKWCABabYNsCdcWYgly6go6QACZfF+kKnTT0EYXp1EYl2aBJCtxeQJ8d05p7CiO6V4p5zYcUneQhkUQTREXG/eePhNLxrfNb24hs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DBBPR08MB10483.eurprd08.prod.outlook.com
 (2603:10a6:10:535::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 15:18:47 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:18:45 +0000
Date: Mon, 18 Aug 2025 16:18:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
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
Subject: Re: [PATCH v4 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <aKNEUocjM16NpPpS@e129823.arm.com>
References: <20250818075051.996764-1-yeoreum.yun@arm.com>
 <20250818075051.996764-2-yeoreum.yun@arm.com>
 <CA+fCnZcce88Sj=oAe-cwydu7Ums=wk2Ps=JZkz0RwO-M_DjfVQ@mail.gmail.com>
 <aKMmcPR8ordnn1AG@e129823.arm.com>
 <CA+fCnZd9m3WBPimikuxSMNar-xbDaNFNQEJ9Bn=8uCMe-uYHeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZd9m3WBPimikuxSMNar-xbDaNFNQEJ9Bn=8uCMe-uYHeQ@mail.gmail.com>
X-ClientProxiedBy: LO2P123CA0003.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::15) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DBBPR08MB10483:EE_|DB1PEPF000509EE:EE_|AS8PR08MB10172:EE_
X-MS-Office365-Filtering-Correlation-Id: 6edb02f2-bf67-448b-57aa-08ddde6a9ac6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?KzFOU1MzcVJFUml0Y0NqdFh3K1V5Ry9seXl0WlZKYjVMODhLSlR5bEExRUxj?=
 =?utf-8?B?SDRsRFZ6SFcvZmY3V3RvNW5YUUhoZXRCNERkZnJPSUxQRmRaQXBacUN3ZHEz?=
 =?utf-8?B?d0RJR1krUnorcVpYZ3Y4MmxSQnpXSTRsOWYrVmNyczg2MHRJaFJQT0p2Qnp5?=
 =?utf-8?B?S1E4UHU4TlZQQzZCNW1HQll4RjVYMWJaUmJ5R1BIa0hWd005ajhmaDRINVdz?=
 =?utf-8?B?UWp4UHJ1dGhlMnNQc01WUjZ5a01XTXlzNmJNaVNkbTZVbnJDL1lPZk82Wmoz?=
 =?utf-8?B?b0F5ZEZJVUx3RS9uQ0V3blJKLytOWFJZYnU2WEN6cTluaEQzbk1qdnlQekt3?=
 =?utf-8?B?UEJXdUkwT1VtY1g0YXMvWEw0RTkwbnpJQ0lQcDRDdGFvRnpDR3lMUXlBSEZk?=
 =?utf-8?B?MmJhWEYvZzlxZmRlUVQzSGRkZWJJRGY0aHE0R2hhRE1iV053aWlFQUpuUW1w?=
 =?utf-8?B?WXVTUENiVUQ3RWRNVlYyVzdFUSs0WXJPd0p1US80N3RhRktVWnBnRVhsN1Az?=
 =?utf-8?B?aVBJVFhFblViZnVONEg3R3g1cXVMZGYvVXJBajVHWk1pUlJMeG14TXRmN3M5?=
 =?utf-8?B?R09JUkQ4ZVN0T0czRjRDSDFEYmtrakdmQjd3eW9aRTBKcnZGTU1SVWdPWksv?=
 =?utf-8?B?VWJ2a0FQL0Q0OWhzYjNJSGVINjl5cDJUeUxIT0lHRzhoZEhkdWc0L2lUR0Vm?=
 =?utf-8?B?Q3hoakJyMzBKUDBzRnBBNHVYM1pIdytmQ01EV2FlRjlmZ3pDVkdnL3FodHMz?=
 =?utf-8?B?Mmx4VXBndi9USGZocnNQa1FtRW9KVVVtK0pYSGhJcThBUTdFVUY5SDZJaWZa?=
 =?utf-8?B?TDcrbkhCQktzK0NTR052b2hNZURiMnQvWFVXYlFOZ2tpa2owdUordk5HeG1B?=
 =?utf-8?B?QUtWcjQxOVVZTXBsRmlyUUZack5FNHNyQlZ0anlVclNYRW85TEIvcklYaC80?=
 =?utf-8?B?eEF1U0k0Q1VyM2Y5YXczTXNtdHAyRlc4aTFZbTFCOGptcmc0TE1xN2dOUkZq?=
 =?utf-8?B?ampWSE5MQUhpM1FhMnFaYWY5TTFoK1Y2elF2bXRYTVJDd2ZPN0EzcGdiQ3pN?=
 =?utf-8?B?UDVzdjMzUmprbGFZbjZ5Rm1TQ3RONXd0UkE0L1JMTlRqTk95aWgyb25Wb0wx?=
 =?utf-8?B?Vmw0VkZlSlVmbGgwRFlEVzRBUkFPaFh1T3N3bHY1Q1RpTkg5b2ZSMDNadDl4?=
 =?utf-8?B?NERRRWJQL2owUXZyclRzVEQ3dmM1T2h1OWpyb3JuZHVua0VlTW1xZklKTjYw?=
 =?utf-8?B?YVpuN0VFR2NGeW11WUxhOEFsTWRCQU83SFN0Y2dxYWxyTkJSVzhrYlFSRUd4?=
 =?utf-8?B?djgzWlBQZGJab3NuYllON2REM1JpWTJTWlRMZVIzUWhrQzRyVDBzYTNnbmo0?=
 =?utf-8?B?OTlZTDlISFprLzVTQm9RTVlzWmpDcWFkOXY4NHI4Y1dHcXhPdU1oTlBMaVFB?=
 =?utf-8?B?Z2FHcHFhZjlSRU93YkJUcVB5M0dqVU1nSGhGRzFNeEdGT1BrcEwyZEg1WVlR?=
 =?utf-8?B?NkpncW84eFFyczBub0VzTElzd2R6VzVqMXpsNURPcmRabnpuQmd6OStabHZ0?=
 =?utf-8?B?bWg4Y0VrRSttZitvRENWZmhTcjJDVzVxeUJid3FjNnNLcnpnZ09VV3Z2VFd0?=
 =?utf-8?B?OFZwd3Q1TlBHVXpQVEMzSlRlQ2Y2MXlxN1VlRm93Q1BmU1ltQ2VqZVF6MlhS?=
 =?utf-8?B?a2ZocjBHdDU1aVM3SXRTMzhlM2ppd2RFNXdSYWQyZ0gwTlhVWmtJMzMrVHdM?=
 =?utf-8?B?ZzZlSVFRZjBMdm9UYVhXSVVON3Z0M2RWQmF0VWltSWxmd0VsLzNzUmVqMEZv?=
 =?utf-8?B?UUVkZG1CeE1memcybHVJa1pyUVdLQXQrREtvM0FCSUZsL0J4WTlCWCtmWmlG?=
 =?utf-8?B?TFR6a0hIdGJKNGhGWE9HSWhqMklYS0ZBSG9rQithbnZ1cEVJSEpWZnplYTZz?=
 =?utf-8?Q?mwYMQMFdF1U=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3d2d464a-7589-417b-4d23-08ddde6a8621
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|14060799003|35042699022|36860700013|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHFER2VIM0JVTUR5ZjFDOXdWUGNWUnFmaGlRY25jQm9UUUViNzJsMGxRaTJO?=
 =?utf-8?B?Y0d4RUdIeUVUUHg1TjUyZUo1SnFlSkpDRkk3aUd0bjJGbCtBTnpKam4wamsx?=
 =?utf-8?B?ckhpMGJFRXVBM3FaZGNReFhHUkwyOGNlZDNrcGEyS2dGU0hLNE5GUmlqZ2dr?=
 =?utf-8?B?R0E5VGJ5OEE4S1dQTkkrZE1NUUlPd2xWQ3BMQlBpL08rWGd2dURjNkxvVHJ2?=
 =?utf-8?B?cFdYMVBWTUk1SmsySnNHN0ZGUTZPWDlLUjI0blNPSGV3a0ZKaGFyTlJOSERW?=
 =?utf-8?B?Ty9WWHVqQ3puVUpNVXEvekwyQTB5emVKRVZVUm5TZFJta3NrTHREYTlEcUIy?=
 =?utf-8?B?ck1WU0hIbkhTaTFTeERtNVhsQjU4T1lDTkxXaVZIYVJqYW9WY0RBUXJnazJQ?=
 =?utf-8?B?cWdvWWN6UTFoZVd3M1dPWG95dTVFNnJEUlFkYUorSERTVkJnQmFzSGUrVC9u?=
 =?utf-8?B?MU03a1NCTWxTZ1hkMWx1MWdmb2g1ZysxTW9SdFNsOXhKeHYrYTJoR2RDby9Z?=
 =?utf-8?B?a2N3dlVkZVY0amlBY0pCT1JHakdTNWVtZ3cvRlREZlBtYjlEbnFnTmZ2cEF3?=
 =?utf-8?B?bEJydEtobnAxWXJ6eU1xRUlQbll6OXkxY1k1UEFkbk9Kak02SEJvUVB3VldQ?=
 =?utf-8?B?UWFwRlVCWVQxbjArYjZTVmxSTjhiMEIzM3dQakFaL2lQenVNWXNRcmZRZzJs?=
 =?utf-8?B?ckdkREx0SEJHV2ZBUWxoZk5UNnVYc1lOZ3NtMVZ1d0dvQkJSaVp3U0VGY0d3?=
 =?utf-8?B?MmJiclRoTzNPT1EzRWZDZEk1TFdSVUh1aVhubmt3QTJNWEU3WHBxNVNobjda?=
 =?utf-8?B?eFB0T1YzbnFISG9uRS9FbEcxWmVvZThhZG5pK1NzN25rMS9iNDhTZmFBcHpF?=
 =?utf-8?B?ZHlpaUliVUJnQjd5aFo0RktTVlhMcC9ZTFVZY29jVGNLZlo3YmRWa0RqL1hU?=
 =?utf-8?B?eXo4Z3R2OHMrMkdCc0h2RmRSYmFtdExDWUpHRm5GamRlQ0lueW5CdFQvMDFo?=
 =?utf-8?B?ejRuVzBHTDNhR1hvS0xKSTl5VTdIR3MrdjhCWS8vS0NsRENjTzBzVHM5MWRV?=
 =?utf-8?B?MGpBcnBSOXZSM20yUzQ0RklRbGpZekVUMmRVMktzRjRoc3NBVmVGOE5mQnpG?=
 =?utf-8?B?QTNHOVhoSEJtYjVqU2diRlM2bE9PK3ZvamVlaWRDTFRtSkdqMU0zQW1ESjRP?=
 =?utf-8?B?ODJBRmRwMlNvM3U0YXZza0hzOTExY3cvNjBqT1JDdjN0ak1hZXQxb2xFU1lO?=
 =?utf-8?B?QlZ6aG9NdDluazM5c2g3TkptdDdtN0liWEh4N1YyemlvcUpRMmRsUWc5NmVL?=
 =?utf-8?B?czBzNXpNNkc0OE5Gak50dElaeFF2bXNXZXVNejhudmVPcmthVDVWNDRtR1ZS?=
 =?utf-8?B?ZysvVHZmQUluU1I5YUJuVVZpNEx3NmM2dklKL1c3enJUTFJoRzV4Nm5QLysv?=
 =?utf-8?B?ZnBIWHJUaUVJM3EyT3NMSFp6QUZQUERsVjhwaTFqQTdXYlA4c3czcjNBTWV4?=
 =?utf-8?B?UldxNjhZcUZnZjdHVENqQkp0am5iUlo2c2lDd0l5TzZBRUdpMzY5TWIwdjZQ?=
 =?utf-8?B?djVDdmhDdS9Lb05zd0h0KzFvZ3oxNzFhL3NlSjgwSlFyeDZFYTlMdlgvbzQv?=
 =?utf-8?B?RWQ5K1duVWF2RE9jWnBZOFE1QXJtYlBWWmVRUHUxM1g0dUJ1STRlbWE1dHI0?=
 =?utf-8?B?U0k4eXVIeGJhcWR4dVU3Nzk3RHR6SHpFbHB5VXQ2S2RuTDV0MDB6S29SU3hs?=
 =?utf-8?B?NXZIcmszeUkrUWVUOEJKbkZuQlFYdUgwV1IxUGRydVljSXk2Y3NwdlR2MFRz?=
 =?utf-8?B?Z0o3cGlIdDNNb0Z2R0JLWFJxWStacE9wc052bndvYURkTmw4cDlUVGh4bWp4?=
 =?utf-8?B?RVlzcVFkdFZjUTN1ZHM5WFdMSjVRK2VYNjc2bFdSR1NkVzZuekdOUkxpNHdH?=
 =?utf-8?B?ZWs1ckowaldpNm9JT3MzQ2ZsazNXUm5kcmVWWVIydGFQVCtlWVpIRE1oU24w?=
 =?utf-8?B?RG02eFVKYWNyRlVWVDF2ZW5ObUpxS2FTSFp6bzNwMGdBTHpRQ2g4SUgrRTVa?=
 =?utf-8?Q?dFAhoO?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(14060799003)(35042699022)(36860700013)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 15:19:19.9675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edb02f2-bf67-448b-57aa-08ddde6a9ac6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10172
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE2DD180013
X-Stat-Signature: it7c3ecn3nmc4e4ur35mqmo8xsb76npg
X-HE-Tag: 1755530365-351681
X-HE-Meta: U2FsdGVkX18uNdot/TtdxF8gHNRLGfBvvXYh0Di9w3kBxbj4mzMPnB51/0a9zATKwrtIbJazit5KatQSKda1ufn4kY+VoTNXfJ1C3E25NvZ+oyA9G7JeIG2Oo2coMW25xH3goqhG//qYyO3IB+8BxwyMHJp56jcLwy92tqvFj+ZF/z5f3jdF5iJ7EIN/Yn2pPawFHrHfHrvt4fgvyBXydAfzYFvcP4HR6X5qLvO5D6+DrNrItoyJMp+7e1WCRCef4Ifo+DOV/qrLnKWJK9x8HX7PDvK8Ng65lUL/xE2B5cp3dNNL0Nnc+TwVd1GIljYsGQcoCojWkKGqAxsyAbFL+v+tNc2exVdU3feu5HraFlXyQKxck7hbgmwMm1QtEv+eqYryxyPLjEGAdiVbBx+ndbNjTLuWpe7tQYpyO9pi9cf07AB4zl7RYB2rFL+fQSpkZbtAOZq0trcdNaXHiMvOvL7BlviVsDqUQ1B6kyw8hbR+aamgatR0G+iT+pFiPyua/eaZzS9UXJnXFhwaW6SsEBtRK+4U7CubwtyDHT9JMwkFR4xygiafxyqp/216PLhkzOCDM2vUTlAa+DxqEma16qlHEhPjk1rm/9jNoF70bDcbbc1CsJCPexR0sE2cJad0W7PdMthWeiGm20g2W7GuSBsn3nH283f4vUg0PY0/eGgjaxI2XTw4mSxMKz82uA9cpuVjcLyJzg4CuS5FgsMNBOr65yJANyRHun9CrZCi1Sxmt8ZwGL4v0iXTlCOc4rxsQn54Ax4Arlsbv7oIeMmFHkon6yRY9F0m3bFuawkZEiL55k1Cdd9ZTrVYTuGIQZpFpkDMo+4Qm7IuH/rgA49jp9Dbh/pDCGtv1wJvFZM/gGXP4zntP4cOmKULrQzoiXRVOW0EBhXvzCjqrTQs6BI++FraE6859R/yxiN38CsEfnhUlgtIkgZCXdlP98FJVUQog1J+D90ZEUiUOf1BlO2
 MY/spAwW
 Jwkvy7lI/d/Rx5YcYGpqiy4Jqox4JEDtRasNePUiOmAiLaEzNd6CFubAHz9KJYUDltsPdib8p+pKOdXfhVMbYQ9aUPx6khmuY7gtsfmVIv5Bgq5e+1ptc8WlQnnwLCajh+pLp3iPkgeMLqG9NInAXvTWlW+EsMHP493bqzpALVXpxPTg7/9J2Bp7qAlZbxLeajrjyC2N9dBQXBPXaZItMCXf03cAK6FMqyxqGru6huoVVYQit/nMOArF5AlycaeGhM920k3GlOXPoGVkwhqZiiYlhH9U+G3I2uqkJPLCIdS3FxlCF8MO6ykHQhldGG/YLw0RlEfysyW36ZLjQPcv9/w4LWZroEwTFZFdTCDjxGpsd0yCGbUsLcCRGVKd2Nd+KdQUkPv1oXgN782Jl/1oqjuHcQuWyNwExplMqCAESJe0438gIroBQ+FgnUp3Er0zaQWNW9ezsdniwVkJLnDV1D+mM4MvVUMNXEuH3KmP58kezTXgLqiqS+9KjZhobhQkoHdOvh+iVIV6byIQm5jlXgXoos2K3e2Vbsw+miTlsWX9bAigqKXZBz9GNs24EIy1+qEp4G6wNfVRdbUZj422FRjG0Vp20aYf4j0k22cBvepiMqKwV2qKE7JL9cejcd9JVSH5rffUm9JD4JwVJN22wIAnDDWy5YKV2q95TkJbRT3CJnvc+eYNLHNN2SI7dcuWxfQN99f+fcIGUq6U48JeGDhX6uwn5b8Zm0qyLde39gvrN2+hGaYvWkQbUhjYLn35LrxC5CL3ZlgE27CCQ05lUTubmRmwV5lzAvm0EFXxh0f0MXmClPLS798/Qxja7nWvfG9bThO3n7piy7PDabsrEiEnZh83IiRyLkLXEYvoZCKRjaZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andery,
> On Mon, Aug 18, 2025 at 3:11 PM Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> >
> > > > +           hw_enable_tag_checks_write_only()) {
> > > > +               kasan_arg_write_only == KASAN_ARG_WRITE_ONLY_OFF;
> > >
> > > Typo in == in the line above. But also I think we can just drop the
> > > line: kasan_arg_write_only is KASAN_ARG_WRITE_ONLY_ON after all, it's
> > > just not supported and thus kasan_flag_write_only is set to false to
> > > reflect that.
> >
> > Sorry :\ I've missed this fix from patch 3... this should be == to =.
> >
> > However, we couldn't remove kasan_arg_write_only check in condition.
> > If one of cpu get failed to hw_enable_tag_checks_write_only() then
> > By changing this with KASAN_ARG_WRITE_ONLY_OFF, It prevent to call
> > hw_eanble_tag_checks_write_only() in other cpu.
>
> Is it possible that the write-only mode will fail to be enabled on one
> CPU but then get enabled successfully for another?
>
> What would happen with the current code if the first CPU succeeds in
> enabling the write-only mode, and the second one fails?

The only failure case is when CPU doesn't support the MTE_STORE_ONLY feature.
Since MTE_STORE_ONLY is BOOT CPU feature, the CPUs have two state --
all CPUs have a MTE_STORE_ONLY feature or they doesn't have it.

So when boot-cpu try to enable the write-only option according to
"write_only=on" boot argument but the cpu doesn't have this feature,
hw_enable_tag_checks_write_only() will fail and prevent the calling
hw_enable_tag_checks_write_only() in other cpu by kasan_arg_write_only
as OFF to prevent other cpu call this function since it'll be failed
anyway.

So there is no case for failure -- the first CPU succeeds but second one
fails. if first one succeeds, all cpus will success ans vice versa.

This condition just to prevent to call
hw_enable_tags_checks_write_only() by other cpu if first cpu found it
doesn't support MTE_STORE_ONLY feature since other doesn't need to call
hw_eanble_tag_checks_write_only() function -- it'll be failed
so it is meaningless call.

>
> > As you said, kasan_flag_write_only reflects the state.
> > But like other option, I keep the condition to call the hw_enable_xxx()
> > by checking the "argments" and keep the "hw enable state" with
> > kasan_flag_write_only.
>
> Assuming we keep this behavior, please add a comment explaining all this.

Okay. :)

--
Sincerely,
Yeoreum Yun


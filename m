Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8CECAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77978E0008; Thu,  2 Oct 2025 07:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F448E0002; Thu,  2 Oct 2025 07:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D165D8E0008; Thu,  2 Oct 2025 07:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA6168E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:43:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CB17119E1C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:43:42 +0000 (UTC)
X-FDA: 83952989484.01.ED1551E
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011031.outbound.protection.outlook.com [52.101.65.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 702528000F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:43:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cg4fUyT9;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cg4fUyT9;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.65.31 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1759405419; a=rsa-sha256;
	cv=pass;
	b=MOr2JeMOKGoXwx9hD6omx08vX3OsQc2NFaQFu4VQNb1d/SZGxnFG3ZMsaz1UBKzOXKpiBZ
	GBRS4Iw0mU3rGvbnH+uf2yGvUDNRr0tjL/3aq3PKlTYFvpeTJ7s3TKl4PzqE5VNrytPwR8
	3Y0FBOAe8E2iRovCl6PO8mAGn1sRIYs=
ARC-Authentication-Results: i=3;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cg4fUyT9;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cg4fUyT9;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.65.31 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759405419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIob6CqaZyQZRvTAhRaSJfxFL6RGvYKLnayqbqD051c=;
	b=VYbU3mxGu2fK3QlR0fGhfrW6/GH0hF4q2NgBWRfDQd2NZxAtYjqJ4QvXCJEQjz+ChxpveM
	5oFgVHGw+HV5qobFK95tORE5L7d5HuP/792rYaIcBt7W2kls7OHZMLwJ8GQpbauaqy87Ni
	bwSGaXB5iSeI6dTEBOCfCXDr0xWV5Tk=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=N/PzCHjZGNCWdZHJCsebLE2R4qlXbWYiQXxRynBFiQkSG/drzF+OVLigD1zZZXVSKHYA3U5GMD2ceF3G71M5fR40t/XTk505vrfud9ZdqEGoV5DbscwoKx1M1BcClFR40q1AttnM4WngEdx0o/soZhA2sYRMAsQRpwLcqg05q78U+Oslzqux5RkmqFsdYqFsod/nQtoFJ0di5qi7we72aX6Z78DqQ9I7JnLpzuMfJRtOdTwdNTqHktim8S/9Cg1KKIaN4RZAWVZn6w54H6R3UpZFfIM8Re63+uyuVeFpf9s8sXVM0wwvoK72hYxgVrT3vxI0GF16EplcfEpLII/IIQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIob6CqaZyQZRvTAhRaSJfxFL6RGvYKLnayqbqD051c=;
 b=Ys/1wjscgq4shEdluoyFEhjqAkabcq6BFL0Jc325gAhM7HmocFhcQxhyLTEoUGx3RPnqf+rWmUNLiAU6JN1HmQ0dTI50e4HzoI6/5HrMlqOocTeqfGDEQwspiNS2mUkwRFwiuLUE6oss2M1XCNCHhkrRUxFRPqnOSmUhuYkiFmRnmQkVZzpeyXErMw5ktqaCx3lWKr3qD0tfZTTKMdm759P1imYyjRTNE6BBtjS8N3lju6APj+UccabyVqg/v9vwrHMcr2Fzc4KgrPfy8fjYhhcSTz0u9LsJSlZbcZC+nz8ygHDftf2AhNaWvE/i/SdoIR9oUVPkRwHCF76H6cEXeQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=sk.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIob6CqaZyQZRvTAhRaSJfxFL6RGvYKLnayqbqD051c=;
 b=cg4fUyT91whG1yTZa1DchSbjDWY3NpQJIRGSW/wEsN23+z8+uF+wQNxb0+ex9pdz/74mAs/T0Is1KiSe7XE/67WKg3JP9b0tWRsocNGJoRp3W1xD01yA9GavP9Z3SYwE5jw03X/1hY87eA+atm6KcyfKnSfiyXEiF2vSJAXL9qM=
Received: from DUZPR01CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::6) by VI0PR08MB10780.eurprd08.prod.outlook.com
 (2603:10a6:800:204::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 11:43:26 +0000
Received: from DU6PEPF0000B61F.eurprd02.prod.outlook.com
 (2603:10a6:10:468:cafe::7e) by DUZPR01CA0043.outlook.office365.com
 (2603:10a6:10:468::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.15 via Frontend Transport; Thu,
 2 Oct 2025 11:44:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61F.mail.protection.outlook.com (10.167.8.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.15
 via Frontend Transport; Thu, 2 Oct 2025 11:43:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMKDaBl93ZopNqO24310KVZtAKMe3GYcWmOdVMQ4RdVX33LUGlScJI7i03FnwUk23NDX6ybCzvtfIAMlXtveXprjKohjYrO20XE5pwKRZzcJmQARa4SR1nZ8y2kWqt2nLc6LSFRUCcP3AeTG7Qd1XaT9puW4sCFv5tu6s//MVLPA1IdXFPNdXJJKrrZ2/Iuv/NSLOryg6Pr36fnC82+YUwN+TITYpagNTyFD1qxE7EibN2K6nHOuq1sO8vkyLttdOs2WU9ErVez0dnQC+IVeCFXJdxy0+mWBUpFH1iEa4zohNPTY3P1MroqA5HWeuOGBHoiyMRf28yJ1z2gpuJHxrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIob6CqaZyQZRvTAhRaSJfxFL6RGvYKLnayqbqD051c=;
 b=mVoaxh+sLVmZLp9Gh6dKxFCOykPCmAtV1EEUXjAahnVN/DxXA4tmfNNZxNtZ026KMainfud5QWvTI9LoJdd0vLNAWXEzPnktM8pDrTfv70FO9vIdgQiJTo8/Ci2VOJvL9WN5f0XBU99gQHDW5sd2x9j2LzsNgnAeJy6kZAGZxLLauZGowOaPkyPeL/m1yhgWwtgytrdERcFv5ZceUToTUAEX8/ReqFYMU9e/BLfaaJ9woLlcxo4VBHuJiw3hfGlKZKzkfaZgkOwGHHzY99p69PCsHyvyaNVcYGDRvefjEoI8mfc7vFFGxNK1pyotQvUIIKdVFPulUYDK/MSfBGcuXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIob6CqaZyQZRvTAhRaSJfxFL6RGvYKLnayqbqD051c=;
 b=cg4fUyT91whG1yTZa1DchSbjDWY3NpQJIRGSW/wEsN23+z8+uF+wQNxb0+ex9pdz/74mAs/T0Is1KiSe7XE/67WKg3JP9b0tWRsocNGJoRp3W1xD01yA9GavP9Z3SYwE5jw03X/1hY87eA+atm6KcyfKnSfiyXEiF2vSJAXL9qM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB8PR08MB5324.eurprd08.prod.outlook.com
 (2603:10a6:10:11e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Thu, 2 Oct
 2025 11:42:52 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 11:42:52 +0000
Date: Thu, 2 Oct 2025 12:42:48 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Byungchul Park <byungchul@sk.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	clameter@sgi.com, kravetz@us.ibm.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, harry.yoo@oracle.com,
	gwan-gyeong.mun@intel.com, syzkaller@googlegroups.com,
	ysk@kzalloc.com
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <aN5lOFVFfewXUijF@e129823.arm.com>
References: <20251002081612.53281-1-byungchul@sk.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251002081612.53281-1-byungchul@sk.com>
X-ClientProxiedBy: LO4P123CA0531.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::15) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB8PR08MB5324:EE_|DU6PEPF0000B61F:EE_|VI0PR08MB10780:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c176c6b-fac5-4b2f-0f62-08de01a8e5f4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?NzhjN2VaTmZydmZMdnZEWUVURjVwWWZTTFVuSGpNOFIrTS9VWmJiNjAyUUho?=
 =?utf-8?B?dzRlekM0UUUrREdjb1ZmMkNuRGF3enorUGZ3Vnhnc0c3S0tpR3pZQjdFWTd4?=
 =?utf-8?B?Qzk2cVpWSG9adS8wVEF6SXE2N3EzWHpwQnJBUkZITy9TREtGT21xd0c2VW9C?=
 =?utf-8?B?T1Nmak1tN1lZZzdhditUdkpJZU1sZnF3amQ5UldkS1AwY1BwRTRJM1dNTmQ4?=
 =?utf-8?B?S3dWcWpMUWQrRytmaC9pTnFROWpzN1lMQ3Z6VnJzN09PTXZtSTBjREJ3VFNn?=
 =?utf-8?B?T0RCU2p3eDFqOG9BWGNFZE1OUWVoYXByU3JYQzZiUmI4eit6eUd6cGZFaXNT?=
 =?utf-8?B?L05VbXBiMk8wUk9pN1Z4bDBVQUFIQ2NmeU9lanBDck0wemFJejVEVVlSMG1o?=
 =?utf-8?B?UmxOc0lpUWsyc0RUNkUzckI2eHFHWGp4M0RSckx0S2FYMEhYOFZNMjgzMFNR?=
 =?utf-8?B?RzZkd1hQeUNaVVlpQ0FTenpnOUg1eUFudVlSRHJGbG1qUUtNQjhSbEVHNHF6?=
 =?utf-8?B?a01qc0ZxcWpTZ3VPV0lIUEVKSUtiUXdhSUtRMitueEVjdVVrWkdCTXVFRmt2?=
 =?utf-8?B?MDErTEJkaGNLelRLNHVpR3RjdWUxYkRzRDlmT0lqZE5oU2p4K3pCS0ZFd0lD?=
 =?utf-8?B?dTBpZ0pjbTJxLzlLUTBvbkhHVXdMTmpzQ0c1RmM3TjJpNU1FMWp2L1V1Q2tV?=
 =?utf-8?B?Q2dNcXlWekJOcTdJZ0NoZ2pVTlFoeUxaeW81TW1lVUNvVkt0R0xiUWdDRTln?=
 =?utf-8?B?VXNkb1c1cnZ4WllSODNZRzVyeVUycFRUM05uK3pjeHlLNUFwQm1Id2hhZFZi?=
 =?utf-8?B?UFp6YWgrSXdMNnJvd0VsbTBCQXJqWVRkajd6Wllrd0QxTEVqTEdoZDk2aHlV?=
 =?utf-8?B?ZHRoVzA1WHJEbzVPcmVXYkwyMFJvelJtQytuOXdOMlJhUWExdkUyL00wZGM2?=
 =?utf-8?B?RVpHS2JTNFFvMy8zc0F2UHpHSHBVRm9DSEwzUG1mQndLTnZDb0R5NWZqaDJs?=
 =?utf-8?B?Z1JXVm1INnBSUzd6TWRkOXA1bFRyckVPeDcxK1hGVWJRR3R6ZjU3TWRtc3ho?=
 =?utf-8?B?a2VqRi9CcDI4U1VaamJGczF5b3paUUFNVnhWWXhYbHpITENaV0ZxbVJ6Z2sy?=
 =?utf-8?B?elB4aDdpUDI2VFJTMVdHZzdoT1dvQ1NuQUhMZGU2UElXZ1N5M1Y4SEJGUkxM?=
 =?utf-8?B?NTlkSjFaRytBMTl2VHpmN1ozUVhFUzlnN0xjbE5saGltUDNJdXMxWXBYMjhF?=
 =?utf-8?B?ckFvN09rN1JFcm9kNUdyd0hYQkpjLzVuWTFOZll6a21mTXBUWGcxbWJUODBq?=
 =?utf-8?B?cldycGZ5Y1ZPZXZnYUc0MzU2SFhYTE51cjd3MWFiOWhXMnVUR0NFOVdzbEFY?=
 =?utf-8?B?TFBqTUdsV2tDK1JxT2Fkb3hpQXdPYm85bTVPRlQ3Z0c5azRaQXhUV3IyNkFS?=
 =?utf-8?B?c3I1dUUyd2NVWGJzbElkUlJpOWFScTVMZkZmbDYzK3M5NGhXK3o1bVhoNmNu?=
 =?utf-8?B?d0ZaWU80U1lHeWsvRHdTNmFHbVZGZWE2MzZvNk9sc1BqczlkaTR1NEplTEJz?=
 =?utf-8?B?eTlpYlhZdmRzN3ZQcGRCc1ZFSXFBT2lYU0l1TXBDK1BUcUEzUTFHU09jY2Nr?=
 =?utf-8?B?dExJWHdnWEMxSkNBakNiNFVLT0dCUkpMVG5TSktaenJ1Tk9JTlIrdENqcW4r?=
 =?utf-8?B?cUM2SUFPc3dxTjZFb3U0MFE1c21UbXBudXJNbWV4UkF2bDhYSVpWMFB1Q2E2?=
 =?utf-8?B?NGNqQmc2bERjdFVQUkpVKzJkRGFEaUV3SUZRODM3bVhVVmxjNWgxa1RTNFNj?=
 =?utf-8?B?WjNBckFlejRCZ1lRZ3U4RHNyN09GS1pOUk4yZDFJNGMreWVlMERPS2J3N0pK?=
 =?utf-8?B?dGY3Um5Vb1RtL2dVQkRBcjdWQkh3bmR2Nk9aWDY4ZDZHakN1NkZyYUpHRUZX?=
 =?utf-8?Q?JeyLq7KTzrg=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5324
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e1ea2fdd-feb1-499f-933d-08de01a8d1a7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UU5xWHNLU2VKWGUxTDNoSFB6aytSeXdwUk5oVUFwYzR4disvS0NuWmtGMFFq?=
 =?utf-8?B?RXlLMk12bitMN2JtUGFpOU9qZjJHRzgrbjJ6aXMwa2dFcE5qU0xLQmNEaTk1?=
 =?utf-8?B?V05jVnltQWFqaGtsN0p0dldyMDh2bkJmVTh5N2JHQnVrNmk1ZjZIN21SN1Fs?=
 =?utf-8?B?Uk13c0U5dXd3VFRvRXVkQkNNS21Fck9QQzNMSzBnZmFhbVRJT3ljOE55SWcz?=
 =?utf-8?B?OXhmR2NvUE11cURqUE90SEh0S2NzYVJsRFUwYjJtZklFN0R1RnlyUGNOcVpi?=
 =?utf-8?B?MHU4dWFPSHVtWC9YZnE1ZUh2VjM4K0RqTjYybk9ZVWhsUGJjYXg2RGVPRUVa?=
 =?utf-8?B?Rlp0M0ExQjVJQ2NFN3YvZGllSHU4MEM5RDlSM2N0andmaVc2K21yOFVReTN2?=
 =?utf-8?B?SWhLdE5YYzJVRGJtQ21YTzhKaWlSVGZaSVNsb2g0dmViL3c5MkVxT2hXUHBK?=
 =?utf-8?B?ZEJmT3crMlcxWXByR3pRNFFaR0xSQ0J6cGFxZVFUbEVZRkZSTGt2a0RYQkN5?=
 =?utf-8?B?M0FIUzhpTmFnRjNHbmFqZFJNb1hLdFphcVZJL2szeTB3ZnA2WGlyVkxCeWNW?=
 =?utf-8?B?TlhuUXl6cWUyREVYZk4yQkhjNitwRzk5clE4VmNoWFBpNzJEN2FrRkpoUjFp?=
 =?utf-8?B?VXdxemRVWWxKRkV0ejZadzBxdFdQS1VNQ2NzR0U1cllmVWxkUmNycEtpMDRH?=
 =?utf-8?B?UFhKNlNRY2lDSzZWc1VmSzNPTUQwZE0vcDVCL2ZxUndjckpzZm1BVXZPaWV5?=
 =?utf-8?B?c3h1WEpGY1ZRTkJxbTNkZVBERkhFelVDT0RBampqZkZqb2w0UnNzcmpqM2tM?=
 =?utf-8?B?cWNLdEFnbzFRNXlKd0w3UWRDZHNaaVZYVkMweVBML0pzVUhuUkVxYzVLdDNp?=
 =?utf-8?B?NFVQWkd6NWtNUllROHFOd3RiR2tQMStmUnZKUjVRWXVxUlEvQmZHK1l2bGtN?=
 =?utf-8?B?aCszSDY5MnZBU2hKRkxlclpYZkZhcEwxenhkSENvNXZ1MjlralV5aVJwMlVS?=
 =?utf-8?B?SG54Y0w1dytaRlV3b2FmYnZBdnVzSUNQUkRUQXVjN3ZuTk9pK0k2dXovUkFP?=
 =?utf-8?B?dGsyRWhkV0NoV1drRlFRM2xoWW9EbS9PTzJlU2luQlYzS3dGZFlnUHpEd002?=
 =?utf-8?B?N3hFUXlaK0ovcmZFanJ4TTZhVXovZWxlTEt0ckhYS0gxSUJBenRnQWlHWjFH?=
 =?utf-8?B?MzgzSzR6MUtnNFZkVmx3RjlNR2tJS2FRODNWVzYxNjdHY1QxODFTVjM2UHlq?=
 =?utf-8?B?bjA4OVM3bEFmMWtqWkN2OUFwU0FmWFFyall5eGs4ZXJiZVl0U1I2ZHJXNUVH?=
 =?utf-8?B?dVFnWTYrbU8vYjJmNE9sTUpzY0tFZlZJMUlKSjBxRjRuaWR3UUNxNEduZlNM?=
 =?utf-8?B?cThEc0ZXWG5pbGZ1QURERy9vSXBDQnY5SlRkakRvRmJIcWxWZUY3Wm1zWGZj?=
 =?utf-8?B?REVpMUFaMkpRbXdnaU91S2licnhVVXljRC9BVUNwK0sxNDl0ZHFEdW12eGFD?=
 =?utf-8?B?R3Q3WXA4OTZMOHc3OTNpeVZwYUx3UzZsUTh3a1pQbzAvcGtnNUV3VFVpQ292?=
 =?utf-8?B?bWZUeUMzTndwWWFWcHJlUTMyd2JuRVNCYldVNzgwYVBsRytnekh0SjFYNXFL?=
 =?utf-8?B?ZzRkOGs3Z3dLdExadE9GL09kbWRqemg3Qm5nVHlBV2tqVW9Dam9kT2dEeFVh?=
 =?utf-8?B?NDdnTERJMWtldlpzQnZORGc1SXlGUE1kUmF4b0xlTGE3aSs1YjEzbHlJMTg5?=
 =?utf-8?B?VWQwMTc2cjVwb1d0SHg5c3RIYklWendFbXNWREk0Qnl4eW82c2t5ZkNZMjNn?=
 =?utf-8?B?RjV0Sy9DOWtmVUI4dUt1L1d6S1JMV1hWdll6WWdDOHNmUlFKSVdkUGhNanIx?=
 =?utf-8?B?Mk9ocU52MHVDbnN1c0xGL2JrRHBXaTlsUG9VSXYvS1k2Y3ptVGd6YXVWRm5s?=
 =?utf-8?B?ajRSeVloeTVrOUFtOHFuMUVieTRlVmtoRzN0eWFkRXhaelFLTUVxc3gxaXYz?=
 =?utf-8?B?TjMvTnQ1SzhVRE03UU1nZnNTd2hCTDJ0ZUdyNnRZRGRaelg3S1JLSS8weXVU?=
 =?utf-8?Q?as31pv?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 11:43:25.6206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c176c6b-fac5-4b2f-0f62-08de01a8e5f4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10780
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 702528000F
X-Stat-Signature: pi8rt1bg7ddqikb65kfdqqyqnc7di8ya
X-Rspam-User: 
X-HE-Tag: 1759405417-363618
X-HE-Meta: U2FsdGVkX1+m9jJ4GgjWJfw/x3767c5Jhnn566wqCMa9e6hxP+3GrpQ01R+xyB1PSGnP/ysQ7TbF1xXLC4dIeQXiSs7X5xfplbKckFJwh9k5QIsjC7j+dGYWg+QaJfXmxXa/etBZc+wqnLHE4OyvOkadV7g+iQ8LwjbdKJl+9jWvAmp6HKlZ1IJfcCiWMCd2esn6JJWvGPVmnd/Gj0yn+pU6WyFccRWY0VvZQh2Fh64rOY7A/SfLWxejW/2Poxq1xQaeZhC8i65LypwxwKqAi4622zghG+9QO2QcRGUcEz62Tvclj70dcM+lvLNhnhcsm86JbICdZKetENSIiEU18bElJ4eGdLxh87Oi18hPfkolzC1+ZydR5ilb9FH1pmbLYCxyGIHkvTRSFO2S3zvQsQY/Ddxl+1e9yb8bqQ0JZF/GHhoKErjyHG5KH2hUtn4jkA1Lyheui1VmGo/kWROJZKn4fg/eMWtMesstWGoIXI/a7GbcKSml9mLkCADedsCQ9QeO72HNooeD/xFv/UIw/lW2X8Ng05VxEXJROxJTOs/nHZVbgHIM0Bs7TGMY8hEe3TYb3D7cbQPtMyTnKX0wg9a0HEUxWx+U08QoPaCGY5tlwbiMVlNJSo98h2NjUiydFuqzeji7OBi4qXeQBhCaCVMfLJXVGgHSeWob+iB79T40oS5GsENeqA9Rxm7jSODzMZTvhWD6/OQDYhSHkwPCmHg/WEZS75ZEOnRu5MwYLZXpoAm5mJr7lhPcjEZKtcO7vCXJvOinG3RJmgbBmG5S4oqOwjLfxzfadm11uPOcQ9Ht9I/aPx+YiUN7x67x0FmoNvl6tr1XQCQxzrJ2efN/NKoCsgEoZTffiCVEUzrBgrOExdBvrJ6s8GxHhP4I/4ERfTEQBNth6CZRQVFYPFS/8pmSVeIxQDAa6+EvxxKKI7HtFTKlCHoQlcSklL3VGjzOOAmM6PFknGZH3h+pssf
 uYjlp+pY
 MwJnYTShQUIx22Wz0ck6VU3zukQp5gXFrFj2GYFkrOXEErapHiJQOzY5pAOFPaSrPWdnDeDWKdAOU9I3SyizlpovbWorq3mrDmVPZrEtPW5yXgvolBjhwNdo48BidT0a8w0vQOFFJ+9iFJWB9DeNpIKNp5WwlDjZ77BRES1sAva9LVj2EMk48LgCze29kd+qU949HIDJxjCCodiXn+k0F6f3uKLjXwhhygQd7KQYu5v/ED9aG5aXSK9sYND0ZkUhE4uL+7OPp/tYJo5krYHT2PX63tLMqIuLz4HoBabpxXhWeLulstxYQK4qktMoChu8PfEJZd9wcNvEwPOfXPqMgJy8n9dE+eFkp62RkwJ5W3iXTFulNpq8AvfgwRJi3crvDJEDlvIB6ea5GuTet1VZWwOQtoH9y8b+k/Swgby/BNn9hYVyY/1H5tIFYKvYMMUjD0GIxVlkAYqV2szSC1DnQj3sMAV9NZZiE/AvvIsDZBHeHU9Axh9X2JhbNVrrdtjEmNOEbaRHx8tbi4/2zNKeJJgHOc2ThhHQmnsnv/GBpDbw+73rmUGWPBh/C25BzJfAPY20JVNUWRWzYgS0Mi/NkvhFl8umW58PslEmS9uEyomf26ZDO0qELD/QPhPwqJgqKWBdvFX/vkS8hhYrxKnuVyU1ccfvEbKCuFw6l8hfPlAtvYn6YyYCgLLTNXT/OdprPc8VnelkdsqZ9k2EEA1h2mZo1c4KForpp8aiMXcVYAWMXD9dHIZdWztOL3gDetwGQsdQn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Byoungchul,

> DEPT(Dependency Tracker) reported a deadlock:
>
>    ===================================================
>    DEPT: Circular dependency has been detected.
>    6.15.11-00046-g2c223fa7bd9a-dirty #13 Not tainted
>    ---------------------------------------------------
>    summary
>    ---------------------------------------------------
>    *** DEADLOCK ***
>
>    context A
>       [S] (unknown)(pg_locked_map:0)
>       [W] dept_page_wait_on_bit(pg_writeback_map:0)
>       [E] dept_page_clear_bit(pg_locked_map:0)
>
>    context B
>       [S] (unknown)(pg_writeback_map:0)
>       [W] dept_page_wait_on_bit(pg_locked_map:0)
>       [E] dept_page_clear_bit(pg_writeback_map:0)
>
>    [S]: start of the event context
>    [W]: the wait blocked
>    [E]: the event not reachable
>    ---------------------------------------------------
>    context A's detail
>    ---------------------------------------------------
>    context A
>       [S] (unknown)(pg_locked_map:0)
>       [W] dept_page_wait_on_bit(pg_writeback_map:0)
>       [E] dept_page_clear_bit(pg_locked_map:0)
>
>    [S] (unknown)(pg_locked_map:0):
>    (N/A)
>
>    [W] dept_page_wait_on_bit(pg_writeback_map:0):
>    [<ffff800080589c94>] folio_wait_bit+0x2c/0x38
>    stacktrace:
>          folio_wait_bit_common+0x824/0x8b8
>          folio_wait_bit+0x2c/0x38
>          folio_wait_writeback+0x5c/0xa4
>          migrate_pages_batch+0x5e4/0x1788
>          migrate_pages+0x15c4/0x1840
>          compact_zone+0x9c8/0x1d20
>          compact_node+0xd4/0x27c
>          sysctl_compaction_handler+0x104/0x194
>          proc_sys_call_handler+0x25c/0x3f8
>          proc_sys_write+0x20/0x2c
>          do_iter_readv_writev+0x350/0x448
>          vfs_writev+0x1ac/0x44c
>          do_pwritev+0x100/0x15c
>          __arm64_sys_pwritev2+0x6c/0xcc
>          invoke_syscall.constprop.0+0x64/0x18c
>          el0_svc_common.constprop.0+0x80/0x198
>
>    [E] dept_page_clear_bit(pg_locked_map:0):
>    [<ffff800080700914>] migrate_folio_undo_src+0x1b4/0x200
>    stacktrace:
>          migrate_folio_undo_src+0x1b4/0x200
>          migrate_pages_batch+0x1578/0x1788
>          migrate_pages+0x15c4/0x1840
>          compact_zone+0x9c8/0x1d20
>          compact_node+0xd4/0x27c
>          sysctl_compaction_handler+0x104/0x194
>          proc_sys_call_handler+0x25c/0x3f8
>          proc_sys_write+0x20/0x2c
>          do_iter_readv_writev+0x350/0x448
>          vfs_writev+0x1ac/0x44c
>          do_pwritev+0x100/0x15c
>          __arm64_sys_pwritev2+0x6c/0xcc
>          invoke_syscall.constprop.0+0x64/0x18c
>          el0_svc_common.constprop.0+0x80/0x198
>          do_el0_svc+0x28/0x3c
>          el0_svc+0x50/0x220
>    ---------------------------------------------------
>    context B's detail
>    ---------------------------------------------------
>    context B
>       [S] (unknown)(pg_writeback_map:0)
>       [W] dept_page_wait_on_bit(pg_locked_map:0)
>       [E] dept_page_clear_bit(pg_writeback_map:0)
>
>    [S] (unknown)(pg_writeback_map:0):
>    (N/A)
>
>    [W] dept_page_wait_on_bit(pg_locked_map:0):
>    [<ffff80008081e478>] bdev_getblk+0x58/0x120
>    stacktrace:
>          find_get_block_common+0x224/0xbc4
>          bdev_getblk+0x58/0x120
>          __ext4_get_inode_loc+0x194/0x98c
>          ext4_get_inode_loc+0x4c/0xcc
>          ext4_reserve_inode_write+0x74/0x158
>          __ext4_mark_inode_dirty+0xd4/0x4e0
>          __ext4_ext_dirty+0x118/0x164
>          ext4_ext_map_blocks+0x1578/0x2ca8
>          ext4_map_blocks+0x2a4/0xa60
>          ext4_convert_unwritten_extents+0x1b0/0x3c0
>          ext4_convert_unwritten_io_end_vec+0x90/0x1a0
>          ext4_end_io_end+0x58/0x194
>          ext4_end_io_rsv_work+0xc4/0x150
>          process_one_work+0x3b4/0xac0
>          worker_thread+0x2b0/0x53c
>          kthread+0x1a0/0x33c
>
>    [E] dept_page_clear_bit(pg_writeback_map:0):
>    [<ffff8000809dfc5c>] ext4_finish_bio+0x638/0x820
>    stacktrace:
>          folio_end_writeback+0x140/0x488
>          ext4_finish_bio+0x638/0x820
>          ext4_release_io_end+0x74/0x188
>          ext4_end_io_end+0xa0/0x194
>          ext4_end_io_rsv_work+0xc4/0x150
>          process_one_work+0x3b4/0xac0
>          worker_thread+0x2b0/0x53c
>          kthread+0x1a0/0x33c
>          ret_from_fork+0x10/0x20
>
> To simplify the scenario:
>
>    context X (wq worker)	context Y (process context)
>
> 				migrate_pages_batch()
>    ext4_end_io_end()		  ...
>      ...			  migrate_folio_unmap()
>      ext4_get_inode_loc()	    ...
>        ...			    folio_lock() // hold the folio lock
>        bdev_getblk()		    ...
>          ...			    folio_wait_writeback() // wait forever
>          __find_get_block_slow()
>            ...			    ...
>            folio_lock() // wait forever
>            folio_unlock()	  migrate_folio_undo_src()
> 				    ...
>      ...			    folio_unlock() // never reachable
>      ext4_finish_bio()
> 	...
> 	folio_end_writeback() // never reachable
>
> context X is waiting for the folio lock to be released by context Y,
> while context Y is waiting for the writeback to end in context X.
> Ultimately, two contexts are waiting for the event that will never
> happen, say, deadlock.
>
> *Only one* of the following two conditions should be allowed, or we
> cannot avoid this kind of deadlock:
>
>    1. while holding a folio lock (and heading for folio_unlock()),
>       waiting for a writeback to end,
>    2. while heading for the writeback end, waiting for the folio lock to
>       be released,
>
> Since allowing 2 and avoiding 1 sound more sensible than the other,
> remove the first condition by making sure folio_unlock() before
> folio_wait_writeback() in migrate_folio_unmap().
>
> Fixes: 49d2e9cc45443 ("[PATCH] Swap Migration V5: migrate_pages() function")
> Reported-by: Yunseong Kim <ysk@kzalloc.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Tested-by: Yunseong Kim <ysk@kzalloc.com>
> ---
>
> Hi,
>
> Thanks to Yunseong for reporting the issue, testing, and confirming if
> this patch can resolve the issue.  We used the latest version of DEPT
> to detect the issue:
>
>    https://lore.kernel.org/all/20251002081247.51255-1-byungchul@sk.com/
>
> I mentioned in the commit message above like:
>
>    *Only one* of the following two conditions should be allowed, or we
>    cannot avoid this kind of deadlock:
>
>       1. while holding a folio lock (and heading for folio_unlock()),
>          waiting for a writeback to end,
>       2. while heading for the writeback end, waiting for the folio lock
>          to be released,
>
> Honestly, I'm not convinced which one we should choose between two, I
> chose 'allowing 2 and avoiding 1' to resolve this issue though.
>
> However, please let me know if I was wrong and we should go for
> 'allowing 1 and avoiding 2'.  If so, I should try a different approach,
> for example, to fix by preventing folio_lock() or using folio_try_lock()
> while heading for writeback end in ext4_end_io_end() or something.
>
> To Yunseong,
>
> The link you shared for a system hang is:
>
>    https://gist.github.com/kzall0c/a6091bb2fd536865ca9aabfd017a1fc5
>
> I think an important stacktrace for this issue, this is, waiting for
> PG_writeback, was missed in the log.
>
> 	Byungchul
>
> ---
>  mm/migrate.c | 57 +++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 16 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 9e5ef39ce73a..60b0b054f27a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1215,6 +1215,17 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>
>  	dst->private = NULL;
>
> +retry_wait_writeback:
> +	/*
> +	 * Only in the case of a full synchronous migration is it
> +	 * necessary to wait for PageWriteback.  In the async case, the
> +	 * retry loop is too short and in the sync-light case, the
> +	 * overhead of stalling is too much.  Plus, do not write-back if
> +	 * it's in the middle of direct compaction
> +	 */
> +	if (folio_test_writeback(src) && mode == MIGRATE_SYNC)
> +		folio_wait_writeback(src);
> +
>  	if (!folio_trylock(src)) {
>  		if (mode == MIGRATE_ASYNC)
>  			goto out;
> @@ -1245,27 +1256,41 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>
>  		folio_lock(src);
>  	}
> -	locked = true;
> -	if (folio_test_mlocked(src))
> -		old_page_state |= PAGE_WAS_MLOCKED;
>
>  	if (folio_test_writeback(src)) {
> -		/*
> -		 * Only in the case of a full synchronous migration is it
> -		 * necessary to wait for PageWriteback. In the async case,
> -		 * the retry loop is too short and in the sync-light case,
> -		 * the overhead of stalling is too much
> -		 */
> -		switch (mode) {
> -		case MIGRATE_SYNC:
> -			break;
> -		default:
> -			rc = -EBUSY;
> -			goto out;
> +		if (mode == MIGRATE_SYNC) {
> +			/*
> +			 * folio_unlock() is required before trying
> +			 * folio_wait_writeback().  Or it leads a
> +			 * deadlock like:
> +			 *
> +			 *   context x		context y
> +			 *   in XXX_io_end()	in migrate_folio_unmap()
> +			 *
> +			 *   ...		...
> +			 *   bdev_getblk();	folio_lock();
> +			 *
> +			 *     // wait forever	// wait forever
> +			 *     folio_lock();	folio_wait_writeback();
> +			 *
> +			 *     ...		...
> +			 *     folio_unlock();
> +			 *   ...		// never reachable
> +			 *			folio_unlock();
> +			 *   // never reachable
> +			 *   folio_end_writeback();
> +			 */
> +			folio_unlock(src);
> +			goto retry_wait_writeback;
>  		}
> -		folio_wait_writeback(src);
> +		rc = -EBUSY;
> +		goto out;
>  	}
>
> +	locked = true;
> +	if (folio_test_mlocked(src))
> +		old_page_state |= PAGE_WAS_MLOCKED;
> +
>  	/*
>  	 * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
>  	 * we cannot notice that anon_vma is freed while we migrate a page.

Hmm, I still have concerns about this change.
(1) seems to imply that the use of WB_SYNC_ALL by
mpage_writebacks() is also incorrect. In addition,
this change could introduce another theoretical livelock
when the folio enters writeback frequently.

AFAIK, while a folio is under writeback,
its related buffers won’t be freed by migration, and
since try_free_buffer() checks the writeback state first,
taking folio_lock() shouldn’t be necessary while bdev_getblk().

Therefore, it seems sufficient to check whether
the folio is under writeback in __find_get_block_slow(), e.g.:

diff --git a/fs/buffer.c b/fs/buffer.c
index 6a8752f7bbed..804d33df6b0f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -194,6 +194,9 @@ __find_get_block_slow(struct block_device *bdev, sector_t block, bool atomic)
        if (IS_ERR(folio))
                goto out;

+       if (folio_test_writeback(folio))
+               return true;
+
        /*
         * Folio lock protects the buffers. Callers that cannot block
         * will fallback to serializing vs try_to_free_buffers() via

Am I missing something?

--
Sincerely,
Yeoreum Yun


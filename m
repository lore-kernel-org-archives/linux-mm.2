Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B0EC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 06:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76A06B00D5; Thu, 23 Jul 2026 02:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00CC6B00D6; Thu, 23 Jul 2026 02:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D316B00D7; Thu, 23 Jul 2026 02:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE8C6B00D5
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:54:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F02D41C0888
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:54:09 +0000 (UTC)
X-FDA: 85019127018.22.3B61788
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011004.outbound.protection.outlook.com [52.101.70.4])
	by imf11.hostedemail.com (Postfix) with ESMTP id 141204000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:54:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=SuPKCqHO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=SuPKCqHO;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf11.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.4 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784789646;
	b=o915Xz8if6DDOqOrQarqt7UX1M1Js8rAwNWToN/2xQ0EDBVQvFZOicTkddAn3bnSG88J3+
	in7O8ofuhRQcABX/O83Fcmth2Sbc4x5vqG6DDBggVC9nSQaChbQd5aDgy7RTC8abISCIFt
	zFJgyW8itjvixWUrWHh5t/uTiuZxTS8=
ARC-Authentication-Results: i=3;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=SuPKCqHO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=SuPKCqHO;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf11.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.4 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784789646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSMrnEqpmD/FIKrjL5Z2NASYXy31gHEngbBuuYZoY8k=;
	b=vsHltYBKJLqHE98py2J4avmJGRGg6U3y85Eb6NtPWeE5Gee2EYdP+/UoMlSTV02gz8K/sp
	Ux2/hZ/zq6DHDMI98CCNqiD3NPzCwXhvXeuWE8+oAKvACd7ZGY6FPIdfVzSiJi3SfBZt0X
	3Qazku+ZcFxm520NSEl8q0c3OwFYFqo=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OKiQ7tklGWIW5EU+5yFv6I1SIAcqX+mkx8ZK9v0EQRFk9kUHocCvU2w8xif6rCuCdLR30TfTJyX+6IJ+fGTDyStEH0uzPohzQh056LRsHZQ3IOy8D6ywBqf0OKTfuJjesVZb4/83QcSiHs3nrhz+ZTYzaaq8sT/YnyaEmDuPB6I+cAVJUfY4UdNDz9YkllVtFDtwiW/+zKXbk6xVAeAuBNgI2vKjJ0dokKMUKFYDAxloyYBooScG52Dhm5pY0DfEE7RTDW+HK+f4UVuB0T3nrjhCqvsxh+wyOIDXkTUoLYqehKcB7ZDWnxuk2x8REHHMvswcAXjEY5bGUtC5UFxwQg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSMrnEqpmD/FIKrjL5Z2NASYXy31gHEngbBuuYZoY8k=;
 b=jXV/E863OGe4QLc9egGtjryqGROCJTMmeJ4kAcNA3vg/emQTq4lkeAO5OP8scp873FyaWkc3hgR9HapkU2SX+HoaWPN84y/ul7yLRd4tSCGb2B7YlFZUCPHvXQycFnGBzsPRtYZAIAftJ3+/Ggigtr5LHuqzEXY8rL2ZMr5uJAb7EIHxjpd0/XqEI4XF7SqUF18yN1dhwzGcBfwotxvTlezPcPaBUdMz2fKiVGpPM3SLn5LFiI5LNbJ4eaK89AcHtnXJks3OYRwPARb/D8ShLJHNaGtIHWToyIBf48CZl432VVQwSXKET63byd4xmx0SJFdN0sgLs1SEXGhOVPEO7A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSMrnEqpmD/FIKrjL5Z2NASYXy31gHEngbBuuYZoY8k=;
 b=SuPKCqHO8+nVHZyCYWcrnd+sLB/XoxAZgqBF87LOPSeNwz2wJIV4TpZqKT6Zq3KOcir1XON3UCoYyc+Eq9ZXQoP5bmE6QRCB3akZYrdgszQYoYs8gwabRt3F5f0y3MSYhPl2ggWsGMv/Xf2xWhvXoVjLpdqGjw09AtVPv/IsM1Q=
Received: from AS4P189CA0046.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::11)
 by AS8PR08MB7942.eurprd08.prod.outlook.com (2603:10a6:20b:53a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 06:53:59 +0000
Received: from AM3PEPF0000A798.eurprd04.prod.outlook.com
 (2603:10a6:20b:659:cafe::72) by AS4P189CA0046.outlook.office365.com
 (2603:10a6:20b:659::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 06:53:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A798.mail.protection.outlook.com (10.167.16.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Thu, 23 Jul 2026 06:53:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZOZ38k+PHW+G/oEiqaCtCgAvNQxKOiFQq3Mx5jWQNHSZlicMM4TGMpuXXdEbNMmBBT8T3pjgrPJwuszYA51o+im7Q/q+H0fj9rxJj8zvJumTGoTbX8fB2w9jJur/1G/GnE5NAk8+LDEOtOBy5izU9IepnKZ/Oz2rTck0kBE+cwW2RKlTyrqXwuzw5dcqpIqxAEjb+unzOjLpK7TD0IxeKEgVzq1bMd5FecY5dRF1RXDQW2OBNCXYs/WVrTREyausVaVwnT4Mrp4W+qs8h4iGAmlUnrY5cGNaFmCUHyCAazMDKifqo6Q+Y3QNIcKTNdjXOP9hi3yugFDHb33uR7P5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSMrnEqpmD/FIKrjL5Z2NASYXy31gHEngbBuuYZoY8k=;
 b=fsVmm39LI0EpEpNoSkavj914WdBWWz+LkTnnDiTKiiPyi5DJADk634suDcLOF0h8Qxj6pa9o31Y9L/0fzBJ8Q9im9Yy+uhf8TjAnk5JQpeBp9C1gEdu5zcEqZVGpX0+nRKcov6XjFqw/JMfqnTwS/Z+7EQd8LN4mOgqkLoJy39ULhiDMSoE1ek3FCphWFzNyQmBVDwruS660SSnaCoXHkeAPySbSmUgTwDgaspymK0398LWkC42nDneMxMcIeFk60O+aLuuGias7xrFvS0Zs+almrwKm1wxc03oallj2YUY+QRfpN/s99SGabHpsTzsVjb9mCfPz8qARcYKVPwMN0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSMrnEqpmD/FIKrjL5Z2NASYXy31gHEngbBuuYZoY8k=;
 b=SuPKCqHO8+nVHZyCYWcrnd+sLB/XoxAZgqBF87LOPSeNwz2wJIV4TpZqKT6Zq3KOcir1XON3UCoYyc+Eq9ZXQoP5bmE6QRCB3akZYrdgszQYoYs8gwabRt3F5f0y3MSYhPl2ggWsGMv/Xf2xWhvXoVjLpdqGjw09AtVPv/IsM1Q=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS8PR08MB8300.eurprd08.prod.outlook.com (2603:10a6:20b:56e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 06:52:53 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 06:52:53 +0000
Message-ID: <bb1c7fc1-a1a2-4a17-846e-bdaef12ff7c1@arm.com>
Date: Thu, 23 Jul 2026 12:22:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v1 2/5] selftests/mm: skip guard hole-punch test if
 MADV_REMOVE is unsupported
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260722091219.61504-1-usama.anjum@arm.com>
 <20260722091219.61504-3-usama.anjum@arm.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260722091219.61504-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0153.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1ac::14) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS8PR08MB8300:EE_|AM3PEPF0000A798:EE_|AS8PR08MB7942:EE_
X-MS-Office365-Filtering-Correlation-Id: bb568b14-fd33-4681-8380-08dee8872c02
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|921020|6133799003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 KOB/E5RAbKJ+9w+EOnPUE5wgSTz1VIbwfd5Vm8InXb/FNJje/l76b++XvdeU1PNm6KVGcXMf3mzM/Syyd4KK1gRYoabA12bHn4aqKtZyBc03SrcBxanpOsq6JybTyBTQ90bqsvbDV0I2utokh52Sqr2wQYjW4arV5jdmUlPzXkAuGVH50PWWtHmpKgEldBxVl7qdlfhNET2ZIdstQGiqKSfZjZVZ/uCiln7eK7UMLfnfqSOp9Q/OeN4oP+PzPtCWZcyBwBS6tiJ1tpz5WK4N/JbQbVQKUXGMhwkBQOlP+IiU5FFQQwB6p7NXhVsek9chRTRuaRR7gGPyG9KmxrmVuItUidtSMgHsVKmI4M9szaXRxxEuNOKjUFV9Z+OiM3Y4w2GwqJamD7HAL/j1B83kJ748bvFvHbjfh9RJfpaTkXOYZ+9BQVKkZkcCGzh0blolIsV5dxp6v+5/vqVf7Z0dcCeszki8YEgeIyFdkX9pNoSVtyzs1oEbojG7SmyrcLNmKcPcxX2wIkPPKC3m3i92pxoQ9C+20JTTVQ0zo+23HCFfRSqu1YyboKTgmprZ/uHc+rBp/LA/wxuo6hpaSfDZ9NYeoXcNu3CpmH8B0DZz4c/DFPh6XB0sOp7+sHRRzuQC8gO9KrmL7icdjfl4BLlVADya2U7C4Tnu8Xi6hzgB17BMgl9sXRLLExwhH5NKREygEyi0WYT0pa9L2LV5ux/TQA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(921020)(6133799003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 eP+F3UFy5XPUvDcQpHYtywsMTYZfpWBmMCiEjiCkzLX/npdRz0GG33i3fUcKKYPpgtqhkcOblhufQemImIJkAoDnfA4eAD81INQLK/0pCT3ia/z7/tgYnEdYIFy7wobDIlQeoYu0+8fKBWX9FOtz+BMeWNx23NKYpv2n7tJlMCKQmDyqXfFJjk/+i6p3M0aiP7O26Ng8FFXM5uyN2if1JlmVtKF+nhQpUdNL3ZaqDOyQnWXXu2+g0jYe5JBaJzVQ7sPnfJShfVtXwDvO7TmtSKnPrZ4iR4dXkBHbKKaR8Rp8LNCFAd7qE/sYzLI1FAeht7TV8oCCnIcZWRMkKp68mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8300
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A798.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c80bf318-9ad2-4833-eb3b-08dee8870483
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|35042699022|7416014|23010399003|376014|14060799003|18002099003|4143699003|11063799006|22082099003|10067099003|921020|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	ysqFiD9Fyv53AWM907CktyxEB2JSng704JS/9NGcmOSFHKhEoDtzIfqALXK8fyl5Oc6vXfj1pzt6WCAFvxVBjZ+pLIBEB+ml3os2DjpRGJqjghZ99f5xO5bj+z6MeueY2dnlrqdhR8RSsLCX4NdAqeON69WINpilmRvvaiI5UHIgbH2HJ7KOWry8aeXm1N/aRSHlsyZdLqeOeAezW6sD7WFtI+jssuc/5RR/dNPjwxpHRgZaPogxB2Kw54i9nIeSyM24kUFyCY5veQ7nVQpIP77AI4vHDkzvfJ8h3EjTCtANiqeCBhhG90JANq4yt/d3HjVeIX9MLCKuVPgMwHiTJUIMMjEGkR8UdBcpmPrjvFWUxfKGdXbsWSq/RmtpyERCOpQVPe3qF9sWV16AQxjh8jPiYfILH5WQ2ata5N5yayG45q84xhs21pSSmbzXLvZY0QZ+goKvZUN8huqHQgrhvJTt2KxjMDfNRrj9795v+iZHt6FrOqssmYq6gu+5bFUmcYzUGuYDh9WILg1PPhnh/ShiJdf2bHOU1cFrKxIp0IdJkIjMpZPUpEBa03aIK8k+4XpncutRzAGQziLhwsFxqrmRxH1NZNSOsoZzFUp+YlKtGfosYUU8DcimEBcCcdyTWsiVdvx/d/BaNrk9sNQDD4n8oZiao/7Vv4dj+uavrbfwSLCTwLBwnDmOERmd7RGWrzUhkC6ErtOcF6M3fJPT4cZSW/RfgEoupMAzNQmOKlSRQ/BEN3U/3NPYF0zyOgUR
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(35042699022)(7416014)(23010399003)(376014)(14060799003)(18002099003)(4143699003)(11063799006)(22082099003)(10067099003)(921020)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M0c/jM5fXBoZJg4pW2IhWvsJQJ2kCtX/iEFOkd1IsQZP8Whxkg68SsjyOKY9AomeadH/NBin7No03+gDjUkDchtQEPEuPp2FQ5+LJ+PbM9yz2ecHGFEo826+p+TPJgIZD8FMnW9NjB3Zc1XxCO3ADjEuzL5oGDrufkTWJiFv9o3Tf/s2bf4ntAjiZuHXCKvhdtz72VDvk4WMzw7FGgxA9hdIxfWwU9pnKIBsTHcuslo2PVq8OevDRsjFOPcm1/UpUdi7SH5mzqz/z65/UKF5lDHDdyz4LgmPDb/hmDpqXl0OMT4qPKRhTZmj9Fp3Jm+z/Gm2blIZSOZo4J13QgacHTyo9LtOED3OziTH34ZV6s006ZI9V8nI/jVGWm9WityJYTrsQdtbe5PldWRmpAdgMCft3th/n/u7z3rmeOw1MkL9qATCVlJVpYX7xAXfK15P
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 06:53:58.8899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb568b14-fd33-4681-8380-08dee8872c02
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A798.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7942
X-Stat-Signature: j1gy4hn3dtojddop7zwttj8b7anu179e
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 141204000D
X-Rspam-User: 
X-HE-Tag: 1784789645-131465
X-HE-Meta: U2FsdGVkX1/CIwODa7JJan+vQoBBCzz71amWW2QTnnn7ZVQJbkOHgLXn4x4/TjiV3CwUrCyy39VOyVhf7PwdB8K7s8JS65iX8aP1MD6j6k0HOPAyysbtv09s3Ls6zWiUGigN8g1u3P5X+P+G5puY3xYfTZf/RrV3GCW3aJ4eSRlxF4kYzcTKuuvw2LcN/n5DSEBWffSWC3YA0ElwRLAX5ZXoYtwBFbeNU8+21WN6YrfGkjtM3rbBK/MWna9waRYzuADEL0cbiY4iwv6NhrCeh9MkSj7TIDvD6zCqMfaF2eKlQelvpAHRrfjRvRqwHPidL+WYS0leELU0QY2K4zneKpd8iQS1O478nSBJXITKYnITPiocb1EaS2PV+x+khohNEvJ0DPmWmdolLIoo3CtfabYQMbTTbi34eySSs9eEyz7Nrc+fVzvRvzozEsX1L2EDVmqu9gyKoZCJDtLrWXisVBOn6TrhTzhW+/3prnSJ1eRr7odcdSOsUq9Ybqmfn6koXX+dZlNKtOsYRunhtlnjeH6YL9BD5ovKKJvoBJAq7WSuCqJ7xuhExv+TWxi8BDIo+t07InwA5Et8hr0Oibzhz6T4Zp9AN9kxZ/633ueIP+Ta0sVsDFdq/m0u9/oewCQ9VaQYSk4GHjcT0xSmkVyz00vJAcke/7tlfWnpKlpXuaKBy8B+f5N50YsJBISAGcglJc9BI8KBzktfpKPNTGD2GTSBOJGa9WKc0GWAjzjC+3ZOLvoQ9HiK70jMpJ3DAqD2QDvcY5qyKwQwFyqWPIGFR1/MqsxYXOFSe35u6MjFmcBX1T+3vTUzjF8muYgANIRF6s4eUWhtQMXHWasxyMtBluPipVQPC6Xcp23S5FUEhZiw9hB+BDvVIeieJxU4MCfjnW0JVeI5GxNbSQHvNZbfAt7t7LUxjhsuzPpFFtz2XIUEMciBQ4iP0ochnPIdkpQ4Su+dcviRDjw5mTtxcLz
 CBeeGgeT
 gBVpZuH8KMrcpHNFiyWS9LK7pBMA3nguNgoN+eENKGMY/jvYR9H1y7ppfJ7UbCK3XPF9tsnkG7s89iqPNltcRr62k+r/27T/vxA91n1/isr1MxX94EuW6FRT+cM2u9+3rRoU63gbc3tzgwU05oPixV72p+xmSltcluzu+P0ngUaMAbjdE520BBwwCVISjgTCnztMDWFYKOvtJrrZAjC7KMnMqBvmpSRMpkSYeK5awKMxkMgNc0hAqrYyseM3RGmh7RAVmMDxUlIoFabR6wSgyiUi5/hNCHfKbNS3oWfUFqweKtBohE2IOAAPmw8oLPWaQEf/Y6NvSAdIzngwVgclfx2vDWJdg2pXeogweB/B0zjfvwCg412hX9yMt0XaRtMRSthSKGy5E94Hu8md1buRTwFuZBJxdCfka/TLmcG9+MWDo/CUWDEX39BR3ASO9j4MXmMEFFD1rGhBoenJBwgyYU30Hov6PMGeWPQZi2FKHCiQGfcvzCQ9HwCb5NP8usKVtpl0+Aqv9ccxWcwgwZpk0Up83Rck2QLprKGvTzJQUsuqx3RlArO3BFXJccwgJXxfX4slvjlm9xwJgNmXAzDChZr654re81iDLHaDeLaHCwGaKLG+R6mkz215NeVLn18RNBKnbMdNWtikufOtk7jKM7SIlhnSaGwe9Moo6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/22/26 2:41 PM, Muhammad Usama Anjum wrote:
> The hole_punch case verifies that guard regions survive MADV_REMOVE and
> that the backing range is punched out.  MADV_REMOVE delegates the hole
> punch to the backing filesystem, which may reject the operation with
> EOPNOTSUPP.
> 
> That result means the test cannot establish the state whose guard
> semantics it intends to validate.  Treating the missing filesystem
> capability as a guard-region failure creates a false regression.
> 
> Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP.
> Preserve the assertion for all other errors so failures on supported
> configurations remain visible.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

I tested this patch on a QEMU by mounting ramfs over /tmp and then
running guard-regions from /tmp.

Before the patch:

#  RUN           guard_regions.file.hole_punch ...
# guard-regions.c:1947:hole_punch:Expected madvise(&ptr[3 * page_size],
4 * page_size, MADV_REMOVE) (-1) == 0 (0)
# hole_punch: Test terminated by assertion
#          FAIL  guard_regions.file.hole_punch
not ok 84 guard_regions.file.hole_punch

After the patch:

#  RUN           guard_regions.file.hole_punch ...
#      SKIP      MADV_REMOVE not supported by filesystem
#            OK  guard_regions.file.hole_punch
ok 84 guard_regions.file.hole_punch # SKIP MADV_REMOVE not supported by
filesystem

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/guard-regions.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index b21df3040b1c7..5c8ec3ca75d7d 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -1912,7 +1912,7 @@ TEST_F(guard_regions, hole_punch)
>  {
>  	const unsigned long page_size = self->page_size;
>  	char *ptr;
> -	int i;
> +	int i, ret;
>  
>  	if (variant->backing == ANON_BACKED)
>  		SKIP(return, "Truncation test specific to file-backed");
> @@ -1944,8 +1944,12 @@ TEST_F(guard_regions, hole_punch)
>  	}
>  
>  	/* Now hole punch the guarded region. */
> -	ASSERT_EQ(madvise(&ptr[3 * page_size], 4 * page_size,
> -			  MADV_REMOVE), 0);
> +	ret = madvise(&ptr[3 * page_size], 4 * page_size, MADV_REMOVE);
> +	if (ret == -1 && errno == EOPNOTSUPP) {
> +		ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
> +		SKIP(return, "MADV_REMOVE not supported by filesystem");
> +	}
> +	ASSERT_EQ(ret, 0);
>  
>  	/* Ensure guard regions remain. */
>  	for (i = 0; i < 10; i++) {



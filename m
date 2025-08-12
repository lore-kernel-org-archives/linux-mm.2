Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9735FCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9E2900003; Tue, 12 Aug 2025 12:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1398E0168; Tue, 12 Aug 2025 12:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07262900003; Tue, 12 Aug 2025 12:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E57EF8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:57:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D91AB0099
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:57:30 +0000 (UTC)
X-FDA: 83768711460.03.2D66D84
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010064.outbound.protection.outlook.com [52.101.69.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id 63416C000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:57:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bo59sG2Y;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bo59sG2Y;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf10.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.64 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755017847; a=rsa-sha256;
	cv=pass;
	b=iW8+LyWaYAlmhSB7t7RtcuBMCxxbhOPGGT/9fTN/PNVuoFA0LByqXB8r9KmcHcd7dQ4UqR
	mluYVoC71Alz1371LpPewwOHUs7OyIrdMT2YZ0iYJ7bOri6nQWACIsUvsBAV81l9rPfI/H
	4UVSPbcaqfrqhWtWeZezeKsnyywWwOI=
ARC-Authentication-Results: i=3;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bo59sG2Y;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bo59sG2Y;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf10.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.64 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755017847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TM44Cf3hg5taaGacOpIErY7NmByAGW0Uqap2daYIDvY=;
	b=1CBBNIHAgdaZCGnQ/t+1+5qCOkWPaab5dvb2vQYfFz103L0R6u8+35l3YYZIm2aUcywPR+
	AqyYWmaYpTo3z7ea0P0tkUA1Qc7mJX9TGUML+Og3eLA9o9e2I7pWt3ePXW/H61Ze1AW74d
	DFTA2MPnITGYojsQYwpPB8dq7W1YuYw=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Tv5ttJ+hCXhU6M+I4cleut5hdm2hDMmPW3qqNuLFP5S5XaoTP9zcziSI+hD75SturWQtt9v7SUMU4xc3qz6yYdF/q4TS8nELaYReHXMaItFr2rHdW3Eh5Z8s+gQS2KWzcXelz6W08YlBk4bEAx84cF0LBgK7686Y5rR0Q0hSYYbRHMw3/S1Att3zr64eGCj86MkHE24h1lUyXFtInZQxVrdqydS1syz7gdXXTD/+A4p2UEjgExN8XMHY2oYcKhqng2GshN8oXBdiF9GC7RAqTZERofqCwfJokQozBFxyUmbKUwUMYEFGr3j1lw3k6LJ8jvhO/xKRKMK+kcDUGsWJYg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TM44Cf3hg5taaGacOpIErY7NmByAGW0Uqap2daYIDvY=;
 b=MJA5WdB9negO5mgsKBwrjg8+zu237E+U7RRMB6PoUrKqbak2JiWrquYuKQYRgtJCPnRTnxhoP3nJUlMVGer+WkIqI7dt33QvlBjEYLkLV51TLgcTBcn4Sey/cEBIlIJbkANsp/NBiRpNICnfGg4mxqtpQ9h2xWFTfwVaxiagjSoIAf7RLIQ7CCZa5+LHrti76/ijguBAUdut7JukmLbJikA2Af+/wKkb65gyz0SGRGGx/RiWwZRkg22BTWBqnsb8/aVKIsG+UIYSp27AMo1+f7Y7SGycCHLzqXWnWVbs7bBeRrYKfxlOvMf2svK/GZhEM+EZxPBWkHDQJ9D1VNhjfg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM44Cf3hg5taaGacOpIErY7NmByAGW0Uqap2daYIDvY=;
 b=bo59sG2YG8O4uh+c1bsd0aBSPlNSgLKrQR4tCVSMwQxw4N9nTzZAaM5zjdbrnBsym17KWMuN+3QIAwsybSC3Nw0bCaKBnuDcZ9xSe30h8APP5hfI2r6uDAoxDrHDmPCQIhM93dVirzRSgjMi50lzOgpsFuFiUAmmeNvQgDqjmZg=
Received: from AS4P192CA0040.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::16)
 by AS8PR08MB9387.eurprd08.prod.outlook.com (2603:10a6:20b:5aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 16:57:18 +0000
Received: from AMS0EPF000001B6.eurprd05.prod.outlook.com
 (2603:10a6:20b:658:cafe::32) by AS4P192CA0040.outlook.office365.com
 (2603:10a6:20b:658::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.13 via Frontend Transport; Tue,
 12 Aug 2025 16:57:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B6.mail.protection.outlook.com (10.167.16.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.11
 via Frontend Transport; Tue, 12 Aug 2025 16:57:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nV3oTPtV+TdTjpHPCCiyRSLRPSr0dPRzGrGOd5aztz68XpBNB5WGAqb+xPl5Hq95mVPz6NYI6H0zOMJqk4d20Aly6SBe2cc5h0ZK2eBLuNDe/AVUe3sZrAmdxbbTACkECFyEz8SPusYj2fvOnFnEKTTObERX2VzHCsCC1yyQ2TgLp2AlUAxMwq1C0Jt4y2rpPpYsaqSr9oVzF7lLDnQjftjip+/m4qD7vdbzfP/ys6sdVVcsz748dGYWl9qKLC7u/F0C4uXeRHP0ww9WmrYpqLBRWcnO++aodACGC8Gjz6MquxklHN1DsFzrvGen4afpN0LN1+b1jGhd4CVPdjMZuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TM44Cf3hg5taaGacOpIErY7NmByAGW0Uqap2daYIDvY=;
 b=aToLQF7O4re5NtZYJIJ4u/admd0o7woPEJggBrQr45V+aG5xS08H8KCYm+TJwOSkqDEWxnYQp7BoxXfYbKF/LnxexhDVWVJxqNk2WhdP/y5iVAxU8X42Hy76GSF2I2ItAU74MpuPpMIKi4yfmjLkyw8CLdLWDvd5SfhUxnsSOkrUn6xgXAZLdV0tyef4xR9elQ+P9nQmCGf1GTSOci1Vj1C4dH5SKaLk0WoOJCRnefBRDLirZntQqt01NNkVSo/0BJYMA3UizlrhKY8BFvjMEC45xUZyTEL3E8yvLYTKeJ45SmoXT2ixCvPesmacQmhKbgw5mz9+2V4/clrRCTuBsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM44Cf3hg5taaGacOpIErY7NmByAGW0Uqap2daYIDvY=;
 b=bo59sG2YG8O4uh+c1bsd0aBSPlNSgLKrQR4tCVSMwQxw4N9nTzZAaM5zjdbrnBsym17KWMuN+3QIAwsybSC3Nw0bCaKBnuDcZ9xSe30h8APP5hfI2r6uDAoxDrHDmPCQIhM93dVirzRSgjMi50lzOgpsFuFiUAmmeNvQgDqjmZg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS1PR08MB7585.eurprd08.prod.outlook.com
 (2603:10a6:20b:471::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Tue, 12 Aug
 2025 16:56:43 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 16:56:42 +0000
Date: Tue, 12 Aug 2025 17:56:39 +0100
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
Subject: Re: [PATCH 2/2] kasan: apply store-only mode in kasan kunit testcases
Message-ID: <aJtyR3hCW5fG+niV@e129823.arm.com>
References: <20250811173626.1878783-1-yeoreum.yun@arm.com>
 <20250811173626.1878783-3-yeoreum.yun@arm.com>
 <CA+fCnZeSV4fDBQr-WPFA66OYxN8zOQ2g1RQMDW3Ok8FaE7=NXQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fCnZeSV4fDBQr-WPFA66OYxN8zOQ2g1RQMDW3Ok8FaE7=NXQ@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::17) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS1PR08MB7585:EE_|AMS0EPF000001B6:EE_|AS8PR08MB9387:EE_
X-MS-Office365-Filtering-Correlation-Id: 10efba60-7522-43a4-0b7a-08ddd9c14a81
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?veWiSnyrpHr8Y8kKNkOYrMA57HWrNzBN/GE9O1JHQWbfCX2xO3IEtYrpJOk3?=
 =?us-ascii?Q?Je3qWs8r1Wxu5gfQIRpMx399sLM4FMAjK2Zg1sKES+j51xEQW+ZcYXAnLs5+?=
 =?us-ascii?Q?vi8d58+h6X5B6Gw2Bq8GYYGNxKIwMfddCj870f8vA8F8dAimBbRBtf7qHn9u?=
 =?us-ascii?Q?yTh0MZ6xs6m/BFZV1881sdoylHSqIK9JqV8TKz0kWJTc+urycGVHpRcNTIew?=
 =?us-ascii?Q?d1doRUdyv5T8NF6WehELsbstxoHU7CQwk2rTalkbLG/d6j6g2sZeDZq1Utdp?=
 =?us-ascii?Q?JxWPiA4WjHG0akFrnCtnAZCK8pKASAhdM4xJ3e4fhujp8sKZlDQkdJIaoxmj?=
 =?us-ascii?Q?VrlFUHojVc1borLTs3uwCuvacTzgTlZrZznHbcJXAuXYVtUAzaPEJxBffhWZ?=
 =?us-ascii?Q?+FJc2cKRKmFtWt5WGm0WBQTsnn/aCmry3/JMCU65pKU/a8UbxX+AN8V5y3c/?=
 =?us-ascii?Q?7Xd6T2GicfLedALKvR+vuO58MVrI+AzyBefPDoV0V1V/lUAgbLR4Ku5fDX4Q?=
 =?us-ascii?Q?bhvBKCR4VGcf/4ncgf+NWynfG7FoDxKjXEasDgY7aDOqe+vD0oQxCIoi+WFA?=
 =?us-ascii?Q?0orZt0Gc9cWLVxj0MsoulMqdeotScIxrFUScTX7+uRR6dRWJJODJeE42dRfq?=
 =?us-ascii?Q?7CERIketFExzKkMj/F0HPVKCs7H0M38o41s4KW1FBVAu7FLNLyEhk7LHMcP7?=
 =?us-ascii?Q?e6zeYyZbJoVu+nNltIeIJqYcOiEEF4gG433p2wSpkp63QWr12FbVqsWNwreZ?=
 =?us-ascii?Q?w5MLDVoQpzOEsnkkNZRfIQXuIgw4pspDjvEWWtEIPCWZUfIAZe8l0Vvt0wAc?=
 =?us-ascii?Q?MZN1nsphI5/RfRO/YalalI7O13ik9OWiUwnhYpuT0fvZqSr8EnduyW+Lz8J1?=
 =?us-ascii?Q?wecasE4+yfrok8o55VqkG/kpFXrZTulREqblxYSdY6f0GhtxEM0uupJWk7HG?=
 =?us-ascii?Q?jwCPUKdk5kynZrKNvzv2pVTP6kvvF1fyCRhEo+omPw24IO8xNK3PDgNq268l?=
 =?us-ascii?Q?fJRNndWNfjSdm9dhe0CwfxbaViz74kgue+Pha36rH6U3uKBsFXlKWDfDd+Yr?=
 =?us-ascii?Q?iUqrJsy0sFuAwVE7I9issTWetGa7bf9LuQvb++eiAVkVIvY0fTyDWfja+GAO?=
 =?us-ascii?Q?32TL71WH0bgDCCx+SvnDecPEr87EStzNrpTPWIQwuKiXpkh926amn/lJ4ql7?=
 =?us-ascii?Q?VWtHxfy+KQeSvA27zxj13S/n8x0+ZqsFdTpotmFOaNY82zFU+oYBCviBQyAm?=
 =?us-ascii?Q?dt+w6+bF5VONjU8Qw99dGJC1c4KjXSHHqiqmxbNJ5tWprp6YOOo+YJc1MA6c?=
 =?us-ascii?Q?fgfviC0eI6XbsZTTZ6Honjm9VlEkNDutQIFrNv3byyi8DYWsgAxSnkup9wua?=
 =?us-ascii?Q?13qxyFh2U0zLHJOWkDaVVt3aY4aJAfaQ+JFMVQX8GHyffUb0rJK/Uh2/yj1h?=
 =?us-ascii?Q?CMt7VgOq2yc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7585
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c530c7b4-2eb4-4bd6-80e1-08ddd9c1368a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|7416014|376014|82310400026|36860700013|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vMr1QGUBBUpMLPOrof12tVFWdxEU13Hkmb3du+VbGS6QwmLPDszRzp6qmHrG?=
 =?us-ascii?Q?FSY3hJ+rZmk+zF/7X8ctGiln5AcsC+1Dh1jBX5r5Fb+6Wsny4A/tM7HhPjwI?=
 =?us-ascii?Q?8DWOuIdyfflp5cy1PER4WROmkInJNX2+vn8gtQBIaMUYJTJyVP1ba/IH25+B?=
 =?us-ascii?Q?uaG1A1Yb6cVtMGOLdWeNGCuOkC7P8kg5L50TEB/rAuTVxnS2N21dXljRNNMg?=
 =?us-ascii?Q?JWJDoc8t8j/5xyhejUjEQRX5c0D6j0HXaFIH+upqCH7l/+o2RLyd/yj0wj4p?=
 =?us-ascii?Q?8DpgAwaSaJvM7sj6DBWzOxsCX40rrYgbzUrie4l6ksDD7gJkwXArtkQIla0H?=
 =?us-ascii?Q?hdneUDyk7xH+mjd9TbgrwrhylIwELCI7LN3qGBcQJ2t06XuyV5bo2ww05dZU?=
 =?us-ascii?Q?ks+yD/4M0VPVG5x4Pkfc9QeYtSY36MfsQxCyOsHotUiWHZrEczMFVmRDglr8?=
 =?us-ascii?Q?/CCl86HXNuyLkORzzeydqJXW6aeiONIXMlPU5hazWxeT0lesSt49O2Jdo+3M?=
 =?us-ascii?Q?dAA28+HPTR4iN2EK1+rTAMBN1mOqcK+W7kjee824rfHoEgx6/e2SbV/4FTiO?=
 =?us-ascii?Q?XW8ywi0UbOBhKBVZuWIkRPCCanL1BBs6VbVdSmOVWDB65052wDPZJ8hk0/Ck?=
 =?us-ascii?Q?BhGU57worOgrL4O9OaUruUZYvbG7sp8JUUlCfKEXkxIdasYR0suAqsIxmspM?=
 =?us-ascii?Q?7id/3P3D0kmJ6WlAZ1BvjUU5QWt/kZtDOMx9dWPsKNEfh8yC+U/DQftt0msJ?=
 =?us-ascii?Q?fK9P7z2hfDxIS8U3m6/kU/qQLDLAGc/v+BAJMxeGLx/G6S7v1FSSfC/gXnw2?=
 =?us-ascii?Q?wsb05rTKUVE/kPmunNmbBxUaejVvdUhohAsINnw1KMUNHRnjAlsIq5tkb/St?=
 =?us-ascii?Q?IoLWoscOFlU2ahEP5aD5OWMYD5t7zeEqBXX0JcopKYge1eYp7q9kxm3Fc4qX?=
 =?us-ascii?Q?rp3vMbrtJ+djNE8Rq2Fb5dvp5rcHte4dhYp/HWM+ymP+KKQPZVVMk1LUI5+b?=
 =?us-ascii?Q?qTZbIYN8hy5VT6A13LlSpTEJ15IiTqK9g+Ca3B81/P7zgc4hY57Od6nbgcno?=
 =?us-ascii?Q?5G7SeMV53wW143plSwLHDzxNUDeOVXGExJbe7JKyUQjMhvtsMJl5bqazCFC8?=
 =?us-ascii?Q?14679puYAvCk/bbo4HnnTkTRJdVH5kILpReRZbBnL+IyQaQDwgTCk69dPNM8?=
 =?us-ascii?Q?xfLg41D7b5UU4MIpFtEwGdG081TqU9lvr5g3ZjjN9MFw+fnfONXiXMd27GYq?=
 =?us-ascii?Q?HbqsSUz/ar8UkqdBQHGQeP9H9rHmkF9oFPVtRX5I8Exwoj9UE2s1/81NDk2W?=
 =?us-ascii?Q?ueBfWHK4YazOUn6k04hCyEBA4ncNCXofsm1ar35QFS5YIWBbdJf4il714tDE?=
 =?us-ascii?Q?2ysERSOK+blSlyayOWgDPugVdto07tN+SRRdpmXX/4+SvkQv9oAyf3J8h71a?=
 =?us-ascii?Q?oWZXnL3WgePyWMvK8b2NxUOJYtEXe1ZawLzHrsAZ6bTyXea17sBcmpsRmS3g?=
 =?us-ascii?Q?th9o4cfpa0axlGbkouctjJynyMHYsSKilQnt?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(7416014)(376014)(82310400026)(36860700013)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 16:57:15.7262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10efba60-7522-43a4-0b7a-08ddd9c14a81
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9387
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 63416C000D
X-Stat-Signature: k11xrh44cjnkx3jpkifatmfiinyke7zp
X-HE-Tag: 1755017846-986087
X-HE-Meta: U2FsdGVkX19D21dle7zxKSTGXa9AzxEQUCBI7CfjfyTYKFZ6obe01RDfGXaVJrpadijw6q9VEAcCE+9tWlIQCpXG7sGyzltkXHAYY4PI0FqDm0T94fi1c9gOuWUCuaNZH8t+s+GB+Ce6tQdzzIFzFue5fZiXpI68mBt+aAhukE6B36/WuSm/aZtvVJ8iUQlzY92A64TI8bApIflW51GWiMzX+Kt94E5FhU3w5DfXuSFB2RoMJ0xr8iDT/bna5BOSeBv7bQpY50zX/E/jpCfRun/baeAsNmxXkSAdrVCBbhwaDDrTkI+Z48nNM3V5nrkof7xVDJuNGQT9B4otb+LTj1uHwQhD2/IY0lH6yqb6UoieSENxl04jRAUJFDPoi0aHRTQT4n6xvZR1ldTFbj/Qlkkf0xWY+/M10Ym4ayWzj360YRasUBcUIkdpoZJ6rijDxIILJxl5zrytqDvhK0HfPkU1E1CkYZC0ZIFM4r6JqrpNHTEgqluOXyTKrvbjmhCkolqhb3oEKWz4KZrwkN2ao+Y9r5hBV3FXS/CFylCKTWM4pRe7UAEdffa76FKsaIL+ALVTgMCepW8vSBlQmjYgztnLBV6imffxWvRLopZMutBxEXoJ+4pCVpc/Pj41q9+3ZJxgYAhDy8KQBXEHfnucHeS/uwRy2a1PvLNMDr+czftzIOwhexXT60fy6IKQYhHrwe9vZBK3phaiiV5qiuSafcTgo7NpOEuSJyIAulRTER3cIOlGJ79zj4yALm92f58/MXzUoZ3GV1bKCCg4Vv1widhcd9pMqxKgKj9gWkVG1AfUzXwbXyiheTKQc1he28vsSlQzOlYZenRdTdylP4dS9nIS/v+NBHxPaulMbjVb0Ix3KtPEbzLS2JFGUo3NWrxPDTBsDlR93rweiEcltWuvstnbhmI701Vnn0b2oE6EZg0t4UB2RXMgorpKxsjI2Kaeqj8cFfUGDKAmC/bGZth
 ibqVOSl5
 Iy0Abfavx/Yn46GhpsM0GIPbWWrhR2lscU9lJokYEdaVaIsKGDC+qhR85vYUIWIZvjnHa0iGGdrN7WorMmXS8/rxGDM6Swx5T2Jeb/fGH0rkSCtTxTkU1mZIQ2fYttGuel+MXTzDvRs3GV+DlXJgykw8HIJKJtZggr1bQ/dQZ7JYz8GpYLGbRrDmzwgVMYVFGFY0ro4fKHAkNybk8fHVk1UZyQshyO5EIqnATGss1Ya7wNo4Og69A+p7kOr2+PyhNPitTuNwYHCNggNMh5yYMgcL74GmVRTpS2fc7gHyBHz+86K1rD/BMLXm0kIWDTpe8EoafZGyl1VlbP1smMaOAq1EXUQCMQOfs74BM59Mc3sbJBWBed9RgaPrjKd3m1IGf6g0MjX27cIs8w3QV8iJxAMR/z34CpAJ9OWBDC5szD40rp0E2Eq3rfwwAAIImlYfYoy5gMHtp35Dq0UVqlv8fWzOfaXf3Fu8ilptQfLh479mX5DORhW2woGYeTj/LU4QHVJ2XlFyDQKEPw2MZUCvbHtQl1rYzJzdq2smGVsJm1o8uoyKzBQTIbs992B1mD+lbYHvuhqC+fbnPjXeMYn2gDkIAgEAqIEK748tjo3UZM123C0a1I7WP3+xviHlly8kN5dVKlLMPZaTgNFaiddkNaf3Q+xNUvGQtZA72nIrVJHRq0AY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,

> >
> > When KASAN is configured in store-only mode,
> > fetch/load operations do not trigger tag check faults.
> > As a result, the outcome of some test cases may differ
> > compared to when KASAN is configured without store-only mode.
> >
> > To address this:
> >   1. Replace fetch/load expressions that would
> >      normally trigger tag check faults with store operation
> >      when running under store-only and sync mode.
> >      In case of async/asymm mode, skip the store operation triggering
> >      tag check fault since it corrupts memory.
> >
> >   2. Skip some testcases affected by initial value
> >      (i.e) atomic_cmpxchg() testcase maybe successd if
> >      it passes valid atomic_t address and invalid oldaval address.
> >      In this case, if invalid atomic_t doesn't have the same oldval,
> >      it won't trigger store operation so the test will pass.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  mm/kasan/kasan_test_c.c | 423 ++++++++++++++++++++++++++++++++--------
> >  1 file changed, 341 insertions(+), 82 deletions(-)
> >
> > diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> > index 2aa12dfa427a..22d5d6d6cd9f 100644
> > --- a/mm/kasan/kasan_test_c.c
> > +++ b/mm/kasan/kasan_test_c.c
> > @@ -94,11 +94,13 @@ static void kasan_test_exit(struct kunit *test)
> >  }
> >
> >  /**
> > - * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
> > - * KASAN report; causes a KUnit test failure otherwise.
> > + * _KUNIT_EXPECT_KASAN_TEMPLATE - check that the executed expression produces
> > + * a KASAN report or not; a KUnit test failure when it's different from @produce.
> >   *
> >   * @test: Currently executing KUnit test.
> > - * @expression: Expression that must produce a KASAN report.
> > + * @expr: Expression produce a KASAN report or not.
> > + * @expr_str: Expression string
> > + * @produce: expression should produce a KASAN report.
> >   *
> >   * For hardware tag-based KASAN, when a synchronous tag fault happens, tag
> >   * checking is auto-disabled. When this happens, this test handler reenables
> > @@ -110,25 +112,29 @@ static void kasan_test_exit(struct kunit *test)
> >   * Use READ/WRITE_ONCE() for the accesses and compiler barriers around the
> >   * expression to prevent that.
> >   *
> > - * In between KUNIT_EXPECT_KASAN_FAIL checks, test_status.report_found is kept
> > + * In between _KUNIT_EXPECT_KASAN_TEMPLATE checks, test_status.report_found is kept
> >   * as false. This allows detecting KASAN reports that happen outside of the
> >   * checks by asserting !test_status.report_found at the start of
> > - * KUNIT_EXPECT_KASAN_FAIL and in kasan_test_exit.
> > + * _KUNIT_EXPECT_KASAN_TEMPLATE and in kasan_test_exit.
> >   */
> > -#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {                 \
> > +#define _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, expr_str, produce)    \
> > +do {                                                                   \
> >         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
> >             kasan_sync_fault_possible())                                \
> >                 migrate_disable();                                      \
> >         KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));  \
> >         barrier();                                                      \
> > -       expression;                                                     \
> > +       expr;                                                           \
> >         barrier();                                                      \
> >         if (kasan_async_fault_possible())                               \
> >                 kasan_force_async_fault();                              \
> > -       if (!READ_ONCE(test_status.report_found)) {                     \
> > -               KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure "  \
> > -                               "expected in \"" #expression            \
> > -                                "\", but none occurred");              \
> > +       if (READ_ONCE(test_status.report_found) != produce) {           \
> > +               KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN %s "       \
> > +                               "expected in \"" expr_str               \
> > +                                "\", but %soccurred",                  \
> > +                               (produce ? "failure" : "success"),      \
> > +                               (test_status.report_found ?             \
> > +                                "" : "none "));                        \
> >         }                                                               \
> >         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
> >             kasan_sync_fault_possible()) {                              \
> > @@ -141,6 +147,26 @@ static void kasan_test_exit(struct kunit *test)
> >         WRITE_ONCE(test_status.async_fault, false);                     \
> >  } while (0)
> >
> > +/*
> > + * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
> > + * KASAN report; causes a KUnit test failure otherwise.
> > + *
> > + * @test: Currently executing KUnit test.
> > + * @expr: Expression produce a KASAN report.
> > + */
> > +#define KUNIT_EXPECT_KASAN_FAIL(test, expr)                    \
> > +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr, true)
> > +
> > +/*
> > + * KUNIT_EXPECT_KASAN_SUCCESS - check that the executed expression doesn't
> > + * produces a KASAN report; causes a KUnit test failure otherwise.
> > + *
> > + * @test: Currently executing KUnit test.
> > + * @expr: Expression doesn't produce a KASAN report.
> > + */
> > +#define KUNIT_EXPECT_KASAN_SUCCESS(test, expr)                 \
> > +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr, false)
> > +
> >  #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {                  \
> >         if (!IS_ENABLED(config))                                        \
> >                 kunit_skip((test), "Test requires " #config "=y");      \
> > @@ -183,8 +209,15 @@ static void kmalloc_oob_right(struct kunit *test)
> >         KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + 5] = 'y');
> >
> >         /* Out-of-bounds access past the aligned kmalloc object. */
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =
> > -                                       ptr[size + KASAN_GRANULE_SIZE + 5]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ptr[0] =
> > +                                               ptr[size + KASAN_GRANULE_SIZE + 5]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test,
> > +                                       ptr[size + KASAN_GRANULE_SIZE + 5] = ptr[0]);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =
> > +                                               ptr[size + KASAN_GRANULE_SIZE + 5]);
> >
> >         kfree(ptr);
> >  }
> > @@ -198,7 +231,13 @@ static void kmalloc_oob_left(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr = *(ptr - 1));
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, *ptr = *(ptr - 1));
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, *(ptr - 1) = *(ptr));
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, *ptr = *(ptr - 1));
> > +
> >         kfree(ptr);
> >  }
> >
> > @@ -211,7 +250,13 @@ static void kmalloc_node_oob_right(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ptr[0] = ptr[size]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = ptr[0]);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
> > +
> >         kfree(ptr);
> >  }
> >
> > @@ -291,7 +336,12 @@ static void kmalloc_large_uaf(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >         kfree(ptr);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0] = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> >  }
> >
> >  static void kmalloc_large_invalid_free(struct kunit *test)
> > @@ -323,7 +373,13 @@ static void page_alloc_oob_right(struct kunit *test)
> >         ptr = page_address(pages);
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ptr[0] = ptr[size]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = ptr[0]);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
> > +
> >         free_pages((unsigned long)ptr, order);
> >  }
> >
> > @@ -338,7 +394,12 @@ static void page_alloc_uaf(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >         free_pages((unsigned long)ptr, order);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0] = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> >  }
> >
> >  static void krealloc_more_oob_helper(struct kunit *test,
> > @@ -455,10 +516,15 @@ static void krealloc_uaf(struct kunit *test)
> >         ptr1 = kmalloc(size1, GFP_KERNEL);
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
> >         kfree(ptr1);
> > -
> >         KUNIT_EXPECT_KASAN_FAIL(test, ptr2 = krealloc(ptr1, size2, GFP_KERNEL));
> >         KUNIT_ASSERT_NULL(test, ptr2);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
> > +
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, *(volatile char *)ptr1);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1 = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
> >  }
> >
> >  static void kmalloc_oob_16(struct kunit *test)
> > @@ -501,7 +567,13 @@ static void kmalloc_uaf_16(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
> >         kfree(ptr2);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 = *ptr2);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, *ptr1 = *ptr2);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, *ptr2 = *ptr1);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 = *ptr2);
> > +
> >         kfree(ptr1);
> >  }
> >
> > @@ -640,8 +712,17 @@ static void kmalloc_memmove_invalid_size(struct kunit *test)
> >         memset((char *)ptr, 0, 64);
> >         OPTIMIZER_HIDE_VAR(ptr);
> >         OPTIMIZER_HIDE_VAR(invalid_size);
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> > +
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test,
> > +                               memmove((char *)ptr + 4, (char *)ptr, invalid_size));
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> > +
> >         kfree(ptr);
> >  }
> >
> > @@ -654,7 +735,13 @@ static void kmalloc_uaf(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> >         kfree(ptr);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
> > +
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[8]);
> > +               if (!kasan_sync_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8] = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
> >  }
> >
> >  static void kmalloc_uaf_memset(struct kunit *test)
> > @@ -701,7 +788,13 @@ static void kmalloc_uaf2(struct kunit *test)
> >                 goto again;
> >         }
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr1)[40]);
> > +               if (!kasan_sync_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40] = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
> > +
> >         KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
> >
> >         kfree(ptr2);
> > @@ -727,19 +820,35 @@ static void kmalloc_uaf3(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
> >         kfree(ptr2);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr1)[8]);
> > +               if (!kasan_sync_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8] = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
> >  }
> >
> >  static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
> >  {
> >         int *i_unsafe = unsafe;
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, READ_ONCE(*i_unsafe));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, smp_load_acquire(i_unsafe));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, smp_store_release(i_unsafe, 42));
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, atomic_read(unsafe));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_set(unsafe, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_add(42, unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub(42, unsafe));
> > @@ -752,18 +861,38 @@ static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_xchg(unsafe, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_cmpxchg(unsafe, 21, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(unsafe, safe, 42));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42));
> > +
> > +       /*
> > +        * The result of the test below may vary due to garbage values of unsafe in
> > +        * store-only mode. Therefore, skip this test when KASAN is configured
> > +        * in store-only mode.
> > +        */
> > +       if (!kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub_and_test(42, unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_and_test(unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_and_test(unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_negative(42, unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_unless(unsafe, 21, 42));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_not_zero(unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_unless_negative(unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_unless_positive(unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_if_positive(unsafe));
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_read(unsafe));
> > +       /*
> > +        * The result of the test below may vary due to garbage values of unsafe in
> > +        * store-only mode. Therefore, skip this test when KASAN is configured
> > +        * in store-only mode.
> > +        */
> > +       if (!kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_unless(unsafe, 21, 42));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_not_zero(unsafe));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_unless_negative(unsafe));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_unless_positive(unsafe));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_if_positive(unsafe));
> > +       }
> > +
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, atomic_long_read(unsafe));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_read(unsafe));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_set(unsafe, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add(42, unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub(42, unsafe));
> > @@ -776,16 +905,32 @@ static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_xchg(unsafe, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_cmpxchg(unsafe, 21, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(unsafe, safe, 42));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(safe, unsafe, 42));
> > +
> > +       /*
> > +        * The result of the test below may vary due to garbage values in
> > +        * store-only mode. Therefore, skip this test when KASAN is configured
> > +        * in store-only mode.
> > +        */
> > +       if (!kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(safe, unsafe, 42));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub_and_test(42, unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_and_test(unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_and_test(unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_negative(42, unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_unless(unsafe, 21, 42));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_not_zero(unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_unless_negative(unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_unless_positive(unsafe));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_if_positive(unsafe));
> > +
> > +       /*
> > +        * The result of the test below may vary due to garbage values in
> > +        * store-only mode. Therefore, skip this test when KASAN is configured
> > +        * in store-only mode.
> > +        */
> > +       if (!kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_unless(unsafe, 21, 42));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_not_zero(unsafe));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_unless_negative(unsafe));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_unless_positive(unsafe));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_if_positive(unsafe));
> > +       }
> >  }
> >
> >  static void kasan_atomics(struct kunit *test)
> > @@ -842,8 +987,18 @@ static void ksize_unpoisons_memory(struct kunit *test)
> >         /* These must trigger a KASAN report. */
> >         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
> >                 KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5]);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
> > +
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[size + 5]);
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[real_size - 1]);
> > +               if (!kasan_sync_fault_possible()) {
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5] = 0);
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1] = 0);
> > +               }
> > +       } else {
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5]);
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
> > +       }
> >
> >         kfree(ptr);
> >  }
> > @@ -863,8 +1018,17 @@ static void ksize_uaf(struct kunit *test)
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> >         KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0]);
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[size]);
> > +               if (!kasan_sync_fault_possible()) {
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0] = 0);
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size] = 0);
> > +               }
> > +       } else {
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
> > +       }
> >  }
> >
> >  /*
> > @@ -886,7 +1050,11 @@ static void rcu_uaf_reclaim(struct rcu_head *rp)
> >                 container_of(rp, struct kasan_rcu_info, rcu);
> >
> >         kfree(fp);
> > -       ((volatile struct kasan_rcu_info *)fp)->i;
> > +
> > +       if (kasan_stonly_enabled() && !kasan_async_fault_possible())
> > +               ((volatile struct kasan_rcu_info *)fp)->i = 0;
> > +       else
> > +               ((volatile struct kasan_rcu_info *)fp)->i;
> >  }
> >
> >  static void rcu_uaf(struct kunit *test)
> > @@ -899,9 +1067,14 @@ static void rcu_uaf(struct kunit *test)
> >         global_rcu_ptr = rcu_dereference_protected(
> >                                 (struct kasan_rcu_info __rcu *)ptr, NULL);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> > -               rcu_barrier());
> > +       if (kasan_stonly_enabled() && kasan_async_fault_possible())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> > +                       rcu_barrier());
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> > +                       rcu_barrier());
> >  }
> >
> >  static void workqueue_uaf_work(struct work_struct *work)
> > @@ -924,8 +1097,12 @@ static void workqueue_uaf(struct kunit *test)
> >         queue_work(workqueue, work);
> >         destroy_workqueue(workqueue);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               ((volatile struct work_struct *)work)->data);
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       ((volatile struct work_struct *)work)->data);
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       ((volatile struct work_struct *)work)->data);
> >  }
> >
> >  static void kfree_via_page(struct kunit *test)
> > @@ -972,7 +1149,12 @@ static void kmem_cache_oob(struct kunit *test)
> >                 return;
> >         }
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, *p = p[size + OOB_TAG_OFF]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, *p = p[size + OOB_TAG_OFF]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, p[size + OOB_TAG_OFF] = *p);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, *p = p[size + OOB_TAG_OFF]);
> >
> >         kmem_cache_free(cache, p);
> >         kmem_cache_destroy(cache);
> > @@ -1068,7 +1250,12 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
> >          */
> >         rcu_barrier();
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, READ_ONCE(*p));
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*p, 0));
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
> >
> >         kmem_cache_destroy(cache);
> >  }
> > @@ -1206,7 +1393,13 @@ static void mempool_oob_right_helper(struct kunit *test, mempool_t *pool, size_t
> >         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
> >                 KUNIT_EXPECT_KASAN_FAIL(test,
> >                         ((volatile char *)&elem[size])[0]);
> > -       else
> > +       else if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       ((volatile char *)&elem[round_up(size, KASAN_GRANULE_SIZE)])[0]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test,
> > +                               ((volatile char *)&elem[round_up(size, KASAN_GRANULE_SIZE)])[0] = 0);
> > +       } else
> >                 KUNIT_EXPECT_KASAN_FAIL(test,
> >                         ((volatile char *)&elem[round_up(size, KASAN_GRANULE_SIZE)])[0]);
> >
> > @@ -1273,7 +1466,13 @@ static void mempool_uaf_helper(struct kunit *test, mempool_t *pool, bool page)
> >         mempool_free(elem, pool);
> >
> >         ptr = page ? page_address((struct page *)elem) : elem;
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> > +
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0] = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> >  }
> >
> >  static void mempool_kmalloc_uaf(struct kunit *test)
> > @@ -1532,8 +1731,13 @@ static void kasan_memchr(struct kunit *test)
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> >         OPTIMIZER_HIDE_VAR(size);
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               kasan_ptr_result = memchr(ptr, '1', size + 1));
> > +
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       kasan_ptr_result = memchr(ptr, '1', size + 1));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       kasan_ptr_result = memchr(ptr, '1', size + 1));
> >
> >         kfree(ptr);
> >  }
> > @@ -1559,8 +1763,14 @@ static void kasan_memcmp(struct kunit *test)
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> >         OPTIMIZER_HIDE_VAR(size);
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               kasan_int_result = memcmp(ptr, arr, size+1));
> > +
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       kasan_int_result = memcmp(ptr, arr, size+1));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       kasan_int_result = memcmp(ptr, arr, size+1));
> > +
> >         kfree(ptr);
> >  }
> >
> > @@ -1593,9 +1803,16 @@ static void kasan_strings(struct kunit *test)
> >         KUNIT_EXPECT_EQ(test, KASAN_GRANULE_SIZE - 2,
> >                         strscpy(ptr, src + 1, KASAN_GRANULE_SIZE));
> >
> > -       /* strscpy should fail if the first byte is unreadable. */
> > -       KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr, src + KASAN_GRANULE_SIZE,
> > -                                             KASAN_GRANULE_SIZE));
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, strscpy(ptr, src + KASAN_GRANULE_SIZE,
> > +                                                     KASAN_GRANULE_SIZE));
> > +               if (!kasan_async_fault_possible())
> > +                       /* strscpy should fail when the first byte is to be written. */
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr + size, src, KASAN_GRANULE_SIZE));
> > +       } else
> > +               /* strscpy should fail if the first byte is unreadable. */
> > +               KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr, src + KASAN_GRANULE_SIZE,
> > +                                                     KASAN_GRANULE_SIZE));
> >
> >         kfree(src);
> >         kfree(ptr);
> > @@ -1607,17 +1824,22 @@ static void kasan_strings(struct kunit *test)
> >          * will likely point to zeroed byte.
> >          */
> >         ptr += 16;
> > -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result = strchr(ptr, '1'));
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result = strrchr(ptr, '1'));
> > -
> > -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strcmp(ptr, "2"));
> > -
> > -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strncmp(ptr, "2", 1));
> > -
> > -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strlen(ptr));
> > -
> > -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strnlen(ptr, 1));
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_ptr_result = strchr(ptr, '1'));
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_ptr_result = strrchr(ptr, '1'));
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result = strcmp(ptr, "2"));
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result = strncmp(ptr, "2", 1));
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result = strlen(ptr));
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result = strnlen(ptr, 1));
> > +       } else {
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result = strchr(ptr, '1'));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result = strrchr(ptr, '1'));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strcmp(ptr, "2"));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strncmp(ptr, "2", 1));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strlen(ptr));
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strnlen(ptr, 1));
> > +       }
> >  }
> >
> >  static void kasan_bitops_modify(struct kunit *test, int nr, void *addr)
> > @@ -1636,12 +1858,27 @@ static void kasan_bitops_test_and_modify(struct kunit *test, int nr, void *addr)
> >  {
> >         KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit(nr, addr));
> >         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_set_bit(nr, addr));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
> > +
> > +       /*
> > +        * When KASAN is running in store-only mode,
> > +        * a fault won't occur even if the bit is set.
> > +        * Therefore, skip the test_and_set_bit_lock test in store-only mode.
> > +        */
> > +       if (!kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test, test_and_clear_bit(nr, addr));
> >         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_clear_bit(nr, addr));
> >         KUNIT_EXPECT_KASAN_FAIL(test, test_and_change_bit(nr, addr));
> >         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_change_bit(nr, addr));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = test_bit(nr, addr));
> > +
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result = test_bit(nr, addr));
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, set_bit(nr, addr));
> > +  } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = test_bit(nr, addr));
> > +
> >         if (nr < 7)
> >                 KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =
> >                                 xor_unlock_is_negative_byte(1 << nr, addr));
> > @@ -1765,7 +2002,12 @@ static void vmalloc_oob(struct kunit *test)
> >                 KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size]);
> >
> >         /* An aligned access into the first out-of-bounds granule. */
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size + 5]);
> > +       if (kasan_stonly_enabled()) {
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)v_ptr)[size + 5]);
> > +               if (!kasan_async_fault_possible())
> > +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size + 5] = 0);
> > +       } else
> > +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size + 5]);
> >
> >         /* Check that in-bounds accesses to the physical page are valid. */
> >         page = vmalloc_to_page(v_ptr);
> > @@ -2042,16 +2284,33 @@ static void copy_user_test_oob(struct kunit *test)
> >
> >         KUNIT_EXPECT_KASAN_FAIL(test,
> >                 unused = copy_from_user(kmem, usermem, size + 1));
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               unused = copy_to_user(usermem, kmem, size + 1));
> > +
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       unused = copy_to_user(usermem, kmem, size + 1));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       unused = copy_to_user(usermem, kmem, size + 1));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test,
> >                 unused = __copy_from_user(kmem, usermem, size + 1));
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               unused = __copy_to_user(usermem, kmem, size + 1));
> > +
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       unused = __copy_to_user(usermem, kmem, size + 1));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       unused = __copy_to_user(usermem, kmem, size + 1));
> > +
> >         KUNIT_EXPECT_KASAN_FAIL(test,
> >                 unused = __copy_from_user_inatomic(kmem, usermem, size + 1));
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               unused = __copy_to_user_inatomic(usermem, kmem, size + 1));
> > +
> > +       if (kasan_stonly_enabled())
> > +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> > +                       unused = __copy_to_user_inatomic(usermem, kmem, size + 1));
> > +       else
> > +               KUNIT_EXPECT_KASAN_FAIL(test,
> > +                       unused = __copy_to_user_inatomic(usermem, kmem, size + 1));
> >
> >         /*
> >         * Prepare a long string in usermem to avoid the strncpy_from_user test
> > --
> > LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> >
>
> This patch does not look good.
>
> Right now, KASAN tests are crafted to avoid/self-contain harmful
> memory corruptions that they do (e.g. make sure that OOB write
> accesses land in in-object kmalloc training space, etc.). If you turn
> read accesses in tests into write accesses, memory corruptions caused
> by the earlier tests will crash the kernel or the latter tests.

That's why I run the store-only test when this mode is "sync"
In case of "async/asymm" as you mention since it reports "after",
there will be memory corruption.

But in case of sync, when the MTE fault happens, it doesn't
write to memory so, I think it's fine.

>
> The easiest thing to do for now is to disable the tests that check bad
> read accesses when store-only is enabled.
>
> If we want to convert tests into doing write accesses instead of
> reads, this needs to be done separately for each test (i.e. via a
> separate patch) with an explanation why doing this is safe (and
> adjustments whenever it's not). And we need a better way to code this
> instead of the horrifying number of if/else checks.
>
> Thank you!

Hmm, as I mention above, the testcase with store-only/sync mode seems to fine.
But, If the "testcase" is failed, as you mention it makes a memory
corruption.

If success case is fine,
Please let me make all related story-only case be seperated
to each function (but almost simliar to pre-exist testcase) with
sync mode otherwise, let me seperate them just checking it whether
it success when it accesses to invalid memory with read/fetch.

Thanks :)

--
Sincerely,
Yeoreum Yun


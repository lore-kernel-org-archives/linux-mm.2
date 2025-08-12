Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB20ACA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 21:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE6B8E0195; Tue, 12 Aug 2025 17:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286228E0151; Tue, 12 Aug 2025 17:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E278E0195; Tue, 12 Aug 2025 17:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0600A8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:28:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97255815BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:28:08 +0000 (UTC)
X-FDA: 83769393456.18.E47CBD4
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013030.outbound.protection.outlook.com [40.107.159.30])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD3CA140006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:28:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qElVVzuq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qElVVzuq;
	spf=pass (imf26.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.30 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755034085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JIAlrahIoJb7vyj3+4Bn+Rx3tUFGZvO3fHQ7vDOLPY=;
	b=GMsQlUvrgWFJrBZDz7mB9Lbf0juaMWAPJF4Zy8c3LmARqsVfl7r8fk6XF7sCMj12y+8hT+
	/7F/kKK6oEIPhKEMkr5+6SkcQWzE9HcQtr1a7dhmbUEcnL+RafcprbMwT/IzukdW9/S8Ej
	clHBADTOI2GyPrH+aBAxBQVcokYRWJQ=
ARC-Authentication-Results: i=3;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qElVVzuq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qElVVzuq;
	spf=pass (imf26.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.30 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755034085; a=rsa-sha256;
	cv=pass;
	b=d67GjwCVTIG2VCEt5KfTg34BKGtow58rGBF7Fe78mqrPGX2D9dvqpMUnbU1UyQiVOhaufz
	DqdRZKYq20ndsS2bVPmSb2705SBV46N7seeDkPHJl9dSLnC7O6/N1mFGNUbLPCCAwNbCXg
	Ol8b/jcanVKQwT86vCnZaDhW/uYHoK8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sactH41ffs2HHpqpTQ6tDSbWDSQeT8BMY/edLg6fEJPAza0PZlY1selk92fdMLi4bpo5GnhIiCuraXg5oW4VYAdnltgA4Eox2bQIvUqQi6d9r1WQ9QsPtXG4UWX9ulKgH39boBTdCdXu5nvWdvTKwoa07UO57mPYoopoG/OLIzt4u1HiNStXwBZ9x5BGWyUf0a9qt2JKXVtg4NxNTO6JTDsSG5l5ucw2chvuMsoTFES8bjoS9V6nKS/a1i/sTqAh4b5+SrcWR0XKSFu1Ehex452wEJSJT46f/xAlCzgNPAaYVvitOE4j+jloT/xNnoBxZZqK5/zUiIyW9382ZrQnqw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JIAlrahIoJb7vyj3+4Bn+Rx3tUFGZvO3fHQ7vDOLPY=;
 b=WHI8bB6NjIuTZZKAdoSHn4nKAUcPkVGkZSUMQN+XIjWU4FC40iHb1taQNVlv4oKQh/2CkiyDdXd29FAvgQGC1jSsh0AgTytS6vQTmte/9yMB3uxxItrTkUiUU3DizrJ26OneV8nZI+vi9ILJG/tCN8LKJEKoiBawuVgmNXgcQP8CAR02pVC7Bqs6VAmQMMR9rD5c6sRTPMoX7wlAzBhhwS19E+nSmKYzk1o4uNM06McHZMVX4TBXoLQPXAgR6DRYYWVn9tlVcNviF2mPkqjhMiDbNxecmhXpKBGIeomUqhXhs8Ixcgo0cYO79NMbZMxbO7lmf+WKYgO+P2nRzBVPFQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JIAlrahIoJb7vyj3+4Bn+Rx3tUFGZvO3fHQ7vDOLPY=;
 b=qElVVzuq1sdE28a2JJO8ztdnAm6Gdcly6ojxt+b2iWrDC+pY+lsP1/3Z8ccrRz6oo4HuBi7l3aJ+pKygVdH7sd4PWrbYenTK+Ol6kkUjszg7QsohrtsH0F6/yrcrTOogJt/w7Z3bRaJbJGImWNOk8eInHfQAFTWmfTXzWTsZSAc=
Received: from DU7P250CA0005.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::32)
 by AS2PR08MB9618.eurprd08.prod.outlook.com (2603:10a6:20b:609::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 21:27:58 +0000
Received: from DU6PEPF0000B61D.eurprd02.prod.outlook.com
 (2603:10a6:10:54f:cafe::43) by DU7P250CA0005.outlook.office365.com
 (2603:10a6:10:54f::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.13 via Frontend Transport; Tue,
 12 Aug 2025 21:27:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61D.mail.protection.outlook.com (10.167.8.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.11
 via Frontend Transport; Tue, 12 Aug 2025 21:27:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9iAaqlNao7VihahFm0lxi44+NORtmKvL69h6RPx6MemJA6CZG+n20xPvf+5+77uWjFSLxWkNRWSYfzKpCCa61j1/F6DRI/aXAvQGZrxEs4g7pKi3gLQu1igSpxmyxVnGDqpF5SfZUe9HDwIpEY/UE9SdhJI14Sc0bz5zsNgjc+Vh2woMwUZFwgmSWNiYKj6RfWrsDKUpjLz1nu4OZSp+OPWt4dc8WPBaPUmgpqzYrlRMO+C4w9PerCBovElW7s9DLe+8ztRXTJRjmkIBZIiauzDX9GbLjg2Xf4cqAiSUGIK/+SFahuFHFB5TVUFO3tp3cMFZrzl1IHv59BDVp/h2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JIAlrahIoJb7vyj3+4Bn+Rx3tUFGZvO3fHQ7vDOLPY=;
 b=UZ1DBYYlY/n3XuqKqfWn3az4AL9N3o7yrL3eLxpkZ39iFhwL+b5Oh9lKnGNVvWsQUFUaV4Gsb6JpAfQhRxoxVyXFcWaZ9cc+NreXOuogqgjqui7jA5tjnGWkyw6I2YmHo8FdSuHJht75dqyxHjB5ZKkemJd3q9tfpx4LL7gw+AbKyBq/RsVGRTLyKsrLp4Lr+Gd0hv1nScT6g6nX1dlAB1Uon1uSisTDMnKtyVpFNmT4y20ySvsp04AXtU3S7yj3SnMny93kmsM79OZ2gZIiuuj7j7VAPy9bxoVKN809yV/M1V2Sk3g4SZoebxAWDIJwjsC0rKHr3luZLXiyLKRwVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JIAlrahIoJb7vyj3+4Bn+Rx3tUFGZvO3fHQ7vDOLPY=;
 b=qElVVzuq1sdE28a2JJO8ztdnAm6Gdcly6ojxt+b2iWrDC+pY+lsP1/3Z8ccrRz6oo4HuBi7l3aJ+pKygVdH7sd4PWrbYenTK+Ol6kkUjszg7QsohrtsH0F6/yrcrTOogJt/w7Z3bRaJbJGImWNOk8eInHfQAFTWmfTXzWTsZSAc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB8PR08MB5372.eurprd08.prod.outlook.com
 (2603:10a6:10:f9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 21:27:24 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 21:27:24 +0000
Date: Tue, 12 Aug 2025 22:27:20 +0100
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
Message-ID: <aJuxuKBm9qfpVkBC@e129823.arm.com>
References: <20250811173626.1878783-1-yeoreum.yun@arm.com>
 <20250811173626.1878783-3-yeoreum.yun@arm.com>
 <CA+fCnZeSV4fDBQr-WPFA66OYxN8zOQ2g1RQMDW3Ok8FaE7=NXQ@mail.gmail.com>
 <aJtyR3hCW5fG+niV@e129823.arm.com>
 <CA+fCnZeznLqoLsUOgB1a1TNpR9PxjZKrrVBhotpMh0KVwvzj_Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fCnZeznLqoLsUOgB1a1TNpR9PxjZKrrVBhotpMh0KVwvzj_Q@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0264.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::17) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB8PR08MB5372:EE_|DU6PEPF0000B61D:EE_|AS2PR08MB9618:EE_
X-MS-Office365-Filtering-Correlation-Id: c1d80ff8-cd54-418b-1cff-08ddd9e71b2a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?UBEVAalBsjrxdPVLcgMjSg3A3Ls3mUg1dGo2YV4pV9KFB/dNzNvqUK8Z5eag?=
 =?us-ascii?Q?CCpD/r7GM/reXXqdcfzddKaqLob08JLKeX1Gc1a6KaewVkdAqXOaUd2EsOp3?=
 =?us-ascii?Q?yKpVgJB0+LAF94CnJfpVwopnMn0/p9jl9DqBeyBEibrvLVafB3oUYat9Lzi9?=
 =?us-ascii?Q?+PlboW5yyPM3v8R3tF6ZyHiRL9Exitm4zZdijmjDyRibG9NHC3a7OCT+u8oK?=
 =?us-ascii?Q?7jqBCFDT56QbaRNqpO1kHPx7/srpjJdW575kB3GQRatg1PdC9cj1S/SN0dT1?=
 =?us-ascii?Q?oXX8XU5BepLrvBr467NFhUMMmG/0lbcjUeaP6kKJUIIvvzLdfUXq5nIMeAHl?=
 =?us-ascii?Q?lcwPfxAjQBhFD6DjXIIRr+1HSuPjbNH8Lx2HDtTiICoh6uHlwsTWoP66u9mS?=
 =?us-ascii?Q?Gv9iYhOL+P/08QzaoOlSxSXG4ZlYOv0eFNYaRwK/+xB+DDGIGUxjI66RUba0?=
 =?us-ascii?Q?KYxnvPEj57XUCmmXTK/4n6LPwJeGLRS9ps7yKIdCB6iWkQEPqnyeBzqSW9Cr?=
 =?us-ascii?Q?muTnQ8Yn2OgxJcVs4ryzYoFiP7CctFKmTZuDfeIXh3CLI2sL3QheIATDhNnU?=
 =?us-ascii?Q?aMB5dgWZryDv9GCa0zPm8/K/KkJisw9crdjQ5/aRRoQ6P7ZtaQh9aTGBDiGW?=
 =?us-ascii?Q?wk7f9zF4m9CJnHSc/SkcHUQl2NqxDP66qDwKTgaQKDJolqKLD0fwA4yoolaK?=
 =?us-ascii?Q?j19GtYi7m4QLndpEeLRQA8HYXEPwZstJablKY2MJVkoJLIRfIr09SQ6xcU8a?=
 =?us-ascii?Q?nuRiQwaT/4WkvAwYryFTA6ZdxvaqXZfj1ExBEHmlpQhVtEvAvBDnxQ4QaP22?=
 =?us-ascii?Q?aW1cJY9aepQKQdHtEDJCp5ltyWSilcVYrTqYnmdf/Nx3qVc85EXd0sZHjr+G?=
 =?us-ascii?Q?VQCaXhQ3Q4HeHKnxy053s1kJDrVdAJ8+Z0TDPYcl1NeK9OubmP/nlumGRN2I?=
 =?us-ascii?Q?ykvMIeMRXmskv+veOJky8wjqIhCBNrw6YQvMEJSPQn4rFIMOqJi8+OVjL9GJ?=
 =?us-ascii?Q?l4R+qv3XgIrY0PrxBG8cN0CNEDgQh+Wtf5eSdBDnNHeRH5Aqqx5qxPv7kOMv?=
 =?us-ascii?Q?HRcEOGvfUAhYAEnZklTtjQbFrIvcAWoAv8J66SuxbJ4N3BttkJFh9l3D5+2Y?=
 =?us-ascii?Q?pduIyHlw6xHnIORZWySnmW76irQrh79993lISc6hh7NylrDm571z9iGg5+yC?=
 =?us-ascii?Q?13eDgmhUWu6KrV8rf7dVY0munn7EyfPpo9Db9pVi95hs+Ibjp+qTtyuquUu/?=
 =?us-ascii?Q?jefIyg240LuGywBV8u3HG7VKItQZZYB3d6eBG3nnkGySAxVgG1AZFr9LT1wJ?=
 =?us-ascii?Q?K25+EkavAe2lkdbMRP1RNncem0CcNKxIetUpvt223kMpZuck2Skc0YRlSMG/?=
 =?us-ascii?Q?RP4C3ztLydD7+1HZxijUKwIvgeJFOgJ8Ct+QcD7kgg6na65ekfNeSUFJreV/?=
 =?us-ascii?Q?3t8YLeDx0ec=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5372
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d8123d43-a49c-4054-1cef-08ddd9e70727
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|14060799003|376014|82310400026|35042699022|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?31zhvKgLcGkV9ytnAPiPKDt2w+LeHWdzDSF/vS8qa1M3cylfFbNTo3Sc4XzG?=
 =?us-ascii?Q?ePmLyN0iPLNBey9Y5WMK+WxpemV2SrQCiXg+CTbcbo1OG4Sv8mEL2kjj8GpR?=
 =?us-ascii?Q?Xidj90Xppx5hCo1V55YBk4PWYQLpcxbHoYSdFMW4lkRJa8wX9r/DO1ukRDbf?=
 =?us-ascii?Q?odu+q8FZHFDTpDV8EY/HqgwPxCRjHiZLYlTZZmcnydjTYO7GOnKCbDFWx9kN?=
 =?us-ascii?Q?S3YWCcYZVj9zuMuVsbOYHNo2G7M0hXZBw1rPDITnwCo1wKyLiJ8is6+ylapH?=
 =?us-ascii?Q?X7VZfNlWC6uaX2FAKzPo0jrFoAdlpLAWaUwwOjcowj9aqNa36l+Kbzvh5ZAu?=
 =?us-ascii?Q?z1xOMwlFu0uzN2AfcTU/XGx4VLlriCboHKLnvJzTp9bMrSNpwD5ybqgr148b?=
 =?us-ascii?Q?c4lxgLs2zHSDv86qpZKEYDrjk1jaTM1WTFOPvV7XVk/3PFx07LMgyMQZztL4?=
 =?us-ascii?Q?xhmq01PEH4Z65E1L8M/GD5Ptu1BDO5D+wy31MCLrC3hXikDWTij6o2sWOl8A?=
 =?us-ascii?Q?hYIY5PmrWC1Cn5WUz3m1olgLSEzd1C6n7gvzBCqqbAhcy9vNNB2bDPlZFLqE?=
 =?us-ascii?Q?7upGeVw3lyDwu64sR6QeWXgUd3JwSnH2MfmZYOWt5mu/zW4a1+HNXgP3Nzcf?=
 =?us-ascii?Q?ep+yE8+s5XBDDDEOzhyhmySzHHAiaXUunlYGoKd2Hlpg7RCx1hC5q3LmisUx?=
 =?us-ascii?Q?HQ8GYPoA55fYuA0HSpOBsCsGDmCHwXoWdEHs6qxBthK3yCjVK1qcgyEJ1abY?=
 =?us-ascii?Q?4zqlqto6Mfr/ZCSKIHkIh0WVOSpJFcpnz2HNdCe2SpD1aWy/XraCfLPDybpI?=
 =?us-ascii?Q?/uU8p7jlyos5NbC1M27Bp+YU16ILuvgpE7hvvT7i+9BaMVwJG9XFaVDi+Dxt?=
 =?us-ascii?Q?aer1ZASEtZviv3BSS6pLlkH5p6De34ra4txkz0nTw/zam9wQke5vLuq535aO?=
 =?us-ascii?Q?jCKFMxezx+FlKNsQ4IP4nKBYsxRJxfhCeKZ32SEvqqq8A0KFHsZ7qs/IUXKY?=
 =?us-ascii?Q?BMWHzcnj71PkNzfoMiCtf3muS8ckb6K+UyhSulz295wx9Jmn+JLuDLL3D3Ze?=
 =?us-ascii?Q?B9+u0Y3YFy1J2aZhulmQ4vwTWpeHMQYDagjPTv7+pOUVZZDN0eQb0fpsbvsA?=
 =?us-ascii?Q?LRYjJgbYa7W+KUsQ5C7IybivYbOVWB/3xHrt3Kq6neIO8Cnz82n+BWv2qCTc?=
 =?us-ascii?Q?3hVD4fjDPzKvFr9SE7SWLcZDhMOfb5wwydVe0RCB/EpObIvkEyKK2/wUyeEF?=
 =?us-ascii?Q?ylJWuv5tSGOQ/YgAUiqPE6nMW3Uweus/o4Nnghq8Jn8sLLY9A/WVFVnz7a5H?=
 =?us-ascii?Q?GquCZQ6yMqvbxdIacmupADm1CDb0qJG/KxFV7+PXQqekNU+M5X/yaTrdPFxg?=
 =?us-ascii?Q?WcLcwVAxP0B7ySLZh1MIM3+e4sq0BQp5iPjw/Ql/G9XhX1Ts9ZbQrdUKDJZh?=
 =?us-ascii?Q?lLQ2gyn2Ly0FfDIvgavFfEYRrnUnMie4IyECJjcvr7wSN0RGt2Pc+0pmju4e?=
 =?us-ascii?Q?MlWD2/PeDWJFoIRQFZfibQWdhK2VZR4FHSIP?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(14060799003)(376014)(82310400026)(35042699022)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 21:27:57.1824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d80ff8-cd54-418b-1cff-08ddd9e71b2a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9618
X-Rspam-User: 
X-Rspamd-Queue-Id: AD3CA140006
X-Rspamd-Server: rspam06
X-Stat-Signature: kshkm1f7udut95z53e5a3oiftyybhmjq
X-HE-Tag: 1755034084-449779
X-HE-Meta: U2FsdGVkX1+9T8D2C3hpyNA91/wXhfVmNaCbMInBs9F89241uaNvjB7tp/CqbItQdnPjohHdIeSsHIpRgh5YIxXxAjVvHmp9V7aygXHxBfOhEq5OXxPuPyAFWOn15N432NC0UUW+vI97jG9AQsTcUZt1fr/CSSaRF3WkPmJ51UcTcJDJYs2+A0Xnqg2xGJEa8F4nmV+q2FUJhwGqWkfA0prD6/nvCB787EDBm2lbFLz0AhmREoFMunDczBsgS6Z+s2WEuRKWC0y2bEHjK2wVl0mHObF7Kml7FSYHUXd4jKwAZnjRARljrLBlefAWs58g87pawlTNsbA0gA7hrsagd2rYxEeh9KqrAOK35LBCxaldsjGkf+EbKqKs8/04oB5qtsVj56Nfnb/u7rkrag5XXEEpCBP67n2AJt0EVXVbrP1auE9k46ZM3VIVYAeDScXF5Ua+sqoluDrzyB9awVY9WX5zC1cx7wW+9CPTrwFMJiCAbgx1AWjXdKnDIKdybvhMgVgdOMwuMLhENWCwnlKk+9UbhAoX+fey5RHJR1nbiU5rl3NofKrgdJWTxmpjYP9JsXrHT5w9hErWz5zF8JWDJ4UKvz+0XqPGcSnBrmesm0GmYY0aFdZaLlnM7vfgePeERWTF37tl5aYTyUPIpjm+xtbBabpZJPlC8iqL5gSptvtIBPG2XuAhhG5ok7hBaZ8a1tjWzfYGz1pfHnDz8A0dQ8whFC2AxHgmfSV6MhyhJLtLPNmACtKMv7SqdsMCb2w/deCQUCCAXbubkIThl+XSGI9vulehS3re6x5pMath8onNuRRU/4dWM7CeTISbtwxpAzl8VQ8PUI2fwxQjBk8TZQRvcYG3oii6L8x84TZbNa8r0Kxcix8mS5uMV58l417UP5bVCA1ucMKQdt6+6RwLEQmD6uR9jkaFnwm0KVlpHPlZp7j6p2XPu8RhwuySa7D+MB1BJOYlHEBWOVUbRl8
 LoaIt2M9
 ++YhrZeIfVUzNLh116Yc/oHYmGiF3lS+Bnd5SollCeiDBuuZ+/TgULgqULKkj6tl+tiKHWTU0IlH8Zd4QccDUVI1lpwZP7jHROOxNINqTjtV558oOE8ratOQGnCElMEdU0I0gpFcMAu0KGmbFVJ69fHL2UjSomy47XJrpy1OlAT7HWywc4Dbp6ecZHvBLo8TdPt90s8Z2thSO9muy9rNnqJLIIEAHRLc01j/s/vIYtbq/wqdfNhy9sX/8VA/tZU2i01Bx1a0Kmz5zfZ+qUzgZsdEzhqAo356ZwnG5BiIyQYkDzX6Ugy4xYudC3UCqj0LJlec4ppQSf99HiP/I6aLB+0ouxTbav66DpK44sv/N7mjnnEr3mvLAxqhdrRxETis1rp1Y++KywNU346ppS+NuVLO9NbD6lbjDPd3oUMme9waSiJgEkIvKkWU0kqz1bL7RtuKwaikUl30IDSll6UqPq3BnCsfFq3Bf9K4rl8B6tdhtfF2MFzc+Hb1eVWmsakK2rOWc1ku18XgmEuzErJRSP33cKpxd6nDD/nJmmbMEWLASTlwU70PnYsvrl8qLYBNzwMDUdWrB0stuu7nVQZkmzLY4H5v3Q2wueP3X39R/m0HDSmrKBp+OtKsb/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,
> >
> > > Right now, KASAN tests are crafted to avoid/self-contain harmful
> > > memory corruptions that they do (e.g. make sure that OOB write
> > > accesses land in in-object kmalloc training space, etc.). If you turn
> > > read accesses in tests into write accesses, memory corruptions caused
> > > by the earlier tests will crash the kernel or the latter tests.
> >
> > That's why I run the store-only test when this mode is "sync"
> > In case of "async/asymm" as you mention since it reports "after",
> > there will be memory corruption.
> >
> > But in case of sync, when the MTE fault happens, it doesn't
> > write to memory so, I think it's fine.
>
> Does it not? I thought MTE gets disabled and we return from the fault
> handler and let the write instruction execute. But my memory on this
> is foggy. And I don't have a setup right now to test.

Right. when fault is hit the MTE gets disabled.
But in kasan_test_c.c -- See the KUNIT_EXPECT_KASAN_FAIL,
It re-enables for next test by calling kasan_enable_hw_tags().

So, the store-only with sync mode seems fine unless we wouldn't care
about failure (no fault happen) which makes memory corruption.

However, I'm not sure writing the seperate testcases for store-only
is right or now since
same tests which only are different of return value check will be
duplicate and half of these always skipped (when duplicate for
store-only, former should be skip and vice versa).

Thanks.

--
Sincerely,
Yeoreum Yun


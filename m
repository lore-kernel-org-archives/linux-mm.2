Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B9ACA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF4A8E01DD; Fri, 15 Aug 2025 04:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7374D8E0002; Fri, 15 Aug 2025 04:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7FC8E01DD; Fri, 15 Aug 2025 04:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 455D68E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:07:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4508BBF00
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:07:31 +0000 (UTC)
X-FDA: 83778262302.20.5AAD9FB
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013053.outbound.protection.outlook.com [40.107.159.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id BD335A000E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:07:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=haJsGhC2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=haJsGhC2;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.53 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755245248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaoMl/Smp3Dnv6i/e1UFNzlS+9QMXvPz3nluE3uu6dw=;
	b=Wsdq/6yR9/xgsrMlYgVNCEvySLGd6fyK7c5g/BzTdv217fBBNtuRDOAt9kQdLWz5L8mpWb
	oBAN8K3/LXIXdKF3KHnMYcnIaafw7aA9KUdyW6OntLI84wFT4TPZph3hNktXQLPtnpmHgO
	ETotN8iHxZOPhzyfdW88v7nDlNEm2OU=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=haJsGhC2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=haJsGhC2;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.53 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755245248; a=rsa-sha256;
	cv=pass;
	b=GdHhRzyfNs35lAmBdpokzpWYJa46JWuIFqemBWwfSwjomlTWz8DDAqX+ySmr8/II+KGALo
	pgn3kvM+y0kScz8wLd4GFZJb06YAlUjF2yTvT23RqDCqfQA4LBeNznjbVSN8UCZgnjnVqC
	v3gGbbmT8+AtV8qjQyId7EOzd/qd8F8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ofsLh8Rm1PYPt8pxF+MLJCOtWZODBoSOQgmaGoCxKjBFvdmDnTRaoeeYwpI3RtVIOol2Zc+UAAfRkYf739WEqG9ghzte3klfgMLRrqBfLdvtN1WIAi40Yi2gbaGNGf5+AImVR0lkBbm8dDeibGQ8yT2t3xNAX/MbTaDLFIa15xAl+aSjI/ntuHQKEBlXinloijbRih+ZNKHHsswwOd2Zxr46fGUmEy4zYdv9+9hkOXDwXvBm/+EaZyVkkggsRWwQ3wWNKfTdFV8vNKAkwSL41eaUdrSYpao/ud4tH2KECOKtp3Krxrn72KQ11DNtWAwZ2nTja/PlLzaQ7YfyJiVMCQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xaoMl/Smp3Dnv6i/e1UFNzlS+9QMXvPz3nluE3uu6dw=;
 b=WgSDbepfkJTXsJeX9yopqFh0zoNEgg47LoVJCRhc7JxLT8V2P+wdcBE+QWFfMd2OUUCi5+Ws+k24XFdWvue157jHJ5Wo/NHYMfxWnS1UdGLEmK7Sjkqu3lDdbfbzqfM2T31VJPk+nI51zlDlV/lStr2DKIBu4QE/r2aW1/i3I9IcFlDRZqj/JfCUI6E1V1XfGPhJ+1frukxn5/93WfQSCruzAg1GEgj8TnxdjmMH+qoHVbRKETw9G+9EmyBm0kJi7knhZ3vSY2ZNp/hy4AEATtMiwtesZGakT7V1Iw3Ga6FCHYvwx+8WtL+qV88Ouj4tQDzfWL42UgkUnVCDAt9xUw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaoMl/Smp3Dnv6i/e1UFNzlS+9QMXvPz3nluE3uu6dw=;
 b=haJsGhC2Bv7sZtHCiY5x2Go86Zns6EfSnv2IL2K75FGsd3dzYd4hyqXiucJ8xQ2CVEf1g5EGuN4/2pV7FTl4oc8yvCHEPIo1mVp/pb11A+sAi61A6AbD34EmD/8wP5WS9w/py9Z7gvl3idboZLKEmUZLZeqHSdRqptoOpdpsS5M=
Received: from DB3PR08CA0008.eurprd08.prod.outlook.com (2603:10a6:8::21) by
 AS2PR08MB10374.eurprd08.prod.outlook.com (2603:10a6:20b:547::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 08:07:23 +0000
Received: from DB5PEPF00014B8F.eurprd02.prod.outlook.com
 (2603:10a6:8:0:cafe::9a) by DB3PR08CA0008.outlook.office365.com
 (2603:10a6:8::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.19 via Frontend Transport; Fri,
 15 Aug 2025 08:07:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8F.mail.protection.outlook.com (10.167.8.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.11
 via Frontend Transport; Fri, 15 Aug 2025 08:07:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6/jedL2M2eZ1W7SNo+a7+2ksFuwQcfzI7WWHgCG1SGhx+ALdzASBEhQkpCq08oJ3YoY/wdpbkQGDmHXhT46jlOdr9m5ZtQMdz6mYtQg0yklJJrKkvS+2gu97oTMSfOlQGVbpZ3bBk25CmkVfQM3qS/mqREwe0IAwa1sdESUjVTAs3bNvWr8cRTydl+i30vgZDzCzDjkWV0aqPdbbJkU5X4m6ICYHcYXt2nM2Yv/vWdXonILFy4hZdnwba49IkNVVfRfZxFeybrAvWbw9wqEk5zI9RuNDWGYMlVvuhy6P5j2eW/kHQvPFdMcrevIUCacMOVXX0DgO1kJG+5yVaW93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xaoMl/Smp3Dnv6i/e1UFNzlS+9QMXvPz3nluE3uu6dw=;
 b=rumsi+96u4KyVFHHVv1JdYiJIGGRDM50zRAarRSrFEhITib3qJrZkM+tkmLCDg24mtgZDlLyf9++SRF7R19rp6aqIxzV1tqReWypgCxU+nLI8UdH81Ki35I1VrOAGs7xVST0LinQ4jr0ZwU26VEq5v2/+KfISVpyZy3r11IrChZpihq7tiyIym6RWIPx5Jo0o64fUq43MVKYbnZ9v9TH7NKR/sa3EtorDKR07lq61Higqehc2/59hE0mGJknzl7th2Xl/MAzs9XC+O14I8550vo8hFg4I4Jm19cbSUbpAYavbQHmcew+wsIMItA4zh4A72yMaD3fBV4c3JEU8jHSnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaoMl/Smp3Dnv6i/e1UFNzlS+9QMXvPz3nluE3uu6dw=;
 b=haJsGhC2Bv7sZtHCiY5x2Go86Zns6EfSnv2IL2K75FGsd3dzYd4hyqXiucJ8xQ2CVEf1g5EGuN4/2pV7FTl4oc8yvCHEPIo1mVp/pb11A+sAi61A6AbD34EmD/8wP5WS9w/py9Z7gvl3idboZLKEmUZLZeqHSdRqptoOpdpsS5M=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV2PR08MB8294.eurprd08.prod.outlook.com
 (2603:10a6:150:be::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Fri, 15 Aug
 2025 08:06:45 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 08:06:45 +0000
Date: Fri, 15 Aug 2025 09:06:42 +0100
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
Subject: Re: [PATCH v2 2/2] kasan: apply store-only mode in kasan kunit
 testcases
Message-ID: <aJ7qkpVA+41HSA8j@e129823.arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-3-yeoreum.yun@arm.com>
 <CA+fCnZeT2J7W62Ydv0AuDLC13wO-VrH1Q_uqhkZbGLqc4Ktf5g@mail.gmail.com>
 <aJ3E7u5ENWTjC4ZM@e129823.arm.com>
 <CA+fCnZdFVxmSBO9WnhwcuwggqxAL-Z2JB4BONWNd0rkfUem1pQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fCnZdFVxmSBO9WnhwcuwggqxAL-Z2JB4BONWNd0rkfUem1pQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0657.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::6) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV2PR08MB8294:EE_|DB5PEPF00014B8F:EE_|AS2PR08MB10374:EE_
X-MS-Office365-Filtering-Correlation-Id: 154c35a3-c186-4f54-675c-08dddbd2c2e9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?gC85I1FuZQy8mPdQ4fx9Qrhj/Y75H0e6IiaObvKJ3VG/+yzODrJAf/8hziXG?=
 =?us-ascii?Q?Rqxf+wr/O+32RRQW7NNo018KLrRWBYWhXrbfa8ULBO/PRG9Pj2Ffe/js2pdB?=
 =?us-ascii?Q?1rdq60D6Dd8wGlQhoFe17WgtsckILvST2TnQH4eIY8R3zw3xCP1FTBq5akpl?=
 =?us-ascii?Q?+nBZegcNTox4zY/3LNTwhfIxtawn4EGP7eGnx9lJ0AkLzjvT45BzQVJWNH66?=
 =?us-ascii?Q?HNlToCkiCmg2Ch5rcJCHs88EqBbb23Oq8Ybz6RSJPDJYNG2bCGy049sR0AMN?=
 =?us-ascii?Q?Ux5XkRt+L6fkP2yCc3pfMguhRLWGiZGaS1VHDHFn1etkxcjuECbDnRQKAthL?=
 =?us-ascii?Q?c6QmFy0qh8eNncG+/w8D3Oav36MiFS/ML0dCwYSpjoLJhSGiEF2F9Dawp8Ee?=
 =?us-ascii?Q?XkFpp7iB2nkG09tqPunRmVODUpE/1fJiiffr8oJQsxqEIC6GCItIqFRKav00?=
 =?us-ascii?Q?4Pooge6o+J6bH14vQV1sVkKPvxhwven+m17SeLF8KsJZ21iT9RrumR2e4EF4?=
 =?us-ascii?Q?ukDAZDbb6ZvJQGu2ZPZYZ6OaLGsl87sVLe3YUJj2v/rFqLqRKE4dNBsMmq1o?=
 =?us-ascii?Q?O1zZs2lMDca7mcFV4rt7Bvqz0vXTeLXH20cskmwwaOxL6276DyuXFo9HboEL?=
 =?us-ascii?Q?NpIBbpuuEcR1LqSMZBe9485LgnXx21fm4sqoHzzHFUMqA1J2qeibl3nWhuJY?=
 =?us-ascii?Q?caIJAbI7OD8OyfV569AMedl/kdMceJS+SnOz5NxKFiIdUWyNmU723HKr+c1/?=
 =?us-ascii?Q?CG72IfbyGOweQ7svpcIUaclu2XFk7basvDA3zWSOpmOD+iUvONmpT9fTGx78?=
 =?us-ascii?Q?xk9Ruv+loawhvWPXGgiYBkw5GSXqMtCwsVHjQP9c80qARZ2t7pGKky1z9GT4?=
 =?us-ascii?Q?uS8766z/6F06MQQSE6qUWodSlos8p3n99Ac/qLDIzxPi6B+AHGU9aKjx0mWw?=
 =?us-ascii?Q?Rax2GJOWcO7aI+zRzNuViCP9DMtE+0PuHtAPZv6AgvfBSM1pKBClbmxzOcmh?=
 =?us-ascii?Q?WzfOdg6+fqt7dVfIaklQxhECGmPGYz8Jf3QuRtmBxAGeVCaan/mvEWxYb1we?=
 =?us-ascii?Q?N9NDNJo1PXUgQieeWDq+y1wpKkG7fl057OmXWbeIEVEu6YrahEz3HG2hG5hF?=
 =?us-ascii?Q?oYn7K7czgW+28o1IDiiFz/3C64hCxKKZPalxbzrMOtt4BexXGRI4UCqf42RQ?=
 =?us-ascii?Q?//PuNJZ2RzeEcpQCtzfJ6ISJ04Tx/waAHfWjFO7hxe29oBva/v4eSe//qY+d?=
 =?us-ascii?Q?+FzqLB9l0JYrnZ2FGasX4Nl0UokB4Fhjm5c7c0oA/aCvkrF0ELlw5VCzVyie?=
 =?us-ascii?Q?xJRmWZFOEouVKmErJ7UxX/V3XWsH9S0gZ/iEcWJkUttjpi9eLU311KN4D9Xf?=
 =?us-ascii?Q?GPb7QN0g7cqVhij8mpmWVIfr2OLQKH2BXeklxuk+xWZGMH/V8jMjaeBSEVTn?=
 =?us-ascii?Q?tOpfIEAYDSE=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8294
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a5a3df2d-44b7-41c3-113a-08dddbd2ad3d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|1800799024|7416014|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q8MnY2nWZO+gqIIDHi2wuBBlCIJg2qJf2jhu823zwiSJZ2EwsPJGQSsyHKZl?=
 =?us-ascii?Q?QlP6z18dnCv1+plainFo+937hLTjXCHcdPumyZRebG7yT6KtlKWXz0fpD91J?=
 =?us-ascii?Q?oVeb0r7F5LWN/+mUH7DoPY1q8IkQqD0qwi4X1VunValk78faUof4zcuo6eAI?=
 =?us-ascii?Q?9WcQcVkiwRuFMGxFB2TxuC+RSeXRzBdsTovszyRDQ6n/2nBt7XqwtJVuwZrT?=
 =?us-ascii?Q?Kbl/eto4P/PeJW/dCgYyVwVggxHNOWf17LAEi+xaq3VJxLg2/alR2VPN4MPi?=
 =?us-ascii?Q?D3qctLh8KTK+43zpTllXj3qpl6FUCs3XjlJiNSFHT+cHX/HuQo5WOYGFKLOL?=
 =?us-ascii?Q?bh2X9gDeSxLj/6oSBEq+4ytT1fgXs+m1COkvzCHMdedQ6UsIdAQFhSxeLBdF?=
 =?us-ascii?Q?JyFJ/I7byVesVUm5Fu0JJ+BepxWSszlGv1oBKcAEZbnpTAiiLsVEjAJ16ycD?=
 =?us-ascii?Q?FN8aPr7GiJQojlrpFFx13AsUFFnjeOoYJ2iGpd5f5Fxt12pf66rlPlCkUsDY?=
 =?us-ascii?Q?e10irGlIXG/6SqhacSqvUVs7K3Awvz8/J3cVYbLJog7aWBe29ywVtDY7gX8N?=
 =?us-ascii?Q?oiOZIxEA4tEhxILbIi/vE2YgXK0EaSird908YDx/GI7k1crSKBfRQp5A0JUQ?=
 =?us-ascii?Q?2ftihZVSG4uMDvRFfP06JPT7T+5Gy2qiLVoBaEh8v0UP77USYlFTK3fjO/ka?=
 =?us-ascii?Q?91HdgfAL2KQaejih5DG8JjFX2KeO6/dVMzIBcHi5f6z0VUC3jN7OGbLNwCHd?=
 =?us-ascii?Q?L/w8VIlZrIa1HE7GCFoA2s2gx+j6sA8QiZu8XJTSnfQ7i2pN+Xerck/Wy5p3?=
 =?us-ascii?Q?+zbcEVAp+ky8xzmkT+n7TGRsYWqREfqpmS5+arZ5h50DlUfm/RQ7gIwLWOY9?=
 =?us-ascii?Q?kra7PSoRAw/e0CTkQvF4h/UNrKh3RwvBEwuylk/waMtQ/87qq+n4VhzZHXo9?=
 =?us-ascii?Q?aB77T8HzZ9cAP+wfCdo1wyqqMJDwQKAu+uVD/ghsqrpxhrj83JiIyKZBOq27?=
 =?us-ascii?Q?vS0l3Cvf+wtbrRoZLzS2EmPKw+kx15bjdFd1+WDWZ5JfvEmUuBU9RvRktRsm?=
 =?us-ascii?Q?CILtJl9tOHjCxhw2he3zDklge0qBPDRj3rn6247bPgRu5rdqPBJV1VJfXeC1?=
 =?us-ascii?Q?/gcHgRBFWPYW5FA+HFVdbr1imZXMiaqxUSiKA5KDHuwP24EJRSrXEbFIuKoB?=
 =?us-ascii?Q?dfdAJWMaV10oBajyWCZ83AgXQZxYsDWusA/pUo/HnUNRMjTV02bdo1BCLCKe?=
 =?us-ascii?Q?JyM9IszRXURZCdz/6gh7KXfe1CMWIunBikT9OW7GWgwYo4h3I4HkxNVksJ1y?=
 =?us-ascii?Q?eqjJI/ClkT7CBMQBNr8xCHMnatcudYIRlN2nCJ/U97v6oAkxYf8OVIsN8Q0q?=
 =?us-ascii?Q?Di5zERlRnvAUyt3r2dw6eJbn4TtXcoJQ08lFyp8BWZbo66VHm2H6fdMWdGpO?=
 =?us-ascii?Q?3Y5fKSCh0pG/aQ+lJs68R3FrahMjY9D7aFLZ4P2Hdg+Q0dtZ+yrpmej6sbus?=
 =?us-ascii?Q?+Psp4PsHWFgEDZgcIxwkLtWAbKMx4eD0G2DQ?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(1800799024)(7416014)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 08:07:21.5083
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 154c35a3-c186-4f54-675c-08dddbd2c2e9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10374
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD335A000E
X-Stat-Signature: rcxq1r9bxo4jjnfo8g33icouy1drxqit
X-Rspam-User: 
X-HE-Tag: 1755245247-442268
X-HE-Meta: U2FsdGVkX190YCZsw+fyFfW69LWyNYuqned3l038FXF/eeZRg400hrVn/TuOeaNrheCzoPWWmnMw1SLWTCux/+Zrt7O20u71+9Wa6K/fhGAOmQmEmLXgUGLOnwsKjBiXf5uf93KNRU/7xD+Hc2BxeJDt0UN+vzQeqa18UDfLm/q1rdR4b6FtqxpY99AISGYIxFuwe2661Z1eyYgN0jbhByzu3Va62vCFWt4f3proORZfwNEdIt85FbxQAJGCuI+aHdwC7a13mtNgikDpGcQYk0tCy5vOM8yc10DZG3PwrHeX9rZYUhbnfszcg6bCeotx32gU9A2oMW9CGQl+kVw8uKAcycNAnM78gZf9gWsoF1oI6MyHQ5bz4OpkMreRyyKdESnqMXfaZi8/gimuQioQ9m8dyeBZDfGPH3hK8xLsyuKN4qJRP/zH8pb1rA4/9DPYzeXGLth+wm2UcAUX6EkpZx/MwrhfvOViN4JZ5HPRCy0iFgs/9C39xPh4A3/E6R+ZTZt+oIZeqv7bdmuRIuBI6C2+/cMeasL6BakRZ+FE+dmhjJPHopka+/Wcq5ggi6ci9EDV3OnlkSvF+0CVbGXlac4hl8vxSOit3kyaWb9+/fD47Xgubl6BpJSmfmDU9JOaLn7rL6hf5HHoIKKdwdA6II4avog4aeemXAJSr0FGKcEdLTUGJWdNtAAArN9B063A3orPFhJlWFdECWjB19iAVwlyzXuKev39BOlGArq8EfL3b7lt2UHGlZGx1grTy9ARkL7cbsR+3TB5fXvfCiYfAp9dmXxTkLBIH0EAiuiP2LtHxGjRzxEDx7WWXecZR5rDFMHbhHw680/9jHPBOJwaxhffV+WFtUkz6whVeoaya+a8s+Ti6iJ5hZvEPJbF1xDiKreS1+PJOJXaeXPKvdkMtUZ7/NcGYoxL2pCX9DunmmKplHjUBIjcDxQ+mEMU08ht8gnkdtfqzsJRMynohjm
 7U6Vn441
 Psn/kH6ZJ8DaYGPd8w78SYQHDR5sSqvbbYyhtNil1pAUqzgXK6+hqZCbvZVQWA5v13JhGWCvMtnCylzDV62rR/8Yrmv5roJowzHhd2gWWzqG14AcuOL7gL3V6syML+L9bcVslMol9V4y9s1kpRrt8RK6UsZJDnuZmGZ+ZicUOtcCKPMXaPEsuvaYSvyQQEd6/0hkhR0wt2EyB4/u+rwmydlhwGn5T79xqZHVC7Vw0ef++e/A+O9mHUjtYXU/FxzUeEX44wrmr5ieO0XegtH39biOrc/lBXlxUmA1vtRmrkiKMWGngtoPsjOECmA+lIGWMnHvVRCtIlg6RrFcjhLJ0tP7rvx+qlxME1TFHy4FLgKjcQCAl4Ln/L9fH6aX/N6+tFBCVldKI8B1XXuhk40uInRv/gOyAw325m05DjPLrLn4A/jKCwMbzEBsDYZzJ/MX4NP0GpLWTiuCFn+jrJfjTpn2qw1PQZWSacPv6BihxgzWCj6CStXXpR1HSApevt0YvDsq2JJLkkehvoxKEzxDf9dIedGYl7kuOMEkhOLEb7L9pKGhHfqTW8nFfraDB2aa0obzFJ6JU9InKaaBEkNunNZ01o+YeANlXYBaRmvmr0uRejP0fY/vKZrw80w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,

> > > > +/*
> > > > + * KUNIT_EXPECT_KASAN_SUCCESS - check that the executed expression doesn't
> > > > + * produces a KASAN report; causes a KUnit test failure otherwise.
> > >
> > > Should be no need for this, the existing functionality already checks
> > > that there are no reports outside of KUNIT_EXPECT_KASAN_FAIL().
> >
> > This is function's purpose is to print failure situtations:
> >   - KASAN should reports but no report is found.
> >   - KASAN shouldn't report but there report is found.
> >
> > To print the second error, the "TEMPLATE" macro is added.
> > not just checking the no report but to check whether report was
> > generated as expected.
>
> There's no need to an explicit wrapper for detecting the second case.
> If there's a KASAN report printed outside of
> KUNIT_EXPECT_KASAN_FAIL(), either the next KUNIT_EXPECT_KASAN_FAIL()
> or kasan_test_exit() will detect this.

Sorry for bothering you, But I'm not sure whether
I understood your suggetion but that's sound of implentation like:

+#ifdef CONFIG_KASAN_HW_TAGS
+#define KUNIT_EXPECT_KASAN_FAIL_READ(test, expression) do {            \
+       if (!kasan_enabled_store_only()) {                              \
+               KUNIT_EXPECT_KASAN_FAIL(test, expression);              \
+               goto ____skip;                                          \
+       }                                                               \
+       if (kasan_sync_fault_possible())                                \
+               migrate_disable();                                      \
+       KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));  \
+       barrier();                                                      \
+       expression;                                                     \
+       barrier();                                                      \
+       if (kasan_sync_fault_possible())                                \
+               migrate_enable();                                       \
+___skip:                                                               \
+} while (0)
+#else
+#define KUNIT_EXPECT_KASAN_FAIL_READ(test, expression) \
+       KUNIT_EXPECT_KASAN_FAIL(test, expression)
+#endif

and you expect the "Error print" on the next KUNIT_EXPECT_KASAN_FAIL's
  KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));
or kasan_test_exit().

this maybe work, but it wouldn't print the proper "expression" and
seems like reporting the problem in another place from it happens
(at least source line printing is different from
where it happens -- KUNIT_EXPECT_KASAN_FAIL_READ() and
where it reports -- KUNIT_EXPECT_FALSE()).

Also, some of test case using atomic, kasan_enabled_store_only() can
use for KUNIT_EXPECT_KASAN_FAIL()
i.e) atomic_set() which allocated with the sizeof 42 (writing on
redzone).

That's why I think it would be better to use like with
sustaining _KUNIT_EXPECT_KASAN_TEMPLATE:

+/*
+ * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
+ * KASAN report; causes a KUnit test failure otherwise.
+ *
+ * @test: Currently executing KUnit test.
+ * @expr: Expression produce a KASAN report.
+ */
+#define KUNIT_EXPECT_KASAN_FAIL(test, expr)                    \
+       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr, true)
+
+/*
+ * KUNIT_EXPECT_KASAN_FAIL_READ - check that the executed expression produces
+ * a KASAN report for read access.
+ * It causes a KUnit test failure. if KASAN report isn't produced for read access.
+ * For write access, it cause a KUnit test failure if a KASAN report is produced
+ *
+ * @test: Currently executing KUnit test.
+ * @expr: Expression doesn't produce a KASAN report.
+ */
+#define KUNIT_EXPECT_KASAN_FAIL_READ(test, expr)                       \
+       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr,                 \
+                       !kasan_store_only_enabled())                    \

Am I misunderstading?

Thanks.

--
Sincerely,
Yeoreum Yun


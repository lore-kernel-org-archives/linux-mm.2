Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B062CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E396B00C4; Mon, 18 Aug 2025 09:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4368E0006; Mon, 18 Aug 2025 09:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538666B00C7; Mon, 18 Aug 2025 09:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1BE6B00C4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:54:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E07265BC7F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:54:53 +0000 (UTC)
X-FDA: 83790024066.07.0967FF0
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010027.outbound.protection.outlook.com [52.101.84.27])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1147340008
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:54:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=eM0th1Je;
	dkim=pass header.d=arm.com header.s=selector1 header.b=eM0th1Je;
	spf=pass (imf27.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.84.27 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755525290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ps4Wxe6/gl/mNTxvkIqWiqZO66jtFZOy6oLUAb2eNLM=;
	b=5BtJA+koB59iET+vkxkKcnDShB/6PAhxdjd/Fju8Sj4lwcqXwfRHMM8BlEqtQ+LxGgTKkd
	5LMSbtmPIZv41prR6wLMu8732S82ns1vpoevzQsirKkFlrlvnSDzpYOu5ehhxmobo2WHi+
	YiWjtHwUZ3LtnNWRMyD2sZPpbm99OIU=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755525290; a=rsa-sha256;
	cv=pass;
	b=jd8QQnn6EhWaedZ+NYnvWAhVhm7q6EWiJT4Jmf/U4rHToWYtqCh8TrjBNS6byp7Ya1+jJK
	/hbqnaCCX7Au7E4mjL2SwUxEDhtdNc+lOrVvfayfAfyam01URH0X7cms55CykkQkVdGrbp
	wgXDmio25aWRHgl9RB4WOHtPLhDR0d4=
ARC-Authentication-Results: i=3;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=eM0th1Je;
	dkim=pass header.d=arm.com header.s=selector1 header.b=eM0th1Je;
	spf=pass (imf27.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.84.27 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=k0OVZxlBI/JkMaRv9pZ8mPe7XBqUpKIDosLmXirAxtBrHYb+ly4SNCVl37nN+cYjcqnMcjGY6pjjbi5cXuq5caG5jFIN+0jI+riRtOto11FXEy5MhExuH/nl4CFyrJXQj7cu/1D7fdksc2oBFz0SlZnes2AxjlNAOv1vLbS4goYjv6psa9RWywKJNfZLB2JwRGRJEttyw8yZBLgDG8RDDp3hZqqrx7gl2zZIMuLw/j5y8JLo86o9SY8LAZay6LPmNhN/cXJ6LoJaB/uqFah983+FFv7YxaHJGovdeBzrm5+GTtMAPcNM0SF+lR/LBJnjupNZY9vIP53Z8lHWhXMEhg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ps4Wxe6/gl/mNTxvkIqWiqZO66jtFZOy6oLUAb2eNLM=;
 b=xZ0XcijDtcyIJUtdqg6F9QqwGDH5ljRcGXpHkvFRXIwslaegpT5lnHEVLj51lN4dxWFS/CXT+GdsTWXWFK+l1YyjLAByxuhXZ7tJ6S6LRtXxf/YMsJSQ5KKAx3XES2v7IxuFclDYkx0NxI52VyGjjo013XG2aGJsdG+4CtxDIg4S8ppOu1NxNlcFhlJJaBUC2NVDx+QdFOp1cBVoMTrI6ZpQXihXCtZuT2xwq41MjVqnpRxslWy9fCAy9xMDm2WZT5xw0EycNHk/V/Pps51DmlRkn04mo1cpEtscwzv+9hgmPzdqX5aQ3n7owjUmEXM9zmza+s2I7FSOk4OAGDaljA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps4Wxe6/gl/mNTxvkIqWiqZO66jtFZOy6oLUAb2eNLM=;
 b=eM0th1JeBLv8tEcIdogZmuxucA1NTSAKrBFjwZLGkzavOpPnfPtSEoI25KZ+V6d5qkjzSoC07LTnTy6UGyZv8Y2Q+5h43agaFBQOCoZSLY5sPeYYctwEK80UPPnW7hnxfzCEQUC+JQ0pSZ7KjH7CqPDyTa6OcCm3f7meiLkyqpE=
Received: from DU7P191CA0009.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::13)
 by DU0PR08MB7811.eurprd08.prod.outlook.com (2603:10a6:10:3b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Mon, 18 Aug
 2025 13:54:45 +0000
Received: from DU6PEPF0000B61B.eurprd02.prod.outlook.com
 (2603:10a6:10:54e:cafe::7f) by DU7P191CA0009.outlook.office365.com
 (2603:10a6:10:54e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Mon,
 18 Aug 2025 13:54:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61B.mail.protection.outlook.com (10.167.8.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Mon, 18 Aug 2025 13:54:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jluNFGYfxiELBAbCKqflR3HL/FoIs79njYw6ti59KznDYMnXVzqJJ3QFa0UYElz0r1ZnXtj8xYWhXy064eOLDZ8JaCQLbiuqNzlnIt8WGlkuG0c3RipB1FfXE2fqUDLrbHN1PniGP1Baa5xyUs11n7dWxzDer3PJ97as0DSNROsFyW5rzNEUnMy7rKboiSUEJpwq67VVkbTfdOME7aH3mjB92gHiO7W0ANlAi76IIXAXD0v5GfFeGrvRmVBIRyy0m3PAGIZp3U9Llfq5g4pCK0EfJFi6XBfsN4uhYH96j9zpIaF+4E7lxpHzoCTwZVOD87lxF8D5z1wh1lKBIQkzZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ps4Wxe6/gl/mNTxvkIqWiqZO66jtFZOy6oLUAb2eNLM=;
 b=Xn5/jZat46LIfNzpS1hxU6u9tbjA6QwkxHeHKGwk76oB9TMPInBL5UgFqlCP8Mbp5jftRHJkJBpjSw4CHWqKoaUXaqtutw4S9tuB30+USQJ+gA6XNzLpOy2HRfH+pcBdTqeZdUOHd/yp3mXrF5BDjEb40scmMDMIOn9SfFRmkKY5j7ZdRtLDhFRopeAQ+i4LGxvwn87tWCZ55CFnMcvVMQ+4wFmDp70IAnCx5VvQzYyvG/vadauTMqlVHR963sUtYgho7XFnkFvzFN0ygT6IF4VXEwLQlVxHkfaNMMzoWo3V7tg1RrZYFX7F2ypn7FPQyh7sgmgKKWSPB7cUTR4GXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps4Wxe6/gl/mNTxvkIqWiqZO66jtFZOy6oLUAb2eNLM=;
 b=eM0th1JeBLv8tEcIdogZmuxucA1NTSAKrBFjwZLGkzavOpPnfPtSEoI25KZ+V6d5qkjzSoC07LTnTy6UGyZv8Y2Q+5h43agaFBQOCoZSLY5sPeYYctwEK80UPPnW7hnxfzCEQUC+JQ0pSZ7KjH7CqPDyTa6OcCm3f7meiLkyqpE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB10977.eurprd08.prod.outlook.com
 (2603:10a6:150:1f5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 13:54:08 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 13:54:08 +0000
Date: Mon, 18 Aug 2025 14:54:05 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
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
Message-ID: <aKMwffDAbL76wwUx@e129823.arm.com>
References: <20250818075051.996764-1-yeoreum.yun@arm.com>
 <20250818075051.996764-2-yeoreum.yun@arm.com>
 <2736fe09-ef37-408c-ba53-a8e492dcc3e8@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2736fe09-ef37-408c-ba53-a8e492dcc3e8@arm.com>
X-ClientProxiedBy: LO4P123CA0116.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB10977:EE_|DU6PEPF0000B61B:EE_|DU0PR08MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: cb7ccfe1-9945-4172-e61f-08ddde5ec913
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?7EOXn2ii+1tDYkieu+meS6MpGi++A8vJ+t5imAasOd3BBsRtAp5W1QAPdEuZ?=
 =?us-ascii?Q?faKd9j/i2RDSvLGewuY5fbvMpWlDILMd3fMaGyyYt/8tBc7whoAKaDULcGwU?=
 =?us-ascii?Q?UF4hLGlZhRk56MWw+AupdrEfksaakL7T0nPsvpkRMmXc1zKlOtjMnjkblkoM?=
 =?us-ascii?Q?v3+lDxTStkzTMpeFms71JYiHKOMEVv5R8RSDh0bBK9xqSNrFi/p2MfbimDLr?=
 =?us-ascii?Q?HGgJdXyObH6E35uBPPCLaEFpOOsuuc9dPZQ1KOT/rhdX7fMurIbqpbLMbL6m?=
 =?us-ascii?Q?vJBtqjpbkcj+ILZg2aLrmg3HQCVf2CD7wkXL8rNRWlE1KQUlsw1EKbv6Oyvv?=
 =?us-ascii?Q?BqLYFuEn/eUqh4/sIwh08hLsVKIJ5Ag2ySKpJRcv5PLpU+QnDRpkUoauj3Rr?=
 =?us-ascii?Q?yW0lEYQvRehnf42McqSuBq5g2NSqUgWtt9sgO/OQ/JBW+eMLhWTqMUTFesQo?=
 =?us-ascii?Q?so/m1aX26vYrzu3kQ5rESNvB2s3GDmg83Na2fIa8cBfb2k/JN9ZKdcAumBPF?=
 =?us-ascii?Q?MVMqqxD3+3gviPrZ75rUBTkIdOI6bf/Q+EgkZbLro1BjgYXrf5vwBTDFWYac?=
 =?us-ascii?Q?iQNxTX6lt3d3egHMgyEOKlabY/TezM3kBytKE1W3JtTaSraOcSp483xJmP2E?=
 =?us-ascii?Q?eRn0Rs0RT+CkBrhqHYLYywXfHJRaPiyD32Es4SMTIBD4dagVEeLPgUzy2LCb?=
 =?us-ascii?Q?xA0+FDi5iTdFaTeOMHAMjG/WxecZYcVhUa/T58289OQK4amMZ5Gh0tqT0L55?=
 =?us-ascii?Q?cMZGuWI3QGWjo7LQUa5osndD2eVV8n2uQkiLuIfEn0MXzWYIVE08e55mp5tG?=
 =?us-ascii?Q?oLbBycpz+oF0mBQfG5hJfad9Uvum6eXm/PxG60doiTD3lnssjFnrmSJxYEBL?=
 =?us-ascii?Q?LSU+FPnniTKGoT6Hu6ZnfHLDcZwJbPfXOtdNQj/F4ZRrrM6PuMPJXjdjii5B?=
 =?us-ascii?Q?KSFe1rAIl6+2m8zgwikClhswpns+8a3ymK51ISDNF0oJmGI4vJuvkAYHZ7pn?=
 =?us-ascii?Q?i0D48RriH9lVQ+h+sF/W+k+UjlUCrrNWkUG39xkL1YO7CReoxC+X2mZ+JvAo?=
 =?us-ascii?Q?1hMRWOv+Zdo0diVeT/qVkq534+TOGx7NtZeD5R29Ck6mbWvcCohYUQ0CTN03?=
 =?us-ascii?Q?ybu47elruEQDRVAeXRGUlRNEacC5pGNLbVewKA4UJ31lp9pGGrwjvGT2kbsL?=
 =?us-ascii?Q?0O04YVSaMN7pWEHmEyLMEoHB9jBApwqyVxyHsLVBpVp/vPyg4I2/hDuOrN9j?=
 =?us-ascii?Q?TJU/6Ke1qbgZV9j7dgoTB9YjsHuIWEixeJnaf1GVbCGxQLzjCikhZA3RJttD?=
 =?us-ascii?Q?V6m51o3MmOjxSnBIj4DARMzT8kgYCsE5C0eXeDK7ZTrPFEoLuSA6iH+3mc71?=
 =?us-ascii?Q?9vsok/xwR6Aoxlz2YOrdER/dXKUQfM5+yYF09F4RMd8zK+U60umq3uNIP/WH?=
 =?us-ascii?Q?kFHBqwe9oUE=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10977
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	76821c06-6816-4a63-3066-08ddde5eb3dd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|36860700013|7416014|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B6GFFhXl26hB0aGFJM1P5E+IbdDHFpGxrPefSjVyDU2CFB/P0CRTWiE25t0y?=
 =?us-ascii?Q?xbr3lDHIQ/TUSXEmUkpAUD/dk8OQIpIPFa21Vd7HB7wfdo6rl5uOQnNFfoBT?=
 =?us-ascii?Q?QPELNPYI1kqS7TN4hU7B8KDgPPTSP/hxfYXSL1+Kre7EiM5GC3QGFdLQHsU1?=
 =?us-ascii?Q?WiEMOeIVBYd3W/P+SxzKaKmBe2UURON5EnKZ6ZFLkEFwZvwE04noafTDYilE?=
 =?us-ascii?Q?oVua5ylCthaW6dmPRM6Ye53aMgoKPlvuW2ez5ZsPjKpf+IDymx5L8LgrhQxh?=
 =?us-ascii?Q?cIxFvAYgNsl3yQIg1WGNcPw+ojJBulPinftqzYBhSvJBNxlIx7jkekXxGZwH?=
 =?us-ascii?Q?jCslB9/RdJQv3VAJbx18s+enZL7V6RHgFzmK6y6m9qqIyi35JrJETyoIYc4I?=
 =?us-ascii?Q?m+VrjTd2hHS10MebbsfaQfn1Mrkrm2hIUkfsqhlvA6qfjlK8Wdo3VX4eFM25?=
 =?us-ascii?Q?8JA9kVzXvXpJpew6dF75xupTAR3yOEe9aaPDl+X6MofOae92ZcJqrbZfIBQz?=
 =?us-ascii?Q?iIvTXJC9G7seuRQB4g1JsgPMtlsX00S0jMp3qtuQJ3K9JFRJiDMnnn0QVjrK?=
 =?us-ascii?Q?rbt/KD/BKA6z7UL5Zb3i43VgR04yobTLzPvzeRdFWhj8gyo9Ieto4+sVIeSY?=
 =?us-ascii?Q?HKuINVPNzyf9zc8IHrSW4/Fn4QWBPqEu0Y7Qm9xJH6mx3X45Kv+JxvA3+snN?=
 =?us-ascii?Q?wsXXJoPOLqNE4edhZX9+ecjOIZSuA9myOfQ5Gb/ykdQlSLZF6LNHit2QATKL?=
 =?us-ascii?Q?IjTPumB2sywvSBBfpYVT/gPSfktjcw+DHQuStidBx9G2+PZ5e1cNEKRW/6Ro?=
 =?us-ascii?Q?5bwLzL7rHbeVlM4MYlVd+DCsqdE6ToypE/HzjONp/8u7Ud46SKZsfw/HI4Tl?=
 =?us-ascii?Q?oCWuP59gOKo4qRcOXV0Vs4RxYGTSRFKU9hRBAkP1LF+edLDp6dLXI+TLiSF1?=
 =?us-ascii?Q?Z0im7BlKfJrGknMAiNTLxkR8kmp8b7zyzi1ow28YZoN303aJpHLDa5vNR8qs?=
 =?us-ascii?Q?Xb7grYIHMbAz6fVXIXf7BrrpxTa20EJNE43HTGLVkNgButWh/ihrMkyBrlEg?=
 =?us-ascii?Q?iVzahSoWqnRGrxUYmSBKvhvPAP2c8Re7mgetXyKszErq3KoLStwWveV3o9Ce?=
 =?us-ascii?Q?ACwXmdKN5xt9wAEy+HKzvSC5SU9F4emUR3KOpJLeAyc4WeBMwsdSLTsGeA/n?=
 =?us-ascii?Q?MCjfoOAgjqBaB5rYppi7BX1jDns40kK2aLRS5SyqLjaF5BQazYQUHdsMOS/4?=
 =?us-ascii?Q?xEi+Kv4HiyUCv1VBoyw+e95jvYGby5lO0zEmGo8kWUfJ1vDGEMjBtk+OHarp?=
 =?us-ascii?Q?dyN6c5WWLV5BNNJ3mghSqbJ3cLiXDwEDpuxekDKMtDYlADq9tpemYqCfoIgD?=
 =?us-ascii?Q?CI6tuB/JuA4ibTr+JEO1mf1dYWQOU1rq0yqk1t1fEpwipoRrm+6XKV61X3C+?=
 =?us-ascii?Q?n7ZZ+SmnEe8QJGTXqvYgMNe+H4Er4g0KrAeaDAOkl+wV0WcfjS6DESTTPlR5?=
 =?us-ascii?Q?XlNRB5xF8N9wmvmC6caMN0FSwTHGJCd8eg55?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(36860700013)(7416014)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 13:54:43.7225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7ccfe1-9945-4172-e61f-08ddde5ec913
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7811
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1147340008
X-Stat-Signature: 3azadzcnx7dd5xgmhzfur7fghrp7y57w
X-HE-Tag: 1755525289-565931
X-HE-Meta: U2FsdGVkX18E/SWr/5BdsYtaV0zFV5DP8XJGO/SSsjA+4s1XpSmwwVEiJLEmupWuJyCCDDu0/xGRpgF9A0+qgjgLMYm+drQISdyuyG+5U3+3wqRGHD85MtGOdYUIS1Z1dSOtcDnm9JELS1fYVk6ShbgtDGK+Zxbon5m2ALw5UCoZpmlWT79/Gebpy0Y6EqeMQsMBwMg5rKT9XjRGn2mtIKcpPCQ3xcDnaaj6NV8TBi62o6VIBEv4s2zcO3T202m5Uvu+xNEfiBMHDHhPFsKpDAxmTigxcw+rOPHYLUTRLG5l/ccF2BvW1MVA+iYsRdCaTMEzrx7EaillM0qps6Rb/R06BK7PaU7FlPN48qs7iibnYeN0KrjHQE4yiqqiYm6oOQfxquOQUxnSgW1GDlxJp7NWCSckGpcWmgfGRhpIXQhvCYSUCvqPhBA1KfUwTehT6rv4lNCMpEZM9x28qyzqKpQ/ny+JjVxHpX5EiDs1JFj6qRxrMZN/sYBqpTUeOUrSyBqRYFAOh1rbCeQIwBQMjTLQash+34C5OyH2mxHzDMdIp3LNJKWObezQFGxA9MJZnbU7mxQLOIQ/GA2uu3Ddlc8UaTCmw3dGyLGCaF4+EVjQLAt4LeOiL66S0/AqRn0dIk7LmjJfqTGQS+Afoqv2dAdP9QfTFGb9P6JBrlXc1U1r8R8i7Cv8fVJxLjb0LzSLCdS0q8PcL+FKjhe/t2ItSMwDmeVdxPSt/+lpaS0vUbL83JUg/qennuV9ypzk2zNZnEN7oK0P8wA07PPFFizoiiY/sG5opNTxihbYinocLzHpRm2VIWfQgpY2MGffu6e3117f+fFPZkx7FHBu3P56hs0/wPpxAL1hLr6HL3s6jeddJWjBvH9oh1fN9dGTYqGH7dyKNzSdGLF4DCXknZo096OXz3KVvRCvaEx9ER3tv8R6hhR0zG5yF4TA9Wo4SGtqVEH1fg7kgZHdvWzzbzM
 V5+3SXw8
 lVSMV/uiV1Fb7hDlfcJVCQ7DEPtZIxwbQetBK/NXBYQshcsk8TzCU2q3zK01vVhP93v3ma1qgGOUy6Vbwe1lWHSwsgRSwViu/FI8EqMPWsdy3TP8BBEeBUnpk1xTvyKSGGIWSoNTT+sTyyOM82bZv97QTliBMOB7c/OJ/DjWwbRbNMOZmEByDvzw3zbTHpHYepKoGy2nKkVQlFHVZ3o4misP8jKnm/RBg0CaO8mXpxrM5xcU6oMhIazOhY2lbe/rUaQWg1kgA9yREjoRLkPDjG169kkKMHSPUE7v8y1DV6yXcs/M+4wqlwN2NbCmeRQ/Bf1UUGLwt4zLaz7tU5ZpehL/jnzUoHlXwZA+s+cm0OVEsEPqwYhYGAxrPtVTYT3D2rJ1kqgCoI+n62r0w5HWdvYooUWGLAfCzA6AUqKS2uohjHV8hNdp9kL6H5QjeRsa9MiTEuVNKteoMtUg8CCetpply7wMluI66OxKsoAp5dSfTfJnLRagWxj5qDFFgfnBeOj7vlB8K11twYZReq6pdfaG+YQ3RDVincHUDgr/tiY2Net8HQNotIEeAGBvvI1gizzkXC63zJ6Yrsj1sx2SDWeHeg2prParcFPMKAGa32CF+hXXQSF0kUksVqytPevQ8/7tPN6pJ6yMnIjJWd+nQArnbjME2RwZ54Fge
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ben,

[..]

> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -2920,7 +2920,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
> >   	{
> >   		.desc = "Store Only MTE Tag Check",
> >   		.capability = ARM64_MTE_STORE_ONLY,
> > -		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > +		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
> >   		.matches = has_cpuid_feature,
> >   		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
> >   	},
> > diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> > index e5e773844889..cd5452eb7486 100644
> > --- a/arch/arm64/kernel/mte.c
> > +++ b/arch/arm64/kernel/mte.c
> > @@ -157,6 +157,24 @@ void mte_enable_kernel_asymm(void)
> >   		mte_enable_kernel_sync();
> >   	}
> >   }
> > +
> > +int mte_enable_kernel_store_only(void)
> > +{
> > +	/*
> > +	 * If the CPU does not support MTE store only,
> > +	 * the kernel checks all operations.
> > +	 */
> > +	if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
> > +		return -EINVAL;

> Would it be better to make this function return void

This is the same point Catalin points out from patch v2.
But for usage of kunit test, it need to keep return as int.

> and add a static key in
> the manner of mte_async_or_asymm_mode, perhaps mte_store_only_mode? This
> information could then be used to help determine whether it is required to
> enable and disable tco in __get_kernel_nofault() and
> load_unaligned_zeropad().

Yes. Since the mte_store_only enabled, it doesn't need to enable tco
since load/fetch doesn't increase the TSFR.
However This sounds like an over optimisation.
I think it would be enough to check when mte_async_or_asymm_mode()
otherwise in for __get_kernel_nofault() or load_unaligned_zeropad(),
it should use like:
  - __mte_enable_tco_async_and_store_only()
  or
  - __mte_enable_tco_async(op) // whether op is load or store (boolean or enum)

But this seems ugly too.

So I think it woule be better to remain as it is --
without static_key for store only since there is no usage.

>
> > +
> > +	sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
> > +			 SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
> > +	isb();
> > +
> > +	pr_info_once("MTE: enabled stonly mode at EL1\n");
> nit: stonly can be expanded to store only

Thanks. I'll change it.


> > +
> > +	return 0;
> > +}
> >   #endif
> >   #ifdef CONFIG_KASAN_HW_TAGS
> > diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> > index 9a6927394b54..df67b48739b4 100644
> > --- a/mm/kasan/hw_tags.c
> > +++ b/mm/kasan/hw_tags.c
> > @@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
> >   	KASAN_ARG_VMALLOC_ON,
> >   };
> > +enum kasan_arg_write_only {
> > +	KASAN_ARG_WRITE_ONLY_DEFAULT,
> > +	KASAN_ARG_WRITE_ONLY_OFF,
> > +	KASAN_ARG_WRITE_ONLY_ON,
> > +};
> > +
> >   static enum kasan_arg kasan_arg __ro_after_init;
> >   static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
> >   static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> > +static enum kasan_arg_write_only kasan_arg_write_only __ro_after_init;
> >   /*
> >    * Whether KASAN is enabled at all.
> > @@ -67,6 +74,8 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
> >   #endif
> >   EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
> > +static bool kasan_flag_write_only;
> > +
> >   #define PAGE_ALLOC_SAMPLE_DEFAULT	1
> >   #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
> > @@ -141,6 +150,23 @@ static int __init early_kasan_flag_vmalloc(char *arg)
> >   }
> >   early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
> > +/* kasan.write_only=off/on */
> > +static int __init early_kasan_flag_write_only(char *arg)
> > +{
> > +	if (!arg)
> > +		return -EINVAL;
> > +
> > +	if (!strcmp(arg, "off"))
> > +		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_OFF;
> > +	else if (!strcmp(arg, "on"))
> > +		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_ON;
> > +	else
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +early_param("kasan.write_only", early_kasan_flag_write_only);
> > +
> >   static inline const char *kasan_mode_info(void)
> >   {
> >   	if (kasan_mode == KASAN_MODE_ASYNC)
> > @@ -257,15 +283,26 @@ void __init kasan_init_hw_tags(void)
> >   		break;
> >   	}
> > +	switch (kasan_arg_write_only) {
> > +	case KASAN_ARG_WRITE_ONLY_DEFAULT:
> > +	case KASAN_ARG_WRITE_ONLY_OFF:
> > +		kasan_flag_write_only = false;
> > +		break;
> > +	case KASAN_ARG_WRITE_ONLY_ON:
> > +		kasan_flag_write_only = true;
> > +		break;
> > +	}
> > +
> >   	kasan_init_tags();
> >   	/* KASAN is now initialized, enable it. */
> >   	static_branch_enable(&kasan_flag_enabled);
> > -	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
> > +	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s, write_only=%s\n",
> >   		kasan_mode_info(),
> >   		str_on_off(kasan_vmalloc_enabled()),
> > -		str_on_off(kasan_stack_collection_enabled()));
> > +		str_on_off(kasan_stack_collection_enabled()),
> > +		str_on_off(kasan_arg_write_only));
> >   }
> >   #ifdef CONFIG_KASAN_VMALLOC
> > @@ -392,6 +429,13 @@ void kasan_enable_hw_tags(void)
> >   		hw_enable_tag_checks_asymm();
> >   	else
> >   		hw_enable_tag_checks_sync();
> > +
> > +	if (kasan_arg_write_only == KASAN_ARG_WRITE_ONLY_ON &&
> > +	    hw_enable_tag_checks_write_only()) {
> > +		kasan_arg_write_only == KASAN_ARG_WRITE_ONLY_OFF;
> > +		kasan_flag_write_only = false;
> > +		pr_warn_once("System doesn't support write-only option. Disable it\n");
> > +	}
> >   }
> >   #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
> > @@ -404,4 +448,10 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
> >   }
> >   EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
> > +VISIBLE_IF_KUNIT bool kasan_write_only_enabled(void)
> > +{
> > +	return kasan_flag_write_only;
> > +}
> > +EXPORT_SYMBOL_IF_KUNIT(kasan_write_only_enabled);
> > +
> >   #endif
> > diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> > index 129178be5e64..c1490136c96b 100644
> > --- a/mm/kasan/kasan.h
> > +++ b/mm/kasan/kasan.h
> > @@ -428,6 +428,7 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
> >   #define hw_enable_tag_checks_sync()		arch_enable_tag_checks_sync()
> >   #define hw_enable_tag_checks_async()		arch_enable_tag_checks_async()
> >   #define hw_enable_tag_checks_asymm()		arch_enable_tag_checks_asymm()
> > +#define hw_enable_tag_checks_write_only()	arch_enable_tag_checks_write_only()
> >   #define hw_suppress_tag_checks_start()		arch_suppress_tag_checks_start()
> >   #define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
> >   #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
> > @@ -437,11 +438,17 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
> >   			arch_set_mem_tag_range((addr), (size), (tag), (init))
> >   void kasan_enable_hw_tags(void);
> > +bool kasan_write_only_enabled(void);
> >   #else /* CONFIG_KASAN_HW_TAGS */
> >   static inline void kasan_enable_hw_tags(void) { }
> > +static inline bool kasan_write_only_enabled(void)
> > +{
> > +	return false;
> > +}
> > +
> >   #endif /* CONFIG_KASAN_HW_TAGS */
> >   #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
>
> Thanks,
>
> Ben
>

--
Sincerely,
Yeoreum Yun


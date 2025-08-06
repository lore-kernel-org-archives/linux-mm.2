Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BD2C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF416B0092; Wed,  6 Aug 2025 06:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86B88E0001; Wed,  6 Aug 2025 06:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27DA6B0095; Wed,  6 Aug 2025 06:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9D98E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:05:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDA5B81701
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:05:00 +0000 (UTC)
X-FDA: 83745899160.06.AFB258B
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011052.outbound.protection.outlook.com [40.107.130.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 544401C000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:04:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Z6BesTV9;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Z6BesTV9;
	spf=pass (imf21.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.130.52 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754474697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejiDJ0YP1aSNH3jL1aB+z0tSOPdBcFt0zIi9QNeeaUg=;
	b=nCu2HWuqr51trSYZKVzC9fRwZK4iLImf1ItQKuFYdQxI+NwN/U4Fjy/ZCVLgWnQaagDKVu
	fGAatC6reT09NInluVavKzs0pIUv2hKQHKi14MRE822QNiCrFnZIow3svGy5LqCo5f8pbJ
	bHtrbJjk7GHN68bzI0xT98N1lagRq20=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Z6BesTV9;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Z6BesTV9;
	spf=pass (imf21.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.130.52 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754474697; a=rsa-sha256;
	cv=pass;
	b=FlQLGZVoLik+UC9KqPniVGx+HdcNRbbei3qYWFvJqkMKbMzG6dNZt5egx4QoZhRx9k2EuT
	9igoNalWu0kdjrV6fp38TltEP7m+PqRrSvG+dlsQLxlhGC0DRJKpJPiwZbdQVFz6kkyqmW
	A2PFefrvQWaMY7OBj3Co9RPlXkNVLaY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=No+oENbRgtdPfCSBbqzdt3MIAcxLaf07XYcDEfdIM2pJwFmdn15EYkciX8IlTAsdJuLPomnPsDL7TugBae3jaWiKTMh6lb7h1Dy+G2B64Advdb7GloOTNLis0kU92at0TGSRrWGi9WQbl0e8/WpGWPw3NL+CtYbpBw8HMydehA7lr8tZBZJPfz+B6zZaWpjLMrbvFp520QbvNRTEjsoJrNCCa9q4NaRpnYq0PbXR10aqNYHkHBKPG4TFpoha5gZjuXSXUQUw4evsPvaTCZqRGactyZf/EM9G216FEbsv0QtQvrok4dQq6xBlzJ+7ezdJJ89QVWZBFTh3PcvtSJgDOg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejiDJ0YP1aSNH3jL1aB+z0tSOPdBcFt0zIi9QNeeaUg=;
 b=IUChoYxVmUkqIxDQPWX4QVTHV8BtCJeG8lR6ESgrOcr/6CWAbAcCZiksA6n5QQ7Az8dNlX7/f5l+ik5Bwk02U2gcygiTq13wfMIgdFEksTjKZv2li8DWuAROnEClP9vctMWqMoHopZznAESWmuBIj9oEN50hhiUJZLRWW0GRgWatZqUC7yjSm1SEtdK6d17t4d2T3q2dZvvbnGxGMbgSAenokWJw7JTm9+4z1G3yGCX/aOqusIGQqo/xr1FlacrDJfw+v2DbPYsL5s3DEOS4c4w+1fy9oIR9BQy82QoqgafOPIv4f2Xa/fAhxt85XwuDu0bri1BIgoBRWc/aWARqzA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejiDJ0YP1aSNH3jL1aB+z0tSOPdBcFt0zIi9QNeeaUg=;
 b=Z6BesTV9M54TI48kWx4c9DHOF0bOSTpE5EPKmTbij5yvSb2PxfA4oQIBvs2HZdDZ6p+J5uVOQEPp9s38elvu8OnUed+Fw7QfLLyi5bgxjtAhZ0dXtpVuNTJRXT7ltthsvV3AxajPqoKKzeFG8s9mDl5NbUskCMBWwtco/cQk+v8=
Received: from AS4P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::16)
 by PAWPR08MB9590.eurprd08.prod.outlook.com (2603:10a6:102:2e8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 10:04:50 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::48) by AS4P189CA0013.outlook.office365.com
 (2603:10a6:20b:5d7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.21 via Frontend Transport; Wed,
 6 Aug 2025 10:04:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8
 via Frontend Transport; Wed, 6 Aug 2025 10:04:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TXTatNc+6pZ0KIfcPvCkAVx1jH9T2ZWqxHrfAsCDa/14SXTCn4+KWTLqDtek4HbhauQzlTHW+qB8M0cr4UiAhhEiWLKYT9cjZWBizOVban0pyvSy/7hYaZ/aBeFSVcSa8nKukrQ2STANaqRSz1GeJAiLR0hPjRP1vYKwzehBjIwXr7fqrKA2+13k/wqwKUQXMn7uwAyC3M20Ucbxxk68oYV1r1MstLkOz3EqUVO50+8p51YsCdtC9ovdTI7yk5AnxV3zF/zEUwY0PCXrFFxl5CDg5wEHKZlBUcUIAI1aeegy53jeSgasn+MYxrHveIUe0rkGsnuibdOCB8O+UnYKyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejiDJ0YP1aSNH3jL1aB+z0tSOPdBcFt0zIi9QNeeaUg=;
 b=tApOEfzyKF3HkabgECgiXtSkdHV60MUUwIVYwXioNFfL937ETRSGfcNmZgDay2u1v/YbraJ3EI+QP6lXf95LdPxpzoXx9oyDJuBpjmqmg/sTsWt0LtZey6ZTD97EVPL1Pz2aJZhsi65cdmT7Soq7NWib8d6xgyTzmO5d7d5VHqqgeg3ivGCXSNTWVzDsgssxmBMRj6YX1w3wxHkuOyEqTkrYXWhsSlWd+EafMad8Tm73Z+vfrRkxTsJuJEKpoukesCXdoukH1i1xTiIFs0y0fqj/H4PZWR1Op75bPYt5nfG/2EYPehFlOaz/pLcDdD+3pO+gheKqHoO7E0bqKgSYSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejiDJ0YP1aSNH3jL1aB+z0tSOPdBcFt0zIi9QNeeaUg=;
 b=Z6BesTV9M54TI48kWx4c9DHOF0bOSTpE5EPKmTbij5yvSb2PxfA4oQIBvs2HZdDZ6p+J5uVOQEPp9s38elvu8OnUed+Fw7QfLLyi5bgxjtAhZ0dXtpVuNTJRXT7ltthsvV3AxajPqoKKzeFG8s9mDl5NbUskCMBWwtco/cQk+v8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DU0PR08MB8640.eurprd08.prod.outlook.com (2603:10a6:10:400::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 10:04:15 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 10:04:15 +0000
Content-Type: multipart/alternative;
 boundary="------------TVDeBQFMlnzuh7XEXBPyLm31"
Message-ID: <1b3d4799-2a57-4f16-973b-82fc7b438862@arm.com>
Date: Wed, 6 Aug 2025 15:34:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
 <54ee1971-d91a-4fe6-90b8-16212c8568d1@redhat.com>
 <0d52d680-f3d3-454f-8c12-602f650469ab@arm.com>
 <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
X-ClientProxiedBy: MA0PR01CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::9) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DU0PR08MB8640:EE_|AM1PEPF000252E1:EE_|PAWPR08MB9590:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f36165-7ac6-4ab9-e52a-08ddd4d0ad6b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|8096899003;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?ZefWhIbE5qqW/dBg3mILIB4cUVUtCO9rijOcubhH3mGTwL/aANEKDTQ1pkEN?=
 =?us-ascii?Q?6Gdo9hYmktXkb1uWy6BHPI6DxAyYLm8ZjX6JHC62bI14kxlg66rnwDlyv7hD?=
 =?us-ascii?Q?FtFxHvSNe1IR7z/NaQ62DXaMTMzBD0VOgd/LSkRgC4gjW2OMBuY7fInF3KEH?=
 =?us-ascii?Q?HD3smXtGw/7eDo+2iuXMRVKAJEIEQU+KeMTqLZfqe2H38yxQa4Byl460ZLQZ?=
 =?us-ascii?Q?MLeUOlEi6ipqv+bYhzihwQ7UiUq1tVu7dKrpxuvS+IkNIzI0WxSAAONwQskA?=
 =?us-ascii?Q?f7e2mIzlTkbg7OCwiifnVvK0uxo7WCfS1rIYs7CM80miW7HwfwPY1pMALoVG?=
 =?us-ascii?Q?nsPn/fPXweLbIDH/dcKDiiuNdSNewQaYvteSY313voRnqQBlTkmEe12bya4s?=
 =?us-ascii?Q?InxCkXVkN5Kr594jYqQddp96ImlC6OeV5NUEBzRLLhSuiQ00WGImcft1YNSH?=
 =?us-ascii?Q?fVW0VJsXlvzlMq8bOnTzicwzC3v39hBopWDGc1EYsP8ki/wZGT//ha1kv9Te?=
 =?us-ascii?Q?YleO21aT9PdXwcelAPsK7whwDrGL9bPPN1oTUe21SltMCUu9Ru9j8kar1WGU?=
 =?us-ascii?Q?WU2gK3QWWK+mxjUy0peufIE64p3NLOzyFEIPwtoJ2hUAKq0qxwji4sVT8gUP?=
 =?us-ascii?Q?JPZkKrAWtgpj8HCFFlIDTTIpbby7YDhhaWrM0PrjNEa18/td+zmknath4gP+?=
 =?us-ascii?Q?/baw40TY8x18SEeoatS8jaddrCU4c5mDSCHQeIQS46A/dHPlq7U/9liNrKMn?=
 =?us-ascii?Q?czdbOvWy/R+DgBmk8imo6TbPm7wuTr/o3jKjms77AtI+5fynZC6lX2COXCNe?=
 =?us-ascii?Q?yfNsd9ZHlMOjTfLXy48Q9C1fv7T7TjgAbqGfoL4CnGQpJTMnrbNyOjhBG7EW?=
 =?us-ascii?Q?sthcxOMzWF4KO3UGZwhOC7j5bNBQizL3prucHfHa1AXFESS2nQmA0hYaU+Kq?=
 =?us-ascii?Q?tiLVdl/T33hE192QokajhiHRRAs0u1Wrtd/F2H17epSI4ddBHhKGojYPdvPk?=
 =?us-ascii?Q?BzZVcsV0IqaL4niEejNZX5Cq/aROuHNBAh7CQZ9w3dj/p0rSR0+Ge6ppOemX?=
 =?us-ascii?Q?ScK5avZVihhacpLbdN7lf3qfBvNGDZ7LJVXDvi9wMMRY2LHHPfrRUbTTxols?=
 =?us-ascii?Q?sYlwLt2Zc0V+EiXkRtm+fXqeoqxcaTcoLNB+1bWX8HOsjpvy47emBoiv7+/R?=
 =?us-ascii?Q?EottR+C81bCcP9dfd3UILJJY/HvrfooFZRFSR3u39CE+QQqQ5N5gaalApUcV?=
 =?us-ascii?Q?6WH4DEklJku22OsqLPG3pAgVaFk84UNSPeC4/y+/qHg6Jrc33ilHUYJC4VYu?=
 =?us-ascii?Q?bfXlXO1F913rusosYNuKtPjNXPerp3LRXQIJhikCdjCH69qNXZaC1pkdnvfz?=
 =?us-ascii?Q?M0y8mYsZYRtlDLQTtpXFjoV3ba+uk4ihx9S0cwjYOpAq+RjZAA=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(8096899003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8640
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9a56b8d2-affc-4994-5f25-08ddd4d09950
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|36860700013|376014|7416014|8096899003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVhhTkVPWE9JcWxXZkxNOUVBall6dXNXemZlRjNzVHh0TEQyMjJSVzNnczRG?=
 =?utf-8?B?RGJGenIzOVJrUTgwS0wrT3Y5UFpGVFpQY0VORG85dFlvSVdIZTNCU21aL0tB?=
 =?utf-8?B?UDQzWTFmTERxWUJ2NFRVbUIxWmNFb0NRVUREZ1FHRDdPUENBYXdTeWRMcTcv?=
 =?utf-8?B?QnJYSDFhSTZMM0t5SXBuN1BWSjlTeS9JOUJQclN0SCt4R3dxOThwWUNheEYr?=
 =?utf-8?B?OHB3d0RoWmdvM0x0Mm5OSzVGd1I2TGFSdkE4dFVnRTA5WWNNVXBJbWVZMFpV?=
 =?utf-8?B?eStoU2thdGxpVzQzWkpuMXd5VktHNC9TMjJBK0RtcmxsZ05PdmFpa1JIRXpV?=
 =?utf-8?B?VHRQd01Qd2hpb05OOWpvQVh5VS9oR1l0OEpScWFkNS92SmI0bGxvT1hFRmhM?=
 =?utf-8?B?aHZ1MjhiQ2UrMk5sUHk4KzdGZWZQdmVuQXNoKzUvNzdxVXVrT3lvTURnQ004?=
 =?utf-8?B?K0RRSktYWk51YzBXb1RSMnYydG43MDNNOXhEeDVEeGhkS0NIKzFHVXhaSnk2?=
 =?utf-8?B?bE1xRHFXbFdMSDYrNmIwVDN3eWtuRjdDU3RSVlFNQkpYakh3Y2ZmK1Z0dDcx?=
 =?utf-8?B?RDZ2dENKVzFYc0YyZHBzWHJwMzUrL3grNHZMVW1yREJuSEh6SUgxRlF3MHVm?=
 =?utf-8?B?dit4Zk9hZDRhSmxkalRYRmsxT29GUU1Ea0dPQUdUb25kL0cwL1MvTmxUbmRu?=
 =?utf-8?B?Vk02dytJb2pNbHZZSnd1WG9Jdk0xekdOcmZDOFZCSUM0dERNb3BGWjFYMVZO?=
 =?utf-8?B?TE4xRmcycU9tMXlsU3BxZmhPRHpnTi9idDFGNzkyaUJZQkc0cERxbEY2Sm5z?=
 =?utf-8?B?QVBpWjdpR1VERkFkQTV3UzFBVTZJL000NVBJclh5NzdFQ0Q2dzVuT0JidVV5?=
 =?utf-8?B?QklCeDJZSU5tOUhhM1VVWFkyRjZoY2FFQ1lDaEVnUzNZL2lwcHR2R3h0dWYz?=
 =?utf-8?B?WU5wRGswaTh6OUhrV2g2bWFDMmcrSVo3R3JzeWlhcmF1QkY0VSttUUR0UVhI?=
 =?utf-8?B?c3ZnU1R1Y2I0TFpNeW45UENQY0dENTdjUjlYc0hjdlBxNTZzaFByeEVyRGl5?=
 =?utf-8?B?QW5mcWtrRTFva21qaURUeXFwQTR2M0NVMHk1YmxLNU5UY1lSb0FVNDBDdndt?=
 =?utf-8?B?MWNIZldVSnBUMlo3Z2NsYlZyWVN6cXRPZW00MjRFMk0zN0V5MVpPL1JjZDBh?=
 =?utf-8?B?eU03NkVMUWpxNkcrSVhIcmRCd3krNkR6VkkvRG9hbVZtVWhLUVRpMmdCajB5?=
 =?utf-8?B?N09PTElneE91Q05ocmpRemdFMG51c1BQdlJRbE9kVUlDOUUwOTJaTlpFN01j?=
 =?utf-8?B?enJBcmJMdFYxR3RJNlVDYjAvSTYrNm1wNm1ndjdsMkV4Z3BjNjRjdHl3OHlV?=
 =?utf-8?B?NFErclNuOXBRR1FFSnU3RXcyUTJYT1o4MlRaNlowMUVGNG5aVzM4NmtXZmF4?=
 =?utf-8?B?MG92MDdFdW5IQ2N2LzV5N0RjVkNIdVVKMC80VXVOZWNicm5ybE1sdDQxKzZ5?=
 =?utf-8?B?Slh0RmQ5L1hncXZUa2ExT3pzT0pjTEw2REE2UTc3eEppS2dXTUlXM0ptSkZm?=
 =?utf-8?B?aEQyZ1NLSVlDK2F3d3libFc0NFZVcC9qSzRsVkNPWU03RnJObjdSOUF1WlRt?=
 =?utf-8?B?NnV5bTVFcGJoYVF6SExqR05oRVhYR1dxTjNyejh2V1pma1NqeXNGSzhyY2pT?=
 =?utf-8?B?KzA0MGxobGl4VDVwZzVwVzhTN093WnZ4eXl0VHkvT3ZyVVQ0ajZ6OW9rdEsv?=
 =?utf-8?B?aHZiUHF6dFc0K0h1Mkk1eGlLUHJWQVB2WG05UFUyWDZCUzQ4Sm8rM0NlK0tM?=
 =?utf-8?B?eGtYY1hPTTk2dzZQZEhNcFVyN0ZYWkZNNzVoZ3M0M1VDS3FLUXFDMWtoVW1X?=
 =?utf-8?B?Z2VZbGJqZUFuM2xib3QzQkNLT0ZRSEI5S3hHRzROMSszcTBzRGZSd1R6UGxC?=
 =?utf-8?B?ZnVKUmFjQXdodGJNMENZNmFXVER6MWltbzlnRkd2VUU0bC9sclNTd25IWTFt?=
 =?utf-8?B?RmVFZXdjaUxJak1xbUgwTnVBNWcxY3o1RXYvVTk5WUd1N3ByTk1weDZJdU8z?=
 =?utf-8?Q?w/hVTV?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(36860700013)(376014)(7416014)(8096899003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 10:04:48.3244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f36165-7ac6-4ab9-e52a-08ddd4d0ad6b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9590
X-Stat-Signature: 8byd3q7shzofumhkwj9i6btf139uska6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 544401C000B
X-Rspam-User: 
X-HE-Tag: 1754474693-222194
X-HE-Meta: U2FsdGVkX19h+XaKb7MtllB8NnbpKBNVli5zlPi6uxNl7MqNYsiEYmGvRcfq7F9gJG5wMoDjK6e4QsChIFQ36O/oDEZSdhs24RnJYapMJAhjAk7AQnXi/Uo7DL52doNsMSJjZ1rLrQvA73Gy9jxO+0DSD6us/0H/7pTIQgVWOwRJJGv1u/0X4KpJHm0k14pcz5qAzuD5jXGEWsbMkTmj8x4Nz8rJoK+9jcEZrMhWvEb/JU0L7kDnL/ZeMqN03ymZp3m//GW73T5eSyRKDbxYGKbi12S6Yw9lD9xm7rQnuQNxvfXjtySAPb5CNsN2Nso9rSzX2wSn3xB5QcInZv3OvpnK+4DP0Oufl4SwMzbEpkbz30x7wLbeKW3kKMqKTifr08XKtXmApGpOD+qP8wGtNpuozMEj8VFuB/xP8KTad06jw4J08eXyFB/lwNpMuomgoU6plMz5lTHiZblrglSEpMlpGWfMBBb1qLo1AvFXfjazolGWAUz1C9R+LvlNj0h7s9kz3oWBhAwWVGkUisUwEBharFv/KVs5x8EtwNC6wFMUtH/TrgloYCXlJPYeEcaTixeDf1aMb20D9KMMYZVJC9g9UGU3mFDMEMz5HZKrwTpiJgWXCDLqt0/wMvXY4zJ2bD3K9LzBooOQYBfE1jzz24snE+cN7yGUg5BnL0H89pKpLUEGp/MNgfnWNcmuXQAXRPnNUR5HbWI8qqrl56Vwd0/wRwOZAEoG3MIp/75T1u/+r8W88xMLkVwhB5hAKUBMuSv8MAMFK8W6E16rfUvIQgt1gcuCSqmhXfzIFc8Pj0jKqu45fmVUCSvGIWeGPm9IQEj24NIStBIx8z7IzqaeRsrFod/QkeQU025oHmCVhV7Md/ZphaBrXyvhjhG17jfa6a1f1peH9yfRQrYmL6+L/0/lmDDXMhLFaJndBP8DJ/7B+MvNfYaDOX2pQ7enqqC8iAW3hqn8G8d2H9OUgbe
 J6NOpTPv
 c1VQ0j3EGuSX+DW3g3Bp6fvQLlaXy77aio2SFb5FBiNkAxB9I2mbHZgEkv6H7CLyd3tpuG/6rTblF5LpXI7hq8m4fTOLbFVbDT0V1SdsNXCP/jZGw2Sf1gs5pVXQTue3E0ZRNkDRFW1Bmt5N7WvpuEXzKew5OUVc3G0TAmzsA4utLdUqTt0m5TlofLaHCP/7gpwQf1iSarikXGNxLsuwur8tx3fcV0CmZRG57g/nnuqrpyiy5/88UBp0MEcPCA8oN0D3OLWd+MHy0+1fLXmmS4oQbWhquAu0623m8nzyyDpe+a33bu4SrA1bN+4FFpxrPzYwMZcEcVXEMVEyILvHanyict6m0CywEIyqpRTYJ7x/LEdJgNZCHU4qvClyvs2/ULZm8UaiT1Y5D9TS5hBekES0W/XrJ1p9vnLZm4YwPuGOKIZaZi9YtfjCtAqqAfRtYBszxU2U/s2eAVCApM3GwOrm8VixnDMHNMjL3LWfUsHTxROAGNrUEh29tPEr04Axv3b8Nr0L75wQDB4WWFiNoGmtfgofvcOK6OFG3gDGPCi2vtJluvojQAxN0cMRseZoOC7yqoTCMpURKGxtzMtLGuFiVKGpCpMYLZN45d5gAUWXt0aArV6V8dbvzM6rLa4EVzXeQwTkB4xnp/7RY45Wj5PNVx4lBk46ZIlUJYkReP3jwTjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------TVDeBQFMlnzuh7XEXBPyLm31
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 06/08/25 3:20 pm, Lorenzo Stoakes wrote:
> On Wed, Aug 06, 2025 at 03:07:49PM +0530, Dev Jain wrote:
>>>> You mean in _this_ PTE of the batch right? As we're invoking these
>>>> on each part
>>>> of the PTE table.
>>>>
>>>> I mean I guess we can simply do:
>>>>
>>>>      struct page *first_page = pte_page(ptent);
>>>>
>>>> Right?
>>> Yes, but we should forward the result from vm_normal_page(), which does
>>> exactly that for you, and increment the page accordingly as required,
>>> just like with the pte we are processing.
>> Makes sense, so I guess I will have to change the signature of
>> prot_numa_skip()
>>
>> to pass a double ptr to a page instead of folio and derive the folio in the
>> caller,
>>
>> and pass down both the folio and the page to
>> set_write_prot_commit_flush_ptes.
> I already don't love how we psas the folio back from there for very dubious
> benefit. I really hate the idea of having a struct **page parameter...
>
> I wonder if we should just have a quick fixup for hotfix, and refine this more
> later?
>
> I foresee some debate otherwise...

Yup I would personally prefer that. Although if you would like to see the churn, here
it is (based on mm-hotfixes-unstable, untested):

---
mm/mprotect.c | 27 ++++++++++++++++-----------
1 file changed, 16 insertions(+), 11 deletions(-)
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 78bded7acf79..0735870e89ab 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -120,9 +120,10 @@ static int mprotect_folio_pte_batch(struct folio 
*folio, pte_t *ptep,
static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
pte_t oldpte, pte_t *pte, int target_node,
- struct folio **foliop)
+ struct page **pagep)
{
struct folio *folio = NULL;
+ struct page *page = NULL;
bool ret = true;
bool toptier;
int nid;
@@ -131,7 +132,9 @@ static bool prot_numa_skip(struct vm_area_struct 
*vma, unsigned long addr,
if (pte_protnone(oldpte))
goto skip;
- folio = vm_normal_folio(vma, addr, oldpte);
+ page = vm_normal_page(vma, addr, oldpte);
+ if (page)
+ folio = page_folio(page);
if (!folio)
goto skip;
@@ -173,7 +176,7 @@ static bool prot_numa_skip(struct vm_area_struct 
*vma, unsigned long addr,
folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
skip:
- *foliop = folio;
+ *pagep = page;
return ret;
}
@@ -231,18 +234,17 @@ static int page_anon_exclusive_sub_batch(int 
start_idx, int max_len,
* retrieve sub-batches.
*/
static void commit_anon_folio_batch(struct vm_area_struct *vma,
- struct folio *folio, unsigned long addr, pte_t *ptep,
+ struct folio *folio,struct page *page, unsigned long addr, pte_t *ptep,
pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
{
- struct page *first_page = folio_page(folio, 0);
bool expected_anon_exclusive;
int sub_batch_idx = 0;
int len;
while (nr_ptes) {
- expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
+ expected_anon_exclusive = PageAnonExclusive(nth_page(page, 
sub_batch_idx));
len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
- first_page, expected_anon_exclusive);
+ page, expected_anon_exclusive);
prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
sub_batch_idx, expected_anon_exclusive, tlb);
sub_batch_idx += len;
@@ -251,7 +253,7 @@ static void commit_anon_folio_batch(struct 
vm_area_struct *vma,
}
static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
- struct folio *folio, unsigned long addr, pte_t *ptep,
+ struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
{
bool set_write;
@@ -270,7 +272,7 @@ static void set_write_prot_commit_flush_ptes(struct 
vm_area_struct *vma,
/* idx = */ 0, set_write, tlb);
return;
}
- commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, 
nr_ptes, tlb);
+ commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, 
nr_ptes, tlb);
}
static long change_pte_range(struct mmu_gather *tlb,
@@ -305,6 +307,7 @@ static long change_pte_range(struct mmu_gather *tlb,
const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
struct folio *folio = NULL;
+ struct page *page = NULL;
pte_t ptent;
/*
@@ -313,7 +316,9 @@ static long change_pte_range(struct mmu_gather *tlb,
*/
if (prot_numa) {
int ret = prot_numa_skip(vma, addr, oldpte, pte,
- target_node, &folio);
+ target_node, &page);
+ if (page)
+ folio = page_folio(page);
if (ret) {
/* determine batch to skip */
@@ -351,7 +356,7 @@ static long change_pte_range(struct mmu_gather *tlb,
*/
if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
!pte_write(ptent))
- set_write_prot_commit_flush_ptes(vma, folio,
+ set_write_prot_commit_flush_ptes(vma, folio, page,
addr, pte, oldpte, ptent, nr_ptes, tlb);
else
prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-- 
2.30.2
I think the really correct way here is to pass double ptr to both folio 
and page,
since the way I do it now, I do a page_folio() twice potentially, which 
kind of
defeats the purpose of the trouble we took to save on a 
vm_normal_folio() :)
So I would prefer the pte_page(ptent) thingy for the fix patch.

>
>>
>>> ...
>>>
>>>>>> +            else
>>>>>> +                prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
>>>>>> +                    nr_ptes, /* idx = */ 0, /* set_write =
>>>>>> */ false, tlb);
>>>>> Semi-broken intendation.
>>>> Because of else then 2 lines after?
>>> prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
>>>                 nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
>>>
>>> Is what I would have expected.
>>>
>>>
>>> I think a smart man once said, that if you need more than one line per
>>> statement in
>>> an if/else clause, a set of {} can aid readability. But I don't
>>> particularly care :)
>>>
> Can do this in follow up too.
--------------TVDeBQFMlnzuh7XEXBPyLm31
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 06/08/25 3:20 pm, Lorenzo Stoakes
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local">
      <pre wrap="" class="moz-quote-pre">On Wed, Aug 06, 2025 at 03:07:49PM +0530, Dev Jain wrote:
</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">
You mean in _this_ PTE of the batch right? As we're invoking these
on each part
of the PTE table.

I mean I guess we can simply do:

&nbsp;&nbsp;&nbsp;&nbsp;struct page *first_page = pte_page(ptent);

Right?
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">
Yes, but we should forward the result from vm_normal_page(), which does
exactly that for you, and increment the page accordingly as required,
just like with the pte we are processing.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
Makes sense, so I guess I will have to change the signature of
prot_numa_skip()

to pass a double ptr to a page instead of folio and derive the folio in the
caller,

and pass down both the folio and the page to
set_write_prot_commit_flush_ptes.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I already don't love how we psas the folio back from there for very dubious
benefit. I really hate the idea of having a struct **page parameter...

I wonder if we should just have a quick fixup for hotfix, and refine this more
later?

I foresee some debate otherwise...</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">Yup I would personally prefer that. Although if you would like to see the churn, here
it is (based on mm-hotfixes-unstable, untested):

</pre>
    <div style="color: #000000;background-color: #ffffff;font-family: Menlo, Monaco, 'Courier New', monospace;font-weight: normal;font-size: 12px;line-height: 18px;white-space: pre;"><div><span style="color: #000000;">---</span></div><div><span style="color: #000000;"> mm/mprotect.c | 27 ++++++++++++++++-----------</span></div><div><span style="color: #000000;"> 1 file changed, 16 insertions(+), 11 deletions(-)</span></div>
<div><span style="color: #000080;">diff --git a/mm/mprotect.c b/mm/mprotect.c</span></div><div><span style="color: #000000;">index 78bded7acf79..0735870e89ab 100644</span></div><div><span style="color: #000080;">--- a/mm/mprotect.c</span></div><div><span style="color: #000080;">+++ b/mm/mprotect.c</span></div><div><span style="color: #000000;">@@ -120,9 +120,10 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;"> static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,</span></div><div><span style="color: #000000;">                           pte_t oldpte, pte_t *pte, int target_node,</span></div><div><span style="color: #a31515;">-                          struct folio **foliop)</span></div><div><span style="color: #098658;">+                          struct page **pagep)</span></div><div><span style="color: #000000;"> {</span></div><div><span
  style="
 color: #000000;">        struct folio *folio = NULL;</span></div><div><span style="color: #098658;">+       struct page *page = NULL;</span></div><div><span style="color: #000000;">        bool ret = true;</span></div><div><span style="color: #000000;">        bool toptier;</span></div><div><span style="color: #000000;">        int nid;</span></div><div><span style="color: #000000;">@@ -131,7 +132,9 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,</span></div><div><span style="color: #000000;">        if (pte_protnone(oldpte))</span></div><div><span style="color: #000000;">                goto skip;</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #a31515;">-       folio = vm_normal_folio(vma, addr, oldpte);</span></div><div><span style="color: #098658;">+       page = vm_normal_page(vma, addr, oldpte);</span></div><div><span style="color: #098658;">+       if (page)</span></div><div><span style="color: #09865
 8;">+   
             folio = page_folio(page);</span></div><div><span style="color: #000000;">        if (!folio)</span></div><div><span style="color: #000000;">                goto skip;</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;">@@ -173,7 +176,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,</span></div><div><span style="color: #000000;">                folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;"> skip:</span></div><div><span style="color: #a31515;">-       *foliop = folio;</span></div><div><span style="color: #098658;">+       *pagep = page;</span></div><div><span style="color: #000000;">        return ret;</span></div><div><span style="color: #000000;"> }</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;">@@ -231,18 +234,17 @@ static int page_an
 on_exclu
 sive_sub_batch(int start_idx, int max_len,</span></div><div><span style="color: #000000;">  * retrieve sub-batches.</span></div><div><span style="color: #000000;">  */</span></div><div><span style="color: #000000;"> static void commit_anon_folio_batch(struct vm_area_struct *vma,</span></div><div><span style="color: #a31515;">-               struct folio *folio, unsigned long addr, pte_t *ptep,</span></div><div><span style="color: #098658;">+               struct folio *folio,struct page *page, unsigned long addr, pte_t *ptep,</span></div><div><span style="color: #000000;">                pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)</span></div><div><span style="color: #000000;"> {</span></div><div><span style="color: #a31515;">-       struct page *first_page = folio_page(folio, 0);</span></div><div><span style="color: #000000;">        bool expected_anon_exclusive;</span></div><div><span style="color: #000000;">        int sub_batch_idx = 0;</span></div><d
 iv><span
  style="color: #000000;">        int len;</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;">        while (nr_ptes) {</span></div><div><span style="color: #a31515;">-               expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);</span></div><div><span style="color: #098658;">+               expected_anon_exclusive = PageAnonExclusive(nth_page(page, sub_batch_idx));</span></div><div><span style="color: #000000;">                len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,</span></div><div><span style="color: #a31515;">-                                       first_page, expected_anon_exclusive);</span></div><div><span style="color: #098658;">+                                       page, expected_anon_exclusive);</span></div><div><span style="color: #000000;">                prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,</span></div><div><span style="color: #000000;">             
         
                   sub_batch_idx, expected_anon_exclusive, tlb);</span></div><div><span style="color: #000000;">                sub_batch_idx += len;</span></div><div><span style="color: #000000;">@@ -251,7 +253,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,</span></div><div><span style="color: #000000;"> }</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;"> static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,</span></div><div><span style="color: #a31515;">-               struct folio *folio, unsigned long addr, pte_t *ptep,</span></div><div><span style="color: #098658;">+               struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,</span></div><div><span style="color: #000000;">                pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)</span></div><div><span style="color: #000000;"> {</span></div><div><span style="color: #000000;">        bool
  set_wri
 te;</span></div><div><span style="color: #000000;">@@ -270,7 +272,7 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,</span></div><div><span style="color: #000000;">                                       /* idx = */ 0, set_write, tlb);</span></div><div><span style="color: #000000;">                return;</span></div><div><span style="color: #000000;">        }</span></div><div><span style="color: #a31515;">-       commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);</span></div><div><span style="color: #098658;">+       commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);</span></div><div><span style="color: #000000;"> }</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;"> static long change_pte_range(struct mmu_gather *tlb,</span></div><div><span style="color: #000000;">@@ -305,6 +307,7 @@ static long change_pte_range(struct mmu_gather *tlb,</span><
 /div><di
 v><span style="color: #000000;">                        const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;</span></div><div><span style="color: #000000;">                        int max_nr_ptes = (end - addr) &gt;&gt; PAGE_SHIFT;</span></div><div><span style="color: #000000;">                        struct folio *folio = NULL;</span></div><div><span style="color: #098658;">+                       struct page *page = NULL;</span></div><div><span style="color: #000000;">                        pte_t ptent;</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;">                        /*</span></div><div><span style="color: #000000;">@@ -313,7 +316,9 @@ static long change_pte_range(struct mmu_gather *tlb,</span></div><div><span style="color: #000000;">                         */</span></div><div><span style="color: #000000;">                        if (prot_numa) {</span></div><div><span style="color: #000000;">             
         
            int ret = prot_numa_skip(vma, addr, oldpte, pte,</span></div><div><span style="color: #a31515;">-                                                        target_node, &amp;folio);</span></div><div><span style="color: #098658;">+                                                        target_node, &amp;page);</span></div><div><span style="color: #098658;">+                               if (page)</span></div><div><span style="color: #098658;">+                                       folio = page_folio(page);</span></div><div><span style="color: #000000;">                                if (ret) {</span></div><div><span style="color: #000000;"> </span></div><div><span style="color: #000000;">                                        /* determine batch to skip */</span></div><div><span style="color: #000000;">@@ -351,7 +356,7 @@ static long change_pte_range(struct mmu_gather *tlb,</span></div><div><span style="color: #000000;">                         */</span></div><div>
 <span st
 yle="color: #000000;">                        if ((cp_flags &amp; MM_CP_TRY_CHANGE_WRITABLE) &amp;&amp;</span></div><div><span style="color: #000000;">                             !pte_write(ptent))</span></div><div><span style="color: #a31515;">-                               set_write_prot_commit_flush_ptes(vma, folio,</span></div><div><span style="color: #098658;">+                               set_write_prot_commit_flush_ptes(vma, folio, page,</span></div><div><span style="color: #000000;">                                addr, pte, oldpte, ptent, nr_ptes, tlb);</span></div><div><span style="color: #000000;">                        else</span></div><div><span style="color: #000000;">                                prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,</span></div><div><span style="color: #a31515;">-- </span></div><div><span style="color: #000000;">2.30.2</span></div><div><span style="color: #000000;">
</span></div><div><span style="color: #000000;">I think the really correct way here is to pass double ptr to both folio and page,</span></div><div><span style="color: #000000;">since the way I do it now, I do a page_folio() twice potentially, which kind of</span></div><div><span style="color: #000000;">defeats the purpose of the trouble we took to save on a vm_normal_folio() :) </span></div><div><span style="color: #000000;">So I would prefer the pte_page(ptent) thingy for the fix patch.</span></div><div><span style="color: #000000;">
</span></div></div>
    <pre wrap="" class="moz-quote-pre">
</pre>
    <blockquote type="cite" cite="mid:9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">

</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">
...

</pre>
          <blockquote type="cite">
            <blockquote type="cite">
              <pre wrap="" class="moz-quote-pre">
</pre>
              <blockquote type="cite">
                <pre wrap="" class="moz-quote-pre">+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nr_ptes, /* idx = */ 0, /* set_write =
*/ false, tlb);
</pre>
              </blockquote>
              <pre wrap="" class="moz-quote-pre">
Semi-broken intendation.
</pre>
            </blockquote>
            <pre wrap="" class="moz-quote-pre">
Because of else then 2 lines after?
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">
prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);

Is what I would have expected.


I think a smart man once said, that if you need more than one line per
statement in
an if/else clause, a set of {} can aid readability. But I don't
particularly care :)

</pre>
        </blockquote>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Can do this in follow up too.
</pre>
    </blockquote>
  </body>
</html>

--------------TVDeBQFMlnzuh7XEXBPyLm31--


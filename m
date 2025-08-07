Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4FDC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 08:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4CD8E0007; Thu,  7 Aug 2025 04:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595608E0002; Thu,  7 Aug 2025 04:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DF08E0007; Thu,  7 Aug 2025 04:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA828E0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:57:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8EE0136ABF
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:57:02 +0000 (UTC)
X-FDA: 83749356684.18.1444DFD
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010013.outbound.protection.outlook.com [52.101.84.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id C8C31A0007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:56:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=QrMYn9GM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=QrMYn9GM;
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.13 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754557019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMgIMRGjpRPZF5grLyOgsyrWc/6omTxToA55LynmO/4=;
	b=fNM+IvpUukQhgXCD2fbVL9qQdd1wq+7Iklx6Rn+cYBwrRafzFKc+bEYJKd2t1NYkXkJHzQ
	IDpfXExe1RMKb5joEe2Gf5AGRHVLjKI84y+oLrhbZvjZUvE66JZbffkG76RPgLym705Kom
	Cr93QcoxzwZ4hh26sNh5X4oKU4H1dRo=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=QrMYn9GM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=QrMYn9GM;
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.13 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754557019; a=rsa-sha256;
	cv=pass;
	b=XOGdNggIWOvo+3n8kaSvzn0ng3qP+pUOy9EuMUXZp2sj7PXsZUER1gMIylCz4V6s6t70fU
	dtn8+nnXS90lvvAIyA7qe526bZXz5s6ilyKTKPFROFEzcKm4bfHqXhWAgNY7KzEVm3+F1C
	aVmMgSq/+V6vApJXW1LQc1v0/FBzwq0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gocbyMBz1WeKi2/Zl4XOHdsykPN3hvMzr4PX+swRuknU6y/m1v2ST55eDKIsmB1dQvJVEC0uOO32YDUk0pN9qa3382l6aMUeqxKKCs5Zaz+1l3a/A3kxWRPLP9UPNAI2hn8XmdXSwvhSGi8T4Ur4pl7BFfTaFx7kR7UAY9m0JDDhQ6+hO/7hVcSTBnH2bcLZnSiM0Co6eHhwAarm3EbVZfFHwkQiKNt8h9xSI40TaumEcLqpjyEAkf6XtXzrTKW+B4U4NBcS8fcrneG+tE1c93C9g5Sl7MXfKDkCvFrnUB2Ynk9eydpERvJMzVmydal5oDAhcpCdW3E1tLeXO8jjlQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMgIMRGjpRPZF5grLyOgsyrWc/6omTxToA55LynmO/4=;
 b=vbiGJP3JwxOe5XjBVYJDNyucIpkWkkDIDxhuvMWJ5MzalL9gGrSBz5p65BKJ3yrybnSgIlj36nJ1qhLhUNbUIdViiLJIbiQ/snoa7V3attcqXz6tlbrycciYsOHJrhOkzFv0pYjh3ua43iy4/dNlUtu+XFvwTLpD02Y6MSGFnv+QijsYIqMiU2SYpVpX+ryh+f04R2yXGdjxh2SofrbXotRqJvhKy5R5kNZHo7ntMow+ePm4bVcr9jqYOAlj5qJiy335Vf+/qxMIsVQJvHzYE16AKLzQWUdMwmGPX3sX8wvx0zO0zTBkAGTCrdt46H8AdwiftUf4bYbEAUPfRdE8gw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMgIMRGjpRPZF5grLyOgsyrWc/6omTxToA55LynmO/4=;
 b=QrMYn9GM2nIzHHKJmIwslp4Di4HaVLBd9PCKvqnUhty3C1XblsTmPFblOKPMlpqWdajbjltDFcABQ0I5xb+ljuzUWWZVGq/5G2PSJTEfQljGCSmpFmzv4kKVlou45GcNlTew8BKvbjbPnuFzHKKlvXh2w3d5gNv87pSb2/kXU0w=
Received: from DU2PR04CA0162.eurprd04.prod.outlook.com (2603:10a6:10:2b0::17)
 by GV1PR08MB8356.eurprd08.prod.outlook.com (2603:10a6:150:a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Thu, 7 Aug
 2025 08:56:50 +0000
Received: from DB1PEPF00050A01.eurprd03.prod.outlook.com
 (2603:10a6:10:2b0:cafe::7d) by DU2PR04CA0162.outlook.office365.com
 (2603:10a6:10:2b0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.15 via Frontend Transport; Thu,
 7 Aug 2025 08:56:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A01.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8
 via Frontend Transport; Thu, 7 Aug 2025 08:56:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B3kEWdTAAE6PrGvh3EX/gpJHCVy2Jw14qB9FbiN98UCzGwe7wBE7mn4wwYAyKfmPz+8jZCW86+0qJMnnBsq0mY3XvfMa3MDYczV0h8FNAnNK0zEUSX8atODFhznmxuM1CxccIx+9bJCHnmWcDY0Qy5g0nfgievL2/1/Jx1qUEcIEQm3758yVFXorINifQ6GjKtt2dTYmkiclReY4lyNx+1+NbaV9NwgzA8PSQMhxAWxUhBIU22B+E4ngc4JlL1su45zjSZenPizu1MyQSUDODYHJM8lthMMS0weZK7/hxgbX3AtBkZbx7jIjqyhi3aRHHOhEFrka059J37d+dfHqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMgIMRGjpRPZF5grLyOgsyrWc/6omTxToA55LynmO/4=;
 b=Swd9hX/7aL0Jh+gg7Jpo3wx7mngC5uKlHhcspxWHQNQ2rPrXqpdO1Xu9K5bi58d0ZtZGhk3NA5zTw41s6vpl6FB7203/tKdnNQbqMIJsGFwIfoIrV6airWxB/zn9LNodLe+Kl4fkY+DwljOJ7Rh/DByMUPS3bav2VKocu/YSi4r2jhfbw7u5S6JqlpocSqulqlxyLjKRH0zfoMoEr1FI+4sE21kH0OzZ4aNSB42bL4MvWy2xcn3BaXmQ1t67e5R5Q1s6M7tdffxvk+wXQgCzs1eV30UeRymdjPJzTHhwCIVmuiFCNNiGec1x6DAPbvHFh+4/JAgwDnOYTuOMzPRbFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMgIMRGjpRPZF5grLyOgsyrWc/6omTxToA55LynmO/4=;
 b=QrMYn9GM2nIzHHKJmIwslp4Di4HaVLBd9PCKvqnUhty3C1XblsTmPFblOKPMlpqWdajbjltDFcABQ0I5xb+ljuzUWWZVGq/5G2PSJTEfQljGCSmpFmzv4kKVlou45GcNlTew8BKvbjbPnuFzHKKlvXh2w3d5gNv87pSb2/kXU0w=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DU0PR08MB9154.eurprd08.prod.outlook.com (2603:10a6:10:415::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 7 Aug
 2025 08:56:16 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 08:56:16 +0000
Message-ID: <da6727d1-d0e4-468a-bc57-19f11e6d2209@arm.com>
Date: Thu, 7 Aug 2025 14:26:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <ioworker0@gmail.com>, Liam Howlett <liam.howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DU0PR08MB9154:EE_|DB1PEPF00050A01:EE_|GV1PR08MB8356:EE_
X-MS-Office365-Filtering-Correlation-Id: ee6e6962-8bf7-4ccb-7430-08ddd5905819
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?S3l5SmZQTmhXV044UUJVcThBTDgxcmVXSmlQeG40YTM5WTlWaFdCK01PY1BJ?=
 =?utf-8?B?YlIwR2NvMUxHT0k1NWZHTmRDc01CMndwVmMzbWVkMGNjVENrcGtiMHRLOEpF?=
 =?utf-8?B?a3FYb1dEMWJhUWNUdVJBeGZSK3ZmVDkxSlVrQkVuYlFRM3VKNmo3R0dLTUMr?=
 =?utf-8?B?Mmg3NDJQeVRVTVh5TmR5TWx5VE52Y1F5SVdGZmxJV0RMNlEwQmlGSm9tYklG?=
 =?utf-8?B?MHRrNmhUM1Y2VW5YWVpSL0ptZFZzT0gvdXkzalV6cnZNZnFhZTZJVmJLY0Jn?=
 =?utf-8?B?UndGdlZvWFhjZVdQeFJrbWxtck95TGtYWkpvSW5ydVhJUlBUY29MSVdRT2dK?=
 =?utf-8?B?Y1lqNjZsNDhBb0pMaEIxVjh5ZWNZa1V3bC9pc1Zra1dYNW56QUFKcnRIeFZt?=
 =?utf-8?B?ZG83K3Jha0FPZ0ZBZ1dLcStBa0FwdnF5WmtjUy9oTS9uRVMvM29OMUhzUStw?=
 =?utf-8?B?NTJ6QXFjbkVjT2xwZXdHcmR1VEtXcU9oOFFPTjVTNWFIMVBwNkxWdEViUTJ0?=
 =?utf-8?B?UG51MmxPOWZKNWl6RUhZVzUxaUtJcElYdzBOTUh5aENhNmpTaFpLM3FDK3FB?=
 =?utf-8?B?bWppMm9zQ1k4UEFJdnBOZEgwN2N6V2k4R3BMVmduR3czRFQ1dGFTa2VMUktB?=
 =?utf-8?B?NjNhWGU5TEViNFJFMk1Zd0dCSGVudEVTL3Q0VDh0SElZZnVyc3dKK3JXa2k3?=
 =?utf-8?B?MHpJdWxwZlBLTmRSVmZmaTFpSytZVktGT09JU1Q4RXdJVElLeGY5SUNNeGRR?=
 =?utf-8?B?cklRdG45dWZYOXAvNnNCZGc5aXpUUEZDc3FRREhUWnlBWEJEUFp5cUJJazla?=
 =?utf-8?B?V3B6VElmOGk2VUdmS2xvYWhMdWpRRlFBTkRRT09mbGJQVUFxUEx6MnFnaVlL?=
 =?utf-8?B?UStuRHI3YXJpTUNYNldhbTRtK0FVQnRTVm0zS0wwV0czbXk0ckViTjZWb0Zq?=
 =?utf-8?B?VEJkZS8xb3NmRG5DWndBM0gzVC9XNnV3YkZyS0lOemNBZGIvRkdDeTBtWnRJ?=
 =?utf-8?B?aTRTbWpYNFM1alh3Tjh1WUZCdWN2THhuQjhjRFpqS3Jya1oydU1Gb0o2NVls?=
 =?utf-8?B?R1RqaTYzVExBbnRoVEh3emZFZS91THZad285SGx1NnFxZUpaVkxkeDZkVHhM?=
 =?utf-8?B?SFd2NDZqbTZjbk8xTmtvejRnZWZ2cG1oR1puNElGekU3dktlb256cmd4VTM4?=
 =?utf-8?B?Y0NoVlYxVzV5cE1Ic1g2SlBneHozc1JHOGY2L2w4TitVbGw0UlNnKzdMQzJx?=
 =?utf-8?B?Rkg2Y3BjVWF4eWY2VXNOOVZvalY3L1JKa2RLRDdFV3ZlLzRpYlVNTUFuQXlB?=
 =?utf-8?B?WGpCSTRCb3Q5cVAwVm1uQVBJYmtQSmEzdUQzeFd5Wmw3a0I5VnhPZVlQbXN3?=
 =?utf-8?B?dWFYMUNabmIzVkF6YW11TDBTVHNOem9NQWMyczlRRGV2Qll5anNwNVFqQXhW?=
 =?utf-8?B?NURyUzZENG5tem9hWmJhU1lmR0NIeXQvcDErOFdTazB5SXIvTTZkRXNmSHhp?=
 =?utf-8?B?b0cvYS9KN0N4Ni85T0lkdGx3WDJjZFpwNDNlWi9xdXY3LzJiUEhCSUptS3RP?=
 =?utf-8?B?ZGZxN1dqMDMxVWtFVEk5WHphWCt6L3F1Si9qajhxVWhTQkZhUmRtUzNjdy9V?=
 =?utf-8?B?bE5CaUlCdnFWWU11Uk5oTm1SMSs0R1dVVHJ4Q3J5Qkg3TC9sSHBlN0NDRVRZ?=
 =?utf-8?B?Y3FUYzQ0K1BiNnU0VjBtTFFmOTlEMkdMRENqQXozd2l4YTlrWDNLd0NCOThW?=
 =?utf-8?B?RkRhTHB4YlcvTklxMEZudDRBWHUxTHA1bThGeXhhZytpa3BySjJKRjFsNnVi?=
 =?utf-8?B?ZEUxL1NZeWdGVE9Tbm9jVG5VNlFjMUNIUVFmaHczUExoVUNyWFowZlhkNjRX?=
 =?utf-8?Q?tE1nOyMFLk4RX?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9154
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9c55eb53-f21d-411d-6f90-08ddd59044ba
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|1800799024|35042699022|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SE9zd0xiaXVqQXFaWFJrOFBWQXRJTHNzZmk0QjNnZFFNSjh1Wk1WbFZmWmZm?=
 =?utf-8?B?bDM3ZlMwVmZZYm5mQnRReHRWcFZHaVRwU3ArMlBRbE56N05UTjVpUk41eldm?=
 =?utf-8?B?MlV6Mzh5ZVRrdHBpelFENnRBN0FibEp5QUJzSEtwTGtsV1g3V20wY3hPYm4x?=
 =?utf-8?B?NXIvbEQwUE5GYzBYYURvNE5ENWVNVEtpVGdyTnM2b1R4T3FZTlZqQWo0d3BH?=
 =?utf-8?B?TFNaS3JsRmFtWTN6SGFXd0VKZW9id0JoejFpeWxmRmlxbmtRaEFxcnJJYVJD?=
 =?utf-8?B?QW1MazVpNGZVeW5UWWJRZmYyTmRzdFFjY1lBbmhUaTd4UVkzSHNQaWExTExP?=
 =?utf-8?B?OHplM2pDaEVEUW9wekxBbWpRMTlNbVZnNDA5MlZPeVJSVUEwRGZVeWFlOFdF?=
 =?utf-8?B?cUE4TlFsTi9pd042Mk9salNpQnN3T3VyNlplYkwvdG9Vd1ZQTSswSWVESlJW?=
 =?utf-8?B?RiswSGVvVHNxbDgyVWtYa2FNMUtOWkVtMFE1WWc3WThyaVd1TWIzcGlQR05L?=
 =?utf-8?B?cVBIdGpTSG80QVI0d3FrWWJPQmFBL1lIRnFxKzgwaG5IVmpkbUN3SCtINFdy?=
 =?utf-8?B?amwvRi9TQjFTMmJIWXJoN05lZzlXSFdWSFhqc1RVUTB1Y2pvaUhsbW1UK1Vn?=
 =?utf-8?B?WmpCdFlnR3Rjd3A0ZldMQUcra1FQM1ZnVG1rNkJ0dTF3STE2TW1KTk9CUzV6?=
 =?utf-8?B?UnBJUm9lNHUzNDF3Uno5UjZqUjAxTTMvM3Nnamd0OWRIWVBzQUdxbGVObXhx?=
 =?utf-8?B?QmtkWHVuVkU0ancwMXRSSS9ka1NBdmNlRWtSMkc1VGlTWjBsblN6d2VyNmpC?=
 =?utf-8?B?UUovYzNQVW54eFR6R1ZIOG5WK2JHSGZjYmM5SERuWVRNMVg3K3FtaE5CZHE0?=
 =?utf-8?B?Z3NtZ3lyajFVaVBTK2xsR0pLcGFsYUZ0MVNOVmZRV0FMRWpzQ1pNZmRmTGhW?=
 =?utf-8?B?a095VGwxOXdUaEZBQlN2WGkybXJOYyt1NjdTbEFXTk5mc0EyTVNpWFJiRlNT?=
 =?utf-8?B?NDRXbkRxZjdjTGs5MUJhTzE4elloMEkxYmRSU245a3Fzd29PQkJ2dEcrQ2Qr?=
 =?utf-8?B?VWxRUm1yUVdWSTlBZ3dxLzFRd0JuenJYRm12aWgxeDVCYkxocnBXaUxWWTZO?=
 =?utf-8?B?OTJoNGRWZWpjbWhlcGc5bjViT0ZFbVJIK1pRRVhkdVVUd1BHdTRqNHdwTEUx?=
 =?utf-8?B?N3owZ0t5Y2tEK3VMQXN3djVnb0tkUXViRmdPdmFLSGF1S0RwR2hQTm01eHMw?=
 =?utf-8?B?eDJHU3lOeDkrZk9BV1FzbzhhWEFEL2dILzkvYjhnTkVMeG41d0IvQVNaTWM0?=
 =?utf-8?B?dWFIZmdVTnFBc0srQi9MV0Z2cms0NnNxZWY3MEZjOFJTSUpQQ29RNTcrVzhx?=
 =?utf-8?B?eTErcGpRYzdPamZvQUpzRVQ2WE95RWtLUm53TWU5V1RCa1J1OHVYZUpGSVJ0?=
 =?utf-8?B?dTg1Q0kwdHF6dUZGa3VKYzQvM3V4UWNZTVgzZHVFMlF5c3BKaWhxd1FYVHJP?=
 =?utf-8?B?M1ZkVUUxZUtiQW9TL2UwOVgyMDFFVjFVTXdPTXNpdUJvd1ZnVldlUzhBV3hC?=
 =?utf-8?B?UWd2VUloRFA4SE5YcU1lZTR4cXpZSmM0UW5GZ1NveS8yTFpMeTd5blMyc0lC?=
 =?utf-8?B?NFdOWHFlTjk5RCtpWlNhUFErYUhKQ1N3ZjdPbzNQNzZ3bStpZE5nNCtFZ2dh?=
 =?utf-8?B?MnZBQnQ0d2EvUXo3N2E4T0gvdDlaZk1nL3Y1c2tBT1lJYmh3ZVR4eEd0MlFm?=
 =?utf-8?B?Wlg1U3F6NkUwL3NvYTZ2RWR0Qm1FSk9YWDZLMk51TXpCVXVmdlJDcmcxVVBX?=
 =?utf-8?B?dEpqdnJXdXFrL01hcGZJY3BsWTYyMEtvWVAxWU15cVFUc0FwU1JiRlR2VlJl?=
 =?utf-8?B?ODYwVzZQL3RJV2tUSGZNVGZRd3pHZHlpaTB1Tm5wV3VqWTFyK1hxc1pGS1hH?=
 =?utf-8?B?SWNNYVdWeWFEWVY2MHQ0Ny96WmtnVEVJdEpjLzhRNDZuM2hKM3ZETC9XYW1p?=
 =?utf-8?Q?SL1A25noAZruGwMAVDdvGzUQMdkrhk=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(1800799024)(35042699022)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 08:56:48.5462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6e6962-8bf7-4ccb-7430-08ddd5905819
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8356
X-Rspam-User: 
X-Rspamd-Queue-Id: C8C31A0007
X-Rspamd-Server: rspam06
X-Stat-Signature: jhprqh9jdkdptndpwdprd17u98goeunc
X-HE-Tag: 1754557018-235185
X-HE-Meta: U2FsdGVkX19KT2SevoFvq+/xb/FqI93gOjs0IahVDe8ji2hjK4XoGkcWDtK5w2y9poN8klLJlq9m9+C6sxI4Mk994bP55CkM1do9uQtRFFfcjmiLi9HbO4ME8ikYogPaZLYodjLtR2gnibKtpY7HAcoEJsVelTX5W8aTic3B1egDXV/TUEXDaiaA3xUfj2eAFPporNPdlkH11tSIN/qwBYG1E8ftrVggMWwy3C3m1umEKHqNSh7JWFsk1HjmvlqXjB7ZpD8ij60IlmXnhLw8dLL2kjoSCECgs8M6TPnkP9LuMuXUrHNwlAFLibOWLbE6GlDqnoJvmPF/HHmbhkg/1MeaNgfoOKC8wKFCjoRQ2oHcWY2wxhAgnUz+unvBxUFke8uGmXEQsKAvHKxODODnq40CrAXV7yXnzyTjj7kHl5ziL0Mea0YKQDuIsxC45hUbf9IYQmS/lrpReAQgyEgrJE9yPQxn0LTMR7iRNUyOy8yBzM8K88j1Yz+NsFq3ZcDPzg5UJE2eR2zfYdG0Cs394Ag8PG8O/+pVGI7kZ22NMs4a6y2B8UgHBk+Db+y5iW1nMkq9vCBn+dMAUPD0gXtkbAHKjkl8K2jV1DithFNsfNKdQuICFwTeSdlpVf8JnEZShqZctQgxLpRqutbiwEjrSkG8AHd7zRttfwhF1zDqaFDsUPqAvpDzp/9nHFbmGxx3A/16s87JYuo/KVnMPlLcTi80HsPaNCBVJgf/aciH0jFOu0H/1q0NhKD7Vw9Stk96iq/UEY2SUefihYj8dzDw5W0qeF4Yi0hCy7sqcPcEdwn2PvXo48+cYrxNub5pm3KGfqBb3dle9o7jzkf26hJFHja0y7BvVBJQy/cWT53yEPQ5rw/FVzf4u71ATXUeod4jESpFNkvSVG0V2MQyt0TpObNSVujZKGD/k7ISG0D/mVZtlMG8qSxm9up7JjAeyE67X4SyN6PFglpVX9gyjme
 1LsFXmpF
 bZo05/sDX6VFYhk0sl3kf7ojHlAOYBLlCfQROiJqsQ/YUAMCkVH4Zquz68OMq2sjPI6kDiHpcvNHX+eIKW7nNH++cJmE1kixEEvI9D2QfvAYa4b25RJ16f7wLTQQb35+XNZt/ilny5vcmaTAGAxe8OGc6bAiGabNvS487Qb46PRDkhgrtIIvIFV8mXu+m0OgypzczHz0O23+d4T9OzgN/ssEescoEdnIUk6CcPLABgh6ljjMCdtjY54MthwNr7hMpG3VNcRgqOzvpFOnQZW6KXYH10fnVTZ1WuNHEjpqN5L/aKI8ECmdMENJ4xX0FsHD3Ork7kxUXCrHaDda0BU6EJNCY+7MJqGd4zzTpIy2bVKGkCzNHy1kofUHFjOi4J2bMX2BZavOG6iFp1soTG7HC1svC7WHjr3GVEkLnS3y8IJfB3Hh72jAsdbV5V/l9rm0lGGUHq6HNtRBF0C1nZJcm9DMAx/Ho51i8yGuPhDlbERAbU6yFrzTd9wkjBkjNDmUY/vkW/1NKygf1VcgQgGTycCPu2DpqB1B4yWDd7uJ3ditVdR3dRtmNpE7LXw4UvdMlsAVcSvkikytUtj7myOmNCl48caOSI2ylQrAoZkKGGxTN8AthfEDl8dSn52caEM3j2ciOipUd+HXXaKAuvZ+KQNbtnguXevs8CoKq8vhDI1taESWyrzo8bVpnUL4HxXWzhg7qjWHLqmAaZdsZQOAGQ5jNcFO2FlvPybxI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/08/25 1:57 pm, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>>
>> Hello,
>>
>> kernel test robot noticed a 37.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:
>>
> Dev - could you please investigate and provide a fix for this as a
> priority? As these numbers are quite scary (unless they're somehow super
> synthetic or not meaningful or something).

Yup I'll start looking.

>
>> commit: f822a9a81a31311d67f260aea96005540b18ab07 ("mm: optimize mremap() by PTE batching")
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>
>> [still regression on      linus/master 186f3edfdd41f2ae87fc40a9ccba52a3bf930994]
>> [still regression on linux-next/master b9ddaa95fd283bce7041550ddbbe7e764c477110]
>>
>> testcase: stress-ng
>> config: x86_64-rhel-9.4
>> compiler: gcc-12
>> test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
>> parameters:
>>
>> 	nr_threads: 100%
>> 	testtime: 60s
>> 	test: bigheap
>> 	cpufreq_governor: performance
>>
>>
>>
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>> | Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
>>
>>
>> Details are as below:
>> -------------------------------------------------------------------------------------------------->
>>
>>
>> The kernel config and materials to reproduce are available at:
>> https://download.01.org/0day-ci/archive/20250807/202508071609.4e743d7c-lkp@intel.com
>>
>> =========================================================================================
>> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>>    gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp1/bigheap/stress-ng/60s
>>
>> commit:
>>    94dab12d86 ("mm: call pointers to ptes as ptep")
>>    f822a9a81a ("mm: optimize mremap() by PTE batching")
>>
>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>> ---------------- ---------------------------
>>           %stddev     %change         %stddev
>>               \          |                \
>>       13777 ± 37%     +45.0%      19979 ± 27%  numa-vmstat.node1.nr_slab_reclaimable
>>      367205            +2.3%     375703        vmstat.system.in
>>       55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.KReclaimable
>>       55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.SReclaimable
>>      559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
>>       11468            +1.2%      11603        stress-ng.time.system_time
>>      296.25            +4.5%     309.70        stress-ng.time.user_time
>>        0.81 ±187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        9.36 ±165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        0.81 ±187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        9.36 ±165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        5.50 ± 17%    +390.9%      27.00 ± 56%  perf-c2c.DRAM.local
>>      388.50 ± 10%    +114.7%     834.17 ± 33%  perf-c2c.DRAM.remote
>>        1214 ± 13%    +107.3%       2517 ± 31%  perf-c2c.HITM.local
>>      135.00 ± 19%    +130.9%     311.67 ± 32%  perf-c2c.HITM.remote
>>        1349 ± 13%    +109.6%       2829 ± 31%  perf-c2c.HITM.total
> Yeah this also looks pretty consistent too...
>
> Yikes.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1633ACCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 14:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205518E000A; Tue,  7 Oct 2025 10:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5A58E0005; Tue,  7 Oct 2025 10:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057058E000A; Tue,  7 Oct 2025 10:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E54978E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:59:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8249D1601F2
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 14:59:46 +0000 (UTC)
X-FDA: 83971627572.16.956CA4E
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012004.outbound.protection.outlook.com [40.107.209.4])
	by imf28.hostedemail.com (Postfix) with ESMTP id A728EC0006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 14:59:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FMSu1r9M;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759849183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnSoUVRexjhCfTga5UVvG1BNNgOYD4rNaVlAUotccxs=;
	b=VUSBgp7PnUTP3AtAYyI4Gfz/If6QpV3QsQlTdNNGYkqY0HKWwlmW7BPt8YG+6RrYU8PvTj
	79Ac4MB0XKlFwZxXTC+lH78XoOFifxfZGxqWszlW3Gm6qIbjWYX/0unWwAII61LlbuQHpL
	wfY7MFWCeA7FR9z16u5OfVbkDYbzJnE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FMSu1r9M;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759849183; a=rsa-sha256;
	cv=pass;
	b=OZaXrBalhAduAFfJ8sJYcD9YzIcEK1iFta1Ptq4sKRtfq4THEBgjbxf0toQZJgYWt2ns8M
	Y2uvzawjrSvqva58nsl0EGKClURYt9tVFaGyGZSkA7OUDVh+XCNNYynkj63KFBDQP3ebx0
	JPnZg/I1BOwt6vaFiH30KLQHCjXEG+Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpdP558qbYXZvPolHztrgpBTUR5Dp1aywtO20UT18azaRMFPM5M6Ls+8p5Zzy4hOkky5iWPI/InYtXj1OB6ymrVcJ598Kif8qI8DMofNOv4mlTuWBCj7OWn5tTIMDRm1VkszesBwfzpIXX4b9InHukJ4sOFcPxdjzmRa+HsiXh6NCFcPqqxnolISAhBGAuX197rhY47GP95F/zgBlzphM14nJ9qrRhSJrz7tM+i+dv2cqKNcxNkWlF7EmcCF2E0ClPrk/I0l/zh9AIP2OUC0qn9zyHw75gt4dIaStdKbwXDxE7yklYkKGXJ2fVlRppmEJ1R2UOPTZfPAwAVxazG2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnSoUVRexjhCfTga5UVvG1BNNgOYD4rNaVlAUotccxs=;
 b=y/C5tII4BOnCefbSoywPzl2qm36f5ANclv/05X26SHOIxvkmR9Nb/U5+DirhMzRD3Th+UXZth5iDR9Av4WXrYTXLq3WoHO+tS7x7Xg2f2Q9VsweVTO00ms7Wv8SIx5MRSW4+vkzY6LpSdeO2cd+3BtdSpKiR03k5Y/tYm3UKJUKYVKpGQ7zoedEheLl+0Hq+4fxzq+BHeoqvRhAmnBSkh5G/bZperv3yAFUjveKw0ggclwtrR8TAri6yHtkTjCmAjDfzCVpZwxr4JuVEhXG9W6cGwLbZiVYOszqacuQvoEAdOCSc0JJMrRcWJ/Dlufst2vnv/jRO0Ey+IcZ3Z941gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnSoUVRexjhCfTga5UVvG1BNNgOYD4rNaVlAUotccxs=;
 b=FMSu1r9MSTan4XBjk9x8OcQ0+y3QFGboi/arba4oRbzbnRrZRfH0ovmCIoD12bZAbWzeeOxFs2iAnJRjGORIYCuaZ07E2g5sdyzXg9lOHv8ZSYWb3HVXjlT3bcReJlejg7ojpbbGIlJt5H3xeWiLo/PpraWBtk1z2qxY/Kqvu3kA39MQPx3rj8ab2NjKEUUi8GblGeCGmNfLs8jgpE2F1o2HBbxr7sGQo5Y/9m8EwKfquowdwYxuRPpwwJm7697cw5oBcxgwAQaRctYnMfEVAEVqI+2h1PLi9QTWA95JjopvMZY65yIFCFoxkBvl00ME6V17GXt+873C4vSbIhjsgg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 14:59:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 14:59:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 Usama Arif <usamaarif642@gmail.com>, baolin.wang@linux.alibaba.com,
 Matthew Wilcox <willy@infradead.org>, david@redhat.com,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, npache@redhat.com,
 baohua@kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
Date: Tue, 07 Oct 2025 10:59:33 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <69B96963-AA57-4042-B00E-59260CB2514F@nvidia.com>
In-Reply-To: <b2a474e3-58a0-45f1-8015-46b30c2d0660@arm.com>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
 <ed17533d-912c-46a1-8407-29fd989f22b3@arm.com>
 <6253b463-bdbf-4c79-b1a7-65860b76beb4@arm.com>
 <e0566f96-09f7-406a-8c7f-da6dc476cd60@linux.dev>
 <b2a474e3-58a0-45f1-8015-46b30c2d0660@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0494.namprd03.prod.outlook.com
 (2603:10b6:408:130::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a400466-039d-41bb-241d-08de05b2214c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkRSSmZERk10cVNlOTN0NnBYTkd1YmJselpvUC83UEwyQXJKNVA0bU1GNmQy?=
 =?utf-8?B?cnBpMldwczJIaVF5RkVYUkF4VG5XbXNjZUl2dWVmSEtpbFc0d1l5MUMwdDZU?=
 =?utf-8?B?SWhtSkI5MFh2cWtMelYyZWtvMm05Y3o4R3Fpb01raGc5S1lkUGhpbG43V09E?=
 =?utf-8?B?aUJqM00xa0RlSVd2akZDbi96YnJwblVzWHZTSHNDWHhNb2pMUUoxSUZiZE5E?=
 =?utf-8?B?dWRDd1RPdkNqY3o2WVYrN2kxdUROZ20yUlYwZlIwc1l5SjZTSWlRNG1IRzJj?=
 =?utf-8?B?ZmFYNW41QUp3c3QzdURwSkJPZGFadmUyWTlIUlREb0pXanMzbytoMXFSRElH?=
 =?utf-8?B?aXpxMzd5azNlclh4dEFrU2tZL2Zjd1Y4d3ZBV3NURVlGVmhud3RuNnJXYkg4?=
 =?utf-8?B?TUJjQ1cwR05NWHRuS29weGhXeVBiK2J5Z3hGZHd1eHoybmtrRmFVeHZzdXZH?=
 =?utf-8?B?Vk5SNy9RSUZsVHR5MFpKUFdnTEJXTi9zeUFrN3RvRklPWE5BV1NBU0tzOUE4?=
 =?utf-8?B?ZGlDdDJSVzAybWJOZTB2bjhsbHkwaVF1NkV3OEduU0lKWFQxRmpsbWpiTnZp?=
 =?utf-8?B?SVRwTXdWdnQ2bldEZUx3YmdXMHE4K0RrU0p6eldaN0JHZTBJSlVaSjQ0aTRZ?=
 =?utf-8?B?SXUvbzVMalgwUGNzV21CODhOL1dqRHZzanJuWmw5R1Y3YktoenoyeWo1ekQy?=
 =?utf-8?B?QjFvaGdRaTlkeUZhc2l6NG9HK0w3enZ6NURzL0JXNUlHWlc3UnUzbk1UVzVN?=
 =?utf-8?B?MFRPT3lSYmJPTE9UUDFXMmlCbyszL2NtY1gvZmp0c1JuZjNBOEdpS3dpQnI0?=
 =?utf-8?B?enhHQ1p2elZmZ3BXNGdKUytXQ1M0T09NYUdhT1hzUnVHODdFeUQxUENobE5w?=
 =?utf-8?B?UUd2c0ZqRmxxcmhJaU5YaldxaXZqNWNmQmRQLzlDbVJhdk5LVXNNZlRwOXVx?=
 =?utf-8?B?d1pwTFRKYWpTZ081eWNUbG1Ec05vYmZaU09QeENGZllYc0Y1TkxUOUlPY2ow?=
 =?utf-8?B?YUY5QTlTVGVOSEVUclUvVjI3Z2VTY09Wa1gvcitnTm0rQ05tQW1hZ1hIS29a?=
 =?utf-8?B?bEdCMVdFdG5PMzhEYzFvSzQ2NEFvT1U2SldOWSt0TnA0SlVUZklkWHdmVXpu?=
 =?utf-8?B?bjVGVW80WWkvNGFJNC9LUHgvKzl3L2tsSFVJeEVCS3RxSTlWZ1MzODYreVhj?=
 =?utf-8?B?dE91Nm1XMmJoSzhuN01KeDVZTXVNSEJqZ0N0Y0w0RDh2L0VOZ1Zocm03NldZ?=
 =?utf-8?B?TWFYT29EeTk4ZTVqbTZ5RzlrREgyVXJiZmRJa1dRK1kzWC9rZy9YaDNreVhF?=
 =?utf-8?B?bEhpK0hKV0VUanJqd3ozNGRJY094c3phNUs3NmJ5MGdFaDdWSVVFdkpQNUk1?=
 =?utf-8?B?L1ZkMk5mYm9IQXVoNWdXbWxPM2x5YmFTRUlEZUduT3grcldOK3JRcU5adW5X?=
 =?utf-8?B?ZjJ5MU9LY3V6bWFLWmdhZFIzQkpUTFFqeWVQT3Q0ZzlHMHN4MldPUHlGQm9k?=
 =?utf-8?B?OXNSbVY0dWRqRkpIYWZFNzdPQzRpckl4aXRZcHdaNGtuNlBCUGlNWXI1WHkr?=
 =?utf-8?B?cVlIY0V6YVFjWVZYcG1DM0NlaER4KytXYlp1ZVRWNk9PMm1MSkpxM0ZucnFC?=
 =?utf-8?B?SEptWlZrWkdnTmZFQytjY21UUVZ6MUxNKzhqZ3ZVOStaZWkzTk5tKzZzeWJM?=
 =?utf-8?B?R1ozNE8rc2k0THd1OFJ4UDV1SzJRRU92U2F4NXRmRHNjNnNQNHFYVkNlR3h3?=
 =?utf-8?B?NFFJUWluWWJjUjFjVmJHVlltWmNraXJLUDRVU2hhcWtkeFJVY3pHdjZXZ1NG?=
 =?utf-8?B?MVEzbzVNRnVaTjEvQjdrV0RsQTBhbnNacHJIZFFjcmQ5U2JxQVcyRXZ4SFJ4?=
 =?utf-8?B?L1RvRDFhY1RTMEFoLzF0NHB0bElDS29LME84RGYyWEw3bUtqNUxDNklNRWlO?=
 =?utf-8?B?WTloNTFiKytFclduR0FiUHBZbG53OFZTRGwrVG9RMU9xb01XZkN1N0JiR1Jx?=
 =?utf-8?B?Q0MzaFhRb1RRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEZTYzhuSTkzdHV5R1NCcjg5ZzNxRFVEeTNTaFRzcDdPa1VQUlNuRDRldTZj?=
 =?utf-8?B?RkNuNFA4VCtEQnVLS3BnNDhjOFNMWlhsK3g3OEhydmZUbGlqb2k5U2dNZCsx?=
 =?utf-8?B?cm1JVm1MamxGd2twR0tFRDBiTGtOTlFsQzAyTTNzTkwxdnV2RS90eG5tKyta?=
 =?utf-8?B?YTZ2MWU1K0UwRE1MdmZVeXJhRW13NVNjKzVDTU0yazFvaTM1cmZIRXVKK3dI?=
 =?utf-8?B?Ky9zRTYwOVFCSzFLaGFUK3c5RFZTNUx5ZlhsRldCanB1QWpJQ1FLL0IyT3Jw?=
 =?utf-8?B?dFdSODZBME5vVHBrU1A3NXlhem5tTUU4dVcwSkl4ODAxY2xEOWRLSTh0TTJu?=
 =?utf-8?B?UFZiSXU3TENvNUJoRGxvVVJEa1o3SWFmcmpyQTVidmhFYTBJdWY0VEhJUytR?=
 =?utf-8?B?T3Bhb1lLeFZqOTJHVTEyQzNRcnVicktDOW9ieWpjRytQTW9WNXduOTBOTDdw?=
 =?utf-8?B?eFNhMDlwakpFcG11Q2kwNitDSTZ3TlFTV1RSaVhSSWo1dlh4UmdYNG1NSXdU?=
 =?utf-8?B?b3dXNWdWVlVnZ2tjOVQzWmdYRmVIM1ZJWCtNcVNia0QyS3hyVHdHZ0VzYytO?=
 =?utf-8?B?NTUzQlBzZkN6NE52dXhmUWVTTjJSZWRNL3krcFphNWRIM0xJZjdJVlZhVWJo?=
 =?utf-8?B?SlhJZk9rNlNzSDFqQ1RqcU1VVlFWekdjaU5zNzZyaVRvTWIvemx3SzcybnNG?=
 =?utf-8?B?ZDdrWmFDQkIvNmtLUzlCNGw4ZTFvSXhsUmNUa2N2TEFXU0ZOYkJQUHd4SEdO?=
 =?utf-8?B?VFJDV3RMVW5CRnpYSnRhOGpwQk1kUzVUSlRFZys5WWVNak4rOTdTdkdCeDhQ?=
 =?utf-8?B?S1A5bFYyMkV0U0lzRFV2MmZONnhUbHJzVWZUbEpHSFltc21PNjYyd0ttdzJk?=
 =?utf-8?B?a1lsSGR0QXdaTUJ4OGpueThUNk1HVzdZQ2lRTHBFK2hzOUtnRnRxRXBpTk5a?=
 =?utf-8?B?S1Q3emUrTnBmRDAxUlhGeHpqMHhrelByQnZrZlk4MHptQStBU2lCQ1ZCTy9S?=
 =?utf-8?B?YWlhM0VGRDA3T1J4NGxMYzAvZ0V4R2dkZzFhOEVyRnlOU0UydHV2aTNvMDls?=
 =?utf-8?B?dk9ySXc2blUxbFJrcDdFaGZNTGNFOTREKzFkcStFTC9wS0lSMlc1RStpN3BL?=
 =?utf-8?B?alhXeWc4NXRISVBBUmdpWWh4SVpaQlk0dUE1QlMyeCt1NWxVeDI4RndaZnpp?=
 =?utf-8?B?SzkwZUxLWHhUQ0V5cm9Rc2JTQTMxMldFUFRraTlaa2w5QmxvbzJ6cENWK095?=
 =?utf-8?B?QlFkNTJoZ0dXRVpvMC9uUFBhNEpTNWVLRjZzdVZaQVlSMzlyRlI0eGNkbE1Y?=
 =?utf-8?B?bGNvZ2VhbXExZmVzZVVodFZCYS9qbkJnQjlXVU9FbFcyZks3WjM5My9EUFFR?=
 =?utf-8?B?bXRWZk1hTUtoQmpTUjRnS3BzWGY0YTB2VE9hSEI3UlB1dHVFNFpNZUF5ekZF?=
 =?utf-8?B?VHNzbWdxUUk5aWFTZmUyTU4zTXByN2x1aUpUMGhTeno0MWFQZFpTNHV6eE1r?=
 =?utf-8?B?SnFmUnpqbDlNMWR6Y1kyVlNNaDVCT1AzakQwRVJXTE1jTnpPWW1ZTUlsVkFP?=
 =?utf-8?B?cUVWMytFQ21BWXpSUHhHM1VsT2pPSjI2Wlp5YnludmlPNkN1QStIdUc2a3B0?=
 =?utf-8?B?cEltUEsxTzhMSU4vR0VqK1ZwVmZXSE5QY0txM3pzSXBQQjh4N0pCdVo0Tnds?=
 =?utf-8?B?dngyTmxyWVV4a3dZUjAvbHIrcVdvMGJmQzB4cDZmUnF4ZEo4TlBaclErRTVq?=
 =?utf-8?B?M3Q5akd4aWF2RnIxZmZIRFBwZWc5Rmd3bmVJL2U4RWhsNUF3SS9vaXJRWWdC?=
 =?utf-8?B?UXM3SnhmS2JCd0dIWW1HekxaYkl0OHdPS2dpNGhFTkgzUk4zK0ZDa2xzSkpF?=
 =?utf-8?B?KzRUbndwUWZsSkxIbWllaVJvKzRLZFlyenBXdmtRYkprZTJhMWw4ZDRtclBV?=
 =?utf-8?B?Rmk2SnhNRXdkVndLT01RcDRDSjQrQ3F1VUJFVmVlSXUxUEhZWmxiVGNLNHBQ?=
 =?utf-8?B?c1lJT1BjdXczelNzTkRiRUpCeE9KbHRwTHFqZFZBMmFXNWh0Nm85Sm92cHgz?=
 =?utf-8?B?aUtEamdWdlNJU1l5Sklrdld6aFFFYnkzcU5FTTExb0dTRzFUMVpaUndwanVi?=
 =?utf-8?Q?zp/PEKTXlyFryepUAHVn6/hvm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a400466-039d-41bb-241d-08de05b2214c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 14:59:35.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfvX9tQUT9RFk4sVvPm6nqNCsPO8jIfVn6gcNgToiFw5tpFWB4KJJ9sAifM9gtus
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5712
X-Rspam-User: 
X-Rspamd-Queue-Id: A728EC0006
X-Rspamd-Server: rspam03
X-Stat-Signature: m46ofsqaozo3nib4ghfrzc3f368cbtyj
X-HE-Tag: 1759849183-672674
X-HE-Meta: U2FsdGVkX19DTBfkCV5OtPIL6ZN5Gpg3tavkwXxCWDkiDMOtgsU7gh9+xZCP1Y3h/HtCMD1uyf/adJgGohbYcHIp38Ckmu7WGXyEFZ2qDuuOZR8miy7cYNt3xTogXkBCx5mQawrU8SVZsI2UYNDMQDIjnJFjyUsIP2xIgucjmRYaD1RwfHLXCK+bQqWf1NoyahEqDIFkLHO2ARhFwf3mM+L56+BpF/b9/Xw2rBgRC3EIwN5e3/EhaSuhL26l8m/CDVPzSyguGcXDiQWLlJkWBM0fHxoa5Qq4xILwnIYrUBwK0Od9d5PkNvSJYqXd9ALbEZ904u0cF34WQifRa0cJQbspAny7Z/LeefV4ec+0fV6IJgAKOd9dmtdIkGxemTPCSD4k1NlMXm+ahZhwBWmVB5snMmtmLWMbT6sqsGgT5JIIL7GtnzF8LcuLqK8oZ6S4RbcL9eySGDG7JAyD/wKReTKofsgcVlNsva7nvPCKtgyo8MmBAmPZjYT3XRbdNIZNH+ZpCv3trpVD8ERoqplPmNR4srIKgaoZFRJp11cjvbXLZRa0Tmj2ST23Q9v63bkGAfFU6YR3nbrYcGdxoNyMqW9vA/qS0DBuf2zSX7rePGPpyWkZLFTxqk+VTALyYP0JYzXXpHuF00ycC8n9lum0M2RFurVDuH2RVoYpsaW8I415yjP4ZLBS+hA+FcJHf22xpF949D5LUcpinIOpzdm+2UxH4tZBBIZFR6yvO3AS5SkKez1IJ59l/pyphkoYNw+RffoeKh01GMyhRZo0UewOfTccfgP3xwTzklVhHaJ2AIFCcPtGS5KQuMLm+ennfVmXd78eP2eYDcw0arhRNxKcky3uCB7d8Km9aR6ND0GJJ6iRnvMPFevm8IP0tz/1W03Hh4UG2G3OHnE8gLxGQUVoZBvei4S9TvDPOohsN8Lpf1Y+cOnqMoGlsXBAnBJ2pasz7Hit55T5cX65o20wQoA
 Mi4l9DwZ
 9Pt+W/J1T3hkMKkLZVrYw7zxA/cON4VgZ8Xw+XcYEP1yZcuTRFYUIAvs4pToKgzj7IKO+uHRF0HMqvR4Q4Fgi6HzYMulDsXwbaXeJRi3B5ruQ3hrG4MhedfUG08T9ltpVs2XipzacGd+A37JLi1NWWe0d8fjHIEsbBwQAs07p8naL8ik94QUSyX5RMiK3JkycRtm1XuZFl6QT8GwEOfIColFkCKRRPInHH+fjlEvH7QKAzL4J4qnM1/jmLp839P9cKyxFq/1EnKsm/ylyVFw/qpfvLN9o7uUr0jZ91kZvE/M4j2RTAjKXlRhn2N/edaOeEk8XSOr67dKXn1J44sBnB4whVcgZiXvv2JIFsDMiedNPy+g/JRU+p83sWqeuxRatHHtmC5QRxgNiHTLCrwQfWS+CiVoralAaPFtSkkZPLgZ1utNd1LAYQqyp3Tt2FH5Zg28F7P+SgKRA8TB/yyj6LVQXZyVyQOj47YZ9kzfIilKaSPtufqgmDtcPb61jPTWee7ssZQAIT3/MVCbT6NOKoFYBCXCFsMs3FosR5HeVi5k5xxzQiB//S94TMgnnmMZy4jZ+Z17f4H3uWZFO6GzaDEzOZFpo91bqy9MkBQllmX4WQHMNnmr0ti1S5s2KKZ3czeFrLTXIx/WDFtFzLhSy74JQ8v76rZo6VZJATEov+A/1yMGgO8gEJoDi7YhEAeGpzOWY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Oct 2025, at 9:11, Dev Jain wrote:

> On 07/10/25 5:54 pm, Lance Yang wrote:
>>
>>
>> On 2025/10/7 17:54, Dev Jain wrote:
>>>
>>> On 07/10/25 9:36 am, Anshuman Khandual wrote:
>>>>
>>>> On 07/10/25 6:20 AM, Wei Yang wrote:
>>>>> Currently we install pmd folio with map_anon_folio_pmd() in
>>>>> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
>>>>> collapse_huge_page(), it is done with identical code except statistic=
s
>>>>> adjustment.
>>>>>
>>>>> Unify the process with map_anon_folio_pmd() to install pmd folio. Spl=
it
>>>>> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be use=
d
>>>>> in page fault or not respectively.
>>>>>
>>>>> No functional change is intended.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: Usama Arif <usamaarif642@gmail.com>
>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>
>>>>> ---
>>>>> v2:
>>>>> =C2=A0=C2=A0 * split to map_anon_folio_pmd_[no]pf() suggested by Matt=
hew
>>>> On which branch this patch applies against ?
>>>
>>> +1, does not apply on mm-new for me. There have been multiple patches
>>> changing the same file so it will be beneficial to say what commit
>>> it applies against.
>>
>> I think this patch applies on top of the patch[1], which is based on mm-=
new.
>>
>> [1] https://lore.kernel.org/linux-mm/20251002013825.20448-1-richard.weiy=
ang@gmail.com
>
> Thanks, but this is not yet in mm-new. There are some unaddressed comment=
s there.
>
> Wei, please resend this patch based on mm-new. I would urge you to hold o=
ff sending
>
> multiple patches all of which change the same file and have close depende=
ncy, till the
>
> first one gets merged.

Or just send both patches in a series to show the dependency. That makes
reviewers=E2=80=99 lives much easier.

Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57745C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 07:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EE76B007B; Tue, 28 Jul 2026 03:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5C36B0088; Tue, 28 Jul 2026 03:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADCA6B008A; Tue, 28 Jul 2026 03:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C51166B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:47:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BF2B1A0305
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:47:24 +0000 (UTC)
X-FDA: 85037405208.17.273C5D8
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013062.outbound.protection.outlook.com [40.93.196.62])
	by imf19.hostedemail.com (Postfix) with ESMTP id 26CBF1A0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:47:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dlut1nBg;
	spf=pass (imf19.hostedemail.com: domain of ecourtney@nvidia.com designates 40.93.196.62 as permitted sender) smtp.mailfrom=ecourtney@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785224841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXcEYA74erMdxXXS4SBWDPqPqDOX5eaOo4ty1URnyiM=;
	b=f5XvoPY2Sr40EeuxRs1fCjZm0CoDGOW5s/xy3nT1uboQ/3mhCRM378Oex3qnaIlMDv1uML
	x2BivmJad2VG+I4cg6PlNGH7T4vNCnec8ZCpJ2ReyzKxDJQ0FN9Re3zYsjnYcW6JIANulv
	BMnsgt5taNxu7RVxb4INjtAiTOhQHd0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785224841;
	b=It8lPilUff6WpYz24aOt01ZT+R9arJJJ6Y3mbI4hEn5Bb3D0z/vvfdUlkBayqyy9NB2bXT
	H4ToYFuSKfjl6ins3W2QmMunndU79ihUvuiopCK7Su087Mzja1nSyYnMvp4q+qMrauFrO9
	+kvnmm7HNlEHnbW/Z7BY2THcMgwCDb4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dlut1nBg;
	spf=pass (imf19.hostedemail.com: domain of ecourtney@nvidia.com designates 40.93.196.62 as permitted sender) smtp.mailfrom=ecourtney@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d+o3zMoB7mfoQD/f6Qk+GwwqAoApFMl+RzyCvLM6FzaKreEglyAdWNSw91sMLMi1G99nHhWyrXbTrnNBPS2NIUwmoZ+rqdcefgDunIl+h9/kcD6LuqfAAE3Rg3RpQHATXrc5GVU8HRjNSK8ZIP+SmG8HLPlwGKGhzSlgh2mFeNu03YBTass07nNqnjIw/ux+OQ/q7hzrRJhc1QRB9DStQ7/hxOSP44XDoY93SMx4QMBlUxgjBRt+5DhrZAmXzAzrhdz42RAGsDZeyfoCtCc0IlePgkCznL7ZpY1Dzc3o2gjp9kRUQ7/np48rCsAXbxcW+k9LkfB+bZr5d6RNutNoBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXcEYA74erMdxXXS4SBWDPqPqDOX5eaOo4ty1URnyiM=;
 b=FMjq6kYvppVdJal79CogcBSQaqpkqMnFJLxqRh7lyVCtibE1A4AaLnzYLLG9rsvF13vLytNlFzTajROKujCYAUS+PfPfn1Mf5qqHl5B9Li8GqXiEsF+QipAFCmQpi4em5rLa8CbBOqYC4mq28TXN+4tDhIcMRqKvPcHdI0NSNXamJPrU4lKHYBSTuTnk30eONrX/LOFguXmJA84SOkeS+1FuMlww/umnMIkPulqlBnNJOQTQQEUit0v10mI+/SQcjzAy2WUKnrNJEhlaruqykejZpMeFPw+k4JMZC0A7Q9GKyiQBBOs1iHb0sOOgpCNywXgO0A0FWnHTugT91Wkjkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXcEYA74erMdxXXS4SBWDPqPqDOX5eaOo4ty1URnyiM=;
 b=Dlut1nBgw6M8EVYbyn4XkRRFUzE2sYYboL0JSjF/uEKqiGbddlv5X7s31xYPUd0Bvv7baHsxK4FcwblpnUIMg9aq7dEGKjKAVCd6m04S1W/HM/XhkQPuofyoegMlOqHfCLaGYyebUvMcD6jSkSxwMv5BcUKVemAxnW31CJtpX02Hazz3h7SI/mmMAexrGO65n1ndCVdIfqu+dXmuk5daLfX00jgLImrTOJSX0Sg+nbaBhDr851UuWu9u+8N2Q5KVxWUNXMVy92/xjZrKLmYUPBwOzyXFS6Sfjf1d0pjq0Z0Co3sdAduOTLygkiGKtZM1gWCtZ+g+Nejay90lQmuOgA==
Received: from SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23)
 by PH0PR12MB7983.namprd12.prod.outlook.com (2603:10b6:510:28e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 07:47:15 +0000
Received: from SN1PR12MB2368.namprd12.prod.outlook.com
 ([fe80::281e:52ee:b18e:ad42]) by SN1PR12MB2368.namprd12.prod.outlook.com
 ([fe80::281e:52ee:b18e:ad42%7]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 07:47:15 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Jul 2026 16:47:11 +0900
Message-Id: <DKA1DXLJ0GPY.1BHVPUJT6JIGM@nvidia.com>
Cc: "Alexandre Courbot" <acourbot@nvidia.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Benno Lossin" <lossin@kernel.org>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Boqun Feng"
 <boqun@kernel.org>, "Daniel Almeida" <daniel.almeida@collabora.com>,
 "Danilo Krummrich" <dakr@kernel.org>, "David Airlie" <airlied@gmail.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Rasmus Villemoes"
 <linux@rasmusvillemoes.dk>, "Simona Vetter" <simona@ffwll.ch>, "Tamir
 Duberstein" <tamird@kernel.org>, "Timur Tabi" <ttabi@nvidia.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Yury Norov" <yury.norov@gmail.com>, "Zhi Wang"
 <zhiw@nvidia.com>, <maple-tree@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <nova-gpu@lists.linux.dev>,
 <dri-devel@lists.freedesktop.org>, <rust-for-linux@vger.kernel.org>,
 "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
Subject: Re: [PATCH v3] lib: test bitmap vs IDA vs Maple Tree performance
 for region allocations
From: "Eliot Courtney" <ecourtney@nvidia.com>
To: "Yury Norov" <ynorov@nvidia.com>, "Eliot Courtney"
 <ecourtney@nvidia.com>, "Greg KH" <gregkh@linuxfoundation.org>, "Burak
 Emir" <bqe@google.com>, "John Hubbard" <jhubbard@nvidia.com>, "Alice Ryhl"
 <aliceryhl@google.com>, "Liam R . Howlett" <liam@infradead.org>, "Andrew
 Ballance" <andrewjballance@gmail.com>, "Matthew Wilcox"
 <willy@infradead.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Pedro Falcato"
 <pfalcato@suse.de>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260717053241.916441-1-ynorov@nvidia.com>
In-Reply-To: <20260717053241.916441-1-ynorov@nvidia.com>
X-ClientProxiedBy: TYCP286CA0028.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::15) To SN1PR12MB2368.namprd12.prod.outlook.com
 (2603:10b6:802:32::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:EE_|PH0PR12MB7983:EE_
X-MS-Office365-Filtering-Correlation-Id: ba221ca7-af5c-43cd-a852-08deec7c70db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|10070799003|23010399003|921020|6133799003|11063799006|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1nfc4W3wM8zDz6JES9DcIxfPnGP9KQcUP7y8Tsy423UvzuZlfLmcBwORINYKfhknUsE9+odT32RKDGmscdot5IbSEIE1Mr5GWTpeV3azaDiaLsQwqhYyuWl1FUouzkX6ilWnMfzHcl2blLHEdjz8JKZUVZ7UrA/RALbplCIdVLFUhfipsOR3KOBKKueS+iEL/+9cHKto9IoUMYzMZJHAziuiCUzCv3hfX8GpLdOFYaAqOamFWui88SHqOFSOVW2+Q82yzD9LGo3UBmsZyB97GHYFQ2g42RaIO8mHwnZftH4X0KMZ4EHjDSCevz9xQytUSa9yJOqxitEFeHMbNNaIAdaRnKJTB9tia8+zS8OUbgoThjg2X0zif8aOpzH1fQMcq4bAZHwgHw70pE1l13ARGwCDAG8Y31GHJA0m1O884/ZhtypxvvD7+e71kaGeAXSk5sEgQ2ZlloFZOR94QaqFIltqcRLxKS/kHVqvwyKSIkCqvJnt14Jp/KFmjsT4ZpMys8yDdK1pL4MtV/Xh1a6MhhZgiIimPn0UwzPG5Jm0k4DMolHkuL+rbQ5IDcjuPABJzkuonehKSiJ2sGH1AWZ19NxEHO6vK/26m1U7r4Q8TMANgdZDIgNnoAQ8UGLv6AXgC/TMTRrgljF5Qp/rSSaW+HL9vHEsNIgeb1BEloTUeAovVt4a4MfkYe6c3rMjeuhBenOa4IClYcviVppbQuRVMw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2368.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(10070799003)(23010399003)(921020)(6133799003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHV3bDRzNTRMM3JpWW1HVUd4aW01SGpsUW44R1Z4UWpsSGY3Ri9sZGVIa2dZ?=
 =?utf-8?B?UEROSXRzeDNoVTBGTk85WTMrZEt1MmZ3ZmlTUys5UkVxRUVtWWFKeTFTZUR1?=
 =?utf-8?B?VUN3cCtoc0lDN0pKVjhveGhCNGNpenNzQnB4TGQ3QUltUlRxSGpiaXlCT2tT?=
 =?utf-8?B?aUZzRFlPeEFaQ3k2ZXFOV3RIQXk1TDNZbTZJZ3o1RFd2eU9NVkxESzV5TmU4?=
 =?utf-8?B?RDFweElHeExBMCs2N085ZW1SalE3Vi9JSVR2UWdwd3BsaXlkQWpFM3lGa2FH?=
 =?utf-8?B?OExzVXY0UWZFdVFSak9kVWhma2lNR0ZIK2c2Z2hBVnhmb0lVTTdRYjhEZVBE?=
 =?utf-8?B?RWR1eEFZcUxmKzlubDhoL3JlVkRSaEtKcTQ4STcyZU5qSkNMODc2dFlYckxJ?=
 =?utf-8?B?aTQ0eUppRUlpR0NPMVR3V25DQWFrdWx1OWg3K21sN3Y3UGpNT2JpMTlMd3Bh?=
 =?utf-8?B?OWFaTE9zNFQwQUJJQzhtVmlWdDJJalJCNjh1RlNlbnNiRFdvdUh4cGRqQ1Rt?=
 =?utf-8?B?L1lwUkpzYVNjQlpFQmdCRTlidmhKWm02elM2bmpnVlAySVQ3emlERWI5TVBy?=
 =?utf-8?B?RnUrcXdMYVJlQy8wQUJxVWhJSi9WK1JVSmRWc3pSTlBxZldISVZWRy9kMEFN?=
 =?utf-8?B?cFRhY0ExbUplckRpckRiU3dNc1JMT0MvbThZeUU1OGNraE5kKzRPMDY0SjFx?=
 =?utf-8?B?eUFWQTVacG14OFAwRVhWZzRSYmtyczB3Y2YzMnBEOS9oNVlYYTBGMzRZNGFO?=
 =?utf-8?B?eVlFYUFCd2N3K2s1bWlpSWlKaXZ0OHZySkErZjBsbnFHNGJ3bkN2ekFHUkQy?=
 =?utf-8?B?ZGlxeDU4UWMvR2svc0VzZGlCQTJFcHJMUlVoOCs2Y1E4cFNvMzlGTXBGVG1K?=
 =?utf-8?B?L29yZ3lwemthZGkvc1JkTEdZaDQzcU5aS095Sk44YmozeW90Y3RRTjhMQkFS?=
 =?utf-8?B?bGVyem1hM09PdnA4LzBqRXJ5WnEvRmRadkMwbXZiQ21vd2hIU05NUlJmdEdH?=
 =?utf-8?B?Ny9sWWRoY293T3I5ZW4ydWxkaGpRY2NwRmt5RGRMVXJQSzNkUXFuU1JvNWl5?=
 =?utf-8?B?WTNURyswWGd3Nk5ITm5lcXpOdHBaa1I3K3hSNytrNDNRdVpmZ0ljcnZhZyts?=
 =?utf-8?B?RkdBTy91U0RXb3Nud0pna2NqSTA2bFBabVNQV3VXUVpzeU13bFdha0laWW53?=
 =?utf-8?B?YUJQdGlweXNyckMwVkptQVNIKzBvR0Vjbk5JR3VEdzJrZ1lzWU55Q0JIaFJx?=
 =?utf-8?B?akJqcHgvcm96K2xaNXFtRnJ5U2J3YnhkcU1Hdlh5SUR6MzdkV3MydWFaMGVW?=
 =?utf-8?B?M3RhV2dnZG9JcFRJeVRKc1FLRnM1a2FHekVYU2FZc0psNmtXenQxT2tqS1Zy?=
 =?utf-8?B?d1M4VEJXaktaUDRsekNvK0RPa3ZvdmtXMWxxK0RkR3VTQjg5MGhWdjN6aTRL?=
 =?utf-8?B?VG9QenFndnE5c3pjTVdiVEhUMTBVb3lwZm5SeGdDTkJ0RXhNQ01Sbnk0eGpz?=
 =?utf-8?B?YkZxZkNTZ0RtR25yWm1HaEdnaFd1ZHlnNzFkbHdKcllub09XaUhPRDRFZENF?=
 =?utf-8?B?VHZBWmVnd0NzczJXeElTR2xSK2xRSDIrR0RrQ1oyMWRSWjM5RWF0NmRjcitF?=
 =?utf-8?B?Z2JnRSt4eENiUVpmdkcxSVFDemV0ZzAwZUpnMnVlUW84TVJqOG14TmFoa3dY?=
 =?utf-8?B?S0xLRk9IVEZ1SHZhNy9pdUd6TDVZZnVOTG9ISDdPa0FkZjI4TmtETmRLK2NY?=
 =?utf-8?B?MkNXdjBsZWhTdjMzY3hFYmdvY1ZlZVRoSXVvbWN4eE83RnNvLy92ZFV3VWRW?=
 =?utf-8?B?NG80ak1YZ1ByYVM2VkQ1WGduSXQvU05UTVFlWFlta2lPNkNmeUprQno4NGFT?=
 =?utf-8?B?Z0NwZnZZcUpKUmFpeGZQQ0VWTzBhME0xWGN5ektXTDgvaXkwalo1VXVoeWgy?=
 =?utf-8?B?Y1BMVHY3OFBWbG5vaER2Tkx3ZmRQN004bmZVNFM5L3FxdDBaV0FOMmFSVE50?=
 =?utf-8?B?MGVYMzBKMmljMnUza3RWUVlvQkdhRGRNNlo5WStxVnpjSDVxZk11UnRnMys0?=
 =?utf-8?B?eDBEUWordHczYWtsYmYvQitwa1BYVnNsenp1czRPMXBoSER3NXJaMmtMMmpI?=
 =?utf-8?B?V2tKMVRBVWk1T2d0L0w1SjMzY283Q2paWENUMGhNSVlac1dyMzlEcmgwK3FQ?=
 =?utf-8?B?RndVY2RHdVY3VHBDejQ3NlZ1aEFDaXVKUU1JR0pvdUdDc1I4a0JaSzMrenhq?=
 =?utf-8?B?Mi9GZWxYek5xMkgxWXBXOU5xQXVkUmJYVEVHTGJGeVdFclJoWW9KcGJtQlR0?=
 =?utf-8?B?Zng2QkRka3JTVExZclBIdVpZaDk2RDhmZURyWHhIV2FTTHNIdStpdHZORkRr?=
 =?utf-8?Q?V3qblhrOjcNX/Jlh+xXI8jgbiErBvsG/c12xenPERG+sx?=
X-MS-Exchange-AntiSpam-MessageData-1: an2MCaXIXY1VxQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba221ca7-af5c-43cd-a852-08deec7c70db
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2368.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 07:47:14.9142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XvckCa5HNrytV8AyHfx78kt/b6LlikENQKuaUeNUeBC63eSUSs88YHwzbz4B4cLVb4pENxiHAxZEmbZzM6mTTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7983
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26CBF1A0002
X-Stat-Signature: zxbzxpw1c65ue4scct7ocm7kfkiipnko
X-Rspam-User: 
X-HE-Tag: 1785224840-680831
X-HE-Meta: U2FsdGVkX19GjIN5hCzSvT4RQ/zxMJKOYJ4DfuVgYPlIeebCkoA2n2NmMjXV/B9B9Lnkw5yuW+eEP6AZvBKDWqZx/JpQrDpiFC1CWJp5hWNjapCs9Rj8Ug4R597F5c3RQjNovJ23/P1ylrrk5wNrWDn759fSSCOofjW/DdJFyaIQrNg204LvnLznU3zTknDmKFcsoMP3zffuL7OsK1+1hhLMzJ8C4Us8DOnGx0jRfiu070b2JZXH9PF3t/oMZCDPLAWCr9nb3QP97mOfpbpB/vmwXSRAmL2YJGNALYX++ir2fyztOEDeGeOC0DIFaZZRx5vTRS72Zq3QYVRlp9yfJFrkq7v1zxouqweI4kHgziHsKm12yHRuRkYAT/h1DXrMUI784DY2KOcM8ZGSNl3SdsW2mKna7LabUPofiIKBwJ0Engh3kZiwLGLA6VuW/v856A3Z2ZdyNt1k6kwyHyfxtRdwdfzxoD7MudK2BsiwpXtq4/GJNdAonXj6ATK1tMRqleL59Bhtq0h8c/fCWSEAyGSObXT55sZx5ydfvyvDzcum4/vqSkEQXLl3LgjKClRt/4rexkoTmTuZSx7Fc0v22PkOmktKZhPz733/jYUAmxir9G5VT7/+jhXDk391PZMqEWR5GtbgCrdYLeajROI1IiLOk2n5bzBYk2D4LbH6vjzQhYCXPYQqpuTe2jmIKu4LvwQQG85KOrtvFEH4jNpvx0mZ3CbyuAGKSq4jLXhY51+mrcWm8CBA9dXawKYqo9YAuCvVdH0a1JbfkgomafHxvGVN2Zha5GbT2QZcT1BoE1wW7ADlgK8ZRQgWk0B35wB0KCUkjc6zTf2pkqOt3q2mPXvtf6IDCaCXpxf4N1Mp3lkJWFxAYP1FH1K/aQLklfAampAhGBGEvAA/gry4DA3Z6P2Bu8x4027JQ5IldBqqq4eSz3aSalLkqDwok+bPIfLAc8P+BAshSM4wNQe2L29
 ctEHgfP8
 gxaZE4PQbUlYLXgIYIa4pYQn0/g1KcygOCRO1pTxbUdnuFWbI/ZpxY6EwmLf1Hve81cmXC6JsJcoSlPxt7d0NSxYq6KSa8W/6r7rC/pRGem+B12jRv8b64t89sHyC6h8iAtFv2MJQSLJ+1XdiGk/d2vyk0Js7f2R7XVmE1m5zQ7uu4kqa0Ho5JIX93PLb+/4h12v3hWo1mvjESuQ9dlY4NCorT89+NRI48ApIYbpljxPO0o2RDd3i1cY9ePZb81QVPALjuz3sN1lYk5ogQtoaC5YNjsDkFLKvOT9+WCkuMAm5VIxZm5gZfGYqyFbE+DeO2gXmVX2S25ZN5mO9CnFJ+fjbDR+QClY1Mz0vTwGPd2zfo8JqPw2mKiSKn8fExHbw9jDMbLb9XZ//yyZWW8Yt8IbxFv89/VNO3dQmA92JtVy/LQQ440olUPTkJp07YfHOiv7M1WwurbHCNbBYjL4yyIe61TJMK+5HfPNUF0u7vjCKxGb7gzH1jrKp1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 17, 2026 at 2:32 PM JST, Yury Norov wrote:
> Compare the cost of allocating and freeing variable-sized regions using
> a bitmap, IDA and a Maple Tree. All implementations process the same
> randomly generated sequence of regions containing up to 32 entries, until
> the configured capacity is exhausted.
>
> The benchmark exercises monotonic allocation into an initially empty pool=
,
> followed by reverse-order freeing. It does not model fragmentation or
> interleaved allocation and freeing, nor does it isolate locking or RCU
> overhead. Allocation time includes the terminal failed request that detec=
ts
> exhaustion.
>
> Run the benchmark at several capacities to show how the approaches scale.
> Report allocation and free times separately because bitmap, IDA and Maple
> Tree removal have substantially different costs.
>
> On x86/kvm, the output example is:
>
> Start testing bitmap vs IDA vs Maple Tree region allocation
> memory: bitmap is exact; IDA and Maple Tree are lower bounds
> Type      alloc (ns)     free (ns)   regions  capacity  memory (B)
> Bitmap      93457345        176151     60644   1000000      125000
> Maple       11758660      12870146     60644   1000000     1552656
> IDA         31066416      20870824     60644   1000000      134864
> Bitmap        919119         17679      6032    100000       12504
> Maple        1158193       1187140      6032    100000      154640
> IDA          2759670       2116004      6032    100000       14288
> Bitmap         17120          2043       613     10000        1256
> Maple         116350        117537       613     10000       15888
> IDA           243396        202654       613     10000        1872
> Bitmap          1220           262        55      1000         128
> Maple          12076         10106        55      1000        1552
> IDA            25730         20875        55      1000         144
> Bitmap           593           124        18       100          16
> Maple           3599          4782        18       100         528
> IDA             3266          1960        18       100         144
> Bitmap           414           129        10        10           8
> Maple           2143          1385        10        10         272
> IDA              892           648        10        10          16
> Region allocation benchmark complete
>
> Reported IDA and Maple Tree memory figures exclude slab overhead
> and transient allocations. The Maple Tree figure is additionally
> a lower-bound estimate that assumes fully occupied leaf nodes and
> excludes internal nodes.
>
> IDA has no region-allocation API, so each region is implemented as
> a sequence of single-ID allocations. The IDs remain contiguous
> because this benchmark fills an initially empty IDA monotonically.
>
> The benchmark is motivated by the discussion linked below about choosing
> the best data structure for the channel ID pool with the capacity of 2048
> IDs for the nova GPU driver.
>
> Specifically for 2048 IDs the result is:
>
> Bitmap          5112           615       121      2048         256
> Maple          78526         59592       121      2048        3344
> IDA           165274        117761       121      2048         848
>
> The benchmark accepts a list of up to 64 nonzero capacities to test.
> For example:
>
>   insmod region_alloc_benchmark.ko capacities=3D1024,2048,4096,65536
>
> The list may contain duplicate capacities. Each occurrence generates a ne=
w
> region-size sequence, which is useful for collecting statistical
> characteristics of the benchmark results.
>
> Link: https://lore.kernel.org/all/20260710-chid-maple-v1-1-4ee869055268@n=
vidia.com/
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
> v3:
> - allow capacities to be configured through the module parameter (Yury No=
rov)
> - document default and custom-capacity usage in Kconfig (Yury Norov)
> - store and generate only the region sizes required by each run (Yury Nor=
ov)
> - clarify the workload, timing semantics and memory estimates (Pedro Falc=
ato, Onur =C3=96zkan)
> - report region count and capacity while retaining raw timings (Gary Guo)
> - add post-free integrity checks (Yury Norov)
> - add default capacities of 10 and 100 IDs (Matthew Wilcox)
> - bound generated region sizes appropriately for small capacities (Matthe=
w Wilcox)
> - report successful completion and return -EAGAIN for repeat runs (Yury N=
orov)
> v2: https://lore.kernel.org/all/20260711063602.426311-1-ynorov@nvidia.com=
/
> v1: https://lore.kernel.org/all/20260711013910.349586-1-ynorov@nvidia.com=
/
>
>  MAINTAINERS                  |   3 +
>  lib/Kconfig.debug            |  13 +++
>  lib/Makefile                 |   1 +
>  lib/region_alloc_benchmark.c | 217 +++++++++++++++++++++++++++++++++++
>  4 files changed, 234 insertions(+)
>  create mode 100644 lib/region_alloc_benchmark.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7cc4bca5a2c5..9e487a94aba4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4615,6 +4615,7 @@ F:	lib/bitmap.c
>  F:	lib/cpumask.c
>  F:	lib/find_bit.c
>  F:	lib/find_bit_benchmark.c
> +F:	lib/region_alloc_benchmark.c
>  F:	lib/test_bitmap.c
>  F:	lib/tests/cpumask_kunit.c
>  F:	tools/include/linux/bitfield.h
> @@ -15581,6 +15582,7 @@ F:	Documentation/core-api/maple_tree.rst
>  F:	include/linux/maple_tree.h
>  F:	include/trace/events/maple_tree.h
>  F:	lib/maple_tree.c
> +F:	lib/region_alloc_benchmark.c
>  F:	lib/test_maple_tree.c
>  F:	rust/helpers/maple_tree.c
>  F:	rust/kernel/maple_tree.rs
> @@ -29323,6 +29325,7 @@ F:	Documentation/core-api/xarray.rst
>  F:	include/linux/idr.h
>  F:	include/linux/xarray.h
>  F:	lib/idr.c
> +F:	lib/region_alloc_benchmark.c
>  F:	lib/test_xarray.c
>  F:	lib/xarray.c
>  F:	tools/testing/radix-tree
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 1244dcac2294..0451dfca7098 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2683,6 +2683,19 @@ config FIND_BIT_BENCHMARK
> =20
>  	  If unsure, say N.
> =20
> +config REGION_ALLOC_BENCHMARK
> +	tristate "Benchmark bitmap, IDA and Maple Tree region allocation"
> +	help
> +	  This builds a microbenchmark comparing variable-sized region
> +	  allocation using bitmaps, IDA and Maple Tree. The benchmark
> +	  runs at initialization time.
> +
> +	  Usage:
> +	    insmod region_alloc_benchmark.ko
> +	    insmod region_alloc_benchmark.ko capacities=3D1024,2048,4096,65536
> +
> +	  If unsure, say N.
> +
>  config FIND_BIT_BENCHMARK_RUST
>  	tristate "Test find_bit functions in Rust"
>  	depends on RUST
> diff --git a/lib/Makefile b/lib/Makefile
> index 7f75cc6edf94..adb18810e3f7 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -64,6 +64,7 @@ obj-y +=3D hexdump.o
>  obj-$(CONFIG_TEST_HEXDUMP) +=3D test_hexdump.o
>  obj-y +=3D kstrtox.o
>  obj-$(CONFIG_FIND_BIT_BENCHMARK) +=3D find_bit_benchmark.o
> +obj-$(CONFIG_REGION_ALLOC_BENCHMARK) +=3D region_alloc_benchmark.o
>  obj-$(CONFIG_FIND_BIT_BENCHMARK_RUST) +=3D find_bit_benchmark_rust.o
>  obj-$(CONFIG_TEST_BPF) +=3D test_bpf.o
>  test_dhry-objs :=3D dhry_1.o dhry_2.o dhry_run.o
> diff --git a/lib/region_alloc_benchmark.c b/lib/region_alloc_benchmark.c
> new file mode 100644
> index 000000000000..e88b4cf55c62
> --- /dev/null
> +++ b/lib/region_alloc_benchmark.c
> @@ -0,0 +1,217 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Benchmark bitmap, IDA and Maple Tree allocation of variable-sized reg=
ions. */
> +
> +#include <linux/bitmap.h>
> +#include <linux/idr.h>
> +#include <linux/kernel.h>
> +#include <linux/maple_tree.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>
> +#include <linux/random.h>
> +#include <linux/slab.h>
> +#include <linux/xarray.h>
> +
> +#define REGION_MAX_SIZE	32
> +
> +static unsigned long *bitmap __initdata;
> +/* One more request guarantees that even an all-ones trace reaches ENOSP=
C. */
> +static u8 *reg_sz __initdata;
> +static unsigned long *reg_idx __initdata;
> +static unsigned long capacities[64] =3D { 1000000, 100000, 10000, 1000, =
100, 10 };
> +static unsigned int cap_cnt =3D 6;
> +
> +module_param_array(capacities, ulong, &cap_cnt, 0400);
> +MODULE_PARM_DESC(capacities, "Region capacities to benchmark");
> +
> +static unsigned long __init benchmark_bitmap(unsigned long cap)
> +{
> +	unsigned long cnt, idx;
> +	ktime_t alloc_time, free_time;
> +	size_t sz;
> +
> +	bitmap_zero(bitmap, cap);
> +	alloc_time =3D ktime_get();
> +	for (cnt =3D 0; cnt <=3D cap; cnt++) {
> +		idx =3D bitmap_find_next_zero_area(bitmap, cap, 0, reg_sz[cnt], 0);
> +		if (idx >=3D cap)
> +			break;
> +
> +		reg_idx[cnt] =3D idx;
> +		bitmap_set(bitmap, idx, reg_sz[cnt]);
> +	}
> +	alloc_time =3D ktime_get() - alloc_time;
> +
> +	idx =3D cnt;
> +
> +	free_time =3D ktime_get();
> +	while (idx--)
> +		bitmap_clear(bitmap, reg_idx[idx], reg_sz[idx]);
> +	free_time =3D ktime_get() - free_time;
> +
> +	WARN_ON(!bitmap_empty(bitmap, cap));
> +
> +	sz =3D BITS_TO_LONGS(cap) * sizeof(unsigned long);
> +	pr_err("Bitmap  %12llu  %12llu  %8lu  %8lu  %10zu\n",
> +	       alloc_time, free_time, cnt, cap, sz);
> +
> +	return cnt;
> +}
> +
> +static size_t __init ida_size(unsigned long nr_ids)
> +{
> +	unsigned long entries =3D DIV_ROUND_UP(nr_ids, IDA_BITMAP_BITS);
> +	unsigned long bitmaps =3D nr_ids / IDA_BITMAP_BITS;
> +	unsigned long nodes =3D 0;
> +
> +	if (nr_ids % IDA_BITMAP_BITS > BITS_PER_XA_VALUE)
> +		bitmaps++;
> +
> +	while (entries > 1) {
> +		entries =3D DIV_ROUND_UP(entries, XA_CHUNK_SIZE);
> +		nodes +=3D entries;
> +	}
> +
> +	return sizeof(struct ida) +
> +		bitmaps * sizeof(struct ida_bitmap) +
> +		nodes   * sizeof(struct xa_node);
> +}
> +
> +static unsigned long __init benchmark_ida(unsigned long cap)
> +{
> +	struct ida ida =3D IDA_INIT(ida);
> +	unsigned long cnt, idx, off, nr_ids =3D 0;
> +	ktime_t alloc_time, free_time;
> +	int id =3D -ENOSPC;
> +
> +	alloc_time =3D ktime_get();
> +	for (cnt =3D 0; cnt <=3D cap; cnt++) {
> +		for (off =3D 0; off < reg_sz[cnt]; off++) {
> +			id =3D ida_alloc_max(&ida, cap - 1, GFP_KERNEL);
> +			if (id < 0)
> +				break;
> +
> +			if (!off)
> +				reg_idx[cnt] =3D id;
> +		}
> +		if (id < 0) {
> +			while (off--)
> +				ida_free(&ida, reg_idx[cnt] + off);
> +			break;
> +		}
> +		WARN_ON(id !=3D reg_idx[cnt] + reg_sz[cnt] - 1);
> +		nr_ids +=3D reg_sz[cnt];
> +	}
> +	alloc_time =3D ktime_get() - alloc_time;
> +
> +	WARN_ON(id !=3D -ENOSPC);
> +
> +	idx =3D cnt;
> +
> +	free_time =3D ktime_get();
> +	while (idx--) {
> +		for (off =3D 0; off < reg_sz[idx]; off++)
> +			ida_free(&ida, reg_idx[idx] + off);
> +	}
> +	free_time =3D ktime_get() - free_time;
> +
> +	WARN_ON(!ida_is_empty(&ida));
> +
> +	pr_err("IDA     %12llu  %12llu  %8lu  %8lu  %10zu\n",
> +	       alloc_time, free_time, cnt, cap, ida_size(nr_ids));
> +
> +	ida_destroy(&ida);
> +	return cnt;
> +}
> +
> +static unsigned long __init benchmark_maple_tree(unsigned long cap)
> +{
> +	struct maple_tree mt =3D MTREE_INIT(mt, MT_FLAGS_ALLOC_RANGE);
> +	unsigned long cnt, idx;
> +	ktime_t alloc_time, free_time;
> +	size_t sz;
> +	int ret;
> +
> +	alloc_time =3D ktime_get();
> +	for (cnt =3D 0; cnt <=3D cap; cnt++) {
> +		ret =3D mtree_alloc_range(&mt, &idx, xa_mk_value(cnt + 1),
> +					reg_sz[cnt], 0, cap - 1, GFP_KERNEL);
> +		if (ret)
> +			break;
> +
> +		reg_idx[cnt] =3D idx;
> +	}
> +	alloc_time =3D ktime_get() - alloc_time;
> +
> +	WARN_ON(ret !=3D -EBUSY);
> +
> +	idx =3D cnt;
> +
> +	free_time =3D ktime_get();
> +	while (idx--)
> +		mtree_erase(&mt, reg_idx[idx]);
> +	free_time =3D ktime_get() - free_time;
> +
> +	WARN_ON(!mtree_empty(&mt));
> +
> +	/* Minimum storage assuming fully occupied allocation-range leaf nodes.=
 */
> +	sz =3D sizeof(mt) + DIV_ROUND_UP(cnt, MAPLE_ARANGE64_SLOTS) * sizeof(st=
ruct maple_node);
> +	pr_err("Maple   %12llu  %12llu  %8lu  %8lu  %10zu\n",
> +	       alloc_time, free_time, cnt, cap, sz);
> +
> +	mtree_destroy(&mt);
> +	return cnt;
> +}
> +
> +static int __init region_alloc_benchmark(void)
> +{
> +	unsigned long bitmap_count, ida_count, maple_count;
> +	unsigned long i, max_cap =3D 0;
> +	int ret =3D -ENOMEM;
> +
> +	for (i =3D 0; i < cap_cnt; i++) {
> +		if (capacities[i] =3D=3D 0) {
> +			pr_err("capacity must be nonzero\n");
> +			return -EINVAL;
> +		}
> +		max_cap =3D max(max_cap, capacities[i]);
> +	}
> +
> +	bitmap =3D kvmalloc_array(BITS_TO_LONGS(max_cap), sizeof(*bitmap), GFP_=
KERNEL);
> +	reg_sz =3D kvmalloc_array(max_cap + 1, sizeof(*reg_sz), GFP_KERNEL);
> +	reg_idx =3D kvmalloc_array(max_cap, sizeof(*reg_idx), GFP_KERNEL);
> +	if (!bitmap || !reg_sz || !reg_idx)
> +		goto out;
> +
> +	pr_err("\nStart testing bitmap vs IDA vs Maple Tree region allocation\n=
");
> +	pr_err("memory: bitmap is exact; IDA and Maple Tree are lower bounds\n"=
);
> +	pr_err("Type      alloc (ns)     free (ns)   regions  capacity  memory =
(B)\n");
> +
> +	for (i =3D 0; i < cap_cnt; i++) {
> +		unsigned long idx, max_size;
> +
> +		max_size =3D min(REGION_MAX_SIZE, capacities[i] / 10) ? : 1;
> +		for (idx =3D 0; idx <=3D capacities[i]; idx++)
> +			reg_sz[idx] =3D get_random_u32_below(max_size) + 1;
> +
> +		bitmap_count =3D benchmark_bitmap(capacities[i]);
> +		maple_count  =3D benchmark_maple_tree(capacities[i]);
> +		ida_count    =3D benchmark_ida(capacities[i]);
> +
> +		WARN_ON(bitmap_count !=3D ida_count);
> +		WARN_ON(bitmap_count !=3D maple_count);
> +	}
> +
> +	/* Return an error so the benchmark can run repeatedly without rmmod. *=
/
> +	pr_info("Region allocation benchmark complete\n");
> +	ret =3D -EAGAIN;
> +out:
> +	kvfree(reg_idx);
> +	kvfree(reg_sz);
> +	kvfree(bitmap);
> +	return ret;
> +}
> +module_init(region_alloc_benchmark);
> +
> +MODULE_AUTHOR("Yury Norov <ynorov@nvidia.com>");
> +MODULE_DESCRIPTION("Benchmark bitmap, IDA and Maple Tree region allocati=
on");
> +MODULE_LICENSE("GPL");

Thanks Yury. I tested this out and got similar results to you. Code
looks good to me too.

Tested-by: Eliot Courtney <ecourtney@nvidia.com>
Reviewed-by: Eliot Courtney <ecourtney@nvidia.com>




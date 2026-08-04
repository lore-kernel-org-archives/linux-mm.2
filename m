Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25046C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A066B0108; Tue,  4 Aug 2026 11:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B556B0109; Tue,  4 Aug 2026 11:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040796B010A; Tue,  4 Aug 2026 11:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAE876B0108
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:57:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F5FB120212
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:57:15 +0000 (UTC)
X-FDA: 85064041230.10.E15F1CC
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010071.outbound.protection.outlook.com [40.93.198.71])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98384C000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:57:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VgynaDQl;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785859032;
	b=s0UERS4oGHriHocUM+RA2PFQzUs3q+4kxfb7gHvzqw/V6I0J/rjwVK58GAFeK4CrrRdFZ5
	+heLgXVQ/KDsuc2nyvZV3bAwolcaJkk/Scv37ags4z8ZYpv4fgkjd5s/bLgHEqV2MdeDn+
	oiY9s6wAi6oLD68FuIgcZezzxN5Poeg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VgynaDQl;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785859032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svsBPlT1AGN46qnjMUuPZOh2U20C3ErQHBH9w0bfiZg=;
	b=pkPelHOBVrFOv6hu53ZHA1BxhVtN3SwUd3tBZagghPbRl0PlkPGSHylsrsEHh6Xwke3VmP
	k48/o3uFTTYxd4jtM5OMDkSNgoaKsyHk0EJ2IDt+zA23IfDQ//98l+Vp4dws4VVN0Utu7A
	0EaIH8ey/wYXkgrDYGjsfIIxbyH732Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwAxujqqS9zNhKMhc4HuZMMxhdf1BRlu3XrtL68M1obIBNA0zRemClpnErU6gyB86YmzAaUujhzB4Gpc37XR07c0FpU6POcoEF226KXoMFVLcSKuGTW/HZ5RNOTnIw7/R4Z8L0bPogVpMZ70YWvTPyFw9ebrHedaBK1QcmmuIB2eRlK3IGAMKAljCyoDKzNGH0wjrnM/UNJUUNcxBj3EwON0vZaIDTexpaI2sy5svoIBBTtJ9ymUXRXtGSFgsoIDyfX2yoEsMOfThl5N1TPHMQLkc7Whhml0nFycaf0W4DS2Z0ufwTjFmrXu6ht6M2IL5IvYoaR1SheTqDIYIB6ZCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svsBPlT1AGN46qnjMUuPZOh2U20C3ErQHBH9w0bfiZg=;
 b=qTWZQhbMnJhl0D7XpQRLi/tQrXIj0Jhw8/tAALqMZcMEgiLaALYD5CrcrV83naepOpWlGO7iiuJ86ehaTqQcLBsRYZPENAq+IE/3WubmoyXKKFhiYgwpOYJZssBMiPTMx/Tizy9YmV+LkD6yI8usPExqOjr28mi/3HB8aP7fSz3MAJAAT3O7ubv6qIqX5sjPtHnFTskrZtneSd+7oaKDRHrxMAFIWGHb/35LWBCVR+TuDzFGg2agjwNa5YN1qfmJShyTSnH3sL9LHUl+iysqAV98Cxg8bO/K5hWSgUqPRvgglUwye9c8UXOdtbmaS1e5nuJKvP2OPFzcspMHD9hDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svsBPlT1AGN46qnjMUuPZOh2U20C3ErQHBH9w0bfiZg=;
 b=VgynaDQlmS3P4jbMjrps6R/SJ4RB0oe6YjgHvaXAjrukB7Nd8DjxGL0tzPcomio5spwe98VyzyNzYA0GM+8w+V836NQ7X/fGv/8pAGs3SiaIbIRkMiDffbp9ED9y9BFxp+S+aLK8JmVWq5oOkTPoAS+sRGtXxRwH/rgHEJgWBsx1wE+IRkoG/8l4vqLr0s+phv0vDSlmn24ZHj5WR31MxPtXz6KrCFNjJUj7ZaFZaJCDdVQ2chhwizA9sLO6cALeMgoSeJGXPaPyH49IAL7GLevrfkXluY2HE0014cO3n0YkDEUtxcmPKe8nzgfuaOz3gSO0NHDNnOFu3v8Q2y9N3w==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 SN7PR12MB7299.namprd12.prod.outlook.com (2603:10b6:806:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 15:57:08 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 15:57:08 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 11:57:06 -0400
Message-Id: <DKGA6V1RHMI1.GWL9QEA9MB65@nvidia.com>
Subject: Re: [PATCH v2 2/2] mm/page_ext: remove pgdat_page_ext_init()
Cc: "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Liam R. Howlett" <liam@infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Suren Baghdasaryan"
 <surenb@google.com>
To: "Sang-Heon Jeon" <ekffu200098@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260804151145.3419768-1-ekffu200098@gmail.com>
 <20260804151145.3419768-3-ekffu200098@gmail.com>
In-Reply-To: <20260804151145.3419768-3-ekffu200098@gmail.com>
X-ClientProxiedBy: CH5PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::25) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|SN7PR12MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 150ba3ff-d0d9-4df5-d0f3-08def241099f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mt/iN+zJIbvuPJ52agZdEMAIKUjxf/tCJD2coqIFXNEQzSMrOU0dbwWZ/Y9Px5t41DSJxTXF24taQShRpvsFe5c1x9dq2wWfZy2ejw2X2YBKly9tIMHXWzoMuBTN2oKyLSDLTJdFg1VDo3AnRuregNE1QtieUdvgKv43SiPurXuQ/2KsE3vi7ATDOzkuwDY51ILbPZTBx/QGGUqKoxP+D34KCGelE8JQMguIX3JNTmhby2zHTroz5p/84ndqvn+jyd0P2a+4yqkp08zXYqQ04MnpycSG8mBExpmkh4o6wYqiuB/COPXoblBP9F+CXi6AmKoFROEk7KZqaeYuGInwC8TUriSF0tJyrCm4R9uq26YYsis6X9Br3NQ/Ns7LTb8gwe7K/gRg3ev8NSvaJjGbjTPf1SWdopDY3+IIBfihhkSuZSE6eJS2RaJRb3LauHK953aVoSq6nM+KiH4B4t546VVIJlgqKUXcrC3wdmYWRkLax2Mx04lSlQWMLQl4ODZNpdTtUNFJH/NKZ3whi255idZjmeyntjxDeyuGBo9K8DvLrqIVVaZ+UUw+j/NN2MzQKPZPwuZGqyGPGH2cJHbOjhe9fBqhCtA3DuEoMgEB9d4/ibHAcExKeVn1KO/Bs8Gqp8o2idj39Q4D5AVu18e6UbvRsBa56G1mKnXWhb8iYkM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEpZN0RnRk9jNFY5R0huclptWW1uQjdBc2NlTG15UkV2d3I3R1JsM2tvOTNJ?=
 =?utf-8?B?R2tQRTZUUkhTUVBJc1lKRkJtSmtaWUR5aHF4T1dQWThZYzNOY1FrUVIyWkdH?=
 =?utf-8?B?TkwwZHRlK045S09qSDFXZTM1T2pGSnA3b2J4ZWJjb0JQUUNSTFI1dDJHTTNu?=
 =?utf-8?B?SmFaYW95azJuQUFlRDcwSXZwdHVkQkxoZHowTGJWSk9IYUVHSEpaL2x3WEZ5?=
 =?utf-8?B?ZFR5TXpEU01FZnpYL1pkQnAxTlM4aXlhcVV1aUFEZzU3dmdkQ09JUW9SazFq?=
 =?utf-8?B?dlhmNWxKcDZNUEVGVUdqRTlaWWhiamxsOXpuaXRGTGdrdVVmV1VJTGhoUjd5?=
 =?utf-8?B?TDN2QXJNSmdXaUNyUDM4dU5Ic21aV1prYWhwUUQ1Rk8vZnNoeHl3VVZPczVq?=
 =?utf-8?B?ZTFNWWpMNkEwS2QvbWRqbFVudkdFUEFzREo4Y0liWGVDN0VvNDMvS2dncUpD?=
 =?utf-8?B?TXp3WFlYcE4wYnF4NVBRaHIxQnQ5OFpGbzJicVBVbjU5cFBuaGVNT0V4TnRP?=
 =?utf-8?B?RVZmTXdJTWMvaUY0S2xwUmE3RkJMY0lDdkVrTkpRSmdpNjNqWkxYQm9nMW1w?=
 =?utf-8?B?KzdwdmF2Z1pHeWFiN21MeDFjekM4ZGpkYlQ1UXJlZ09hZFRqa0VXSnRXNmQr?=
 =?utf-8?B?QTVzZ2hrdkFQYkE0bTBTVDZ5b0R2RHJsL0dodHJON0FRQTFIL2U2UlBrbUp0?=
 =?utf-8?B?dnZRNHI5SVlCMnhsTkRKbFVPUlhTU3lsb2o1VHNHemNlalcrTWhhZ1VXZlZj?=
 =?utf-8?B?Njd3RXBybU8xSWx4dC92VDZiU29tL21jSGp4RzF5QlZUV1Rodmhhb1V4LytD?=
 =?utf-8?B?VjJ3R3NIcFdPL2UxcFkvbzRRNkR4NXVJM2dWeWwzTy9HMytUZGU1MFBUaENQ?=
 =?utf-8?B?cGM0ZjRza1Z3SmxSM3pWUjJhL0JFYkdqZHdyZGVIYzRqa05KUmlDcHdXSVFu?=
 =?utf-8?B?akpzWDQ0V2hUN2tTbFJZNlErM2lyeUFRRktQM05zQ1EyMnE2ME5YV2JZRUc2?=
 =?utf-8?B?UGlTTGtzWVN0R0E3WmhMSm5iY0FJMkhqZHkvZUw3WFhDdFhBUUVzR095emdS?=
 =?utf-8?B?S0QwdzJ6bW80NG5pRUpOREdQNmh5U3JVampHRnJwb1R2eGF3alNzMVJ1Sm1V?=
 =?utf-8?B?NTJyL05wOFpVL2ZCTVhEMzU0VU4xS0toL3JvOTVvR3Bvcy9zY0xoQ2tEeEh0?=
 =?utf-8?B?UGd6NGwwdVVDWWlwSjZ0NG9wdHhDSFowbUdyVEZtLzh4S2llNDFvSytZRDc2?=
 =?utf-8?B?YW1kRVM2MjlvZ3pJOGFPQmFYOWxuUElhWVUrWFBQWWwxb1J2aXRRMEowbGU3?=
 =?utf-8?B?aUJVNWNVMCtRa1FrV2NuSXN6UHYyQlA5OVhRTzFlelpUN2VSYXdpZjRCcnVP?=
 =?utf-8?B?L2EwaDZYYUU3Q1F4VjJIcTROakMzcmF6NDdoeGsxSWxodjdraDB4NTJicSsz?=
 =?utf-8?B?WUJhVVZJNUpML2pLSXR5V3ZoUU9DMjc2K1VSWlZWVWM2YmVBVjREbHorZStE?=
 =?utf-8?B?eGMraWVCTjJrdW1zTDh2TUNwVHI0eGQ3ZTFTMjZvWjBYZzhmV2w2c3hEYVNm?=
 =?utf-8?B?MGpsd3BkdHl5eStjODFmby9WMGx5cDNSR2Q1T3UwSWtaUVZ4ZmNpVEZlTXRS?=
 =?utf-8?B?NGU0YTNSdWdXekJVbHNOZ2txakNNamhrNUg4SnMvOXhBRnJsYjE0Nzh1cGRN?=
 =?utf-8?B?YUd1anpxdm9peGJVODdxZ0VRaDNUY0kzeWNqcFU0WWswanVDRXZOUzluaUZQ?=
 =?utf-8?B?WGhqcFp5RllkdUE2RUdVZjN2QlRXVjJnVGtySy9XUlA2dFE0MnU3SWsvWEJx?=
 =?utf-8?B?c1FGZEtzQTBBMEM2bVNTbHMzZUtrMzFRTnM1TUJzQjMzbnVQWjk4Zi8xdEFN?=
 =?utf-8?B?MDhQblRYd0NKeXpkZFVZd1VvK2g0SUNTOGJ1aDZSZDY2OUIvRW9CejcydVo3?=
 =?utf-8?B?UmM1OWRiWXYweTE0Q1l6M251K3hCelFvN2NYSGJ4L0I0SWNvdHhRZTlzZ3V5?=
 =?utf-8?B?ek5tM1ZGQTNjdFAvSTdtaUYyaDQ3bW95VnV4OWFPUE1FL3ozdjR0aDZhci9m?=
 =?utf-8?B?a1VPamlPbzZ0czBGVjVNd3JpOVNWSFY2eDlpSlRoM29Ma014dlVGMDU3QTlk?=
 =?utf-8?B?SGkvYzVrR1BtdGFQb3RNdVVkbFR5aWo4NFVZTHA1SFdUTi96eEExWE1jUkky?=
 =?utf-8?B?K1hoU1NEVTNJYkhmcXV2SUlEV3pHMTNoRmVaM25qdFRkSHh5OEUyVGt6U2RK?=
 =?utf-8?B?WkRNWk1oY1Fad2Ruek8yYzNPcnpQbFlQZjdDT09vWDE1enZCcnFJUjFUQVR5?=
 =?utf-8?Q?oEXt34v6iAiGBuzCRH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150ba3ff-d0d9-4df5-d0f3-08def241099f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 15:57:08.2633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtY7YEXhRKtAceGwJIUpkDr/Jq+/6CsARFsg4OH6/qo8JKqDOZncgEVpTlOyt/8k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7299
X-Rspamd-Queue-Id: 98384C000F
X-Stat-Signature: yye3j3xgsoe5zbr6syw4iueq49outojr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785859032-350743
X-HE-Meta: U2FsdGVkX1+8MVH3BzBU7rUdeJNCW5RWBOT5G4PS13kMyk0GZVEKp0h0JKpztxVUP8uu6pNGrMn1iBMxEoIj0TVgwBzb9p22pmiEzLF/Jov29izUNkan/YqBjXX7t7B/4p7UgZd3ThhU8y/tExLvpwo3Uo6j0lHqtNX3sqTUUBp3Af9VBQgD0fqxBGlJmIHbeN5P1KSbKAOny9E/wUj6yTeaJRIRQ94eb1RfRp6aDLVbvaqC74jF7ImsVCayGXQr6iTcpFBZDxgwHCtTB2wwhuSdwviIML20eKGr2cva3qDwfIXzT9t9/vRdbgBYS24fFxsuokwbj7FZCGBV7Mm08+kvP5ybsoqxNk9DjqlEZz8KhMUd+OcFakiFwop6m93+t/wHFFOV9+vr/mjogvUVPIDWja282Dxws70b0+2iTBsJ6CYymrsxB7iM+P3t7vuATKc+vpZGPZvEw/66N9udRzxbnsbNpcAuY897eroIQb0n3NfRkhBdqg1u0q9SWZ0GyPizCpHG1KTHFSOYu+v77SXEq8FB4EHyMFI2WHlSOAPhAI+RQfBMU7qO93HpQhPcrloUOXF1jnq1JlvZZsDGy+OVhj3y5KrqH52FEY+DoSd2GwCcwMD0PVctMVlVTmXfG3NzncCtnm4FZCUq69qwRDp2jlsf/TNRvlDbNFrB7Xjzr2sULGnvu/l5Ie6R1IyU5AJW2jsCKWVvylOeqbXxqMMOEwOIoil+ZO9twMXmP2uVOoDOe7FV5heJ/qOSq3Wg6PYnlUCQSf6aCtU0S21Ye4JmWnW2UrV69TUienye9H7AUm52/PP49HFpjFBXM2Ic2yISHDc/lUL+qRWO06YQGRQ4KyqFb8ZaaGEEB2Q0t8dZxJtTNb+CA9mr6KVP/vmzRZaQpTNcWZyE87to49imO/uG5TH+4Rm8rE5TLMq1NbhDjNYiGThXvWUWG4LVcwwP02i2QjVbQh7PaaoOYVd
 RzFnjXjr
 SVXfDH4vKRC6AxQoDQ8nTERM7knDBSZpnh90kWSJ63FzpNzrzPAjQjc3d3Rtk+agDy8kJiJQ8suXVewnAc63GdPXzFHr7PLO2vtyNOe/jkcyDzgZbXtn9ANis4C8cPhTFGSzUvGJE98tZ+9Er+Nq0gkuph1+LGo0aF4UpZXSSs+KApsQVRk+PSi+wwqyrMee+/Kt49/2FAmpUwheuf+nsHrqYKvt4dC1bXEbdY4n3tGaFaxHwOGQba+FelZCaZSsGiUkHgvX4fDS5+ikiZmSRo96/CeE6+41FqQSxMfObi7dOCtFRShmjYCPaGo+D5AbIFyrW8fIFLLWtq1yjpb6HjC5mpvX5mmURJrizG0JpOiymd0LAOFOm2ALiY7EPVc5wjKujc54Vsgpv3srA7FBXYvwreZYBgYVId8Cxa+Gvd0MCvvuAW86oijTHl7MyGQU9WCU8C42YTjuXrf3C9NTq5/iHNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 4, 2026 at 11:11 AM EDT, Sang-Heon Jeon wrote:
> pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on
> FLATMEM. FLATMEM depends on !NUMA, so the pgdat is always the
> zero-initialized contig_page_data and the store has no effect.
>
> So remove the call site, the unused function and its declaration.
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  include/linux/page_ext.h | 5 -----
>  mm/mm_init.c             | 1 -
>  mm/page_ext.c            | 9 ---------
>  3 files changed, 15 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B460CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE1D6B0093; Mon, 22 Jun 2026 11:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98EFB6B0095; Mon, 22 Jun 2026 11:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8572E6B009B; Mon, 22 Jun 2026 11:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5220E6B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:33:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA35C165E5F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:32:59 +0000 (UTC)
X-FDA: 84907941678.19.6CCEA1C
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id EBFD9C000E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:32:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fZ1w5Nbl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782142377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27FTpVNmsrAGKj3FyC1TMfaT+RpmXRWa30jDYiMxIPc=;
	b=NxRGknkaKj08mroHaA2AApo7GbdSVmJAOYHTOGKHouOBXYbv6U6VRRolN8+Asf2KusYkMY
	0eEa3uQ11lHKxrj99NBWjIDNqdbBAAgmQobSvFJTxZZzo2cPw7WO+QfrCrUmZc+CHr/Sam
	uIlnY+0w9Y6wsHeybtniuzmgcdNTjIQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782142377;
	b=vE4wxXVBmN0573jpu5vkT3XEmUu2S+4VckLN4Bo88OpHIGw83vWWIrrK+CIzjL3JrNfNzQ
	IAOFBFeWqC4N1KmuwO0H0Afw0EiLKH1OvGzdTAdgM++Kvk6CPjIe6TXKrCkdMT7kaVExWy
	AiMdZsWFneIB9K7xvLlBJLbEIVQLNJ4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fZ1w5Nbl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RxhN8AWziSGEoZosbqPT1K9X7zzYCTCkEwwdWb71Xnce2uPGiiP3Pnphzjajg9lO71pxYAWEkxS5CUGgo7NwTitwS0MgxihV6hmec6Z/TjLs7KpEysxhkzHn9oi63R9124uWVlD8KhES0SVddUAHMUWKxc/olnHcljEmBqyPh5jhPx4qzrJ2RIYlp+XfbkC3eMjcoPB3+hWYDaO0YCgnJC5BfNlyIFxtpG1kq4vUofPSi669FezpQtSYkAR45BFS31SDW7/Vo3KZS0/iq/oC5ouRcPZDCWAceLY6UJpU8kX1V5FgR0rlzM2UwmRU9rSTisf8X3yLKurUT6Zpd1am6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27FTpVNmsrAGKj3FyC1TMfaT+RpmXRWa30jDYiMxIPc=;
 b=FaO7vjOA33EThIQRiEjBHamvoves/8zl6CKlM5CtfWPWPpiXOLkG/c/BOG02nXbAaXHKB0hE8wH7bu8sDJlnwht23zKATYOjsdmqCAzaQ7qBAVuPxkX4TO3NL4T3a4zsC/doIYHOkwQEtBnWYP7j+I7hZkkaTYOeghoiH027Qrj2ONgxJbHcuPYSTnWB2jFegjeGazqOyn4RrSvWNSm4I4gA1oodatjvLn7IjG3BVtuV2sUAY9VjJsCV1VJIpaclE1mLdMBYKVQohAMjzuO0ORk61XMZ+JAXA/B2je3s3O4IvkjPdM6kpeCAWZ2f5YYwUCnzKxwslxEc89j+yVZsCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27FTpVNmsrAGKj3FyC1TMfaT+RpmXRWa30jDYiMxIPc=;
 b=fZ1w5Nbl6W5JJGXwNsCNPzV58tKCEcgR3dXOXOl9yN9NY1YppS1hEkxnaWgVu+Mw1xaIN7gG+ifC/lQM5TcdtSjA13qTSInQCxcxgVGSO2rN4Uy1abLAAnMB3N6dxWmRh2E2ERq2youayDSFthvBzprWkI79/Lg5u6eOtaZmDl5BngiAeGOWyFQnSrsOrzUDbA5DFPbWG57NbxLfQUwGURyPh+rIIFAm6t7T5g9tLTWVRsvypxMLonp+zeC9LxLWnMoY6QKM4wwx80slie7vt9RTHl3dqqKMC5/lenL7A2n8dOu+1H0/ClgcHZVEqvN4CT0VUL/oQSLIrvHczzRyBQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7207.namprd12.prod.outlook.com (2603:10b6:510:225::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 15:32:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 15:32:43 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 22 Jun 2026 11:32:40 -0400
Message-Id: <DJFOQQ7NYAO5.2REY6S2W78UBJ@nvidia.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Cc: "Miaohe Lin" <linmiaohe@huawei.com>, <harry.yoo@oracle.com>,
 <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>, <david@kernel.org>,
 <william.roche@oracle.com>, <tony.luck@intel.com>,
 <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
 <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
 <rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
 <osalvador@kernel.org>, <willy@infradead.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Jiaqi Yan"
 <jiaqiyan@google.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
 <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com>
 <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
 <DJCAWX74LL8P.2AX46L7QCCWKV@nvidia.com>
 <CACw3F53jgq5JS+0qkC3Jmj-jkDRHm1H_Z=Xvv-jKoL5XHy11sg@mail.gmail.com>
 <c8ab2147-c6aa-480f-bfe2-55f095b55add@kernel.org>
 <DJFOHJCQM9YS.23PHVLJ0FKUMD@nvidia.com>
In-Reply-To: <DJFOHJCQM9YS.23PHVLJ0FKUMD@nvidia.com>
X-ClientProxiedBy: CH0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:610:b0::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7207:EE_
X-MS-Office365-Filtering-Correlation-Id: 05f69afc-cd25-4e08-1ffd-08ded07380ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	j0krYmD1t0DE84WxmRqYfNA/D0oQTgSMGigITZZSfAARbvdrlNnxEaAtA8/+aqLmdQ2T+wD4O8xMVe3w+PC9gFJ6fb7x27Q0f5lC2RFGoA1aeHqFojiR/s6FmYPWMTrTTM8ziV15Ljlc0UaB3V5bOSKhLE/BpdPrQmTBaDO+neJqgx/wWWole0kA81yux6qv3uH3kzGsJD7R3Li4DXXQTS4+5E5dQZ+Di8y9tCyVCa92e51zK6nA5iu5nyllJd55T98g2imvNJJ4k8medmkvK1QZlabMBW900Z7oBSshgmljnycKXKpMqh7p6sxq5ZQfxwsdhNwuob64nwF5c91fkmiLvH+ESNAKdkbPhL5rX7gEANfSb/MkJFldgV11HuTSevHrEQKwjRTTWqd7U0VHdvyb8gXOYEBghFAmk8fIVBn+3rOBT423PjEG6RUt7QGgNpm905Qna7zi5gXDoamSufpIuFkXPL6saMcDoz7638itappflbubBTAw+r95xYhnrC8qjLYsNEoyquUtAuazo3l48NWgeae7fuhr8WIOrlviijJENmIJEPKRBFFHC54YVMHFp5UY9Q4EbuyWkYxOUi5Ja2WBjl5sPJqB/s17L4vPeJvuPP9YJCgnfkt29Om1taVtp5HqWgfASlmINE+hkSOucUBfyTVYNdgfBSRDnuU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3R6d0NnR21CcVhzNy9GOFNpUXhkZnEvWnhDMzI2V055NXppcENtVEJPbXc4?=
 =?utf-8?B?RnlzaitEQ3FCbUpnQkdxd3M5bjVqVEE4YXlvSGdNeUdDcUlKMkduUE5pREhR?=
 =?utf-8?B?SDhUdkplV0tiT2o3ZUdGd282ZWxydDdpZ0NqRmR5KzlZbnpZeU1xT0JtNUhY?=
 =?utf-8?B?YnB5UEZDT2J0R01yY2VwZXc3cFI5eUhScVJadlBRRE04Vk1XNlJMa1J5VElB?=
 =?utf-8?B?OXQyTjl2eEdjZHk5TkRvTkM0QXZKQkN5bUhURDFZaS9BNmtyOW16MWFZMVVB?=
 =?utf-8?B?cENCblVrNU5ZN2R6MXluc3NjU2JmU1lOZzJlUHhqV3M2TTE4bVpkdTk0UFYw?=
 =?utf-8?B?ODNkaUtHUmVpUXEvS0w3bXZPdFJ6NTNUK3RYbHlSeDErbVNmRHNmZDg5emY2?=
 =?utf-8?B?a0Izb0g1cTFBWWpkSldlcktwSE1BQ2tVbTE2dkVGVjd4cWE1cmJ1Z2w1TVVV?=
 =?utf-8?B?enRkNlY4czJ3SGs1QlRZRDJaaE1vT2tCUEFoUGE3MkhQaE04dVllL2NXTU5G?=
 =?utf-8?B?TWhheXpkSjk3MUZhcG9sRkVXOHFUbnNvRFAzTUtockg0UE9tV1ZMUzFyU0sy?=
 =?utf-8?B?aUFnMVhyeVM2ZEwzRW9qclVWVjVHVFhKVTNONGtDMnllRCthOW5remIrOFFW?=
 =?utf-8?B?Rkg2YkpUaHVHczdnUFlYWEtmWWtnMlVvOWpxaUxKYjhCR25UYys1NGlmRHph?=
 =?utf-8?B?RW1mbXRMZWY2S3lxZkpuYUhncGk0Q1VwM2c1YjJidnI5Vyt2TThYa0JaSERv?=
 =?utf-8?B?NHU0eW5INU1yYi9JNmJ3L2tZTTMzdnVOVU9mc3FneHE0T0xFRk1WS1oxZHUz?=
 =?utf-8?B?TE16QTRWTWZyaEN3eVV2MWtuVEdQYy9sMUYrNVNtUnJicmhkeU4wdmlFTkpD?=
 =?utf-8?B?NjIzZE44b0VKSHJ2WlZkb3NOOU1ybzlQdXRqSDBFanpzamlGdDRBVnBDODd6?=
 =?utf-8?B?SkNmWThxT3NYblJlM202L1JhUnVMenZXZEV6bmo1dG1Ob0FrRVpvNk43bmkw?=
 =?utf-8?B?cDNWT0YzQlhtcmF4MFFpUC9rTEs0WVJ4Q2dIM1htTjEyUE9TRXpwZThsMkQw?=
 =?utf-8?B?QWV0ZzhUZ0xuVDIzUWZRU0pkb1E3NFhXUjV6dDVXNUZheXo1cE1KQkt1TGIv?=
 =?utf-8?B?M3BBeWdkbkpoNHZhMEVCQ08xd2hGcFcwYXd5bCtOOE9MUXlzL2kvaG1MUWYr?=
 =?utf-8?B?ak9jUU1Tc1VuUnFkTEF0Vk9YVnl4NENmT3RPb01OaVBCcjA1VWkvU2JvN1NF?=
 =?utf-8?B?Uk9rRkhaNmJOaWFHYVZyN3hhQ3dHVVI3ZU9NbG4wYkZBOCt1SXZnR2ZaWlVI?=
 =?utf-8?B?LzZpT1RCeEpFZnJPOURvdFZwWTBrMUs2M3NRVDhhNXZXWUJFcldpcjBadk1H?=
 =?utf-8?B?UFVSYjNuSTNWeEgzNHZBa1B3NWlLZytORjdkdEc5SGcwbzU5RVBDUWFxV3Vr?=
 =?utf-8?B?N2ZValpJOUlxcnRHWWdzT2Z2MWJRNTBRQUxPUm1odlQxdWFIMHhuL1pqU2N1?=
 =?utf-8?B?ME5LSnlJTDBJdWVhTnZyRStnNGRHeHR5emRXYWRzVCtXQUhycDFPOFU1eXZ5?=
 =?utf-8?B?UHYxWThlTkNhUkdxcFZBa0JpeTJuMy9HczFkTnpNYWYxNTgreFVZaDNTQndN?=
 =?utf-8?B?NGgrMVRnV2ZndkVPbVVmeldCMjY4YW5NbzlkamNjaEVsVlU5R1lmUFNMVEpx?=
 =?utf-8?B?bGVidjNrajlPK3hqR2ZoY2hkRzdvU0hqVEdSVU1mUTRIZEM3SUlSUHB1c3ds?=
 =?utf-8?B?S2VlY3JkTVBEak5rUnU0VU44UGF6U0wrOHRESnpXUmp1enA2UFVoZm5Ybnli?=
 =?utf-8?B?OCtLVEc1T1ZGTFNna3BmV3ZRNEUxNWdrMVZPOFFYaU5LR2Q3R3ByYmo0RDh1?=
 =?utf-8?B?QWJjQTltekJsQ2pnMUVoaHRUWHZVWGFSU0diSGJlWFRLcnQ0bUQzVHViSm5J?=
 =?utf-8?B?aC9hblhaOFdYK29xVWJlSFpGVFRMOWZVMjNhOXUvMEVxck1Wbnc2alZ2UXpX?=
 =?utf-8?B?NmJiV2srRVhsckxzRU1wNlJrcjRsQXhJWlVXOUpUVGt2aVR3ckppZWIzSHho?=
 =?utf-8?B?Q2F6WDJDUlJSMTY0Vnp3TVd3WEdrQ2tYL2xRMHVnMFp4aURncllmczVHd1pk?=
 =?utf-8?B?WFJ4R1MwMFo1RVlXa0I0YS9JclI0TVBCUS9lZ21rOWRsNmdnT2lKckE2RFlr?=
 =?utf-8?B?c2M0Tjd3dERuMU9nVGZvb2hyQVk4RDA0YUt1UlRrd2ZwbEtQK1ExWWh3TEp6?=
 =?utf-8?B?akV1M2JxOXU4WCtnZFFvTlZXRkNUd1g1UmswcUxWVDNFWGZyc3dIQnRNcWht?=
 =?utf-8?Q?Geo2g5ehW04Oi+kdRv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f69afc-cd25-4e08-1ffd-08ded07380ce
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 15:32:43.5085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kX1oRo6gm6dFQwKLkMZ5v+dHE/LtWzUMOvCDObH/t4MYRer/9XLtTq5jW91frCgj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7207
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBFD9C000E
X-Rspam-User: 
X-Stat-Signature: zmz5hkwbjbb9bzmp3hefgrexnrwpaz1d
X-HE-Tag: 1782142376-672082
X-HE-Meta: U2FsdGVkX1/J8lTHDtwrN1NQNbecWzaN7/z8UAM4UBEgvosfUIgxqqPr7VM/pcCEkYtCENUM5h2uWK0mYCtGNm4c7LeQYoeJQAgP86aQPDxZABZloL4vXS3vP8RMsKFHefa8BL5wt2r9ydVL6SGWYOErhb7uBq1IKm7uRUPvEQamuMSEsYAcg0zBeBm9WGTAhP1wNKVEjj6Dqg2hOncgjAjvptvALxp70ni9L6LNOM6odBYjDdKKC2SawJ0cxZrWNR782Q0QKrsfqaUzhayLyx6MpMFrfVXyC8uT3e4AAzqYywdNUkvv3jEADcyLgV1oOeyC7bZqnTPRc4Fbk9QWmjAINkIQGtAHkFyRlPAz/tneqvn2EDdhNgwBaO8fVoyNvq1jL8e+VwCozsn0dqtFgC4Sftno89Foydae3zkOVD4/F8URMcviv3+LTFVcBpjVzpDamX3Y7ts6AO87a2iF63WsciDOlpHCZ3GQ993ssMtY2od3HUYL7XZwy6tHqVoD1UDT37jzFEEKQspbVhC3MAs1/Mc4iNbyDKlEoIh0qtH1kxPiMh4MclLDLmbPS/YwHphqR9zUH3B+3nykTjUJVpVTyTIdy+0A7/fBrP21OczsRX1gCqBs6wxrkoamNENdgkkW1+zRmAlfAxku9UWjTEU3g22qhDo94w7KaEmfkRCXQfFhGMzyKxVZh9sXZIZPVVJ8badmjHlPrmfflZjiXwd6AbTkJkPqxayZm3ThIB+UcRIM6iTCqlA00Q/fk3As4Otlzm0fo4b622n5hyZDr1ISxmw9T58XGfFrPKF5vYq2eKItbs7I9JYdHFdMg09wiJVBjSllvOkhJ15B0hP9suF5tq08i6YOsJ4HeHYPyRdGE0WV00m6jFcbCKW0tgd8R2AFA6Y8dGRdtmCMg3D+YH/llRLjoJda0u6nptnVsSRcw+h7AN4KksxbYJMfKab6OisjHkzTww/qZxP2ELa
 WqOOTyJm
 GFFkkSlvNUlZduZ8Lkz8n/PGAIpbQNTxrd2UOUAjdqFFDooXwDiXJdheCS3FMxvGgkGRgEQS12+TvdOoU7qXMGiZJ970AG6mjwkrKdGtScx1dbs4/JFpJCIukruhEsoQDk+dLWPQE3TNHnjy5XsOW1J3A5zrz8O9TrpxhYXInmVYDrSRITd9oD1BEbhpyNEJQUDn5qr54iQndbzuyRidYMEP5yt1uv0PraSkl4sIHffnMO8W6aoCuxXlk/KcVqSzQ35eIUXtgmSh7s2OzMF5TWxKvL8Xtk5pI13SQAWY2RBt3nNPHYIoTtmeGwe7KH2y5ycXN0jPqPGxdJv0R8S6Ic4qj8novylfftdLoMJWMtARv1as4q3GFfSiDSGnIRw9T1FCEdyi0zWFr3G13puuXwj8P/xnzbvQE7KICspv6klB0LFqdRlw7s0ozwLCRodSqOiL8Dy6c34rGwHz0f8neLNjjgJPzQ7jeuyrno65o+owIcU5QA8ugm1JyU4ysKvahDH/kzIl8vxyFzZlp6chSHro+buKR+rhrRU2k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 22, 2026 at 11:20 AM EDT, Zi Yan wrote:
> On Mon Jun 22, 2026 at 4:35 AM EDT, Vlastimil Babka (SUSE) wrote:
>> On 6/22/26 03:13, Jiaqi Yan wrote:
>>> On Thu, Jun 18, 2026 at 9:04=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>>> >> when copy fails with EHWPOISON), the next list_add() is going to ca=
use
>>>> >
>>>> > I think we should fix compaction_free() (as a separate patch precedi=
ng this
>>>> > one) to not proceed if prepare returns false. It could in theory alr=
eady
>>>> > happen before this patch due to a random memory corruption of struct=
 page
>>>> > causing some of the existing checks to fail.
>>>>
>>>> Something like below should do the job, plus
>>>> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio m=
emory compaction.")
>>>>
>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>> index b776f35ad0200..b2104cbe63477 100644
>>>> --- a/mm/compaction.c
>>>> +++ b/mm/compaction.c
>>>> @@ -1876,10 +1876,12 @@ static void compaction_free(struct folio *dst,=
 unsigned long data)
>>>>         struct page *page =3D &dst->page;
>>>>
>>>>         if (folio_put_testzero(dst)) {
>>>> -               free_pages_prepare(page, order);
>>>> +               if (!free_pages_prepare(page, order))
>>>=20
>>> ... for other cases that free_pages_prepare() fails, this is
>>> absolutely necessary for correctness. Do you mind sending it out for
>>> formal review (I will be happy to help review).
>>
>> I think it would be faster if you just added it to your series with a
>> Suggested-by: or something? Unless Zi objects. The change is straightfor=
ward.
>
> Let me send it as a hotfix separately, since Andrew prefers to have a
> standalone hotfix to avoid splitting a series.
>
>>
>> I'd perhaps do just a
>>
>> if (folio_put_testzero(dst) && free_pages_prepare(page, order))
>>
>> to avoid the goto?
>
> Will do.
>>
>>>> +                       goto skip;
>>>>                 list_add(&dst->lru, &cc->freepages[order]);
>>>>                 cc->nr_freepages +=3D 1 << order;
>>>>         }
>>>> +skip:
>>>>         cc->nr_migratepages +=3D 1 << order;
>>>>         /*
>>>>          * someone else has referenced the page, we cannot take it bac=
k to our
>>
>> Maybe in the comment here add also the possibility that _prepare failed(=
).
>
> Sure.

Done.

Link: https://lore.kernel.org/linux-mm/20260622-handle_free_pages_prepare_i=
n_compaction_free-v1-1-fcf3b14abcf7@nvidia.com/



--=20
Best Regards,
Yan, Zi



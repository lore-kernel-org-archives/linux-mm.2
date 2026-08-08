Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D6EC55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 17:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F096B00C8; Sat,  8 Aug 2026 13:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9186B00C9; Sat,  8 Aug 2026 13:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69006B00CA; Sat,  8 Aug 2026 13:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2346B00C8
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:03:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78B86C039D
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 17:03:08 +0000 (UTC)
X-FDA: 85078722456.17.4596362
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	by imf21.hostedemail.com (Postfix) with ESMTP id A50201C0011
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 17:03:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DHrJNWRG;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786208585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8N+Fb3gw5A6JHxth/ie6KzN1ODFYHGZkYixswGBa/zE=;
	b=OaD/RLVGmRSGME6+qn0PK5kgLRE8IPzysv0LCyoNagOgdmKRTGFqs2aSc0vtQ4Qit2GXM4
	SKxEwekPgCzqf+0gcIFpx0GBPe3JM1ptfFhgW0BrJ2WerBgNJD8boKGOC6gK3/CpmoGnyn
	r60t4357JvOTMPahp8ef9HlKbkC+cXM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786208585;
	b=Ly9QdpVAMo0WDevQmaKb/Ik3d7HxnJxNebKQyanR6wjisaoYJNHKznD3AYail7Cq8WsorG
	YgNt7GHrWImeK2hcnqXA+NEhKdtBYLttKupPQKMGbOBkVQQZT0SEOR0bASu7mA1344ttLc
	ZqRNEy16LaeyOPna1vaXI7aMxqpo0qE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DHrJNWRG;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zb2SVdhEicRhaXA8YdXAUFNe6Iua9XYAnuocrV6av83FRMjFNS1BHL7ycXu4vMmlP+GqdPEVKV2cx+TUTjXEiz9vglBfdMqugHQjVMPJFfgdgH7gxLNXNl3AULiCxDsuSukroGrMiTbtaRfHji6dTuBkCwMGPBNtNbN0EZMRYspyE+8e62tsAUtStrFjLLAwaWorNZonB1UrBU0DbynJNLcy0Qc66bIBvtgp+XJAAJW6invXZb0gjqYe1V3hUdCj1wSdPOd3Z7JvE5TEQSHRFwvXyBrE9Oo2o5FkSeWCEgOjSm6B04yNHf5vavT5cJUdJc0YxsbztKBU7E6BjHr43Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8N+Fb3gw5A6JHxth/ie6KzN1ODFYHGZkYixswGBa/zE=;
 b=FDgNvD0Td0PMk+C209dyUzPWYclMkdM6jNUA05q6z2zptlP4TpZkoxIapwOKCaLsyvORSiE/EaTgHGRMXoTFGNylOI1kLRXM5s60QDa8qKpzXARb2eAXJnHkKUtAE9Z1F/GuokPWU9Vp4DHAX/2aRXCfoouXMUKfc9kRSz4+8n51Xv0qhpQcKO6i0JXuJWjFNtxoe0q67bMz99awZhNJaEpG5bgalJIpQ9Iyz76RWfNObHN9zaNBiq1KmPCR1bWu/jDONW4hnKReIYqWgjP75YbIdbIe4hVVS1rxEzZ4VdioJs3B3S4ZL2j0EvROJHeg6iTTwUAYGjZjSX9JeQw8ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8N+Fb3gw5A6JHxth/ie6KzN1ODFYHGZkYixswGBa/zE=;
 b=DHrJNWRGiyAs8gUBk5j+CIlffoOP1Ht7m9DH+yCNixjHkvlNYBTb7L6XMjyHMc1sWLRBgOEkbEraiClS75l7Eg1HPy7CZyrrX7Z3ydD1fnTqBBL9/0AR/vGQY1fqr2OXKJVXMNaQOiXQkRAhkVbL2BEe0X3jpfNR0j6MEtc0wU9VXTCW9JWCGof2CLQBLZA5wJ7CR0mT1A4NEFWzEr8wnymGtRenWk+yWadn/z7FtoFGpzxMOb62iIsIoKPoSpPxnbdRyy6ziJL0cEvn4rM3pERhXClg3hFf/57CM//9332G1ukjlFQsZW9+Ip7fVfif9baceFe8Yk6ps8JZ7+yTHQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Sat, 8 Aug
 2026 17:03:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sat, 8 Aug 2026
 17:02:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 13:02:56 -0400
Message-Id: <DKJQ3G2MCOGS.7T7QJ4TDZWG1@nvidia.com>
Cc: "Kairui Song" <kasong@tencent.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Shuah Khan"
 <shuah@kernel.org>, "Nico Pache" <nico.pache@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>
To: "Shivam Kalra" <shivamkalra98@zohomail.in>, "Kairui Song"
 <ryncsn@gmail.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 0/3] mm: support splitting mappingless swapcache folios
X-Mailer: aerc 0.21.0
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in> <590B3189-5B66-4ECB-84CD-7B7EF18C0E54@nvidia.com> <anNOroQdjQh7xmU9@KASONG-MC4> <DKIRYOJXLIYN.32KI06POZL7SY@nvidia.com> <anZLkwwxHdhM2M2Q@KASONG-MC4>
In-Reply-To: <anZLkwwxHdhM2M2Q@KASONG-MC4>
X-ClientProxiedBy: BLAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:32d::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c25f074-0626-49de-8260-08def56ee5b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|56012099006|22082099003|18002099003|4133799003|4143699003|6133799003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	1uuJM02rLxKrfEI9dAOObbtXSiSYFjEuyTY79EmHPQy/OHM+jiuJohd2IVzRaHot/HVvxyjrEHLNHHhsjY0ttlMCwHNFyPspfLISyvo8JW84jpystqi6oWo1GqQQkSJoFeBezDQYjYAEgsA9QnyA2OyUrKCe+7yLQbVo8P77jEJPUsOUp1bmhCcamC4qgaccF6PTBPHuHE6EiYjrDqkkuFoe9XVMs3HtQlTGcXmjcLDGHo5aemLIRENgF0XoDLesmZytEIipPHMllW06e5N+DC3fcb1PVuNTFtLIFFtxXbY1c8s66Iuv1B4o0eiJYUaJBWE55DWjLhswC6WamGFkv+KrIo5A3SLTS0ehkXVCRXdl6mgm/Xo+mVIT9b4cXBfnxI78Aynjp40gX8St9QrSr/rbzE7qxmKcSJj1NpL4LOMYcghS2NbXN37ZxWBNpVPFqO5A35dyK4u4uMyHjCzdZizlww6F3ZR+n+zQ/mSRIO6YPYndb03aMQe7tZpR43dvZllfQEWFJrIP0ssoTA1SCvNFwzwYv/DK3t5uZeSFZOGM4KaGR5e7VJ9iC7oC66PSZDAF740NRhp0FmhRRskaubZG5WICrR1HW9UrzL1HCyIBkd+9St/0MQcHZO53Oq6U4YazrqJGD2cqXyyUWWaHXachPHcGld79JYIYJu/+MhU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(56012099006)(22082099003)(18002099003)(4133799003)(4143699003)(6133799003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?allwSmE2d1NIeVROR2Q4T2kwZTJWQmhPV3B6LzFKajNwUEx6S1N6eTBXem5B?=
 =?utf-8?B?YWNNb0NWTStUWUZhZXFYOEdocEFXYTl0b3NQVE81cmhBOXpXREVZMlEzSjhM?=
 =?utf-8?B?Qy9YTmVvd1daMkpVT2Z2STJyemVpTEtUZ2QrZ2pKZEdERkF4bW9uNlNGR1Ni?=
 =?utf-8?B?TUwvTU9YcEMrbHR2elpNV2ZSbi9sRUt1WTFpSkNFaVBGbS83eHIwREVQOWVv?=
 =?utf-8?B?MFRuMEFUcXNmQ3pRSkx0OFFiaUtTZ0srM203VDNEVGhHUFcyamdjbVhYQnZM?=
 =?utf-8?B?anM1OXNDUjJMdGJjSXhlRXVsMUladXhDeHFvcmVEclNwS3lSVDBCbGlYSmlM?=
 =?utf-8?B?S0x2cGtZR0E3ZGtVN0p0M1pjVlBLYXN6TTFiclRuVWpWd2JaQUtWSDV2QWdD?=
 =?utf-8?B?MFd5OGpOenlpajBsbTBLNUNaeTdGQnNQSlAwU1cxUGozaXVrQWxlMUJtSWxx?=
 =?utf-8?B?a0pKSDlzbjNneDZKdTdLN091V2VMdmtQOWtUbEpITVZ6YlBIS2dLeEtBc1hv?=
 =?utf-8?B?VGREUG9qWDBKOWFscmZaTTZWMTlybXQ2RmVTN0M4OTY5WnNERXdRNVpuWG1o?=
 =?utf-8?B?RkhzdVF1aEltQUJ1M3V1RkFsdkpYcHRzWFc3SWZhSHN0K1FjOVdSaG5jQmRM?=
 =?utf-8?B?SmVBZ1o3YmNUUXpEWk9yNytIZC9YTFdHZndvaXdGU1hORUpKNkM2L25POW80?=
 =?utf-8?B?T1BBYUZqeXdsdzVZT1h6VC9FVVp1b2Jsekk5cU5McWtMUXlTTzd3cmZkUzQx?=
 =?utf-8?B?TzFLRit5ZDhDeld5MU1kZ2JLdHl1emNVMldXaWE0cTRvdWMvMlh2RFhxTWVu?=
 =?utf-8?B?RkZVNFdCb21VbHN1MHdkbWZvU2hPL3JrSkpjSHdTZUlmZzJxeDNuS2d0NkVI?=
 =?utf-8?B?aWszcHZOaDdnWEJrRHFNMUdtYW5yd0pJalIzaEJJRklPOG10Qnp2R0FRRW9H?=
 =?utf-8?B?WGRpUDhIMFE5ajByUlZ1T2xlZlRqZ2lxVU5uVVBBL3FRdXNTeFp4WU5WMi80?=
 =?utf-8?B?bjhrcFdvcFg0eENBMkV0SHp6OEdIamhpVWp2TllTWXBQbzZNWG9uNTk2emQ1?=
 =?utf-8?B?bS9NQnVnSitYeHA5d0l2ZFNnd3pMa3hFVHhKMEliQXZvcTcrM05KZUxNWVZF?=
 =?utf-8?B?QWIzcm5CVU56YUcvTmRxbjg3L21wdGI2LzF0UjBHYmNUbmhTZk9GdTdUa08y?=
 =?utf-8?B?Qzkycy9mYWVSMjBZMlMwbzdwQ2F5MDYzcFY0ZU16N1NlTHl2RW9HbGh2KytP?=
 =?utf-8?B?RXNYUEdyNlBCM3dtZG5xTHBweFhOZndJclJwbjNMK3hndlNxQUw1bGg2d01m?=
 =?utf-8?B?T2RBQWpxMDlHMmFCTkJxYmtxNS9FVWdxMWxPYjZNZXV1a1ZneDYxYkdDaHBR?=
 =?utf-8?B?a3BhdkRQSkw1dVlNQmJ2bytxN2VPMWZ3WHlsT1ZXNVk1V1dDMk1HNjlVU1dO?=
 =?utf-8?B?MWlFT0J2Yng5d2dWK29FWkp2U3hENFJncW80MExHQm9COWR5cVI3N3dUUFFi?=
 =?utf-8?B?SGpUTEw0VWo0MDVGZ0tmS3VHdXYrbVRFY1ZhNUNOWmRhWEtTazVPVSsyUm9Q?=
 =?utf-8?B?ckVGSWhrMkJpd2k5RkZhU3pNRjNjVkF6bVBiMjdUVURiK0Z0S1NBbkpSbEx5?=
 =?utf-8?B?dk5WWXRJNFQ4Yis1M2VWWTlOem5uSExiWTR2TlY0azk4UngvUWh4Vlh1N1h3?=
 =?utf-8?B?UHY1bFI4WmhkajdTNjYvVk1QQisrU1Rjb1NMODBOa3lLQ0tPTS82ajZqRytm?=
 =?utf-8?B?S0NnN3h0S0UvenZ4UTdmSENxSVJGTlVPamloUDd6UklXbEczM0JlQ3Zyc0M4?=
 =?utf-8?B?NlpKcDhzUUVWWVJRVWtwTHovdnNVaUQwVEFiZWRWVExVTXArd2gvT2RWdnh6?=
 =?utf-8?B?NUxxclJmWWhGZ1VzLzR6eE9ONWUyWGc1YXdEdmpCNUU5YkF2aEI1U2VyZkZ2?=
 =?utf-8?B?ME1BcW0vWWVUcmY0dFlxTnJsYnhRaTUyUUVYU0JETGUwUEVQeFhVWHp1cDAv?=
 =?utf-8?B?b0VBTzVkdGUvQnZWMDNQSi91T3FYOGgySjM5L0syL0dsbEJoYUd3M1VWSDJF?=
 =?utf-8?B?bGc2bDAvTnU1bGYwaEpJa3NYYVBLWDE3bUswRXh3VUQvTnhrMWQ5MnhydSt5?=
 =?utf-8?B?N3FiYnFUODIva3R1aWJHa0JLdjd0UFcwNlJWN2VmVzdIVWEzNVZ4dkhoMWpE?=
 =?utf-8?B?N2FhamllNEdVakFIME5zeEJDeFhQN0orYWhSY0VoT2hmKzIvLzAwcVR1RDAr?=
 =?utf-8?B?eDFFNUJRUWVqZnBXM0pPRTdCUHBUazI4dG14eHZBTVhWUmdGM2svRlc5NHhG?=
 =?utf-8?Q?MFClkKlgz1q8P/XVOS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c25f074-0626-49de-8260-08def56ee5b2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 17:02:58.4502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/ThR/1D/FxfpLiJLrNbjXWSrV9Ee/h08AR3nANBa6dekwbOdVoRYqCIy08505mg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A50201C0011
X-Stat-Signature: 9xw9p1zjqd9e8xxwi3scdxsnuprgdeiw
X-HE-Tag: 1786208585-294781
X-HE-Meta: U2FsdGVkX191x56+VEeCh4/lez5+7lLd1qUd2aoz3tauPNzJaaUn/wN94QEkGNg5xnTr61Qclo/KLfVRMfV7e4mR/yIXJ+UmtHzGnqPlhkARPh056E8PCQNWlpiScORbYLa+wXRlKqOQX6lzO/a/BXWrWI1Q/osxzcoMc7vMISMbaPHxRF7hhwM5TCNi2g8nmZuYDq4X1tYCl5G7wHvpbt4HxgDHIrJ2/dNswnHppSGE8oiqkBp8WXcGnatVilHWE081frIVLNlyW7fCmT5jQSb+6/B7uPzoQ+aojthrzfiTJSbSwLXkiKJqq8NxX8sGhscNDyygq3e1VMKkrIxhodb3hppzRQCvfwaGxif+/VTi6AKJm9Vg49nJAsUwYE8HNC5paOw3GVVPz/9zfr8C9v/ByVuqkz866O2i205qzXNiDEiLhyXh04p18q5VPoFAQPeVAMnAzwxoCyoPke6vYD/Yz3JHLVhutlTgnNEpICtCSXHVs0angyCjUgY3zj6PbMsdS97ssv1+dz3GipN49tZgRSYZX87lDFNS+FffMpIY3Ul8MuDbRg5p6X5jqbRdhkKq/jsjhoYh8W1eDzORZbWVPvwJYw5tuh/Vmtc+Yor1l6WG4su27VA+XXOq2slCvwdA3Gyw+ggz+eIwEG7/dsb9pfITtzSucX4WaIx8N3V7e5HsaFXyr+kTvG2Y/Bgo8OXzHBFIw5TLhSVtqbgaREu1ijXXtMJegZxlU2M8XFzIxZQjJ0qUhFjSu4Ltu0uBvm1R2rePSrChP6eMreHOB6zdrPsdz0AGb5/ELJxyNpRPGS9nIjxMiHxpLcgZOzqA5ScVvpGkBdiLr0yK1wTv7Ezi7rqFPU6e4pHM6pnFn22/DhyZKpNkutiq1SBrvU6fbxpIW99I6/k5wRXKfd8JbZ2E+MzkkWTqIk7a0MJWVGfuZpJfvH3X3qNW9csBuJGR7uTHqMYELaO25rS/aC8
 txWcianC
 nZyKcSKwuApcepJkm9W7oAdW02J4vbUEdSRXcoZLffcdm+m07wiTly3wD/VFw3aZdJ/R1MrE4aGl7xhnhjnYcyUWUoSxHDXTPsCKHzMQODtyPM4+CNQuQ6QERWAnPw5RC8vhRXRGTjj+J9R++24Djzn5IfR86Nj+Pcm5urMKpo454GaL2QHdAaA6ayVdROwSFmiDAEGs3SiAxvp9rkmZBBoOJUibN3ofskFSRAc7ix36CrPSyOqyrvR8yWq7GHSdaGvF/gcVn7FqIV7bDq5UqA945x7CmEZ/DbfewTuqup3p3AB6NapBHi5utAmQB5W0jGwDpK+tY7yIblKID9rc+q0Gss0OnUS156iTvGpb+MlV8ydbsARg9OmdMwDe8sQXv+hic/RSB7K0KzVg6Lo0tPOb5pUytyyeA3KbVvQU8xH+rIr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:22 PM EDT, Kairui Song wrote:
> On Fri, Aug 07, 2026 at 10:18:05AM +0800, Zi Yan wrote:
>> On Wed Aug 5, 2026 at 11:54 AM EDT, Kairui Song wrote:
>> > On Wed, Aug 05, 2026 at 08:03:33AM +0800, Zi Yan wrote:
>> >> On 5 Aug 2026, at 7:18, Shivam Kalra via B4 Relay wrote:
>> >>=20
>> >> > Large shmem folios lose their address-space mapping when they are w=
ritten
>> >> > to swap, but remain valid members of the swap cache. Folios read fr=
om swap
>> >> > but not yet associated with an anon_vma can have the same mappingle=
ss
>> >> > swapcache state. folio_check_splittable() currently mistakes both c=
ases for
>> >> > truncation and rejects the split with -EBUSY.
>> >> >
>> >> > Implement the longstanding TODO for this state. Allow mappingless
>> >> > swapcache folios to use the existing uniform order-0 swapcache spli=
t path,
>> >> > while continuing to reject truly truncated folios and unsupported
>> >> > higher-order or non-uniform swapcache splits.
>> >>=20
>> >> Thank you for your patches.
>> >>=20
>> >> As Kairui (cc=E2=80=99d) mentioned in [1] (see =E2=80=9CA bit more de=
tails on this=E2=80=9D),
>> >> we might not need to implement this split. I will let Kairui to decid=
e
>> >> how we should deal with this patchset.
>> >>=20
>> >> [1] https://lore.kernel.org/all/CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756B=
vxMQC_MCn2eTyA@mail.gmail.com/
>> >
>> > Thanks for the CC, this is actually not hard to implement as shown by
>> > Shivam, I just found the code more and more hard to follow and fragile
>> > as we add more logic to it. And we don't have to reject higher order
>> > split either which can be seen easily if the code is cleaner.
>> >
>> > Personally I think doing some cleanup first is better, I haven't post =
any
>> > code as right now there doesn't seem to be much user of this. It will =
be
>> > needed if more clean THP swapcache begin to show up due to things like
>> > THP readahead for swap, which isn't here yet. I think I can send an RF=
C
>> > tomorrow just for reference. I'm fine if we prefer to remove that TODO
>> > using this smaller change first :)
>>=20
>> Thanks. Can you also help review this patchset? The changes looks good
>> to me but I am not sure if I get all the details about swapcache handlin=
g.
>>=20
>> --=20
>> Best Regards,
>> Yan, Zi
>
> Hello,
>
> Thanks for the reminder, I got a bit busy so delayed for a day on that
> RFC.
>
> For this series I think it's functionally fine, just the split logic is
> a bit complex to follow and we still have restriction on swap cache
> for order 0 uniform split only. I'll have a closer look later. Also

I agree. I wonder if it is possible that a shmem in swapcache could
enter non uniform split, folio_split(). With Patch 1,
folio_check_splittable() will return -EINVAL, causing a WARN.

Hi Shivam,

Can you check the above issue? If it is possible, we want to avoid it.

> let me know how you think about that RFC.

Sure, will take a look.


--=20
Best Regards,
Yan, Zi



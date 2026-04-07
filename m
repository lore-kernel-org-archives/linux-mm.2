Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6376FEEF41
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 13:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245A26B008A; Tue,  7 Apr 2026 09:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6996B0092; Tue,  7 Apr 2026 09:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEC46B0093; Tue,  7 Apr 2026 09:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAE026B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:21:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85E20C2798
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:21:36 +0000 (UTC)
X-FDA: 84631821792.21.A0CEC6D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011013.outbound.protection.outlook.com [40.107.208.13])
	by imf17.hostedemail.com (Postfix) with ESMTP id 76CFF40007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:21:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=spTzZ6PP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775568093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2FX56NtXi/VblAlUOAHPjqz8guTWDBOuXi4XmFcv1Y=;
	b=xDT94Tfyh03vyVOiZbMMot+9v76BibNLwRqPRFswd9EeYw48gq2zJlTgOuvUY6anR1GM8z
	j29eVto1pzf0UZ/p0uKu6a7zfu4QSMtttgWScAM7Hw1K3TRRJALLumTZcC1edQUaj0X+0d
	KuqoswaVYVeNVImSeByXbeD0+79+gB8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775568093; a=rsa-sha256;
	cv=pass;
	b=DeTg9OGn8QztaFMQVZOP9pNLpaL6gLWUqy+FqXs3emTRR6H79BjQoPrCfAXSbKETROIrwG
	itIO3xYd7m/rDSuxat3bbf3CrHNgqULZabVfeTH175jHAOjp3oviIaE84Ic+TCOlJwLjfT
	S6fjkghUYmAPGjsRmVjRocaqrlzqs00=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=spTzZ6PP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ibPp+oq1C6lv6eHHpHgealloP9N2BPm3Pfq6Gfcv6+TqWEHJiiZD1cyhbb6MMd3V72/AOa42HuNx4lZs4fhfs7uBdn+4KUg9XsD8TG89X4NjK+BSDDw4EThyb/M/eE6FqYIQ/MIvvR/gTxQLitnL4eFH1jx27UQsJHoFPe1IvSRokYB7Qg0nYYTsbnMcnalJQKshMmzvpjQPGTOQww+zfvsIR230369M+l87g8uuQxM7BVli83Fb2z/CFiXxyr3zGXAeTYTVg4jEhHdGMTJdcqRB7J8cxQzIMDicIQ/gryDL/hGjJ71mG+2JqWTYtxqALs4mgKExTxa8zoqJcpUjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2FX56NtXi/VblAlUOAHPjqz8guTWDBOuXi4XmFcv1Y=;
 b=HlHHmDbW0giGVCRAGl2TsA9mRtq9jAqa89ewLdjMCusK30blW5d4bjPjGfvwIqzW765xdikD4cfAlr/vQvFZ0hbpGtfscx0b9GB0cKQPScbbbP6gK5bqlPtEM8evXMZ9pg+L3NhaM508ANi16KSIiMOR/pirx8dwRa38C7Vz36MOMWM03HDzXw4YA8YqYG5X0ZndHjpke8RQkVSXdr5C5kT6i+jfayGD0WS/51l9TZh3B3RUiqc4L5RSgUUHOBvC3MIxmHRFsrOKHYAbTDIQ4toqIeRq5Oxym9fg0JmWQ1jLGlDY6rV1i5LPzUKCGgRuoq4gGbprKiOYSoo2H8J2mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2FX56NtXi/VblAlUOAHPjqz8guTWDBOuXi4XmFcv1Y=;
 b=spTzZ6PPVMr0Qs4XB/bVxfktp3hWj25DWCzJKcJ/uwvcd8TBf/3ZaIGO33EYp5Ypp+LhbyfBG8omr4m0cgXQHJEWczxEtBuPFR1byjc6hKr0lT+0Y9kHsLYSOb1fPjZxsSOQJH46xqAp+wW/CImfbVNtERIBPNlj9dLVSt9esf+8JxKTjGawZ4unQP7ROJYO0mGRib/Lj9UnwU6JeLeh4hPpYy/Miyvd/6SO5P+T0tN5Daw6+zIciaSH1ZRSiw1XBfUQJzNbQ0TO0nAfj1OmArNk25OgtAF/YTCIUgQRQOG2ogPBwvZ39L657nU3CMTBrtCELf3U3D/C1X7uQRlzSQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7435.namprd12.prod.outlook.com (2603:10b6:930:51::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.18; Tue, 7 Apr 2026 13:21:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Tue, 7 Apr 2026
 13:21:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
 =?utf-8?b?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
 Evangelos Petrongonas <epetron@amazon.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>,
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Date: Tue, 07 Apr 2026 09:21:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DFD0C0F5-F23B-44CA-B2C7-9D03F2397DCF@nvidia.com>
In-Reply-To: <2vxzwlyj9d0b.fsf@kernel.org>
References: <20260317141534.815634-3-mclapinski@google.com>
 <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
 <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
 <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
 <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
 <CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
 <58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
 <aburnbP64n9axmu_@kernel.org>
 <CAAi7L5evx8ta8BifNiGNfUoTiaBUsv4cgQRbm_15RoAfdKPcMw@mail.gmail.com>
 <acAAp4JaTGn_STBH@kernel.org> <2vxzwlyj9d0b.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA4P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7435:EE_
X-MS-Office365-Filtering-Correlation-Id: f44a00dc-8fc5-4bfd-4dc5-08de94a8938c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6q/TbbS3iweP7MiO2TWyy1MVglCVs3yimYm5CrAoh+UBeDHvzibGnZDoyMyud2YxbBOxj+YgXbzcMoPAYCXfABqmcvWPPHJtb0cwBESnIRGnismSqfVxSBfr5VlaMwLlHNiGybiMA6lSzjSjsNG9EelE5821YZMSdz9vYXdW4/TV96bbWyNVCtiK3NUmbI7hZH85dmPF1ktpctvaTLfYrVGBsoWHjmFbzkt57pEIZWTiteuSOt4BAkSYp68DaFIsdtnGjubmjfJz2Yp3CAACUwdJ+QgP0nvdNo3ZWkq6cvaIl9S1t0kRo6pY6MAqjmi0V2bSbJ3KjJBprThG4O656K7wsAFuoqxGA6VAlJpou+O7hxFqPjQLfq6ksx97dTVbppWw9qF9eWee5GZhNkL5JoUwQjDPItQNB7fvCMQeKtyt9a7olZkKs38H2b6Slr14oFWaj3cZ03RJzJdZaR8yYLqnnYuLv2TbuTCLh47jOUVjsg+VMjNl/EzTot/79qCAOSxyZGc0o976cH/0ArvgJ2pfIV2mqRCJSYGkZJF8Wsh+kXpwTkhJGYZo+V8/6y8An6cUyNA4d8VGh/3tWB1zNe5QkcxXKwluXahIRz9Srjqkv3XQQfcOpLTbWpK2iguQu6nBCWDpV1m33IEMypnXV+WgaQCgLI6dO6CT55PgN3ayrdiJKErP0I11CYrDLZe6ScdquNdIOVS3Gtj5+mMUEKo8U4+/3Vqd5aHXF8whAy3d0Cq6CoDGZkUir3ftCvk2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGhPcTNoSDVncUhOUVJsL1pYTWpPQllZNWN4dUdHVHYza0NQazlOajk5dHJP?=
 =?utf-8?B?TUFCUFp2RDZCQzhqUEFic1c2TWV3L3hFRXQwc2FJR2ZuV3J2T3hEZkFHZWpa?=
 =?utf-8?B?SXphMTdjQkFmalY1VWY2U005N2M3NHp2OFFndlJZaUx1TGExRDBuS0lqakRX?=
 =?utf-8?B?Tmp6czhrR01kd0o0OENFMXM0WDhwd3dmQVdnS0tnNGs2WWtWOTExeFVKYlNr?=
 =?utf-8?B?QTY0ZzN6VmpXYXBFYzd0OExXcmptSnBheDVOUzZ4VTltMFNvcmt1a0pJcHdN?=
 =?utf-8?B?UU11bDVVYXpqNG1ubk14aEZZNGx0MHh4MzlnV2cwN1RJbWhHTDlXSjF3bytN?=
 =?utf-8?B?c3c0VVhtZ3QyRHU4RklnRGF4RXlrZ1QrSlpyWnF2U3JhUTI0Y3FmSEpkeERL?=
 =?utf-8?B?VjRCV2pzYmRwcFhtQmlreGFpeU1IYjRoSE95UlAxV3hmd2U5MlJnanFrNklR?=
 =?utf-8?B?QnRTUXBlMmJ5REkwVk9IRGlRSVpOQjV3TW01ZGF2YWJDeTd4cEZxa2RaZHp6?=
 =?utf-8?B?SVNNc0sxcVFSSW5GVmJHdlVkc0pwNE81dmxGaDFnaHJzcVRZNHN4cVJWT2Y2?=
 =?utf-8?B?T3lIT1MxNU03cUszTmlmVEM3V2VGcERwWlJOQkpEU0pTSmpQSXYydGpZc0Fr?=
 =?utf-8?B?S0N0dzdtRkxpZUY4aThCdTNlOHhjbklyQ2wyenVVdFlKUUgvczc3VFNuQmcz?=
 =?utf-8?B?ek1RbjlpejdVaUpVVlFMK3pEeUtSNVNoYnpLRHA0SVpDSHFtbWFFV2F5WGtS?=
 =?utf-8?B?NmxJd2pDbzlwNFQxWjB1Wmk4YjUrMEhKMUNkZWcwMDcyT0NWWTB5OG92SzZk?=
 =?utf-8?B?cWcvVXRGWkRJSzZINlcvL0JTNjVyYXdqMnhsZExmSHJoSWpySHBqODRDci9o?=
 =?utf-8?B?ZWFQbDRzMmNIMUVlemF2ZWZUYStnTmM4Sk1uZTV0ZENCSy9yR3UvT0s5K1JG?=
 =?utf-8?B?OFMwM3VYWE5ZcW5ROXZjZ2piUnFrSzNXbldzQkNOa21kTktZME5mbHFDMytq?=
 =?utf-8?B?OHlwRXVJS2hHV3ROanpBcnU4QnB4MnR1OXNzcjMrM25taHhJKzhBYyt6UDlz?=
 =?utf-8?B?cy9GT0lQNE92ZGJkWVZQdFp6a1l2TUoyVHlVVUhwN1VBZE5rb1NTVExybHdi?=
 =?utf-8?B?cXN4VUI0d200b2pmQ1FjOWpHbkc3R2FocWZ0YXVqWW93RmZOUFBsVldIckNB?=
 =?utf-8?B?OWg1L2FmYjRhZ3hRaWoyVXp3aFptd3RIWThRRGxtNVU2MjlpZSsyOXhtRkhD?=
 =?utf-8?B?OXZiU1B0OGt2LzRiYkNkcWFUNHFBYW5RU0NxS0Y1MzVadW9QTk9ZTEpMSzBI?=
 =?utf-8?B?MDRveWVYcC9HRm1PS3kva2pkL215cDB4a2pUbnZBQ0JYSnNRajl6VmxPc3FY?=
 =?utf-8?B?Mm93ang3V1N6c3hpVi9IeHZSVXB0K25YbmZMdGdUY0xTMisvckcxNThUTjB3?=
 =?utf-8?B?aDhwYmFoYnBGTUduZEl5Y0tlRW5HREJxQVpkTVA2Q3hvRWVwZDk0UklLMENw?=
 =?utf-8?B?ZWJNVzEvUXVPSUlIZjhydnpBeFFzVHFCcUVwMFpPSEt6UFMxTXg4SFJNR0Y4?=
 =?utf-8?B?a0JGdFRzOTZFMmxoY0FROGhaeHl4UVgzek5QME9LSjFxOFN6RWdtTnd6UDhi?=
 =?utf-8?B?SWRKb2xNSHp1R2ZFZi9mRFVNNGMvN1A0U0ljYUtNZlpWT2xPZXdiWFdsMWRP?=
 =?utf-8?B?ZWt2MHBMcWJUZGxZNHNoaWZkQWk1QUcyVzJlVkZZcUVGdEFXU0w2N0cyMUVM?=
 =?utf-8?B?WDdwUlFlTlFVS1dNT3I5dDJFNGh5Y1hLcytuOHhnWGR4OS91QnJXQ1cwTG1Y?=
 =?utf-8?B?N2tqMkpRMThTNVFVU1JPcW5oLy9pUzlTc2J4b2RJN0NEcENjU0l0RU16WXZx?=
 =?utf-8?B?QjBQZEd2bHpVcWRGc3M5TThFbWNLWmxuWmE4bWxsdEFOUXppT0hBRmtoaldi?=
 =?utf-8?B?Ym92cnc3QWIybmFaR1VaTEFRV0pvcmlBL3hJWlk4SVVqN2wzb1Q4MzhPeTZV?=
 =?utf-8?B?V2lHZ3NwVzVFeEJxTlVxWUdXc21YUk9EVnp1Tkx1cHgzQnNZelYweTNuM2ls?=
 =?utf-8?B?Rzl5Y3M2emlxRWV1L2JaSTVYMHJ2RTFRbXNiaFdkckt4SXBLcUhhZWlvc0Zr?=
 =?utf-8?B?OWU3aHJOUGJFZjYxVWlRMERMM2IveUc1bUJkc2RFRHdmM3NFTUdleUVXU2pU?=
 =?utf-8?B?Yld6anVXSXZ6Q0pzSXd6YUxTdUpZZjR5MDlRa3duTkNvOU5JYmpMUmlBMHh2?=
 =?utf-8?B?M2MveHdUNkRoK3ZNOU12VDFXd1BuTG1DTFJmNG15bGs2S2t2SkZNN3pQNVVC?=
 =?utf-8?Q?weep/YISrG8X8hApVS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44a00dc-8fc5-4bfd-4dc5-08de94a8938c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 13:21:28.5446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgdjiyoYBGDjAajVBosYE6aP3NZLnd+f/7meg3EVeJ5Lhb1ogopJJDs134k8hfaG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7435
X-Rspamd-Queue-Id: 76CFF40007
X-Stat-Signature: ous8b1ahcxzok5yafoqcrr556s7wo85a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775568093-351404
X-HE-Meta: U2FsdGVkX1/PZ1moZe9CinGGd16a9WpoNJGPpi+TKl8jcUOpTJn7Yoa0MWhJoxjNJq3jrUHTIvMAZ6DzNiG5stXdEPDlwPBEmwAlM8SmtvmuFvCRTsG9iBNP1OEzrzLtZkI+OMpi+bRwvJpRgILmc0YUM5yBeEppnCWntqkPFTKvZYrkN2uAvE0d5ESOOr/twIFCdfre8ZI2F5Q4ZxW/+ro2vERot7ladrHWSDsDuZhqCTlpIsLPYOYWysmRoPsskCwSNzpPkE0quiP2fpBmHTWsHhigcyeFSKFxdv6padMvLi168ucp1R1C1018SPnvVXc5E4auvkzn2Q9qKoDJO1fZTHXRpsIv8vITfPivbSuvWVP2taLXoIJlB56xzNFqVqltmEKrslHJKffV+2M02i/VOLhxeWjaIkmlYj7m6akvNy53TkMOPKPznzxtHQW8XCztR4sf9HkVrj2aL+fOh6b7J8Z7/0KDvPHvq0qXrVFyWGzDCEY7YQ+aWXqmKJ7vxMa7ww65Ap+J2uxoNKMEnuaFf0hKWzaixjS6P7jREWCojVW3Ev3AsMINtzkCNhRBga1NHLG65KpoF5yCWmi72KUlAHwd0q5YMjYJTlEjEQyDIsIm6jtPtchE9hBLv6QCrihZpILIj+a43ygWTlJNuINAfLam6CYQj1NaTPBHTLaOyBsO/pvgjbaLJ1rqdnLGOU5xfk0+wb1scTpob1C3Dy4mI8yy+25w3uaskWumgA4I02F7M7kv7xteT4MjQ113ncVlF4ucuNFIVhZTZ6QQpk3+a6lJL8PsQlGrMznSUqoo/DA7QIHGiys0MmqAVTrQqpE6vLmliqOx/JXRT3q05oifse01PKRZSZnUedRzQWMblv2WaNqLiGJoxjiy4jJaoTAqMT7ZbWX7mwxhP1lUZEYp3rAJXQ2eSTRg7cncnyhpbeDJd2G57rN53YsjWoP+zgiKP1Nz0r8++aCREeJ
 lK0EJJ9H
 Eyfcj+icbBxe50jXOU+uP+DRd7O016tar1vAqCE7tCNLzvi5dWsCMB1oWb6Ls7O9sIlfoB8YFprQJs4ybdEXOguTuLCJENXudc3nL/f0yPnzgWZ4j7+McI0a7bRHyylwFkEJGqRRKeVrasJA3WPBxIpxsZKSYCbNM68yGMJy5kqpQvB4r11pQB3xDT4rZJp/l7z54cmv7paK9LesMRlmiXF1b3U/GeBroRJL7ar90xycC0TqictzuZHuKoBFZffy6j5XHhiTTPXnFCYsb+/uzZb5UvJ9Wd81n3kxzk5w5LR+bsD9LFMZp9mTL/2nCneYB2JwtXMeOrXIVwRsxABxWKgLvGLtiyf1EWsBNg6GYfbNBWhrEKDQPHjNxNeLJT8DqnLT0AH1M8ltnNq5ymgoW/tBI86OIVFUFaCNvV+2trfHuwy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Apr 2026, at 8:21, Pratyush Yadav wrote:

> On Sun, Mar 22 2026, Mike Rapoport wrote:
>
>> On Thu, Mar 19, 2026 at 07:17:48PM +0100, Micha=C5=82 C=C5=82api=C5=84sk=
i wrote:
>>> On Thu, Mar 19, 2026 at 8:54=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> [...]
>>>> +__init_memblock struct memblock_region *memblock_region_from_iter(u64=
 iterator)
>>>> +{
>>>> +       int index =3D iterator & 0xffffffff;
>>>
>>> I'm not sure about this. __next_mem_range() has this code:
>>> /*
>>> * The region which ends first is
>>> * advanced for the next iteration.
>>> */
>>> if (m_end <=3D r_end)
>>>         idx_a++;
>>> else
>>>         idx_b++;
>>>
>>> Therefore, the index you get from this might be correct or it might
>>> already be incremented.
>>
>> Hmm, right, missed that :/
>>
>> Still, we can check if an address is inside scratch in
>> reserve_bootmem_regions() and in deferred_init_pages() and set migrate t=
ype
>> to CMA in that case.
>>
>> I think something like the patch below should work. It might not be the
>> most optimized, but it localizes the changes to mm_init and memblock and
>> does not complicated the code (well, almost).
>>
>> The patch is on top of
>> https://lore.kernel.org/linux-mm/20260322143144.3540679-1-rppt@kernel.or=
g/T/#u
>>
>> and I pushed the entire set here:
>> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=3D=
kho-deferred-init
>>
>> It compiles and passes kho self test with both deferred pages enabled an=
d
>> disabled, but I didn't do further testing yet.
>>
>> From 97aa1ea8e085a128dd5add73f81a5a1e4e0aad5e Mon Sep 17 00:00:00 2001
>> From: Michal Clapinski <mclapinski@google.com>
>> Date: Tue, 17 Mar 2026 15:15:33 +0100
>> Subject: [PATCH] kho: fix deferred initialization of scratch areas
>>
>> Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
>> kho_release_scratch() will initialize the struct pages and set migratety=
pe
>> of KHO scratch. Unless the whole scratch fits below first_deferred_pfn, =
some
>> of that will be overwritten either by deferred_init_pages() or
>> memmap_init_reserved_range().
>>
>> To fix it, modify kho_release_scratch() to only set the migratetype on
>> already initialized pages and make deferred_init_pages() and
>> memmap_init_reserved_range() recognize KHO scratch regions and set
>> migratetype of pageblocks in that regions to MIGRATE_CMA.
>
> Hmm, I don't like that how complex this is. It adds another layer of
> complexity to the initialization of the migratetype, and you have to dig
> through all the possible call sites to be sure that we catch all the
> cases. Makes it harder to wrap your head around it. Plus, makes it more
> likely for bugs to slip through if later refactors change some page init
> flow.
>
> Is the cost to look through the scratch array really that bad? I would
> suspect we'd have at most 4-6 per-node scratches, and one global one
> lowmem. So I'd expect around 10 items to look through, and it will
> probably be in the cache anyway.

It is not only about the cost of going through the scratch array, but also
about adding kho code to the generic init_pageblock_migratetype().
This means all callers of init_pageblock_migratetype(), no matter if
they are involved with kho or not, need to do the check. It is a good
practice to do the check when necessary, otherwise, this catch-all check
might hide some bugs in the future.

>
> Michal, did you ever run any numbers on how much extra time
> init_pageblock_migratetype() takes as a result of your patch?
>
> Anyway, Mike, if you do want to do it this way, it LGTM for the most
> part, but some comments below.
>
>>
>> Signed-off-by: Michal Clapinski <mclapinski@google.com>
>> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>  include/linux/memblock.h           |  7 ++++--
>>  kernel/liveupdate/kexec_handover.c | 10 +++++---
>>  mm/memblock.c                      | 39 +++++++++++++-----------------
>>  mm/mm_init.c                       | 14 ++++++-----
>>  4 files changed, 36 insertions(+), 34 deletions(-)
>>
>> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
>> index 6ec5e9ac0699..410f2a399691 100644
>> --- a/include/linux/memblock.h
>> +++ b/include/linux/memblock.h
>> @@ -614,11 +614,14 @@ static inline void memtest_report_meminfo(struct s=
eq_file *m) { }
>>  #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>>  void memblock_set_kho_scratch_only(void);
>>  void memblock_clear_kho_scratch_only(void);
>> -void memmap_init_kho_scratch_pages(void);
>> +bool memblock_is_kho_scratch_memory(phys_addr_t addr);
>>  #else
>>  static inline void memblock_set_kho_scratch_only(void) { }
>>  static inline void memblock_clear_kho_scratch_only(void) { }
>> -static inline void memmap_init_kho_scratch_pages(void) {}
>> +static inline bool memblock_is_kho_scratch_memory(phys_addr_t addr)
>> +{
>> +	return false;
>> +}
>>  #endif
>>
>>  #endif /* _LINUX_MEMBLOCK_H */
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexe=
c_handover.c
>> index 532f455c5d4f..12292b83bf49 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1457,8 +1457,7 @@ static void __init kho_release_scratch(void)
>>  {
>>  	phys_addr_t start, end;
>>  	u64 i;
>> -
>> -	memmap_init_kho_scratch_pages();
>> +	int nid;
>>
>>  	/*
>>  	 * Mark scratch mem as CMA before we return it. That way we
>> @@ -1466,10 +1465,13 @@ static void __init kho_release_scratch(void)
>>  	 * we can reuse it as scratch memory again later.
>>  	 */
>>  	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
>> -			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
>> +			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
>>  		ulong start_pfn =3D pageblock_start_pfn(PFN_DOWN(start));
>>  		ulong end_pfn =3D pageblock_align(PFN_UP(end));
>>  		ulong pfn;
>> +#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>> +		end_pfn =3D min(end_pfn, NODE_DATA(nid)->first_deferred_pfn);
>> +#endif
>
> Can we just get rid of this entirely? And just update
> memmap_init_zone_range() to also look for scratch and set the
> migratetype correctly from the get go? That's more consistent IMO. The
> two main places that initialize the struct page,
> memmap_init_zone_range() and deferred_init_memmap_chunk(), check for
> scratch and set the migratetype correctly.
>>
>>  		for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D pageblock_nr_pages)
>>  			init_pageblock_migratetype(pfn_to_page(pfn),
>> @@ -1480,8 +1482,8 @@ static void __init kho_release_scratch(void)
>>  void __init kho_memory_init(void)
>>  {
>>  	if (kho_in.scratch_phys) {
>> -		kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
>>  		kho_release_scratch();
>> +		kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
>>
>>  		if (kho_mem_retrieve(kho_get_fdt()))
>>  			kho_in.fdt_phys =3D 0;
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 17aa8661b84d..fe50d60db9c6 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/seq_file.h>
>>  #include <linux/memblock.h>
>>  #include <linux/mutex.h>
>> +#include <linux/page-isolation.h>
>>
>>  #ifdef CONFIG_KEXEC_HANDOVER
>>  #include <linux/libfdt.h>
>> @@ -959,28 +960,6 @@ __init void memblock_clear_kho_scratch_only(void)
>>  {
>>  	kho_scratch_only =3D false;
>>  }
>> -
>> -__init void memmap_init_kho_scratch_pages(void)
>> -{
>> -	phys_addr_t start, end;
>> -	unsigned long pfn;
>> -	int nid;
>> -	u64 i;
>> -
>> -	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
>> -		return;
>> -
>> -	/*
>> -	 * Initialize struct pages for free scratch memory.
>> -	 * The struct pages for reserved scratch memory will be set up in
>> -	 * reserve_bootmem_region()
>> -	 */
>> -	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
>> -			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
>> -		for (pfn =3D PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
>> -			init_deferred_page(pfn, nid);
>> -	}
>> -}
>>  #endif
>>
>>  /**
>> @@ -1971,6 +1950,18 @@ bool __init_memblock memblock_is_map_memory(phys_=
addr_t addr)
>>  	return !memblock_is_nomap(&memblock.memory.regions[i]);
>>  }
>>
>> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>> +bool __init_memblock memblock_is_kho_scratch_memory(phys_addr_t addr)
>> +{
>> +	int i =3D memblock_search(&memblock.memory, addr);
>> +
>> +	if (i =3D=3D -1)
>> +		return false;
>> +
>> +	return memblock_is_kho_scratch(&memblock.memory.regions[i]);
>> +}
>> +#endif
>> +
>>  int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
>>  			 unsigned long *start_pfn, unsigned long *end_pfn)
>>  {
>> @@ -2262,6 +2253,10 @@ static void __init memmap_init_reserved_range(phy=
s_addr_t start,
>>  		 * access it yet.
>>  		 */
>>  		__SetPageReserved(page);
>> +
>> +		if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
>> +		    pageblock_aligned(pfn))
>> +			init_pageblock_migratetype(page, MIGRATE_CMA, false);
>>  	}
>>  }
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 96ae6024a75f..5ead2b0f07c6 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1971,7 +1971,7 @@ unsigned long __init node_map_pfn_alignment(void)
>>
>>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>>  static void __init deferred_free_pages(unsigned long pfn,
>> -		unsigned long nr_pages)
>> +		unsigned long nr_pages, enum migratetype mt)
>>  {
>>  	struct page *page;
>>  	unsigned long i;
>> @@ -1984,8 +1984,7 @@ static void __init deferred_free_pages(unsigned lo=
ng pfn,
>>  	/* Free a large naturally-aligned chunk if possible */
>>  	if (nr_pages =3D=3D MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
>>  		for (i =3D 0; i < nr_pages; i +=3D pageblock_nr_pages)
>> -			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
>> -					false);
>> +			init_pageblock_migratetype(page + i, mt, false);
>>  		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
>>  		return;
>>  	}
>> @@ -1995,8 +1994,7 @@ static void __init deferred_free_pages(unsigned lo=
ng pfn,
>>
>>  	for (i =3D 0; i < nr_pages; i++, page++, pfn++) {
>>  		if (pageblock_aligned(pfn))
>> -			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
>> -					false);
>> +			init_pageblock_migratetype(page, mt, false);
>>  		__free_pages_core(page, 0, MEMINIT_EARLY);
>>  	}
>>  }
>> @@ -2052,6 +2050,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn=
, unsigned long end_pfn,
>>  	u64 i =3D 0;
>>
>>  	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
>> +		enum migratetype mt =3D MIGRATE_MOVABLE;
>>  		unsigned long spfn =3D PFN_UP(start);
>>  		unsigned long epfn =3D PFN_DOWN(end);
>>
>> @@ -2061,12 +2060,15 @@ deferred_init_memmap_chunk(unsigned long start_p=
fn, unsigned long end_pfn,
>>  		spfn =3D max(spfn, start_pfn);
>>  		epfn =3D min(epfn, end_pfn);
>>
>> +		if (memblock_is_kho_scratch_memory(PFN_PHYS(spfn)))
>> +			mt =3D MIGRATE_CMA;
>
> Would it make sense for for_each_free_mem_range() to also return the
> flags for the region? Then you won't have to do another search. It adds
> yet another parameter to it so no strong opinion, but something to
> consider.
>
>> +
>>  		while (spfn < epfn) {
>>  			unsigned long mo_pfn =3D ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>>  			unsigned long chunk_end =3D min(mo_pfn, epfn);
>>
>>  			nr_pages +=3D deferred_init_pages(zone, spfn, chunk_end);
>> -			deferred_free_pages(spfn, chunk_end - spfn);
>> +			deferred_free_pages(spfn, chunk_end - spfn, mt);
>>
>>  			spfn =3D chunk_end;
>>
>> --=20
>>
>> 2.53.0
>
> --=20
> Regards,
> Pratyush Yadav


Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2989C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC546B0096; Tue,  4 Aug 2026 11:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CFB6B009D; Tue,  4 Aug 2026 11:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E8F6B009F; Tue,  4 Aug 2026 11:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6146F6B0096
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:56:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE9C4A128B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:56:18 +0000 (UTC)
X-FDA: 85064038836.27.43B8FF9
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013031.outbound.protection.outlook.com [40.93.201.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E97ACC0009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:56:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pEfpqaJ3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785858976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29zrd2chakpgrnxeaU2ZSPmSep/Ycon8H54+oeiE50Q=;
	b=Qg+E/OvFqxBRdQV406XBaq1tx/FGoFNol+/O86UMRtnGEHsVsqlB0eR4G+32DTPL1BTf8Z
	nDqts0323NJ5peJc8WMyLHdon0HHcvFdwILF3LG/pjRGbANVU4pnmljevfYXGCOQyvr42E
	eeDfp4pc2liEUxtZS70A427fen5ICpY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pEfpqaJ3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785858976;
	b=etl+muXN7Pw8zJDa+5PGOJ6kFgwwg2WWGAs6ygfamAOhXctutrPjqQywJj1N8C0Munkel3
	CPMNCVkSfR6dzPzoEEbZlIzOBvesuTFkQ5D0LDqso/wphte8F3kGBk/snPIRDu1HdVlMm8
	vgSTTJQZjLF11A9AwknwHWOGItnn/Nw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWqdufC1YhDRyKa8hwworABdUmpedwy3AEYSI+iap/SYiGnUS+BZC5fZUlnDh8SSBEOcIXoQezft7p3LMUTjf8yo39xvX1m4J0S6pTSAOVMLHxiXjOVCUkAaB9ni8Z6dmI48jELE+RrDLyO1rQ3zZwLb11jXgkrUQqPmhc/5U4AIqZCPIsZnnlcQcxiGTbd5mGELVi5IQLZAlIkyj9JnNBQNj879n9NDau5dSMrLhl//NYBZXManBFva+qmxLSmlbS29Y42cPemPuQMSOzyPI4Npw3RP553JVUfiNGvso+RGS1a1ecn1o5zfv2ZpYfm/zPjQ9Ejfocwyw4cpzcz+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29zrd2chakpgrnxeaU2ZSPmSep/Ycon8H54+oeiE50Q=;
 b=J8rPNr2ykNSC1DyCYI0tnOT/u9NIk2yY21uONi50fTdXpw1mIYhMsmEJXZbW3BPR6IPsnPLjMj5T4fRAqqzvOE7Ptuw+0uNA5VOkGp+zlyPHUD9AU9HCD2Xw1e0KXjvi8STx22p7i7E2M7oi6WYFPOozw2p/YCVocE9e4fU4EargOn0HN9jSPszLqLdY0zEuM9lxlYzArxq1lBsbtOX+K7fEkBZz3XkK5EB+nLB2saIgKNIGiZoUvHBdLPRSLWjijH9sRk6i9OR4dRROUZMEIyTI7PHpBbVcR0bZPvdq6mxE6GE9w/pCDSPUpSRMRg2WOHC+X/vV+jswP/T+AL6ENg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29zrd2chakpgrnxeaU2ZSPmSep/Ycon8H54+oeiE50Q=;
 b=pEfpqaJ34PQMNI31H9potu2EyEGtLcapNvWZ1RkSHkZCOEDv4Rd/0Xkjo05x+sDmcltpFhz+KJ8NKytxCMIIRQ8riE6fpu6BCpcLlyBRJ/A/Z6qkkUxQNDjHY4qqUQ+YOlY9kOO449tOyVeOcZwog9CNGF20PsIfFSYon26OMyCcVCz3pCvsoiXQk5+sOcB5S3ZV2FIOvAONb3KtcFUyczGC6NxbbQmbo112R/YF/yiVniPTizdo22GTGi5fDZLwpzO8pOBvmDuBTit0/xBFTt/9rypFgWS824xfRVZnc7hfCpkqVGJOKdRFex/baVa7V+cZfbY2cnmZXx+LBxSHLw==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 SN7PR12MB7299.namprd12.prod.outlook.com (2603:10b6:806:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 15:56:11 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 15:56:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 11:56:10 -0400
Message-Id: <DKGA64YR0R4N.8VJWL85SV03C@nvidia.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Michal Hocko"
 <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
To: "Sang-Heon Jeon" <ekffu200098@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm/Kconfig: make FLATMEM depend on !NUMA
X-Mailer: aerc 0.21.0
References: <20260804151145.3419768-1-ekffu200098@gmail.com>
 <20260804151145.3419768-2-ekffu200098@gmail.com>
In-Reply-To: <20260804151145.3419768-2-ekffu200098@gmail.com>
X-ClientProxiedBy: BL1PR13CA0153.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::8) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|SN7PR12MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 27fdca3c-1392-4348-9193-08def240e7c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DmMs2EUvt2dWZGhf0mF/naQu6IwbEHfmxiloKBI2v+NIXiyB7Aut1E0nvErYgu9hp1HXVAjcPUFcs0wPsMzRcPkpOv3P1v5AWoBLy3J6wVw+Yyw+t5BbR8Sl+sxsWGFwqutaWcUhbtD/unbje/UFogbkRPvuuBa95d7RyNpzwocamHWaO8Z4cDegbqGuoxPS6jlQdWbBdByt3/7FA+vG57xm7mVICMKEWr1H33DBBAOyU37Yvq928ZWNtDJ3Efxx7Ts5bzzeymETXbX0elO9vl9x2N6PPwuNgzPrEBYS8R9xvZcHThqJVdLbk4q65OKcCbJTa1oL/4VcC+V/1gdMxn2nqBpVd2VztTpW0ECQ8jd4N7q0jIuVQ0S+wl/OmXL049hXmK9yBI0inKI+o8nADnABRyNzShjAaMO0TujX2kG724Y8sRsm2dXS0zkuCW3bJTC9XkvCnWCAVAE51rm4+loZfm5FD4sX/y/boE7jrwVEZKydqcR63jeQ4kVcaEq5hijhguxfRohNngzl1DBFzyPPosfg63bBHeseq6ygwBMBMhbRBpiYD+8dTCKnkpwR+hdFVlYq+9BzhW5T4dPQoS9lzLQW4yz31CHpXXVXjyLO3P+SgjGz120Cquh/YDeTS5G6hCILcGa9A670JrLOqE/u3H4Lz2tGbuGmLeK3GjM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SThvR3gyMHd3djdSbEkwWThGcmJoblhUY2ZidHY1cTBheEVIeFFHOW96ZW82?=
 =?utf-8?B?SlRndmpocEt3R2E3NUtjVVpXMXFyeXM1ZGZKdXBGN0dmMkJhaE9uT2VsMlF5?=
 =?utf-8?B?SFBSK2tYcDN5VkNpTkxvWW9xRVB0c2dIei9keFhZWGlWWmh5aDFGWWRjUmp1?=
 =?utf-8?B?R0grQjdIcVE0b3d5L3ZUVHI5bjFic2phNVdtV0xlTDZJbndzSkVpUndRb0E3?=
 =?utf-8?B?N0ZmdkpPZjNmdkhmUEx5U1BnOUlFSXZ5VDN0T2dCUFdjWFVzNjdqZVN3YWtF?=
 =?utf-8?B?bVEzZ3lLdmo0NDVQTGcyMzhHbEVBV3FsUDBFRXZIcFBVTG16Uk1RcWJkdTJr?=
 =?utf-8?B?SHlJSjhwY1g5YlJnY0RpVklxbzFKUk5PWTV2MFYwZENuU1dTUU1vMFMwS2d0?=
 =?utf-8?B?Mk1yalJMY3RBblZ6UHViMm5QbTRibnhmNzM4Qlh4YUs0QmF1dDVyd1FldURm?=
 =?utf-8?B?dlBoVU53dnNyU254RnFVdStFV1ZaUDUwTVpWd3pwdkh2VEJ5bCtQeFdFazFJ?=
 =?utf-8?B?aGttNFFUaE1remN6N1B2Rk1mQUxtcXkwYit5emd4MjUwY2JFaitqTEczTnRV?=
 =?utf-8?B?Z1dEcy9iazlDQTlta2RUenp2bmNRR1U3cVRoVHZFR2VrV3NueHdmMCtNMkJ5?=
 =?utf-8?B?UlVSbVJhTkVMSDNNQ2picStBeit3YTRwR2xzSVhERTJGdy85OTFVY2FuNGhv?=
 =?utf-8?B?MXhYVE1jZ3psdGIvaXE1ZG9SV1NhOHU2aFJzRDhKVUdGVXhuQVh5UUJINTRC?=
 =?utf-8?B?a0hDQ1c5VE1sYkRxa1lsMVQ0RUhqUGZXai9hYkZwdFBCRlZPTlp6MWRENVZr?=
 =?utf-8?B?amZvNVZoMU52OWJBV0tqdW1hNjR1WTMrc2xtRUxnRlNpMjZzYUhMWExud1VU?=
 =?utf-8?B?UURqeC9ZZGhsR3dlTkUwc3B6YVpEVmgvN2NsOEZyTW5zVTJHWGowSE9VTGNX?=
 =?utf-8?B?c1ZoM2NJLytwdU5WQ1VNK2h4WFVjTVNReThFT0xVNFl2Y25RR2l3OCs4Nitt?=
 =?utf-8?B?WG5INGFBV1JSS2UxZndsR3JSRXp2NHM2MUhDVnc2Z1ZiL0VFMXNYNEFoc2py?=
 =?utf-8?B?YjJFYlVrb1k0bkVjNXZSZkhiL2ZYV1o4c0JJMWVFbjh6RzFyTDVVeXM0alpV?=
 =?utf-8?B?clhCWkR0S2lDWWh2SmErd3NzSkdLWGt4TjViSG9SZGlyQW40dXBnWVpWZGpG?=
 =?utf-8?B?OHFSMlh1eU53U3YzSXlqT3M0T21NSTJTa3U1MTZtaFEraTNHS0xOaFVYVTZp?=
 =?utf-8?B?WTdUY21OSzJUYWNaL2tQMnA5SFlFQXRZbXhxcjVjM1VmUytXWi9VQ1RBL21X?=
 =?utf-8?B?MEdqbjBPcmdWMmw5MEwvZlpCZXoraVBaazBRUGZSWFR5Y1FQUlJQeHBlRnFt?=
 =?utf-8?B?KytJaGNwbjlsUmgxTi9pNm5VSEg5S0lXZGliMzZOSktjVnVjWHZuV0NIY0dK?=
 =?utf-8?B?Smo5R0pCZlFIZWw1bmtIbjg5OHgxaGwrMlRBWWpVdGM3a0dkTmJOMXBYL1Np?=
 =?utf-8?B?bVdrcmxFVjVqZURJbXlJUDBBbHhoQVlhOHJ0aVdQaXljdDVVV3NTU09ndWg4?=
 =?utf-8?B?V051WXNRbm9VRE5MazkyUmtvZHBoRXFNcmZVQjJzcURqNjJveGcxRmd2WTRi?=
 =?utf-8?B?Tkc2dWkxb0ZnUklPRDByTUtSdkcycFcvSnhkZXNHbnBEckZpbWx4QWxodVhF?=
 =?utf-8?B?RldYMDc3UmhFSXZqOUEvS0tMNjBKeDh1V2toblRwMWpLTGxSendBa3BLaDhP?=
 =?utf-8?B?MkgyS01TVEtFVkRRZE03cnVlNXcxdDUrcEVCaGxVdStybzZjQ0taWk4ra2R6?=
 =?utf-8?B?b0I0dFlKbk80b0F4ODN5SFVmS2QwcCsyc0NBQzNCNlIwOVhGUDg1bFFTbGxY?=
 =?utf-8?B?N1ZOWU5lYkFPMFBpSmtTa2Fnc0lCaTROdmlVaTRSc2VwdFVPMkNUdFkrWlc4?=
 =?utf-8?B?UXJhUFF3N1ZsU3c2YWJYUjJ6ZHQ2Rk1yS01VRzI5VGpXVVR2VlN4U1VRNkpp?=
 =?utf-8?B?WWZEWmcxQ21HQWhGNlU3aUxxM2JHU3FMNVgvNlRxNmJBOGFNemdIY0EvcUw4?=
 =?utf-8?B?NzY1TURHc0x1SDZ3YkxrOGMzdFhVQlMrVzlaQWlYTzVZL1A2OVVuLzJnVmNx?=
 =?utf-8?B?MHIyTVZLQUVGUzVOYXlWZXd0c29waXorblJlNkF2OUZ5MXhOeVd0elVXVFZj?=
 =?utf-8?B?QjJuV09rSmFZdVJDODBxbFNFakJiOW9kWVh4dmExQnFKVW1pbzFkbmdiN3Zz?=
 =?utf-8?B?Q1YvRDBhNm9oN2JsbzZVRG1WK3RMU2gweXBTSll5SXZFTEpobEhnTjg0NWFz?=
 =?utf-8?Q?KwxAHcvF3oTuIhfIJc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fdca3c-1392-4348-9193-08def240e7c1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 15:56:11.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sx/bBw8GY4nugKBiex0ybNsGls+MKLEtIxMr89XGRMJ9zpJmp0pXv1tiS9qQ+a8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7299
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E97ACC0009
X-Stat-Signature: 67fp89hrxdx9q4bzpumw8y79o1bg6g1s
X-Rspam-User: 
X-HE-Tag: 1785858975-623873
X-HE-Meta: U2FsdGVkX1/UfBPG1dtTbGj+0st3G8nDxVwLsTg6vgyS4qm5wL+13Jff68iv/vYtETkEeYY91rwSL6Ga6JGwLZgfrXUVdbpYC6Evjn3qD70jfJ4u2gfOqTVKGlGuDMFeavPCNzmSznUfJIiPhtWd+RXkr5Cquxv4VmHrhQeX9gOssZj1kl+Mo8rg8EGypeWnBg3QwBYePeWHAiWyytMO2LNyfk4+vDkaL7V34f4C89KbdO5pYsPY03OhB9d9F/OjNbEu6oSMGMsHBDwOpdZg/LSxPjaYj6+ooLgJcojDm96PcWGPlPzOgDo5jdEzOVEPkWLYM+yglZloRVHfvaGsYQvL9sf5qqrJjm7VMZdR/Se2L4xySKGvsDGrDVuIC/BQSsYX8N1z09RpWEOcR/PWoTsOJ1mt+BObdutBIACv1v42MLCbrxu8Pk3lmDZketTHcvkftsSTOr3ZRs440NOnC4c9zWHHtUuQ8C8nCoCIMfKgIGL2elYqn6urgJ2HsML5chatO5Tc6FfUGmsgMF0F+DNGAZCud8NK6px0Fsd35SEs2X8yzAJUhaxxP8Vp3fdogtJKLPcn9sG/Jmr3Z/XNsrF5Fvo4qpuDH6lWmsJIc/HS6lLRVa29vQxrL3qoSw6YfKGijj/h36vGum1eVdxCQZA9BLYhZm/IhoHLlQ0Hlt5Rys+3LlCeF+2CW/GWba1IuTOgm2lSjo8EAVvpc21IeB6K3QuEo7UaiYQKBWxotVUR2J0Aiqbz2G6PdP38XvzRZJAOo2VjkaUe3BTj8U1OkRjNLCfr/PKh+X1iTBKEdnHUInRkxFAvJrGV7bRkmXxFQ87JFdbx+IF6l7+eh1m1iYWZysX6YHNyD/KwJYN9Pqp8yf6lP2vY+mCnJiEWf3+GV4QFGof0DJq9WFw0QZi83SN/s7iAjha/EmwuNaShRGSejL/eu6obWx+3D71S2btYHucYJEJyZvxw+qEu0AC
 AO/vO/oV
 yRwVvK2+2xE0h3ZQZNlZjaeQTqp4Yn01kFSvTZ6OY8cF++A+c4g4bemSZTm3g8k/qKinQLJ54r7WKEveb27slGpX2lwOEw/4BGbc/H619cwe/RkeHlS0x5Fecy+eWkXE+Quqpnj9a+XHYZCp4bjaL26WVG76nZfSH453ig/mVS0aql/8hkM9pMbrDTwrd+fQghcIdxwyCZTKAqWLNx2vANJfGnEk/8+gAYf6MeZXVO7SlWYVBrs9PoyHpPCJ6+mPwpfbuSo7ckKiA3TKtKiiAK7ivOfXkWXMraO+S2Ud06JqfMxk0dkq+H4sKyH/OFm7hjowNWaRAgqD+Go8o2xriGqOkNCZrbY92OV7vp0YeTfhEdrwigTsa4Z59/P/tEqrPBZSEEtH5PSptc1VXyS6TkerEDbMjA62jboriKN/4yH1sr0XTcQIo8UVA4FuVbWIwYJCtYO7SrSWbBGyoEZUp01vuZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 4, 2026 at 11:11 AM EDT, Sang-Heon Jeon wrote:
> FLATMEM + NUMA is not supported by any architecture and fails to build.
> The constraint is only implicit in the arch Kconfig files.
>
> So make it explicit in mm/Kconfig.
>
> No functional change.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  mm/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)

Hopefully no new arch will try to support it.

Acked-by: Zi Yan <ziy@nvidia.com>

>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 060190e12bce..331daf7fcfab 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -390,6 +390,7 @@ choice
> =20
>  config FLATMEM_MANUAL
>  	bool "Flat Memory"
> +	depends on !NUMA
>  	depends on !ARCH_SPARSEMEM_ENABLE || ARCH_FLATMEM_ENABLE
>  	help
>  	  This option is best suited for non-NUMA systems with
> @@ -424,6 +425,7 @@ config SPARSEMEM
> =20
>  config FLATMEM
>  	def_bool y
> +	depends on !NUMA
>  	depends on !SPARSEMEM || FLATMEM_MANUAL
> =20
>  #




--=20
Best Regards,
Yan, Zi



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72085606A332
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 05:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bpVQxK3e
Received: by kanga.kvack.org (Postfix)
	id 8FD2E6B08F6; Wed, 25 Nov 2026 00:50:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D52C6B08F7; Wed, 25 Nov 2026 00:50:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3E06B08F8; Wed, 25 Nov 2026 00:50:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 581D06B08F6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:50:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD68D140C88
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:50:44 +0000 (UTC)
X-FDA: 85472567208.18.3C868B7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013024.outbound.protection.outlook.com [40.107.201.24])
	by imf07.hostedemail.com (Postfix) with ESMTP id D70E640004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:50:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=bpVQxK3e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.24 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795585842;
	b=tbawsVLwzFawWbxNks/tkSSN5Pdjiarqj48plqZJdzbus4k1eteWGWA8gMuak0GK+xXWcS
	xT82Oy/tx7gdccDXSYXEcC1yRd5+TnNPLN2ED1PsXqY6KXjVL6+QBKJP4y5vw+2MBg9bLF
	PtHUAdTymA+PesLoagqvBBumRhwz8ZE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795585842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSFW/v8Z2rWSZz3Oef4q78B+rPzqCYALCOF2d+D1eL0=;
	b=IEdkP7txdRggj8pQfg7EmEkbM5cwOcnFWobBZN76U8x0/L+DGAy7ViCWqYnSbicW2257Py
	CIndqplQGAE+UqMY6srpYsM+y8Ddvl4WzDtmJfGHAKQshwjkPZ/HfyiBPRigrj+/RAYimO
	saGeW1NXBo9DK8/9Ix3w2UDBCq/W5sQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=bpVQxK3e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.24 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJostf9daACjKL1HDjXxZqtnfTXhV/BOwc31biOc9E+XgrnqG8q1/mPsQVS5TzoI6ViVZlrF6XWBH8TU8nlFFPqrFb453sN2i84px5HFVnHL50bbuebt0mh6zU3SOieU+UlTrD2Wy2VLrQ3Ew1ajUoUCOt7ez98crhQCbOhjQ7Kt3cBESBJISOPVbAoceRrhOb67tJXRgjaubDxx1JVTA8qieEkGuhztT96/DOjVSCfoKMftVWVW+hx4mjwKpKMg9sKp7gpW3+/2HjCtFbktFBFrP8Jb8XIq0qfWRoaJBwFeYmnvf6scL5LQubDHt5qIzrU9EwGTZqrZz5CYyaM8yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSFW/v8Z2rWSZz3Oef4q78B+rPzqCYALCOF2d+D1eL0=;
 b=gWi8g1WFG0HhLQOvIp4t/bQv2aYSYx9jAoEZSJMr5gxVuCzJsKBBFDo21vgzdtUn737Hfjd7WozuiGRroy45Gxo7+BkLQjgGK1ydbjZxzqQXBmXC9d0NMUZbm+plekMhpXOjSbA2WWL1B/DtOBNYcRdfzo/O5MYCx6gVOHrHUnxo7c9YhKK/EVa+I0DaQAxYd5/uK8vS0JBObHUalrOb3RqyjjnTIYpMudwQoT+Em6ke22rs/ZQOkUqAa3zJhh+kYyAzN6/MtxjTjR5/0YTGIaxGj2BaaWkCdLO0qWywBRMbFbixWg0Tt30EX5ok/FHBs9VemftknJPx/xCtl3eNlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSFW/v8Z2rWSZz3Oef4q78B+rPzqCYALCOF2d+D1eL0=;
 b=bpVQxK3e3t6ht3j0zgPlhAWF8+J6mf1DfCHtwbdxK4oOzz/8DghkHy+3pNcsHh9Pt3IFUmuRWdWP++A/Oon27aD4j0+6chV5CAiFLLGnEIrnZzoRCSVwfPbaq2orcjMe09E25oo2yQ+FL4LYPbzJ199FNNXx/D4MBEQyS67STFGQLq9gjh46fi2CptobcxWv3cgrLqwlyiXcYMV+MCB9xyITSwTf28+BclpgBoj1fZmxrVD7Fwz4M6R88FftnLq4TTbySNBnISa8zqg5z76ht1VKYJwK/olZHlyrB1+dXbMpvnn+m2nfy5oafwqt/P2a/eFNf1ygAuG+hvK0Jm1p0g==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by IA6PR12MB835995.namprd12.prod.outlook.com (2603:10b6:208:600::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 05:50:38 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 05:50:38 +0000
Date: Wed, 25 Nov 2026 16:50:33 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, jgg@ziepe.ca, leon@kernel.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	mhocko@suse.com
Subject: Re: [PATCH] selftests/mm: hmm: give migrate_remap_fault a longer
 timeout
Message-ID: <awZ2S5yZXOHIxBxm@parvat>
References: <20261119133955.54001-1-zenghui.yu@linux.dev>
 <av94SXo6ZAU7Z5TR@nvdebian.thelocal>
 <20261124213730.a8b4f5100785a2cde54fa8b4@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261124213730.a8b4f5100785a2cde54fa8b4@linux-foundation.org>
X-ClientProxiedBy: MEWPR01CA0265.ausprd01.prod.outlook.com
 (2603:10c6:220:1ed::16) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|IA6PR12MB835995:EE_
X-MS-Office365-Filtering-Correlation-Id: e3b16823-0d7f-46da-4297-08df4ab8082f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|6133799003|4143699003|261009223027099003|18002099003|22082099003|3023799007|10067099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261022115727099003|261022105027099003|261022075727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	N9CCYCp+LLOGd12iNoWc0lDoBiaSVRRr6HlDSl20pSLnSpl1CLiuiOT6KHsdL06XtRMUcv1ZjsvRBFidbwhHNbqzYoN7XWcd0Nt0dvKY38gncJUzfaDLomN1OuUX4NfxbPq8cuy3z6RAj1Sk+etb2AdjNzT2PsRK4M2WuLQDS28ZVdfCaK9EhX1J9ucFIDvn7Xg0wdteaMRLp2FAgJrvC5cS6egn69WxX+djBZcKDwmeew28vp1xBSKBbJyCr6FEM1Sw5PaJMax+sYvTVQ0papEqnpbYmyvSR+ifjteuXCzoUdtHpM4OT6PvH6f0Eza5JjP2/1rSGj33nwa5EPuFQR6ObJ17F1JEVC4EvvHPt7IWc3mmASmAdR/BUc3L0NEtjA1gorBzxzyVC7VU+ZoYmeNLp2G7WbVDUH+ETHBv1hpVSccxPv1gJVxnJ0T89NF9LokTjCa5dy1B816S4kgedfL7sMbn1ponkEBoy5dwcLZV2WMuU7ACT9kZvVzqFMhKz39cIo75sSMbwB9GMgGuxe/KziGiDBFRU2DO4pv7s0cb33pvOWQtE+tBRV5WHvJhimb+g2rP+cbjNfaZQw2DhI5sWsM99AFtec4l02MbR/4zCB+J+agbLxdHFLPy/jQSMcHu+kgezu9ifhSEUhTGC1SFOtcFXfezEk/gFJ3KcwA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(6133799003)(4143699003)(261009223027099003)(18002099003)(22082099003)(3023799007)(10067099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261022115727099003)(261022105027099003)(261022075727099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkpleHVjeUY4cXY4TEV3emFtb05wa1VtZ0F3VzRDV0h6Rllka2FLNFJWQUx6?=
 =?utf-8?B?ci9rS0x3d1JsdHlSZ0U5Q2F0ZHFNcmxWalRJK1FEMDYvZitFNmhaNE52c2xC?=
 =?utf-8?B?UWllN0NudlgxQ1NhQ1ZoUTlUREdGMXl5VDE4WjdXajR3UXJVYUhoQ0UyY1h1?=
 =?utf-8?B?QjlBc1B4WWQ5UEdDZ0VQc0E1MGtkNFNjZTBySFcxRlRpU0x4UEZDSjdKRVFj?=
 =?utf-8?B?emtqYTNKekovYjdHSHV5ekNLbm9RTHF5NE1sSm5TWEZjMlN6dzRDZmlZdSt2?=
 =?utf-8?B?TC9WV0xQRmtmRU9FRGdOMEM2TFVHSVlTbndVcmZSdE9YRXJZdHV1aHNtRXQr?=
 =?utf-8?B?R2kvV3MzanhsYlU3NDhmc0pOKzI1NzNHVkduWUgrdEkwbnpvSjk1ejIyMlps?=
 =?utf-8?B?S3RaMWJsNFFxcVpKNG5MMVFvWEV5TnNENitZUGk3S3BUMXA3bmNSeHlLZlV4?=
 =?utf-8?B?b2tkV0R1bTVHWkdyaHYvMTczK2FZZ1cvdUJ2M1AzWExmSUJTNTd0Zk5HQkdr?=
 =?utf-8?B?dVBUdnhrbXdUdmhlM0lHWFV5L3dpc0JIZmFyNHB4bFZxT1NZR3Vadk9HWVBh?=
 =?utf-8?B?dXdGWUVHaXBBZVYvaFBER0VEOC90ZEJuVVZyd3ZIb1RkR0crYTFPd0JZaXBP?=
 =?utf-8?B?ZEJsZ0lGUVNqbFVTbVVMUTBub2htcnpvME92UTZDK3hGVG8rdU1yZ0VpZnk1?=
 =?utf-8?B?RGJJZ0NOMFBTRzRseGJZbkorTEtFN2tKb0dHRG1HQmxPMytWWlJvTHptdVh2?=
 =?utf-8?B?WWZRWHU1MGtTYTFRVGd5VnlMSHlvc29OaXdFRityb0hxK1FVOUUwaEFnTHBJ?=
 =?utf-8?B?c1o4N2RPSlRPZkhFMk9FYnpJbVpUYjlJTmpMMFAwTVREaHMxQUxLRGNFRzQv?=
 =?utf-8?B?MWR1RFdPd0E3TnpxRm1lTTIxYWNFUnZrK003L1NhaXNZeWh4L05RK1lrS0NB?=
 =?utf-8?B?cXRUemFQRXh0blFQcmwrbTVaSERRK1lIRGxmS2wvdzJERm52c0JIY3kvU0Vx?=
 =?utf-8?B?dmIycURhSWlxQzF1QTBLdFc0RS9HaDA4dWcrNDZUZ01hNmFCZjNad2lsbGsv?=
 =?utf-8?B?UGErRXVJTjRvbmFkUjZkMnlVK2lPU1g1VmdvU3ZKVmRZdGVWZzQxYmJ0RFRR?=
 =?utf-8?B?d05FWWJ4UVJUdE90aDlUQVlTS0pnQUx1RXBRZUx6NTU0MG9QVlR4RmZVMll3?=
 =?utf-8?B?UEpyYkhxc1Y5T2dSQ0ZpOVNUaGMrUS8rM2dQN25HNnYrWnJBU0tyY3FiZ3ZX?=
 =?utf-8?B?WTdIZG5QdWg5cVBaWU9CM1Uvcmo3d2JtUGpWa0QyQlBUT2dnNGRsaU9lSmhh?=
 =?utf-8?B?NStPdTdiSGFhaEJpWDlzTXVwczdPN0M1cHRWVW93MmVMTzNZMG1ZeTZUdVRj?=
 =?utf-8?B?ZFpkQnpIK1QvVTNxdktkZmNTYUh0SkZJcDRXcW9zN1RERHFwdXJacFFsZWNY?=
 =?utf-8?B?cGR6NVdWQUY2MnV6WWF3dTVwUHNtQ2Q5Y1NPMDFuZzUxYjNrT3JpcTlUR2w3?=
 =?utf-8?B?TmhVQjJ2SEU3NGtUR25vSEJjU3VzVGpsQlVaOG5mY3FVVS9lN05lQUJuQXJy?=
 =?utf-8?B?dVR5S0Q5aGphY1IvamlFVXYwK0VFNDFEcU1sa1BvaXNoYi9xZHlJaFFQWEtS?=
 =?utf-8?B?OXEyT2pLWUlYdVlBTjg2clB2Tm1KUEdPYVFveEtXMUtjbk1tSUc1ejg0SzUw?=
 =?utf-8?B?bHpGaHhvenNHcjhkOG81MVhGMEgyU2lGbUp1WDgvQ1V4dlVKSldrdTRncy9K?=
 =?utf-8?B?QjNEVXBFSXNQU05DTUdTclhqQzhTdW9PbmlYWk1VZ0Z6N0s0YkNnWTU3bDBT?=
 =?utf-8?B?ODVWbGlCd2JaemJFdnFMZFZQUEVONlpKVGMwZDZCOC91cGkxSExoUE9KRStX?=
 =?utf-8?B?U2NBUjc1Ti95UzJRVTJRMGJvc2cvcFNPOFFVNVhEZTd3STRGcmZpdElobDJt?=
 =?utf-8?B?MjB0aU5oOWpjTG9XVGRpbWp3cXkrMS9SZkhZWFE2YWZoR0hhaWNCS1d0UDBl?=
 =?utf-8?B?K0lVMWsveS9YaWx2SGtGOVBTYmNQUnNiWGcvUGpRdXYyS3FWRUR2NTlrNWIr?=
 =?utf-8?B?NTcyaEV1UTEzdG5MN2tZeUFWYnNsdHFrTE9WQmRSV280OWNRSUR0NWxMUmFl?=
 =?utf-8?B?a3pzMUNJZkZpV1JPbDA4K3VnTG01OGFMcmwrUGxwc0toWXExc01LY21oME5I?=
 =?utf-8?B?bUF5a3Vta1ltT04wWStMZkdyZWFDOVM2YVUxS2M5cnRXQWlkaG5zVW9nTXpa?=
 =?utf-8?B?VS9jK3JyKzlNT21KcXY1V3MwZjlNTmVvVFBxOUFKTkdjUWNQYmhnNFVyTFR6?=
 =?utf-8?B?eEdlVFpzd244WnpGV2NrMEZDY0FUREY1SGtrakhFUlRKcVZvalExZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b16823-0d7f-46da-4297-08df4ab8082f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 05:50:38.2660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nn34BGNeMYWeM+lCbaAMevBgqfg7UNgK7TOXmMF8vafiTG1cm90/GHYndykZj4DvShBTg4SVH8dzxmjzTMMJPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR12MB835995
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xog8m7yj9jt553775mtoetzjbr3j1dso
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D70E640004
X-Rspam-User:
X-HE-Tag: 1795585841-707527
X-HE-Meta: U2FsdGVkX19Mge+jPFQdA1m6ZxdsklE7kC4g5hIPV3tGIUVmo6icfWHMulTij8e03zNtM6VkvWBBvou1mqVGccyz/TTmFt5gfZZN+tlMm3hVeAQwYm1rJ83g9Bi3A6gRvnLFAy42cASkt3e3NmuxzW7VMFDbNMwCvOok0y8LXzGpfjJfs/UlMGmRlUg1Sr4BADCgkDFMowTU/4B+Rk/GAG8A+5muGNJI0dvNzcab9NKAewzrDDLU+LsoDqQ1Gt9zAoQcWnTaAFWWh5VvaERzZN3Z69hrD7O7kskj1b+yKl2lZmozdywXCl3cdrMB26fIPMP11B3XIk6Fds1mNB2Df1gHzU2SkMB1DiLLZzRko9uWy8xNLVlvKht4Lj6Ud0hr5NGECOxOvtOuGvc4o8uQr82rJs0vgcwO3gxtNIDe44buJSFnDL8DLWTEB/6hIUMH80LuqVwOCruqjtK6T1LZwTOpQq/yHZsv19ZYvDYoDt0ZGwWRkRSR+SsIZ9i41pfeTkWaHY9nsinlib4cxrANfcile/WjGOL23xcew0C6v0iSPUCnnGDv62RRdgxQlu+bQvHMzmqL3tV18uLqczR7wxuDqxfoR64rGTLRRcWiRY8VONQ6Ct0PBhjv0j922h254dhPmFy0r+IMC/FPbJW3OaFSjcS86D7ISZUuVH4uP7sNui4kaxm/X/CvZEU3IHWR9uqdWFUWOU9iYMj8Z7nc7gIOQxRKukO5kVJ95GXz/xeLuAe8pGicrQ5/xf0fQzF+R8VH2CG87EsvYrnBcl+2anb+AMtpVFn3LCnCA7Yx/uF1kv7Y0Q76QaidXoEYrGh1yM7kYJtim176bHxxlYl7V+d437CQIRzX4jbyam8LXnwAYSwD1kjbqqUc9LClePitEXK6dt47v20HcukWeLyEIkglngvlT0nX1a3ON/9jC8jP0TfJPUplttimC0gySNeSRzJ4w8uDsUmnwokNPpk
 tQjATpF/
 dDMpqXCVEYqfVyOaLIoHg66NHbiikgIhGrNhNhj/3+SMpRh8xeiD8vSoknYH2TiqY2vEQfI/QKeUXRW1dZwLVx95Tx5QIjHJPQBLk1dEmN9Fh5ivr0NfJqO1vrzrRNkCPuHjgZru8iZAf69HqZQ6Be2gpDxhTT1BRA+nPpxcah0EnGNhKWKUvbJPZIskeggpLB5bdaeu++m4FXWMRJukA4Pcan5LFsmE+WbuzLZRcJlhxieInWUxtJBfd5fARDy16vOrrVo4VlQ2Obor+IQ16xXGuJJN/wO2Hx4SEF7oQ62B0K6JjoGaNcf0irPH+xShJAxS26vIwxczz/rV0wjFFBe54vB5vEnZU2/L8cFcVgs7AMJsYwy9I+epHxzKu9peWbHUqLTTygRErQ56lKHQyPEJEi+NzznW34Yv0CFmlbiIZR4lOWWBd2QvYozu1Cuk5Eptj13SXmOUQh/mpbjsC1ZmZ0LGSj5CM7DUQRqLKZVUn/8UObwhg148MLirtUV95Lw7GEmJALY6Sy6XfHRKR5uVMoWnTAXhsbxVlDvSUzTKin6VfdRXR/CESazOAzY4VYDoc8WjbdNyO5sKK6zzVCvDeAlJ4h6EBPwcAM/aJSBTr8gNJb9rzQnzXUqjWxvf0lKXD7y0gbro8rT3A5rhm/E2Zxh80Wc7d+2GJ4v7WYGCk9y/Ir/YzlImW+/aVy20mB+frbXD4whJ9KwPnS2noyrXTjSDd7NR0gs//R/pMenj7bUPtX/H+Vs2X0XjpT95AgJCQGVReuSNoMX9hn8mAXnod1BYxOqo09H7tqKvsDk/YB22Afg1gY/9uxiBos7sSzxqvje3jSet2NEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:37:30PM -0800, Andrew Morton wrote:
> On Fri, 20 Nov 2026 09:31:23 +1100 Alistair Popple <apopple@nvidia.com> wrote:
> 
> > On 2026-11-20 at 00:39 +1100, Zenghui Yu <zenghui.yu@linux.dev> wrote...
> > > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> > > 
> > > migrate_remap_fault sizes its working set from the PMD page size and runs
> > > 24 combinations of migration/mremap parameters.  On arm64 with 64K base
> > > pages the PMD size is 512MB, so the test churns through tens of gigabytes
> > > of memory and takes ~32 seconds on my test machine.  This just exceeds the
> > > kselftest harness's 30s default per-test timeout (TEST_TIMEOUT_DEFAULT),
> > > and the test gets killed with "Test terminated by timeout" even though it
> > > is making steady progress.
> > > 
> > > Raise the timeout to 120 seconds via TEST_F_TIMEOUT, so that the test can
> > > run to completion on configurations with large PMD sizes.
> > 
> > I guess the alternative is to reduce the number of test combinations, but that
> > seems like it would reduce coverage so this seems reasonable. Adding Balbir to
> > CC in case he has thoughts though.
> 
> 32 seconds is just too long.  We have ~1200 seltests!  Imagine if they
> all did that.
> 
> Can we figure out how to make this test a lot faster?  I slop-coded a
> thing (below) which halves the runtime but it still needs to be taught
> to do at least one full-PMD MADV_NOHUGEPAGE run on systems with a PMD
> larger than 2 MiB.  And 15 seconds still sucks.
> 
> See, if running all selftest takes multiple hours then lots of people
> just aren't going to run selftests and that harms our overall project. 
> They need to be snappy.
> 
> If we can't do this then I suggest we find a general way of excluding
> exceptionally slow tests from run_tests unless the user explicitly
> passes some --i-am-very-patient arg.  But that's out of scope for this
> present timeout issue.
> 
> Zenghui, are you able to figure out some way of speeding up hmm-tests.c
> to avoid the timeout without compromising test coverage too much?
>

That's the delicate balance. The changes below look reasonable. I can
move the perf testing out of hmm_tests into a separate test or trim the
sizes to smaller set of huge page sizes

Balbir


> Thanks.
> 
> 
> 
> --- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-hmm-speed-up-migrate_remap_fault
> +++ a/tools/testing/selftests/mm/hmm-tests.c
> @@ -2250,7 +2250,8 @@ TEST_F(hmm, migrate_remap_fault)
>  {
>  	struct hmm_buffer *buffer;
>  	unsigned long npages;
> -	unsigned long size = pmd_psize();
> +	unsigned long pmd_size = pmd_psize();
> +	unsigned long size;
>  	unsigned long offsets[3];
>  	unsigned long i;
>  	void *old_ptr, *new_ptr = NULL;
> @@ -2258,16 +2259,17 @@ TEST_F(hmm, migrate_remap_fault)
>  	int *ptr;
>  	int ret, j, use_thp, dont_unmap, before;
>  
> -	if (!size)
> -		size = TWOMEG;
> -
> -	offsets[0] = 0;
> -	offsets[1] = size / 4;
> -	offsets[2] = size / 2;
> +	if (!pmd_size)
> +		pmd_size = TWOMEG;
>  
>  	for (before = 0; before < 2; ++before) {
>  		for (dont_unmap = 0; dont_unmap < 2; ++dont_unmap) {
>  			for (use_thp = 0; use_thp < 2; ++use_thp) {
> +				/* Keep a full PMD for the huge-page cases. */
> +				size = use_thp || pmd_size <= TWOMEG ? pmd_size : TWOMEG;
> +				offsets[0] = 0;
> +				offsets[1] = size / 4;
> +				offsets[2] = size / 2;
>  				for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
>  					int flags = MREMAP_MAYMOVE | MREMAP_FIXED;
>  
> @@ -2309,8 +2311,10 @@ TEST_F(hmm, migrate_remap_fault)
>  
>  					/* Check what the device read. */
>  					for (i = 0, ptr = buffer->mirror;
> -					     i < size / sizeof(*ptr); ++i)
> -						ASSERT_EQ(ptr[i], i);
> +					     i < size / sizeof(*ptr); ++i) {
> +						if (ptr[i] != i)
> +							ASSERT_EQ(ptr[i], i);
> +					}
>  
>  					if (!before) {
>  						new_ptr = mremap((void *)map, size, size, flags,
> @@ -2321,8 +2325,10 @@ TEST_F(hmm, migrate_remap_fault)
>  
>  					/* Fault pages back to system memory and check them. */
>  					for (i = 0, ptr = buffer->ptr;
> -					     i < size / sizeof(*ptr); ++i)
> -						ASSERT_EQ(ptr[i], i);
> +					     i < size / sizeof(*ptr); ++i) {
> +						if (ptr[i] != i)
> +							ASSERT_EQ(ptr[i], i);
> +					}
>  
>  					munmap(new_ptr, size);
>  					buffer->ptr = old_ptr;
> _
> 


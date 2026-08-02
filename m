Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B035DC5516F
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 01:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0436B007B; Sat,  1 Aug 2026 21:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151BF6B0088; Sat,  1 Aug 2026 21:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A8E6B008A; Sat,  1 Aug 2026 21:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6BBF6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 21:21:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49497A1AB3
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:21:14 +0000 (UTC)
X-FDA: 85054576068.22.9276695
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 73A8940008
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:21:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qL/cIfoD";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785633671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcoMjamgmnpSi49IE9S2XA6UdAsXmsAB4lq+ttMtSC8=;
	b=nUcZ2YTTIpvlVO4RRkkB44iGRU/Teq2zCXbQTrO92hLEdK221EUlTzz5ng8iEcxwlKulNy
	JmxUXqXgNQQLjXllaA+zYxkiguAK5Ng4bB/Tv6MRhI6L6HkSr3V1snw8Bj3jVdQU44rbYS
	wo5pG5BaGTK53l/qCp01Q80efg16MEo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qL/cIfoD";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785633671;
	b=UIaNNftwRvk8IgeBLKQfcx/NFT/C2WRTx6OSrr1B8v8jHlyaLznz9wt6iMLvqgKWuJTBtk
	qP8kYgBPcvuu6y/47MlVDHNi7+M0v0GT5VwMQ1eNgqAVz1MY6CsjtuEYW8Vn7B2jJhTCOL
	y+WyU6TfRYDT/FDkffsAVRJkq9/fJSQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ymih5iA5ecCGcxb455iuWxK8bYTgWnszxTks/w+6Ncwhkq5DkubwW0eg2E4fsX1o5ET0ubDvggKhF1Yaiz0SYZ6WRvkfdjQJ9QGB+KfTpF+NKKmMFIW5/ki45Cg5wc5wV4YhjI3sdhEAgzD+yv8DyhNfbd0CR04Ibcv8X+ZU4O7QOpszH0Rbe95U5l4kTh01nVN2OGP/2PDy+393OGQzPriDBVwJVJiQe8onkaiPfkgPPDzBO2nZYoZh7pH1IrU3/skjiaojl4hdOgKfdKPYbOE6RiLHP3GapDlW/3v68QP3NboFcOK3BGKj2Gh//W7BB+IobLi4lju0r3Qye2pZ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcoMjamgmnpSi49IE9S2XA6UdAsXmsAB4lq+ttMtSC8=;
 b=ZGDRJWeNI5l+uju4bJ/skD69PUKjwaTPbX7wiJNKIVvLL+KD8D/OA3Blfb/FO9alqAt3wZAw5eqR75sxPtBEFoO/4lXfXfxNXq64eH0mK8Iw5a+IQI6ZAxGVww0ZBVn2f7bTUg0c5jINA3rkcNWgFqglXF+05JLFCkaJRWSzSGl7KN+bt7DEKY0FRy+xouPXZ5XaGbjC0C5I8f7bGhvfGhgN/m2GASJklNd7oZvx2N56jLYB+L+f2fElWyXGWhaQVuGDGncMYRcF2ZPIpc4GvHQjnT+9kaBm2xbtLFE685IrXHeLuErWLrq9d1IIp0KRFEJy28meyW3wpKgEgL+OMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcoMjamgmnpSi49IE9S2XA6UdAsXmsAB4lq+ttMtSC8=;
 b=qL/cIfoDwa/OTRbasBGqTsxCxv9pvHOZgo1hIaBEMGV7Ep05V8pL/wjnoUyrBTEh7SrCvWZ5pEJc6MjgLji9qS7MXLhTo9nJS3/5F6tC/fjF5/w+izndsY4wScFIIpMzHAOxWiRPhnXQ8ltN7yLv8NUhzdXRRGJwoEbghDgGELkuoHXNkYn3c737nNW0y9fsujU5TRW4/MYmKyTsbdrFCtggjmIbHWlr7teM5ku0Urnvt1KIf/bcytVSrjb8ZO+4lKHllPRSD6y2qtRLQI1wS0q9RUEme2oq1wAPfC844AEGDukwnH+BtoIqFfiqeXt3SbRxqNv4UCnm61WA8/FedA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7497.namprd12.prod.outlook.com (2603:10b6:610:153::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 01:21:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 01:21:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 01 Aug 2026 21:20:58 -0400
Message-Id: <DKE2AY7ZD4JG.256PLQ1WXGZAT@nvidia.com>
Subject: Re: [PATCH RFC 02/14] perf/ring_buffer: stop using PG_private as
 AUX page high-order marker
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Kairui Song" <kasong@tencent.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Peter Zijlstra"
 <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>, "Arnaldo Carvalho
 de Melo" <acme@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Alexander Shishkin"
 <alexander.shishkin@linux.intel.com>, "Jiri Olsa" <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, "Adrian Hunter" <adrian.hunter@intel.com>,
 "James Clark" <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 <linux-perf-users@vger.kernel.org>
To: "Usama Arif" <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-2-142c97ba3562@nvidia.com>
 <20260801143227.1267657-1-usama.arif@linux.dev>
In-Reply-To: <20260801143227.1267657-1-usama.arif@linux.dev>
X-ClientProxiedBy: MN2PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:23a::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 564a383f-17fa-4554-5828-08def0344fc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|4143699003|56012099006|10067099003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4eLa3ilGgVLWVucC1/BCtbgDF4xSwByrjTr3Rb0ZsRpSNsuxeQJc+yT8NfiDIKhwJEWIEBPQ4H5mqawzkTkICMDVpHk8BFGFPQZBsC3xJL2rlujnxY9E4ZNA+dQqxPqTyWEBXJlscFxz0O2H+vnXn8dypDb/+ORVeS/2cXUumBstESiFCIWeF0l7TpKjusv4kqqE4iofuQ/FFdl7MmshyjE5a+x7R8Zx9p2xQtqp/BbdA7x6GSUBuEF8uZianeW6xWAA6IMb5oh+kTAInNCap672Eq/VTqKdmZrHxbgQhJnCW+FetpZeScIt4EAhxkQ6niPpcLRJgKctC0Rgt5D6+0CS2zS+sM9mNH8HjSsJHq4LXl55F6TFeId/uYKXu+FB78M3YQaFOeLYTomKUroqIvHoJOPqgkp2MsQuEYWiHio41Rqbps/KKaLVZI7/v/t5KcuhybkNXrXi+WUx8venRBglw5c4mdBVoVI2nbFGz/8oTVlY53/t6xj2qQ1TES4me5dmcDWGJiabyrr3y1REB3lUA38q0e/t7Waducj7WArB+9gfocWTIcGNzkXH8EiuG7smSlc4UijejNrWsSXyGUNR0Q7oNTdJAfxcQ0CKMf9zuFzzz/jgWLR6Y6XZNN4kaYeBmBZ5H8gD2Pu7c0KpQb8DNDhS5oKmu4uclszd8v8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(4143699003)(56012099006)(10067099003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFhTTnV4RTQ1cHdzY0t6Skh1WVEzUXJTdHF5UVhRWTV6YVZLcmdQQkJCSnV5?=
 =?utf-8?B?aDBZTWcyZU5NYWFySnA2T3hVa0FySlIxd2J3QkY3bHYwVTdnbndSZXMxRUNB?=
 =?utf-8?B?Ry9IS3lGVm9PVUJYNmc2WWlLendCREx6bHhRRnlTSEhJWDZWcU1ZcFlKTmpD?=
 =?utf-8?B?OFlpYWh1T2ZPRnBralV0Rnh3T1dJM0x1V1IxTXV6cVJyZGtsU1Jpa2tnekpD?=
 =?utf-8?B?a3IyQzVBcUgzVHlUVU5sWkV4UFpDUGJNMGVmMFFuY3UrY2RMMVdBV2Q2Um00?=
 =?utf-8?B?LzhVUzBPMDdFYnhhOVlOaXFOQ09SblRMeXpYRHFRMzRCcENkWnFTcGRiUmR5?=
 =?utf-8?B?UFk1dFdNZ0Rqb1NSMGltN05vd1k0WDRyYzQ0YmNhZ2gwbGlmNG1XV3MwVVAv?=
 =?utf-8?B?UFUvU1ZZU3A3cFEwTjlYditwcFBDdm04Z2xxRnNPV1R5UDBZaEU4YXhEa0Z0?=
 =?utf-8?B?Y3JOYkFib2JaUGYzcURpL2c4TmNEbXdTd3VxWUxTMkJnZldPRVNlc2VFdEFO?=
 =?utf-8?B?NHNGN3Y2STk2U3hhRm1aRWZ0aHBkSFhpZW9CeldxMUs5WmVoZnNpd3VkMFc1?=
 =?utf-8?B?Q085ZGVYelNvQk5FK1NJYXZVaWp0S2ZRcEtEenEwT2twSVZTVTRuQ2pPdHJW?=
 =?utf-8?B?MGFrWWxSRS9JYXdZKzAvL1dPTnJaOUZhTVdvb1pmNXZBQUw2eXNrSFhvNXVv?=
 =?utf-8?B?NkZaN2djcXBOUEQyQk8xdkhYU0Z3dmhhVVNRbkEzRzAzOGVXK25JeWFkQWp2?=
 =?utf-8?B?R0pmZU1aZkZVNHBoRlk1Y3hFaDZUUU03UWE2WGNKSmpIWFF3QXluU0Y3V09H?=
 =?utf-8?B?U1lKR0Vjd0hqWndHcFE1WU1wZ3plUXVpTDdmSkdFQkkxK0RDU2RmdS83Nklp?=
 =?utf-8?B?V1I1RW5TU21KQ1kvbU1wN21XZkxYemw1RTBoZU93QW1IUGJvREpIK1dPeWg3?=
 =?utf-8?B?Zy9jR1FieW1DbmJKUGxpdVVvSE4zRmJnQ01GVkhNSlpndlp6SlpBcTZIYTVs?=
 =?utf-8?B?K1lDbktKWngxa1hMTFFTY0VPV2lnRHI0emJjWVJaOXRhY2tDQzBQV29OS1Iw?=
 =?utf-8?B?bDJsT3lIZkliR1d0OFFFRitrN3crdHV1QXpKaUdLRXJqSnl6bEh4N1JvVkxp?=
 =?utf-8?B?aS9lc1lGczlSNWoxMEVYUnExMC9rdkl5bTF0RkZhaUIxSzVMRHFiRktxMWlm?=
 =?utf-8?B?YzJVdlBuNkpWNXVmU3dva3dhTkNRYU1EaVNrcEpySXBHRU5HK3RHbm5rNzF4?=
 =?utf-8?B?Z3ExY0E2ZlhhUncxSGx4cGM2bW5sZHg4OWRrWThmM1BwN3hvNkJIMStLRFVx?=
 =?utf-8?B?L2NiTlZDNUNqeGxONVdQZVBlbGxnY0YvU0F0YUtRNWtYWnZZdUZyMTMxYkt4?=
 =?utf-8?B?aUZlZ2lXamtvdGU5SGc5ZlZaSlBTWk5kQWliVzltOHVjbnlTVHdKcGdqdEVM?=
 =?utf-8?B?dmNCYzFaZ1FyWXE5cFZWcjBCL0ZqUjVNZDMyTVpEOUZ5cVBrTkpQa0RUY1A5?=
 =?utf-8?B?ZWJSem9zQms4akwrYThpL25nY3hUYUhkWHlaZ2srQTBINlNWZG9PdDZLWDhm?=
 =?utf-8?B?QzJQSGFwOEpDT1pCeWpTc0VyaXdxRTN1M3hQUUJNd2RBMVR5OXQySjJOT29Y?=
 =?utf-8?B?Rlh1QUcwL2pjS3R1WTlFNmRSMmhKM2h2blRyY1hnbG55Z3lwWEh5ZVdqWHBJ?=
 =?utf-8?B?elNiUWxrVW9KMW5ncXdPdkVONzFKZndDWlpBaVdzSHZNNzVoYWIzaXRzbWt4?=
 =?utf-8?B?UWpuUUs1UnU3Y2xZb1RzenNad013Q1IxQStFdzlXdC9yT2tjelJmc3ZLSzZW?=
 =?utf-8?B?ZU44NWo2cStranUwR3VPVHJqWS9kcHo2VmxzZjhqdGZvbUV5dXdZbDJLTTJj?=
 =?utf-8?B?VGUzdmdURjRDVFRQSExJUGdSTDVZQnI2VmF0S0JKY25OckZpK296VmY5TmU3?=
 =?utf-8?B?dGdJOTEzZ2FlZnRpdGdnbkJLV2dwZUNBdWZEUktSbHJpUFZsQXo2amZubXU3?=
 =?utf-8?B?cVpiZURzWE5sck1QYW1NaEVRTkxwWTFLS3VRWHZ5djNlekJOUngyOE5PSml3?=
 =?utf-8?B?Vk5VbzRQbVBmUlFRV0F0dFExcW41c1pXeVpQMkFVTTFOeFAvcmRYTjYvcysr?=
 =?utf-8?B?MDNSdHpaZVdjMzlibTg4eWV4ald3RzF5ZVJOSnI1MHAvUFA2QlNxditwQkdl?=
 =?utf-8?B?UkhycVdVUVVHK1ZtQi85eGhOWUxUT3E1WTcvdTdVdDNYWTZZdTAxOEFqemU0?=
 =?utf-8?B?STlsSk12eTNvb3VJWTMzSWY2dzlJd1FGMVQvSktpQ08xRkFPR3pwbTVmR093?=
 =?utf-8?Q?VV8HbWZaNX3V57xyfo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564a383f-17fa-4554-5828-08def0344fc6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 01:21:00.1980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgcR57FbDJkfuchHuhkV2LDjudUkxM1SkoPMNCQY4QydSn1n3yXexu3I6XXwPx/u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7497
X-Rspam-User: 
X-Rspamd-Queue-Id: 73A8940008
X-Rspamd-Server: rspam01
X-Stat-Signature: cyqn3h8t39p9pa9zbost144rxmjtkbc8
X-HE-Tag: 1785633671-793247
X-HE-Meta: U2FsdGVkX18exsSYhj6Ca/hYWpWkxv/G4oV5czEueBQIHikidvo0URJLm8rcPf3nNBC6GCTUPWMrBpVPji7NYM62w+iAcn4loV/e/fOYTz6X/hERzgzXeI3bgYoVV2i/rM2wcTXHNovIGmHJfVED5YsLO5q04Qnj0CmcfJ+3RFRHL1KoliVSUICwyq/2IbLML9vRGubO2pT09/d9K5nz/rQUzH2H9o/Q65V4BkGzXLj5P92rnBCubQM/vG0XBBsDl5Xj7CMEgQAf1Jb+AUZQLQSqhUARobyRZbGkwV2poRorOU957jp4qq2x8M5FUFrDenjkOy+qwEfal0c1qhSIPWMvV1GVCJEgBn+Vt1lb05McCxKMeG2nmTR1MonWBvhrLcgLxHYZnGAnFa3Twg6U+5A4WvDirbVRZRaItQSv5+pOHyKOTZQolNTeJoMWlwDDAdiyKmnNmbKjJrbRFpeKeVlIb+Sn2wgt/z6fYHHqWt4CiAHWQ3ruI6bgOkOs7rg/KGECOGyN+u04PH5IWZYwpVWK8mZ7GDkwzBo7KPmZriyokEqGL8KC5yX43ldix7I0GZHAlL3P9hmJr9ao1ZgKXgsdiVqZ3KiOUZ5MIZrsOHvlUxJVHnMMldjlXBy3dN//9oNZc4pR8rS2EtxV2CZLwtLymrwCR7teCO3zVnrOSU3a5QSBgjllsm8UyOfKj2E1ciemtQOZwPFQWqD/0v+jan/eJGWZf+NyqUROaukc2KFTVG6KsSep+8z84M9CymTIRszZXsgjpJS7dtvhMkZlouc4B6Rtr8HHtNLD/w5z28BuCS3oaz+sH5AkD6eEDcVwYg7BGDxFpH1MCfRcXZvKRcq0/IQDdL1mmNn2apKVBRDXkr7hRGBf2mcJ/Y68q27UJ/PFHPh+Sn1J4mLTFdXmHODR9dH5l1F0zYnbEYS7i2siwLw3FiucrVlnT+xTHoHKDANKtJ8Z3tEse2O4Dzw
 7rZtZrpc
 B6Km5REJmaVlk2go4NQMvqCkfEcFsVj7NngmwjlTrn/3udfai/zQlRfFMbwjlcQLg/wHA/BnBreYnfFdBXIZzuLCnnBrZRQe+WBuD/Y1dtFwGJxPj6cXFV6TnCTDGgRy5P5krCEfXCmmjVMZuxpYPFzC2GbhPuvxsJapMdX87PmnvU0b9OSiAbGinaYktR5fjnOdQPirj0F8Ayx2vwqpSl3qpHnhJGcr/hbLCiGtnPkkLM8NdnMG7A4TsAc2pVjEw706uDxUHjnjZ+7PyO8MWqwNQph0LEwXCHwhwMbP48TobYVGFKpU0PujKKR36u2xK7ItSGRLwepGJpre5IvZNqZM6rpR91S2dBXtbXp2dJd3pCIl/dBTbJTRslCfHzH0/00GxFCcgFixMb4Z0YmbEYQuoRm6+2x0bBG3xEEhQU9yuV7GSCWcLELuR3Tmgthw5HQ0gJiSN3rdsjTd/byyFSzqopzFBMM3A8p3KvlMifRD3T/hKI7SkWm6bHlwmLadPlHfPaZxZkwVyd5JoIWd4j1XCM/Vrx+kjIps3uKLHbe51lC7htgdFZbWo2OWR7n0gmpKl+iaEohkrfgevz9kHkgDobAP9tOINThPKL0z4mqjqMnmDErCeXJOcXmHAgdqUlwQbYD4ZyaT6r+FxeJUejNKHUgoz7NTyT86+uoNuaCgvarFxKiogCS5r7NBXZOy8H6A25GXvITqqfmqNtKW+kMrcuSzmQ9PpzZtwP6WZxCSdFAF8qKqTHY+Bim3h2Q+zf1842YN2dR2mjhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 10:32 AM EDT, Usama Arif wrote:
> On Fri, 31 Jul 2026 22:13:25 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> A high-order AUX page sets PG_private on its first page and stores the
>> order in first_page->private. Stop using PG_private and check
>> first_page->private for AUX page order only ring buffer and its users.
>>=20
>
> nit: only "in the" ring buffer?

Will fix it.
>
>> It prepares for a future commit that remove PG_private.
>>=20
>> No functional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Peter Zijlstra <peterz@infradead.org>
>> To: Ingo Molnar <mingo@redhat.com>
>> To: Arnaldo Carvalho de Melo <acme@kernel.org>
>> To: Namhyung Kim <namhyung@kernel.org>
>> To: Thomas Gleixner <tglx@kernel.org>
>> To: Borislav Petkov <bp@alien8.de>
>> To: Dave Hansen <dave.hansen@linux.intel.com>
>> To: x86@kernel.org
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> Cc: Jiri Olsa <jolsa@kernel.org>
>> Cc: Ian Rogers <irogers@google.com>
>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>> Cc: James Clark <james.clark@linaro.org>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: linux-perf-users@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  arch/x86/events/intel/bts.c | 3 ---
>>  arch/x86/events/intel/pt.c  | 6 ++----
>>  kernel/events/ring_buffer.c | 7 +++----
>>  3 files changed, 5 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
>> index cbac54cb3a9ec..5849392cf26d5 100644
>> --- a/arch/x86/events/intel/bts.c
>> +++ b/arch/x86/events/intel/bts.c
>> @@ -66,9 +66,6 @@ static struct pmu bts_pmu;
>> =20
>>  static int buf_nr_pages(struct page *page)
>>  {
>> -	if (!PagePrivate(page))
>> -		return 1;
>> -
>
>
> For order 0, 1 << 0 is 1, which is exactly what the !PagePrivate(page) so=
 LGTM.
>
> The commit message probably needs more text but everything else looks goo=
d.
>
> Feel free to add
>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thanks. Will add order 0 explanation to the commit message.
>
>
>>  	return 1 << page_private(page);
>>  }
>> =20
>> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
>> index b5726b50e77db..29d8b4a3560cd 100644
>> --- a/arch/x86/events/intel/pt.c
>> +++ b/arch/x86/events/intel/pt.c
>> @@ -774,8 +774,7 @@ static int topa_insert_pages(struct pt_buffer *buf, =
int cpu, gfp_t gfp)
>>  	struct page *p;
>> =20
>>  	p =3D virt_to_page(buf->data_pages[buf->nr_pages]);
>> -	if (PagePrivate(p))
>> -		order =3D page_private(p);
>> +	order =3D page_private(p);
>> =20
>>  	if (topa_table_full(topa)) {
>>  		topa =3D topa_alloc(cpu, gfp);
>> @@ -1289,8 +1288,7 @@ static int pt_buffer_try_single(struct pt_buffer *=
buf, int nr_pages)
>>  	if (!intel_pt_validate_hw_cap(PT_CAP_single_range_output))
>>  		goto out;
>> =20
>> -	if (PagePrivate(p))
>> -		order =3D page_private(p);
>> +	order =3D page_private(p);
>> =20
>>  	if (1 << order !=3D nr_pages)
>>  		goto out;
>> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
>> index 9fe92161715e0..061b5cb222266 100644
>> --- a/kernel/events/ring_buffer.c
>> +++ b/kernel/events/ring_buffer.c
>> @@ -630,11 +630,10 @@ static struct page *rb_alloc_aux_page(int node, in=
t order)
>>  		/*
>>  		 * Communicate the allocation size to the driver:
>>  		 * if we managed to secure a high-order allocation,
>> -		 * set its first page's private to this order;
>> -		 * !PagePrivate(page) means it's just a normal page.
>> +		 * set its first page's private to this order, otherwise page's
>> +		 * private remains zero.
>>  		 */
>>  		split_page(page, order);
>> -		SetPagePrivate(page);
>>  		set_page_private(page, order);
>>  	}
>> =20
>> @@ -645,7 +644,7 @@ static void rb_free_aux_page(struct perf_buffer *rb,=
 int idx)
>>  {
>>  	struct page *page =3D virt_to_page(rb->aux_pages[idx]);
>> =20
>> -	ClearPagePrivate(page);
>> +	set_page_private(page, 0);
>>  	__free_page(page);
>>  }
>> =20
>>=20
>> --=20
>> 2.53.0
>>=20
>>=20




--=20
Best Regards,
Yan, Zi



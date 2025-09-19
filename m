Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6518CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280CE8E0005; Fri, 19 Sep 2025 10:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2588C8E0001; Fri, 19 Sep 2025 10:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147918E0005; Fri, 19 Sep 2025 10:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 010898E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:34:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A437EC06B1
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:34:48 +0000 (UTC)
X-FDA: 83906246256.19.8CD3A5C
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id C60D310000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:34:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ag9MS/xY";
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758292486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J28esX182dTjTfuBJNfdpEWQKICDnMOMHN0mZqbvpIk=;
	b=NR7WL/c5RMuLsDvIGorEmxjD1+MrDWFXTI9rlKC/wNOHe1NmOtqNM+zZsrp4KC+k5/BDqi
	31RC3AFTfmq7tr3HDnCKebewmUIONkkHsIjvkFsy4fyhjGwyVK7bAsg6Kd/lmOf2ugaHUM
	q1dszHDXwS80pBu3+MZSO7JeZxLE14U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758292486; a=rsa-sha256;
	cv=pass;
	b=tseeYImMVyQhc6u+oh5PrCWhIJ+kPIugng2mgVMfzKJ3W5ZiN9FU4UeyUjbWvDqaR/Ds3g
	pKGGM4s0R3jfc461b233rqgDkcTpa6pkab9M99JHF8VOLGcWUfyG2Uo148CzM4b9rgK0bC
	EXZFA6jR64iBHnOqN9x95wf/TbWXZ5o=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ag9MS/xY";
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaN7L4HK7HTJ8wE3cpvl3bZMdnXaiqVVaYmzlp6OjCa++//ABzmB3HIevVyRoZ2glHksLP1bDjdupbll/f9wI9iy8CzhGrILAb4w4xkgQP7UGIH5/r4NYv3lEQICGEnDJX/RYNdSqvXGeZBD65N6kQ/w+YJkaVNVAmC/3Xa+AOUJ9miqQjWs6CWDdD11wxQj3atEss1wdyCuEL3l1HKhcKpeyEkVvhsY4dNx5JgG4LyU9wDTMU1as6APrWmxjoqmBewDZcyvE8pUcp5hgfgXCy3+Q5KoqUjajyqlBs0AupIKSmBvBAxcXulbPlF1BMsGseutrxbF+5QC5ief0D/kcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J28esX182dTjTfuBJNfdpEWQKICDnMOMHN0mZqbvpIk=;
 b=aegeSTMClCi3a444/HFQn6C4k/undhMokwMY6qNg5XjbZ+3HNR87zuSgbskXt3gudhIX1uSce1PPN10ghdsFrZAVnKn5IWiPDRTlwrM5vmSP+Mj41N4Mz4TuYAFmv2wTLSjr0RgOWAHs6M17o0q9DAjN1aza/vWqgEMxdkEADG/bwxIQ6sk2g6z3HVBQT0VR5KOE40Ges8hs382uac3W/HqH0Iwmcz7vVq0xzqowlMgdEjYmJ97LVzed5ZrsQiU9ba1RDFwnTun2YvIAGgzSwXEsihpktylkPMdDl5SwF6rsWirk3vIDcd4pYT7V96QoIJ+PYtEJMSh1zUEAkIF1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J28esX182dTjTfuBJNfdpEWQKICDnMOMHN0mZqbvpIk=;
 b=ag9MS/xY018UY37z+IzW8jCiq/drbWI61LyKS2ZDQum3p3RzL73pTdRlzKa6PgvleOdX5u1t9K1tQDYs+3y4hRBY5zfgQz+hcZr0sC/O9Y/rmZPI5LveYFUZgKQpuG9FEWL2alTpl4avwXUbRLOV13hZ1DZIZGBCvCLMbKAIXAybgy3X/AkSIYmf3IaX7A5LOoEk7GqXu+G7BkGTWwNrHEPmgSdyDH+F/dwCfOjX2HNDIiSEzvIoAmCD28iyY9MbvjxJBQQ+NKZ6CJH5EfSSyxdSHZ/gdbMm5bIxC5hanVuNdKUMw4BFqZlx4/mYKeoMp2ZjnWciLCIDxDIkBW7bxA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS5PPF7B9F1F8E0.namprd12.prod.outlook.com (2603:10b6:f:fc00::656) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Fri, 19 Sep
 2025 14:34:38 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 14:34:38 +0000
Date: Fri, 19 Sep 2025 11:34:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, ksummit@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, imx@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Richard Weinberger <richard@nod.at>,
	Lucas Stach <l.stach@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Message-ID: <20250919143436.GC2132010@nvidia.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
 <547dcb81-434d-4910-aa7c-1d69019fcb3d@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547dcb81-434d-4910-aa7c-1d69019fcb3d@app.fastmail.com>
X-ClientProxiedBy: SA1P222CA0124.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::12) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS5PPF7B9F1F8E0:EE_
X-MS-Office365-Filtering-Correlation-Id: cb084d64-d3dc-424f-e7ba-08ddf789a94f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PtZOYs11Ja47HOlN9334CMLfyFyUTg8tdovrMLTzuSMIhIgroLTR5sRjiAmQ?=
 =?us-ascii?Q?vIr2Tyg9r2FmYhSEcZKAqdd5a/eaHrUPGgkd6n9c1YbFemL90GEC8socAsf6?=
 =?us-ascii?Q?ssPqxrdGMfeUAKM8TgayXlrPmbJTx9KVxYKMnA+kcSRVHIZZLpclUwDBQsW3?=
 =?us-ascii?Q?GzX0/Lnc4glR6OD6d/Dv9BW0qzv2ta9V9lxF1+dQ+3ed/kZEwH4K22yCTDS+?=
 =?us-ascii?Q?gj4OPEXEs8SDO4kbmNd6vJtSChRpBIOcGVTVcVyW3TAquIfau/4NeesOwOZ8?=
 =?us-ascii?Q?ILKl8YvmcgesFLBDbT/RKw/HlrTqJFXZCy+WnhcW9nf7Hq8vaKSObPF0e34m?=
 =?us-ascii?Q?RN3tYj+C50A+/ntB7e42feHfVP/NbtMwgUitcTuhAgQ1QaWPbQpQsC2RtXhD?=
 =?us-ascii?Q?/hJITAUksYUefnh/4Ldz5Ack9MDQGDwR1GHMKKJWro2x2GA8WBr5Vy+/57ak?=
 =?us-ascii?Q?mluWN+uvgYtP6yuw6yyoYJ5VozSDSK4KQ1Xu+fZnLp2IAqI1I/z7u/kGpFFZ?=
 =?us-ascii?Q?/mayuizqHutxeVkTT3iqk8ox8OPb2A+S1r/ly/KhtvrSQ2nH+Gmnla5exM09?=
 =?us-ascii?Q?nHQHoq6vgLaWMw16jkmyMa/WYagPP1Kk4xR6bWvBrkLitBW04gbQ8CQYkF36?=
 =?us-ascii?Q?AJu7ctP43exuooSf2zkdvxuMfUOUtiVZjdx+L1INZtr6Q3FI6KGB2ABEe5AP?=
 =?us-ascii?Q?djPJH8IGbrZ/rXVtIzjMU0cdFBrF63tCZ8p1kXdarE0l1EU74Gqzo/cRTI8n?=
 =?us-ascii?Q?gkehG2c+OwrjUT7B2nRMmJ0Tm0+BH4/dska2DLIvn02wDFiqVX7cmmz7dXgz?=
 =?us-ascii?Q?b2GBTXwmLU/K/ckiGTG7NyGpHCijAI1+LJZrxJD8ExbB4wCKSx4CXjzRxpA0?=
 =?us-ascii?Q?oUoNVkafWe4bqagbYau9WTDPl44fkBojgANJCZcWqF6xsnRZ43WxW8nv0Ynx?=
 =?us-ascii?Q?9DDICi3ysGeEEYmvmjujGSarXcb2nVDoKkaf2w9/3WQnHO7MUssReBqtGBa0?=
 =?us-ascii?Q?h3Ywx6PHsvGWQU9y/eIZZBxlSFsbIVT5MqcjBSyeg1j0FgAsfp/QUTKY6LBw?=
 =?us-ascii?Q?hZ1cvQr+oVma+ZGeFoj/5s/h21B0ZlkPYd/BBsSVe8alAxjdkC5i225Qm9C6?=
 =?us-ascii?Q?B4V3XiLNganXe/el7irxnk61BqpRIyML2Qc3jOLKG5KpIpR9apUSH4LumEIe?=
 =?us-ascii?Q?B/TSZYN38qQtteJVZZApRafBXzNCdp/Pgt7R2uatwvw8WrVhQI4Oe1jzGO9o?=
 =?us-ascii?Q?tAd0EtGdkwiqXgeak8zNv9jBMFDDE9nu/GkYMCtFjF3fRXlYEVouxT90Kr16?=
 =?us-ascii?Q?DdU4JR1kZ1U7FXqP6jhQhGsIDm7GP9Nvf2czE0hTut5i/OHi47ppX8HygYvs?=
 =?us-ascii?Q?w9v8ujq1LmCoSrQuiK7BXCX6yISXBgVO+IxOnWjLhkPAhFHkWovyiIiwsm0s?=
 =?us-ascii?Q?46AXp5uG5mA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U+qH7Fd2TsJQKkFmu932eakzZFtuWMxdK367CywzPI8harCsAXQeg/zAKpSb?=
 =?us-ascii?Q?Azg+VKo3ldYRuoyF4sEJbKIK46XsNuY9lFlL41lPkEflK36J2F9dste6T/i7?=
 =?us-ascii?Q?AoGom4C3jETguK+FgzkUVsCvJ64UFebVVDwI2sSAXPGietVK8N5/R1C+2r++?=
 =?us-ascii?Q?iqZ/ejYsmbVepXhkPfUvqyoImNT172muOlqgITcqlTtj9YqnQCYgShKfum4a?=
 =?us-ascii?Q?x/HZmjpe+Dh/sXkrDKYlsUX+vjO98qQcXqhMGeu2/P+z/04ECWIpIjg2+2sk?=
 =?us-ascii?Q?QMitHnrRJ/eWYPNU6yOzPfbCq91WsjZ8zmXqgQAyQf0Va3nP7mv10HzFSMB8?=
 =?us-ascii?Q?x0VsnMOzhsYu1biuJBGY10dMkFuqGY4y5KAG+Ub7Z5Rmv504J2dyeqak3bIM?=
 =?us-ascii?Q?pe1JPR0nEuumGhlDKHKDtoyhpX/75Tbv74R8BH4it54pxPdi5Ay0ive3Imog?=
 =?us-ascii?Q?mXgiTy2BmmzTjf8nk96FURSZOS7UnyD9UGtk9KBvE5KwgwgKGHwaqv7uLElT?=
 =?us-ascii?Q?AP1aJPOwvYGWSK4YEggro5VL9ZMfslDBCojf/iEGwcQj1RMYZ+euH/iqLMgo?=
 =?us-ascii?Q?4DlQyJ8VFGUnZWNG/isENAtMNjiqP1jDZA03pKOSA0q/VzxFTDNzI7ruif6K?=
 =?us-ascii?Q?WncgpHUTjbYH/pFcux5Q/czZZ1caWPTB0L2ALNzu9E9wb4TUlO6JQmZM+q1I?=
 =?us-ascii?Q?QHknP5m/RIY8Z1hkk2DkZi4wWpRPL12ruk+TfXPmr2lETMwN0IBqgy/2k4jo?=
 =?us-ascii?Q?k6WsxDU8DcxWeua++v+R/jC/3XaDW6PmZ/m9gqI+EANT9aRQ+Yi47AbZubNq?=
 =?us-ascii?Q?ZR9XPh46uE1Rh832fMIjB2KlTUTgVwDBgBu2GhWhP1p++Wo4Jtoa/sZ6LAp3?=
 =?us-ascii?Q?flpUjQ5kNdGJgb9G8Xrbm23jCHZ8CGUhPfn6kP0B/rsyAQiWpZOCML0iVfZy?=
 =?us-ascii?Q?uzhtBEwV00/+32GbvZZ63+yzMoFNol11aGFWtz7ezr5YuD7Le8iT9ZqfJcR8?=
 =?us-ascii?Q?R2JrFRWxaugQvjICjRe5yPuoQXmmybgrCeUdyX5adicYYz7PZDZ/pPh7mRx5?=
 =?us-ascii?Q?bWgtTcKBQi4TogGF0roG8dCaUF+hERW/9zICymjQ2elZfbzJTa9wkoFr8eVV?=
 =?us-ascii?Q?+9ejk0nRGoHFxdtVftA0YXGR938Cvrr4LmhjeSzGuUBMvwRyGteuYCPJIL0I?=
 =?us-ascii?Q?+BewAHdh/dPnMu/J1DaefakWUQfLq/Gh6Nv3esWYQ++s9QFzYzpfGe+aNb3W?=
 =?us-ascii?Q?aHHw7MCER7wgT5ka5ijVTjyqq7w5yM6oZBEQhfTTgkdyCFUFToCRjCC1krxm?=
 =?us-ascii?Q?WAX6ZPpNfYmwV3vbj0SSfA7eB78U+PA3m3o2UtuJcA1WyPNbWVnSyZ8hoL2v?=
 =?us-ascii?Q?woGcWnSPVgGDXQJseIfxqofhuDPs7w9yXgnSr7r5H1GcEKJFuLZWvNSl7a1u?=
 =?us-ascii?Q?0YX07TWCLnK280eBKRXmMxa1ac/+9Ob6/BgMug6vUrJBAyjk2IJtegHr7osE?=
 =?us-ascii?Q?VkzbaeO5PgkcGBbzYXAwfdtrg9XXcSR37Fd35GVa05CUUkQBTyoPHSh2fVAo?=
 =?us-ascii?Q?ETfSNhZL82ProUr9fVK1nnUvvPJJn8mv7JlduMMP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb084d64-d3dc-424f-e7ba-08ddf789a94f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 14:34:38.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLjv0KWNkTMkPQKwt0u+xmJShecgIQeR6fHB1yzmKmB0FXsQ6Q1oQTkLPlYcdApA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF7B9F1F8E0
X-Rspamd-Queue-Id: C60D310000D
X-Stat-Signature: 91ucoh1qx3tteg99kh1tmhrf5w8d5x1m
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758292485-50283
X-HE-Meta: U2FsdGVkX1/bvMxZlSfD6GohekCDY07QHdXigjX68eQdIj8CjlWH91U5M+K5cQoqjprQ9jvGN5RDauzIwwnDE/h4j5NIRFaDGze74Jz1CtWVWamsMh/C3EoaHCdnLe5QLTDlu+pTYRSOWv/xy5eKnyHoOWp4YT1X4QfTXHgG4iOxo4v2iDie7nizkEafvEnF//fMC3+BTG6WU7d32JLFmCqgHCqGvqFo6V9Sy+BpmnFHCcf8J+VmPO+ZN2AThrO3g4eyasPTmhRUYT8RKYhoJbK45pay4qIANRtjbGlVb+UuwuINPADOkDjzoqBQaqHq+PZERS2/1fvXhHtBAKW96YnGVM6IXhmwrLhA/SdVBkPYIjKCUdeh9TnAR2cIOkicLNPcY/zGuyscKjtG3E/gt7wk+Aqscqdbt4VDVv85+5vxlTYneTZVEzOJ9Y3YI1GyHjvBEGS9FrHPTNJLBrjx6DmHp73JvHwxfGkABGvELykrqFz7ZIZ+CGYKoDLdvNBKqHloUkCZHJLb+RwekKhcG23AgSpsNvn0VBZd9amDV+V2jd7X9ZcnLh4jq/irQTi8BRq7MxMb+RI/uPhGwAsyHjCRunsAgzmUyAN5oUQGQOLWnSeaUo5cQbuDnya5C9adRvB/EB9jUOFtQDVrdUT/gIIlOa9gPjae5h2AApcQIY/kqgRTrt7VsgN6IbewK8UEdqgcem6jLxGyIIYcfdJr3TIo5uGZntTLIVu6NN+/lhdHSXdLQZOZ+xrgOk/uEN72PaGvs1oryYxQBQUgAIh0UVTVQo6p8KBgNYetooORF7J2rHg0n7tYyLTmIgjjLHxp3gfUOG81QKB7lu13f4GhoNZ6LqahtBnWWE4LtFyuwVEwGgHQ4WPqPtAR7j3kV/2YVqxwpupgf2MQNp4EYyz9AUc2HBMWqeT+Yc/EYLln2q7l1Mw44fNFTa+VfcAPP/JAg4pRujk+UshYvYg2eX8
 XY/XIGcz
 nepvqWlY6uqv9D2Bvn+zVxX4B4pU6DT7jGt8UzOUuzK0M0423585Sj2ID6KXjlYLT8OzD9T/LjLb1wfMv02Ra2bn7LcfMJgMuw1P2M080vRiD3gpMq5i0s8P7q8JVL8KK9pOpbgonomw6qb+LOKZSBG7Q8YamkN+PoFyj/WJqPko065bU85FbUmFpdaUjT6rlkyQHOLAr+kDU29rnbyjMu11iH5HixjEGjwP+Rc7aqJKnbk3YEeNejofGQAvJha4C7VOX4SwsXCRQF4lLuoEtqFhs1tPd1DkDVrXwQc9LBLI26XBPBiWEW/KtGlxgGOTJGwH3hOkyJnj7b51eMW13CqWgvmqHCCjsV3+rGNByaWtIXd9uhjzq1GCaxq764SkWCw4y3wWNy4iqUx0wJoPl//srZpMEH9ZN3/FHJ/fs+DdAxaBJjlUQxLnaHK4dpou6cBvCWKhuM3GF1Tg5zDi18EWFbZmeeA84DTPOfTg/H/KWeV9vCNAxIwmJyFrrxw551ptFqLO8yNVvZhZ5GkDKsm8obXSfJEFdqm0QYBrEmLJuaHEK8uE6inqhOeVqH3E8FLktKiQ0Y9niF9o1/ztEbf8kKXJRem1jKSC/vE5vaPOAd00d3qjVlUwNyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 04:22:20PM +0200, Arnd Bergmann wrote:

> SAM9X7 in 2023 added DDR3 mode with up to 256MB according to
> the datasheet, no idea why they chose not to support more,

Quite possible the internal SOC wiring only has 28 address lines. :)

I am right it sounds like we can drop vivt cache support with highmem?
vivt is alot easier to understand if kmap isn't running around
creating virtual addresses aliases!

Jason


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4CDCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 01:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4022E8E0008; Wed, 10 Sep 2025 21:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF5F8E0001; Wed, 10 Sep 2025 21:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C84F8E0008; Wed, 10 Sep 2025 21:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1937A8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:36:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B07DF1A037B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:36:01 +0000 (UTC)
X-FDA: 83875253322.17.E476F38
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC7B2120009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:35:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iFVvrEH3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.79 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757554559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnUDwLeAPSkq+ljSJ4Xhv5C+92eV6UoNgfH3KyBzfbc=;
	b=YhYJIV3Gej++zP1SE/sAI7LPpumMbllIXCiMLhu4JqowEY4ce/80LtfqNBn2WXNeYGXznp
	kMpSWJhiADvycabCBheEc/m1VsbmLZ4aOxhP+dBFnY3WQHEEKBhv076ZBlf4AoxdfbnCnP
	OHciFXKkReyXkRS4iVqmYjZ6yu5mccw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757554559; a=rsa-sha256;
	cv=pass;
	b=iLkE9ag3wCibvhVx3TbJn2c03wJJA6qWdHuYsKLIRRcBPMhyqtjbraNDRAlmEFKqCW1rh+
	6nA6SavDtOt9uwTLfnH/c5IEufYAUc+5qYnvx/3h5t2FWGe1nQEnS5kEdSQ00HLd6MvYnE
	82PEvL1J1+xGqtokesnoCGBbGOIOTJ8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iFVvrEH3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.79 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DQ3N8S8bXAIMKEUbHMbOf6uowZWRQaGnkFbYT3qtQtXa3fpGgEIPpORJ1hFI7xYcqMyInJflGHD7xDLwPpmwTt9UHH2jZFz4ejCbtaVna3cAZ1R1rayMUnMo9rS9D7fAAMDN5hFA1Gstbov9DV8Q6kqG10KHHDcDzoQrFNXpa/vc8wP9IFOkxVIGQPNo79pqOASYTOIVKrXrN91aDsXeYV/v0EZzuGMq4k7hcbL6gx3pHUFBeYAxyZiWu6BCfByMsQgEGPL9+c26l3OeKfBJURJ3qDot1ySEaSS4IPgyZWLrtGPLH05QDHyciIst5043m9IMT1CHOVZl+p6BCQNQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnUDwLeAPSkq+ljSJ4Xhv5C+92eV6UoNgfH3KyBzfbc=;
 b=VslfwhTdABk+zvSTEVL4Pu3o02T47cH9OFjQRNkaHZcGVFYu08TaY5+9y4/znS84TkokFKf/ylaPlCEomVZVOKWiEMcNXunJK+dHYqMiuuC99Ln+RcMHzqKei/TzdynEYlcMtJyttbw5Aaw075Q3B0MKIcJM4Brgwf8JEgBreWL7zZQTcN9DKGBblI/PsI1f15xsBmf0TUSMCatEZlQJw4JUKv/sqg6LMzu1dMrz404KLVszBLpB0Bbx+ca5ir0vOfy8m8hTA+izTzzeipBY3VXE4ArBPpyKng23MGJ5lJ5jKF6yKQ5/oAxK9oUeZOuOliTSkob0Kd9G6BQxo280sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnUDwLeAPSkq+ljSJ4Xhv5C+92eV6UoNgfH3KyBzfbc=;
 b=iFVvrEH3HbaVtV30QgqXHLPd85EtY9C0CKm7fENfQoWB6+1ZFR6WttHgJyobuL91RdcP92xlVqFfsOEJdbT2ssM/bqGrVUxR7lV9CuLMbcQH9pUnat1MZoWmq7X1iJXADGRTdqCCQpJVcJZ5W6+Ing90ESBiC9S/t7GVdWIOAA3bw5Up7GC4rOul280mh2O9ov8PzF+tllKjYsbXUrjyKbAOujt/feK97WpnIMbA5WQsvz53gVW4H3IPUxHSjtzmQxwBjVV6GCXIhCkd8TRnmiYU39dxiZmFnLx+QMoVIlrfhncovDSyu6mfFyhEvAiX4oQOehI706qmduDT9AUQLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY3PR12MB9632.namprd12.prod.outlook.com (2603:10b6:930:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 01:35:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 01:35:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Wed, 10 Sep 2025 21:35:53 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
In-Reply-To: <20250911012521.4p7kmxv46kwz5fz5@master>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DS7P220CA0035.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY3PR12MB9632:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d544ef-3ee5-4be2-b477-08ddf0d38d61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xv+U53mW7LgAJUUcxH9IiwP+PK7CvB/3VD7BvlZ8vBcTX2rF5Y+UqsW11ONC?=
 =?us-ascii?Q?5za7ev6q1H6RRSzrZPAy9JhY5ZG88XMAXScMhib26qbTDMfilEeiQr2YOJB8?=
 =?us-ascii?Q?CNLKZoiNZyONPKGwZcgvbIzgclWaj9SKq/GrVKs/8NeO8G6A4zo11CiR8u/v?=
 =?us-ascii?Q?RJrqp1gJw3rTE320ct8ESe5lvbYWhnClqb+/+Hc/6xvWYEoZFva6ZiQvCnrx?=
 =?us-ascii?Q?hysrG+jqpD4leEYi8qnTYaiYrFZxLA6yGxpss91KHpfHZdiwurUEU9tZwyRc?=
 =?us-ascii?Q?su1WlG7eVnsyFubbVU+pKnLk0dsUt5VPfsthFc2CShG2FHV+eMgGa/6y2Sr6?=
 =?us-ascii?Q?PxLWVHPPSY4wiI4ol4DPB1elVDmeyq3jzNHgYu/3RV2bABNp0S2ti5qnw620?=
 =?us-ascii?Q?R3Q0a7TDi0nPwxvvxhY3Lz4CgYgn0RSlVfPqRdum9RTQ3EmyW02OEzzDcBEW?=
 =?us-ascii?Q?dY7u2CX8dwnhQP8HGFSeNo8aX4vqL6uWVtHKFFutb65xm902fGdVgrqVJbid?=
 =?us-ascii?Q?i2+Sty/QdVsisXCI2vgc5iYdCfOQQ6Mh8v4v+jcZUb0yx4j59u+cv4/mxgHd?=
 =?us-ascii?Q?f/7dpIahknzb9HzuLImKsMdD1So86/rn09v/5J+cFJbXkMW/OitaTcLGqkbI?=
 =?us-ascii?Q?8qjxDEepnOa9+ldbhbMCDK40cajNgZkpF7EkhEHsApdMJbaYJCS1kuFczJV1?=
 =?us-ascii?Q?o0tvz7a+okU1upKKXs6RpTbAoKXKAB+0/aoFoO0zgN23zu+xtVCB7IvKQb1/?=
 =?us-ascii?Q?L2j/ysJX3TpuXg1Jp/ZnWBQ9C1ehNLXUsSfKa5X9mKr20PmGkbtFV3Sxrk1d?=
 =?us-ascii?Q?6t09RkB2pBihAJiA58CDB5/1gcvBHNWrrInRRz9G5e0MByjsEWnvBd6nscF0?=
 =?us-ascii?Q?xo42/ekIwwv5WKcxxw1b2GYCHN9c2jSAm7lJ/3/pZT6SUVagWLt/s3Wg1K5y?=
 =?us-ascii?Q?MvIknwcnyeMsOnmt1ujWPtmSzXSvdz5bxyk1FdKpJrt08XwXvUvN0Uver6zN?=
 =?us-ascii?Q?QfWUCTT+1AW1z2h2VBSE0znQILQ/S9VVZ2GzgYORxm/09douGyd0zPXzTFfC?=
 =?us-ascii?Q?istgNdSaAVi6AcRNC9GdRS/vRnkGeEikn9LxYkUFi775h5atT/9HLoud2zoX?=
 =?us-ascii?Q?lIdW8Gmz/57M5XZnHi/IE0uQobmAwDqEspTm0v3mcsD6c6OnG2Ow6KneTyXn?=
 =?us-ascii?Q?xCpXuzcLkKbUtCAI6sySqSyvVtXXIBNuyCLZNcL/WJdC+auzMRkdCS6YCdmi?=
 =?us-ascii?Q?OWHSwificwWj4/wuOI2paHW7mQmmCmlw/muJZvpPlkrjy+zoa0+0nEuoBMlN?=
 =?us-ascii?Q?/7efz5EIQgF24GVxRY7Ay9VsRUk3oo1QqlA5eTwlCh2qt2d1l+Q9mRcJGghy?=
 =?us-ascii?Q?tx9CpKeWSEG++LgnMAIEkuWJgTUy7qrwKkyHWAsdx91svrmYL6oAHSfbTNlT?=
 =?us-ascii?Q?m63ppvSwWN8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r0aZ2jBAC7Czvji4wYlWoLQCmi1CqvXfEGVLd+9p2MYk+ksIho9Qtbl76JuV?=
 =?us-ascii?Q?wGELF0VOlMvDBCzH+qWRguJ0vd/uPC7I8YXpz5zMPf4AnqNk9+IK2egTMaoz?=
 =?us-ascii?Q?wPQKXh3nTS3Ctgt6kUCvV/9oMRSkkQPLT4ndu0Xfh624arX8ajp9xaZvDpmt?=
 =?us-ascii?Q?GlJIvYdui5TDSs5DjIrBLs5bDJJMDQE1TtR+tzXW+kLEaEiWDq3AEOz87QUQ?=
 =?us-ascii?Q?xs/AdqP4gMEE+Z7EVa/AoR32zAaaB4nKrFu8MgjZX2Drt+w6CEURQ32SRi2v?=
 =?us-ascii?Q?Bka7fxCdJpL6/h0vjvOAjCD4r3Mli3wCUEJEkKfTjMp+sVkO6dKwXMXdyVrj?=
 =?us-ascii?Q?b8WntFqFmTYXy5zEzhuWHPFn+cf6NHrnIniKzvXZ1TPhYkIK+cNepPGjQxHr?=
 =?us-ascii?Q?Eqk3/teV8Stmgk2sfMLgYFPx9BRCOXxry3g2CtCkyGckXhoAjFvSBS4dulqQ?=
 =?us-ascii?Q?FW7LssXQPcYimTy2WCosZtJjBzCxYJG8Mvm/Qzau808IDlniMUoD+NytsVWo?=
 =?us-ascii?Q?1Pb89iA/FTgqg4dNBQYmV1YM4R5Il/h/Bu7quvo1XMRpF2NjDi+LlRm7p4D6?=
 =?us-ascii?Q?eqTZauhhjDsbuUdi2CW92uTIC+7st1bPy1y0LA8TT8L9r49sD8WN5+L27big?=
 =?us-ascii?Q?UrPC9SpIHMUL0gd2yW4BBAjNtMdMSl2+DeJ5LeL9JALEgX/10Uxz2bGRAAzZ?=
 =?us-ascii?Q?4Pa9gWhfhNocoIjOzwiZ30GWRb0tKpDWvfKNKSYRCdHshJGbgVemF6IcL02o?=
 =?us-ascii?Q?0+0WuNFrz43WS9VDJMv5etYhYWmexpm+Q8Bf2UaDlS/iJsM44wOcqlZ2h1OX?=
 =?us-ascii?Q?fOiOd+p987j1TdsyduPr6KSvM/69jJVbtEAuuAle/6F5+8Einio7ayCrOwI8?=
 =?us-ascii?Q?tK1t8ALvGnq14OoHYIzMY6qmgjaseVouidK3FuD45snjgqIBNtN/9QaAPLM5?=
 =?us-ascii?Q?fa77vRwOTV9XTF55FFnHKoiurxCycXmbQmG6nP7S5Zk43bcq6cYgyFZfsSrB?=
 =?us-ascii?Q?M5QqUG/lukDhtSemDFaFcqLnHxlQKzXaBjO5jOKHr0LGQR4jkNEjmoDp2/Lt?=
 =?us-ascii?Q?FdtIeQvtg8UpFUYCda6bPyqZgNXo/uJwAutLNXCAg8vhmIOZAoDnpU7TR66x?=
 =?us-ascii?Q?eJVsEeNBVlolJYD3Ii4f9TQI4HZcmh1TWlCjZxR/jCfyHzI9bkb4wrkbwCpm?=
 =?us-ascii?Q?D7nfZPE/dyCKnggstaYWuwEjivqQ98QveDCIG0nzgF99OCbAZAp3epzoiofE?=
 =?us-ascii?Q?gN91BOuAVxSpO3qX5VucEuCU3BfjFg+abbk+bug0/dR8yPe4Ziq7ArcjjcXm?=
 =?us-ascii?Q?gXrTb8AZ28fiz/htVX/hkbddZiE5RkDkP44mL6mi50BNOv/FuVo6qDSu4aJ6?=
 =?us-ascii?Q?IuHlTEZzgbdI0LdeeBDhB50bstAO1Q9+pHuCIVxk6Iy3ObdeAZjhhUgg+2QI?=
 =?us-ascii?Q?4Wp60uFxFgslfX2S9uxtIfNqTyqZkAUaYQHf4DjvrL2rZ8KhFXDhiIP1wogR?=
 =?us-ascii?Q?NwXYPewvH/p1xnuYduczKQYfjvD8VeeqCy2AHjaZ24Jetz4o/XLG09AOS81e?=
 =?us-ascii?Q?OCKLT/bj4yH06OPQr99URp/gN6+JpywoxRAnq+3Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d544ef-3ee5-4be2-b477-08ddf0d38d61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 01:35:55.8396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kA+Xk47a8K2kAToYGKCf6H9F9W3Hf7ED97MdXc+COdERBG+O0dvUlufmzJo7EN2R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9632
X-Stat-Signature: zcixwryy95dtuzx17ek37aphi65i1gbj
X-Rspamd-Queue-Id: EC7B2120009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757554558-109313
X-HE-Meta: U2FsdGVkX19fRqNVVnj1oA7c7ts2yuGdI6rf5+bql9kKMDKIVLPe1Ua6VC1l5jMhMooFHlMNI7rUZx1ToFbOp2JUyLBLZPIR8oE7ENJwLLhkbpyvA7Vx/nrPZdaOJtnBw554sQHlo79MTJR+1KSrBLViAh+i97t2MCwlc2EB3d3s6TSj0PNsWVsOkOaBMVazJF6RRnZH+7Vedb4Jkf0E9U+qTieRR+BJHiZ4JQz3fp6y/+U8bRQfsC+RcCjzHI+pZbSP4zus5n+ZCI0Hg9hGCGyhmVr8637AM6J0adHHaTMoziGUm6+51hxdB/g4t4YfKTKXzJCQsml+1tmRMHX9G1Zgq8cWSxTx+NdvRHZO/gXUjFR6Z3BPXvYpSoeJ//5cDDapXJ2mpDID/cd7roaTAQKIBwqeI9LhW1ExM1Q4c5CUR9bKtGaYU5rarOWrZmVyVHLW2Z8UwYywRolBC4vc9aZn7fWpI3NM4v+Zc88/JarOm0HINFI0BxrAutjbtPDKirVM/jUe9bfudeDy4Uepmzhw5T1zTtHbAVcUC7nD9GEM7fsKULfdWqmqlDP7YU5lzn8+D812DP6cX47x5AWR7bekwsjUL9Carco1GxyWRTK3n2wRcRAmP1Id0r+fgi3A1viPrUQA+4oUoy7oHUTVrLRmK7PdN8f2Jds5gTd/Wm34u1t2XnY9wihmK5LRw4D7ONe0IxN8ONSxxAAHZVDaae/QJM7R+VBgaUGkx0Ftdipf5JoIp7CwzbCkQEcH5JbDPSTbOas/KRxHLQY79xVLwrFxd2rL2DQu2xwb0HHaXxNiQ9uCmD7f43B4I821IumYhAD8CSTuFY9DH3lra3Ic6jAvKhM8N4nE+qx+V67qeE5Z5GiSpxl2Xlqg3Qcy3wt4zOFXT3SwkC4bMlFAVFGfjUJPuRXV99OwQYNyfkPNfdDrxPUZxcjwvTtmpnrhooZSE2THFlZkW/MtPz+vJlL
 hgZhfJ9s
 lF+nxt9YGtiKWsEJC3F7dEhV1pEBgntKl0aE8FVtyQXXPOxXtzUEBOGUsME3xSz/paIdO1CAk653zEMWd1wJBR7A73Hbjob8hdk+N1ySLZUr275O9h2FmSnb6A0SvE5x9CKtojcrvuVfpQbSBt89ycLoNaoep2dULkh5jYJtBy3BBQrUoOI7gwY/sENw0rV5z0zWCNvFUpAspcFM0UyNIhLTcNP6lkBnOrGZ6X8x5CZwu9wz9ZoNa6sXZz1NxMexmQ/TmsEMw/U3khtx/UYopgieRpaGu4Q3dJJsOKvLSM5SMA7FduMdS4ky45gQD1TMiVqWp9Y2urfLe6AkG4XTq8/LUHfSNIsWT9hE4gH75Ysf1ZJqtdeDWBlTyBouikjYeSwVuKc74+fqB2l0KWRPIXDvX9mLwREeBHYdmL2lpMu95pEEoUlsdBh+FlavNbqrt22XzBFD/vrMzmOZYxAxBtRZbtSdjUyuRsfALCqlEjd35XoQei8MkdFSw9g01ftgTD0nAIxIN7sNRs5WzGO5If3HZe6mCTy5vHWDKFXkURGIQiozcL/GwP3LE/xO8nxB3Q1FgZ3SyXOkC4x39/dgbgHJ3Sv/eW0MXMnx/2QkobmAFpKhUVS4zaTnYu+EFXST4X7N7YDqVBDFP18w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Sep 2025, at 21:25, Wei Yang wrote:

> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>> isolate_migratepages_block()") converts api from page to folio. But th=
e
>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't poin=
t
>> to head page.
>>
>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>> which means low_pfn only advance one in next iteration. After the
>> change, low_pfn would advance more than the hugetlb range, since
>> folio_nr_pages() always return total number of the large page. This
>> results in skipping some range to isolate and then to migrate.
>>
>> The worst case for alloc_contig is it does all the isolation and
>> migration, but finally find some range is still not isolated. And then=

>> undo all the work and try a new range.
>>
>> Advance low_pfn to the end of hugetlb.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolat=
e_migratepages_block()")
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>
> Forgot to cc stable.
>
> Cc: <stable@vger.kernel.org>

Is there any bug report to justify the backport? Since it is more likely
to be a performance issue instead of a correctness issue.

>
>> ---
>> mm/compaction.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index bf021b31c7ec..1e8f8eca318c 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control =
*cc, unsigned long low_pfn,
>> 				 * Hugepage was successfully isolated and placed
>> 				 * on the cc->migratepages list.
>> 				 */
>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, page) =
- 1;
>
> One question is why we advance compound_nr() in original version.
>
> Yes, there are several places advancing compound_nr(), but it seems to =
iterate
> on the same large page and do the same thing and advance 1 again.
>
> Not sure which part story I missed.

isolate_migratepages_block() starts from the beginning of a pageblock.
How likely the code hit in the middle of a hugetlb?

>
>> 				goto isolate_success_no_list;
>> 			}
>>
>> -- =

>> 2.34.1
>
> -- =

> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCADAEE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 23:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006276B008A; Sat,  7 Feb 2026 18:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6556B0092; Sat,  7 Feb 2026 18:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD75D6B0093; Sat,  7 Feb 2026 18:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAF5B6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 18:01:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B4451A04EF
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 23:01:00 +0000 (UTC)
X-FDA: 84419182680.10.08749A1
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011026.outbound.protection.outlook.com [52.101.52.26])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E8A2C0011
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 23:00:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q8vR3fMy;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770505257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuJ1SyMoS0n2fUlNE4hMmh2XznPXn2sAz2AbaACp1fo=;
	b=d0SIBsjntgtgIQN0uz4MmALd8t8TRvL925NWiUuhFMfvKnU3nPyRbCDOGr5dS3UAr17eOt
	HD+UhYEndMqT9gfd86PyWtkPlWJaTMCPP5udoDoZrASPcBXb5OYQiD0yDZDsB44FxM1mD8
	VcX0s9rQDSF5JJMaKqrqSSGzQFrWJJc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q8vR3fMy;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770505257; a=rsa-sha256;
	cv=pass;
	b=ylbJ9+MQVjLFsC/OwlEmTa/GeMTEMyLtTc5am2dWjiyTqvCfe6bMBx0U3l2aB7ELEus1Rk
	qqbqAdJFaxZwU1boHnEnw4KfPANvs+ofDqAYYBWDvIozTFUjtjsPwDzNta14gNeOHQM0+K
	91Rr0j5NQV3rzklnQdhv0JMVWw6o6e8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VLinaaFXvtxrgxnPL5BPE3T9ksRWGDHkMIxdLAT1ISj54FVM1Cg841MM1VFVx0aY0F1ZMaKfiugtIhP3L28XAZilXSs0erlH1YAECtgrg8mwwyADz75Jh5lymnBzAFQZWzGb2kHII+ls/vRj7ltrUjkw61bhPVxqlfbdwn3uL89VlYMEtlsNAcRk17TSaXrjmbwCNnQvEBj1A+ofGWXNWTV3lQ46EVjjKwf1dl81ookgfbQ46ZxCM968thQsHeQJ2DBaeM1+72wchDD4oPHv+0fxikaiyYiTD/+aaQmSMIWDkrstpGpQpaOetZJWWK36iniTD5MAb0j3Dy1jIhDpRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuJ1SyMoS0n2fUlNE4hMmh2XznPXn2sAz2AbaACp1fo=;
 b=GnVVopJMig3YBz8ofVs8ZxtzBf+6AN0CcqalrmOzIkQMMOQYt+/7NywMnhTq9DHTlvm/c+cry75Uda8hdJ+hPVTh08E/5K0SsLeHTEJa7UxuWlSRDbuF5QXcB+dQlUTIwUKOcUkGvwPutpcGzYFmWPeBK6D5G+9lnbosyECa9J1OKxDNlnttdpckxSzzWUyUeOFJUoAB1Gu0OnA1sKo8zOAcTYtBGH9ATaCMR8dqNwg3moFby3zf7ESAEQUMSaxAg6SoVtce3hBBtpWqfgIxfuLIcSUTMhrb+AtKCZjWE+sfNBOsmtfapX/hP/nW09OcUeP3fQAle7YQTewUGOUfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuJ1SyMoS0n2fUlNE4hMmh2XznPXn2sAz2AbaACp1fo=;
 b=q8vR3fMymIUJ4a0Ks9ilN5sfqk0l2WRQpgeKQpTzm2E2j2iOAJyHNYdb9MRyPWhKrKSi6hwVNlrO0VzgM0r5NoTEf52MHyenifpa8GBoB6aTJHwGJ8ZCjXPVkcXEqaTRhJ8YxOXjre+c0nk0ruO6S9F+XgatYKYJ1wftUVcAScEljPQgUvMpA2iq6tNm6rGKjzxP8qPM3uTJq96DVyK1TaTLl3eOpkcYsJqMH4bUkKiaFwFezcwLn3gpK5ribY4L96YVw7VBSjy4XhcK0OXgyoTqbOpr3m0zNKXFQH3S+/YGETlbinL/DmMBRaO9lChIj5VBGR5d6jjCdTfmRas8HQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6043.namprd12.prod.outlook.com (2603:10b6:208:3d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Sat, 7 Feb
 2026 23:00:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Sat, 7 Feb 2026
 23:00:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
Date: Sat, 07 Feb 2026 18:00:51 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
In-Reply-To: <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6043:EE_
X-MS-Office365-Filtering-Correlation-Id: 517cc98f-e159-42e3-c3e1-08de669cbee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W85O07QusQe4DXrAbAgywUU3niUOQ2xGAPSnOZLzTZ4FHd2BtD0QBfrXc6R0?=
 =?us-ascii?Q?+UKVQE0ANEoHCbgAyXgf4ADZnWG3CjNMO57TWZrRqJIv4yIJjVArXd49oiaW?=
 =?us-ascii?Q?85d8MCrOY3/NXYFDPXTUzC8s/HVgaE1KylSLzoQB4qD4FliH0NfR8JJcx9ho?=
 =?us-ascii?Q?eicZVm8M8iFMn7MjVEk12fwTSt8ugzLUyk1JgSta6rO71pXNPRCqlTwLEZmt?=
 =?us-ascii?Q?oQ3vhX+3rUDTPdDdtrHBgNsYRzMAWFF1U8pcV0/AQPL5j4ixDKRBI+WScyfM?=
 =?us-ascii?Q?m+4M3wfTEfupLf+bkn2nP6I9s+TqlxKqRHO3q14q7Lw0lRhOttWfBH61BGVC?=
 =?us-ascii?Q?e8GrEVxU2YJlr3iBuvs8LSAQ1CTrCPPzKuVZHegZz382p5+vRiT5RYE68qEk?=
 =?us-ascii?Q?zAizPlNqrbrHdHJqMMSRVfIgNlu4wtWuu03WT0+hVo4hF0z1LKMCP3USt69f?=
 =?us-ascii?Q?4NeOph8p5b/yOXrKX+UgebfeJYnshR3m4XoeSUfSSQS8CJ8LY+M0uYBmw9HX?=
 =?us-ascii?Q?/Uj11poTP0TkKinJ7kM70Jkab0nzNaY5ZDqFLTPLAAooLbO4HjkC7WMvj2jj?=
 =?us-ascii?Q?Nz2B+u9SLw79PKk8gKLHVmp5mQkTWL2umR0n4HZkAjUf1/3nhickySLLPxuf?=
 =?us-ascii?Q?bo+uUKY7+UT2c4qTNA0IwRbTWDGHgvGSx/fmu8/OfJ6exYfU4epPw8N5ubbP?=
 =?us-ascii?Q?v2R6QOEMwZ+bCyCYN3wFkxZzEYYnm4UiQGRVsocgRbSWoXtpZXCWW1GQOybR?=
 =?us-ascii?Q?nOlPW9Kl1N8co4dAgoikGUe09o3DsRd56snoyiTQaZqnhFwVRL124d10ztE1?=
 =?us-ascii?Q?3ZBFQPudOOeaspp8cLWgDf6g2TztvM6SQVgeCcFseuPT87MQRNtyjqL87GOW?=
 =?us-ascii?Q?Ajovxsg5NOWsngJIMX7naWOElm2ga67mmIww5jKcXr4rsIptaNEItrOzxK90?=
 =?us-ascii?Q?9/8bAeL09ZO0508GHHGfJjOGCvhPCq41z57zPrDk1j++amw7nvv+EAkOkOH6?=
 =?us-ascii?Q?saQ8I7qCPRVmLxQ3+Xw8ZcVwQugKlm60VoaoDXLOkQtPGUUFXKEUl3w+K/+c?=
 =?us-ascii?Q?MUCG8clMfWA4pclJ9sKIHUL0ZStk6Azei9PsQ8MDGUX59xDv1F3ZQgeDD3lC?=
 =?us-ascii?Q?1gB5z7iwTCiFdut9iSszfvpx81kPNvzrei2mveZsB5h/uNQPy0Hb1DqOF/kV?=
 =?us-ascii?Q?otbQg3WW34jMOULXqCT03BbpbMExqOP0hfzpX/UszeIzL1fMGyy0jbzZq1od?=
 =?us-ascii?Q?Bb+g1C/OVxB86r5BV5bjDeuATYe+Kb6fdkRzVAi+cGSe/NzH3cO+579VBG03?=
 =?us-ascii?Q?wkto/mOg/3smsZghLiEH3i303TMfyLYr88YslvE2cb5rmZRQt8/Y1VhTu6kA?=
 =?us-ascii?Q?amEnQXdlPaGMEzT9xv3jIK149sLfdfFVgEiuUjVuTrSsBJjlJHHE3ayqyuIJ?=
 =?us-ascii?Q?p7z1rc8FETCpLgOmcWGwkE1klt/iJjHwFbq6zDAfx0V+KzLR7nLY0szIk66y?=
 =?us-ascii?Q?wNOepJzGv5XpLaHxQi507QeVHg0GJaissHlXBw/sMkxrT0wfLKf6x4Ljiwbi?=
 =?us-ascii?Q?P9PPJg2x219gkRXnYffIV87uV2KjM/MZ6fhr1D9y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zYmPtY/jX6oGI9L86lA6hqXAf+XGVubVOAO4RsD8ty1xNLRijWVw5lDUVakS?=
 =?us-ascii?Q?d2vUzwX0eZ0PcGE6S6Tsg0g3KebkbKCjzZ7n7tFZxGh4E+nUJcL7DuMOIYa0?=
 =?us-ascii?Q?E4DGBHY+bcCxsYA+MmJDosh/FSOuUjQdN/Js8MAoIdbgmqS3/QQCyOfDjGsT?=
 =?us-ascii?Q?WVVk48vXAyffh2zbGO8UeGVLwVIqad2TLDStH8ThjmW0eWylMK7kVe7qCTwH?=
 =?us-ascii?Q?bduMj8D6J8hYOyUTquxfZ6BJlIW0HzIaBhLh5gekbMXcvHwTKoetZZv3PhPH?=
 =?us-ascii?Q?TplNObfl80Mg4zW94w7m9FX9/C/mOfDGP1JUwykbDb5akmLjOo1uwiRGt+rE?=
 =?us-ascii?Q?t/0Lf6jgHiCtG79hKNEqBLvQV6/X/HYurVEdCR7JKqXCmWGpMqW0Wo3qbH2z?=
 =?us-ascii?Q?J+o1Fr3ypaXf2gss+ZH6VwxZGHtE1vf17yW+SQwkFDUYNjQ29/qhoDhavXgO?=
 =?us-ascii?Q?UcH0bGixoAxllXDl4t2c4ZCyH9Fg+qeMGx+W9g3AASraYLosNlq0GRuoeZDj?=
 =?us-ascii?Q?xVwoTGm+FvgGuQkYrv2AK6R03lMh/yXvnbu84V1Q1tVxJuYLZ4V1sReRNFsx?=
 =?us-ascii?Q?7mAbzv5o5VhFyjyPVRudMYLOacLOQIjwbjMVWH11d6jDBApQr28ko/iV3ZMM?=
 =?us-ascii?Q?QMNdVmCTP5rLwQE5LXdc41S1qscvSsOdSXaT8H9lVftu/KrNC5nVBNcjA/VD?=
 =?us-ascii?Q?QDJedyLKnwu29ICT0o+5/ckFzEKAMiG8r2tlxBgFj6gxRHiM84U+oR8+woc1?=
 =?us-ascii?Q?Mbm7DAdkqVyArnZi+1G+5LcGlQpIUd8Qs50Z0Ov95wB1GZ50FyMoT/OSNZh+?=
 =?us-ascii?Q?2qdXv23o0AarTsmgzkB3vWKJDs6H6cBruJw6JHx4dGHZdz8VG/Bw+/6RwMnh?=
 =?us-ascii?Q?1tbYgn3NPnTPUvHVX0Qf5IuUTVBQnxCXZxrGjiAZXyrhZsWFuoqV5qzNIa4l?=
 =?us-ascii?Q?FXvF0oVqVJWw8KlekE+Zwy8yTBtTPLV84GrIfFn57BDP8Aii1ZHQnZq9PyBF?=
 =?us-ascii?Q?l7xUWnhvn+RMUeOqCXkOuOS4PdBHZLK8GuqgkX0Z4F8ob4Uk7xlh67AzOiTo?=
 =?us-ascii?Q?r51MVv/oe/CVnU2ADx1PU772E+aEr9tv0Q8/1DWpshrfZqm8FRCXhd8zbEEK?=
 =?us-ascii?Q?ZkAsgFTaSGA9Yd1J8g/MDuz9gaNRpE6ha2tMnySQeMeCbHnrsflYSh2lPj6q?=
 =?us-ascii?Q?tg04MthoE19laaqsESg7ga9dKXJprYQOpE1DDqBv+6lGz+qJod269ZWepstL?=
 =?us-ascii?Q?Ck9HiiZC3qD320Cht0rbT9hRxIddTodlDaocMumS9wBh4QDOZcyJYhrTy7HU?=
 =?us-ascii?Q?L+dhDfVz4OQjfXFiyipOPM4kWdnw3ic+MPdDi2jKlrgfLz3fzvG0BeLtmTdX?=
 =?us-ascii?Q?AYMv/74rGF/We4IrrXlbuor0KGHDuNZ4YPGW194jcwjs2AfhkzmYEFS7uufS?=
 =?us-ascii?Q?qAfa5IA4s+MzZnnjYdkDB2aFidlROyxcQNNckmevz8nvI2w2zcvoXmFxrFfa?=
 =?us-ascii?Q?BRphuhzDXe4VVZEngKGRfQCbM1+RcG3wz6CfFwDpQC4x6mWlACm803xuaDPR?=
 =?us-ascii?Q?SMwgzMDz0ktHH66ohsLhyvjuFl5VQRubDmvkO5xRzkG0kIfew+ARyeU5s75P?=
 =?us-ascii?Q?6o6orqmTgqvjY3AJVLoXd1mB62Ew2LCpfKtrMIvsTwsgqYycJoCANwIoQVVF?=
 =?us-ascii?Q?OGqRo+yhvj8kqRjlc9ay5qzQxMu9UOP0GecnI78qSalOMyYn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 517cc98f-e159-42e3-c3e1-08de669cbee4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2026 23:00:53.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OpD1Yl6k0bYbiHQ/ijx5y7LkUXr+YtQJYs8DNC2uHjrf+sguab47dNPWnuQfOwo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6043
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E8A2C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: 395ihyhmgrm1uy8hpxwgr5d767wc8rbg
X-HE-Tag: 1770505257-678416
X-HE-Meta: U2FsdGVkX1+faadEjpX4qQ1f/BekCj5gErkyxnKQ7p/z0sI8wIb25ClC8YQ8chZYLm0RVYTp5/DAJoOQ+dx9BOTzQa5ggir9hPcIRt2hZzdYjE1+OTK+sc1PllQFMie6aYagpzxaiDfBkz9yp2s1xLLxEsxkeaPhfsjzOYtvahjJYEZCnjwkjiEyk2cbMUJSVnI5cBN4vM+HCSMBclkiqyfa/dh1+WDRBfV/suCE7JWpZV4SpzYP2b1J22AHtreCoyp/89nAeLcWTrlbh19pZqL13Rv15nqSV9UUB6buCmOawf1W2iQ9pramCQiWd3GRmUS8k+Go+gwGwOGMgHW61mFtcKrFsppHhtYHY0pdwEk3kJPkUIGt9tMCWGLecnp+Q2ax4mvXL9IlkZ6AJYDfIasdmgw+XkmXATWk3DhIRoLpnT8NeBJNQFcyctlZKIJd0oFelBmyEkI6blggV6g+MCjevCGf0lV6o+dbz4KJ0bsVMxMQ90XOiEiRXRyMm6WKzDDCbljnEmUCzjcdSTfHzc3XlbK0Xu7QNmbaEfhogtZpUavs0HFot5Ns2/rbMIfDnu17mDk+7EkuF8EiTLRNI+lR5HIpFh0S42gmtXSUBuoU5k6ht92wuXKj5+VXySV8blFNlkGDeUEzrBU2JtIER3ND0WcKyplIW9gCIPScIM3QuXF2f0wdF2fmZaqCg/aQO90FI/gbn1uD/qjpQepo4Rps7eCeqxt0Ko/ecKN0fJOprrLykGJk3CLUY+Da/9IN13P3DhMl/qnlnUHN/qBkN7BK5LfnlbpzY1QTRHZY+4iqLBtHZnn5nKqP59KJ0FFnEK2PjJqsQXaN0nMtAJKbg2qJGZB36wuE93QNMZz343MYREE/aGgAmElai2lYLZv/ch2zz6lRH/UkYX7q4i8IoT0xwkow7jqH4KS5zWBVKtuUhtLKmeHMEYqalRjmhW+a984G+A+j3Zt2DZ6rVeb
 kJS422x8
 7iA4s4suHWPipcoYqYMR0FnNqbZPh6YadHJD5yjjKs0hd8gf1B3UnseGV1TwsJkRL6UBw3gxj74U3ypS5lO2jGg1StydlkKEKIQlJozOdOo+kiYHRkTk6zNQsV7lO2lbcYirMecB+RwAAuLt0sce1S5KRKsre/OSf0RWS+mH9LE3ambOmVz77ZDiWGiJ2u8ivRc+Y0S7Z3vSK6iB/Ic85/cyZFHS8hvHVGSXU68Hq9mLDcIa/NQwgq0kL7yudsAgjYIbIK8R+igh4Oy0nRHPNxs6IfrNBGzFSUTUkX/t8RFxPk74A2DgwxBQAsMoaxiCSg9dBNJfqf23bX2FXtbLbnuJ/tYQwUOALrKDn1XcTbl50LaPv0bjpXocil36L8nyglhWJLOXRYcmvG4WxkIleIaac3s7ISzvy14YGBFiOUE0TgGVJL7Cq6GuxNs6fHdkRGdNf4SeZBj0JZ8TrOzLykmR6iw+hPo4IdnXNMLj3YWpApAztTogxo05/pHWDt2DGtGm/LUZ9iOcsu2awT9aWKADtGmUL7BtWVHv8yPbr59N3EQJL4UzBr8JGzbIwPAI1FknE/9QVvvF3tmyT1qXUiyrKYHl4DS/aoFVsMcWyyHXHMc0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Feb 2026, at 17:02, David Hildenbrand (Arm) wrote:

> On 2/7/26 18:36, Mikhail Gavrilov wrote:
>
> Thanks!
>
>> Several subsystems (slub, shmem, ttm, etc.) use page->private but don'=
t
>> clear it before freeing pages. When these pages are later allocated as=

>> high-order pages and split via split_page(), tail pages retain stale
>> page->private values.
>>
>> This causes a use-after-free in the swap subsystem. The swap code uses=

>> page->private to track swap count continuations, assuming freshly
>> allocated pages have page->private =3D=3D 0. When stale values are pre=
sent,
>> swap_count_continued() incorrectly assumes the continuation list is va=
lid
>> and iterates over uninitialized page->lru containing LIST_POISON value=
s,
>> causing a crash:
>>
>>    KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead=
000000000107]
>>    RIP: 0010:__do_sys_swapoff+0x1151/0x1860
>>
>> Fix this by clearing page->private in free_pages_prepare(), ensuring a=
ll
>> freed pages have clean state regardless of previous use.
>
> I could have sworn we discussed something like that already in the past=
=2E

This[1] is my discussion on this topic and I managed to convince people w=
e should
keep ->private zero on any pages.

[1] https://lore.kernel.org/all/20250925085006.23684-1-zhongjinji@honor.c=
om/
>
> I recall that freeing pages with page->private set was allowed. Althoug=
h
> I once wondered whether we should actually change that.

But if that is allowed, we can end up with tail page's private non zero,
because that free page can merge with a lower PFN buddy and its ->private=

is not reset. See __free_one_page().

>
>>
>> Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be=
 split rather than compound")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>> ---
>
> Next time, please don't send patches as reply to another thread; that
> way it can easily get lost in a bigger thread.
>
> You want to get peoples attention :)
>
>>   mm/page_alloc.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index cbf758e27aa2..24ac34199f95 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1430,6 +1430,7 @@ __always_inline bool free_pages_prepare(struct p=
age *page,
>>    	page_cpupid_reset_last(page);
>>   	page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> +	page->private =3D 0;
>
> Should we be using set_page_private()? It's a bit inconsistent :)
>
> I wonder, if it's really just the split_page() problem, why not
> handle it there, where we already iterate over all ("tail") pages?
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cbf758e27aa2..cbbcfdf3ed26 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3122,8 +3122,10 @@ void split_page(struct page *page, unsigned int =
order)
>         VM_BUG_ON_PAGE(PageCompound(page), page);
>         VM_BUG_ON_PAGE(!page_count(page), page);
>  -       for (i =3D 1; i < (1 << order); i++)
> +       for (i =3D 1; i < (1 << order); i++) {
>                 set_page_refcounted(page + i);
> +               set_page_private(page, 0);
> +       }
>         split_page_owner(page, order, 0);
>         pgalloc_tag_split(page_folio(page), order, 0);
>         split_page_memcg(page, order);
>
>
> But then I thought about "what does actually happen during an folio spl=
it".
>
> We had a check in __split_folio_to_order() that got removed in 4265d67e=
405a, for some
> undocumented reason (and the patch got merged with 0 tags :( ). I assum=
e because with zone-device
> there was a way to now got ->private properly set. But we removed the s=
afety check for

It was the end of last year and the review traffic was a lot. No one had =
time to look at
it.

> all other folios.
>
> -               /*
> -                * page->private should not be set in tail pages. Fix u=
p and warn once
> -                * if private is unexpectedly set.
> -                */
> -               if (unlikely(new_folio->private)) {
> -                       VM_WARN_ON_ONCE_PAGE(true, new_head);
> -                       new_folio->private =3D NULL;
> -               }
>
>
> I would have thought that we could have triggered that check easily bef=
ore. Why didn't we?
>
> Who would have cleared the private field of tail pages?
>
> @Zi Yan, any idea why the folio splitting code wouldn't have revealed a=
 similar problem?
>

For the issue reported by Mikhail[2], the page comes from vmalloc(), so i=
t will not be split.
For other cases, a page/folio needs to be compound to be splittable and p=
rep_compound_tail()
sets all tail page's private to 0. So that check is not that useful.

And the issue we are handling here is non compound high order page alloca=
tion. No one is
clearing ->private for all pages right now.

OK, I think we want to decide whether it is OK to have a page with set ->=
private at
page free time. If no, we can get this patch in and add a VM_WARN_ON_ONCE=
(page->private)
to catch all violators. If yes, we can use Mikhail's original patch, zero=
ing ->private
in split_page() and add a comment on ->private:

1. for compound page allocation, prep_compound_tail() is responsible for =
resetting ->private;
2. for non compound high order page allocation, split_page() is responsib=
le for resetting ->private.


[2] https://lore.kernel.org/linux-mm/CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2=
BGf_Hh1hWPZATuA@mail.gmail.com/



--
Best Regards,
Yan, Zi


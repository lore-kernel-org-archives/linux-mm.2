Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AF4CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62146B0101; Mon, 18 Aug 2025 09:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E127E6B0102; Mon, 18 Aug 2025 09:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA526B0104; Mon, 18 Aug 2025 09:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B80DF6B0101
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:55:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41A7C1187DF
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:55:18 +0000 (UTC)
X-FDA: 83790025116.28.4D9C612
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7ABF41C000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:55:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J42GqNK4;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.96.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755525315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXuwZHaPD8ErL4USrctAkqmnoAkbrX6RxrXIriX4VqM=;
	b=C6UizcSmp0j/MqnNWapkewF9sr+hbVJfTfrs/Z/mb/GK4CsL8r/ZedEgu/uY8OfMuprlmL
	vJkciefUKtYOUrekbVh0VLWVr7X9WJRVcuYo5g1KtEj9CGF4wjbO55BrdikkomElSKNWnO
	7iEnlScacLUP5ku3ET3URSzY0GB4I0E=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J42GqNK4;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.96.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755525315; a=rsa-sha256;
	cv=pass;
	b=MvOzP9VCPCa9ATPDN4M9o+6qLZ+2KO+JW5QJq8Tbn/V5J/bySgowQffhpBI4augIar3Nn1
	0qlABqCfIjefua7cLNzD4h/uVIwZtLZUgm0WsheRnSl/WaO4B/GWqW02heZjaxGRi7naVn
	6uglE4I6FtVFP4CBbvWqruN/VN4ilFE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqiVcUIiWULDdDdwToFG5TePDjdMhlvu7F+2INyQnmSxpUN/pcZiSAQZTcHopMswq/G2gAx6hoQ/nDRLIvplrQAHeKrTKX0zPxsFPbJqBMhl55EOgag1Xcl5PyNHMFqDy6Zokf74ec9DK6GQ4ox2xnQbegiyLsDOjYIRgzXr2nOkE/DIc6VqdE4k4MnbiCIaYLKcZ8D9wYriubyjHWfygdhKbirnfunpWnmouqs392lnsQhXjoH0Sc0qZ74zcWqYFl4Cd9/2JS6ZIncoZaLZGrH/+LrsPY1M0exBmTZgS4LRXWcvXdiZlCpNqtUXJL4SbcLjUa/cfTlFfpLp2a4+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXuwZHaPD8ErL4USrctAkqmnoAkbrX6RxrXIriX4VqM=;
 b=wwOKWBEaebcrGdj9MohwcjRwK4Ib/J2okPbZB6YX9ef21DS6XwDaWvjXOs1zHcVlNzjHWfxJ0+MN6Fn7xbsUjJH3ZwlUVyz1a4KsIwoyMQt7KfI2NLX8Z+3Pa9AeTgQ3sNyaR7p14Fl3/L5aUESI+4IcojXiK/0s8LEEy48nCpNdojHo49sS7Aqu94cCbcyRUlfpcbJjGvsF70Ie9Yc8Ue+hPjl8MB/cVm3jOa6KgEexJp4rruHncr7RZ7OtfJsQuVJs4qb9zorMGJHcRo4VeJAz0xDEA6wJbZZ/mrb3hkdgZw4IYxyvWeTs1PXZWsF/UCScman4Pm0dnBFNWe2U3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXuwZHaPD8ErL4USrctAkqmnoAkbrX6RxrXIriX4VqM=;
 b=J42GqNK43D6BEQwOzRb7ZDSbKzYdh4U6Fgec5aEIQnFl0L/h5pgassu/joYbB6eDT/Q7fMFCk9Bbl8t7/KpglzYXmjoGY+sBIziCPe/4yZK2xZnKXrZcjzmKd+nQWX1/SWr/aXhBRzqdZrah3YceL0hHSF1GFfjX9fxiNbDrhmgq2krZKJVqmajPtmY9sZAC3EuLq2ZW3YNz3MI8Xez9jSTruofAKrOD5Nuolh+fFJ8F9OgTuR61qY/totSdpERnGyEDt6bUy8iKxXCfIke2xpkuizk0YYZk+TR2B8ME8IGsB1HuefshSbgXK9qkjzN6b1kiC1bhDvef6I2rSd9lmQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB7764.namprd12.prod.outlook.com (2603:10b6:610:14e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 13:55:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 13:55:11 +0000
Date: Mon, 18 Aug 2025 10:55:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and
 physical memory ranges
Message-ID: <20250818135509.GK802098@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-8-pasha.tatashin@soleen.com>
 <20250814132233.GB802098@nvidia.com>
 <aJ756q-wWJV37fMm@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ756q-wWJV37fMm@kernel.org>
X-ClientProxiedBy: BL0PR02CA0131.namprd02.prod.outlook.com
 (2603:10b6:208:35::36) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB7764:EE_
X-MS-Office365-Filtering-Correlation-Id: e2263c24-9d73-48a1-d365-08ddde5ed93c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qqlsPz2ATyqjSe2h2YUoZTApYq/48IHKPxijtHQSg9cS1vrlMiTelhuYG5m3?=
 =?us-ascii?Q?S1PCEMoEjO0D/ZVS2TrWeriuyodAIGmDEnuAFlLAFIDgoivd9yRSw6G4IDnJ?=
 =?us-ascii?Q?JjJ84/ZtUmx0sjP9NAJOmxuaeIM1ayuujh0hfRhtaIqjqZr/UTGW8x9wST6B?=
 =?us-ascii?Q?xkDjIREBiaA9W/4Wk/kctAOZZ1pRfogbk0ggWL4DMd1TZw3ncuss4HI0l/Bx?=
 =?us-ascii?Q?9jRF5MhEq4XxI+Z7HItOGGk9J0voJY2Ysw4euTaxMHaQKDAs6lo+8muU/Am6?=
 =?us-ascii?Q?/hZBN7n+ipihCj0J0M+GOUorTvp2QjF+GNIL+JoI0eyIQsEEYymCCkNskGvN?=
 =?us-ascii?Q?JO38L48s5qI6seBxuvlJ+Qp3bXtK3ZP0lU+tlW/RUvl1iJh1MQjlBDhFdXHJ?=
 =?us-ascii?Q?3pNvzbVfRghHnWY/87s3B6MpppE4rxurogdx7EK6FSl12vTZXWdoZ14JdzPI?=
 =?us-ascii?Q?5B88Hl0HqdIBRfiemtRvaSLBIJ7eHWTnHtciwDXCzmY9CNWDiamm+q/5LTSX?=
 =?us-ascii?Q?rAuQtUG3qGPHOgLDCGfguc3tmhVEP0JQG9helWYwJre9wpa3jIC/JYOOgIUL?=
 =?us-ascii?Q?vnxva49woPB+XN/Q4+oiR8kE0elOWzMHvK3WGGD5uuAMsxRxrq3zvc3bTxAw?=
 =?us-ascii?Q?ppGny56raPEDM+xXTyriqmm76k0ACXij4P/4KmKVMfDZ183sBuHktgLZNQAP?=
 =?us-ascii?Q?0fctWw1mxVB2JbwgvpTH+EKvpHR2aa0mC84yxg2iPxP4qNnznI0tQ0n/X8mY?=
 =?us-ascii?Q?qaOTHa9jldAjwQQwE9r3qL5IsmwOgLLNVhphtYbeXPurccx9lJZrO5YlJNKq?=
 =?us-ascii?Q?ITZ0EEP054pHopbQcISsAFhoxzoHDK9aki+u3IJh+ll1WeiOwhDXR3wW0Sgi?=
 =?us-ascii?Q?bkZ4k1MMThellUZGKubj5NiXK2UEY/hhm4gg6prBWm2DL2GtsiykdzHBL3x4?=
 =?us-ascii?Q?s/ZdcaEEBrCIYVg/BY7qvlE1wIqIEQ1oLJPjxPUq3rF5/h8fdCWty1FJY/7s?=
 =?us-ascii?Q?0ig5xBTgN7sb27pkRVWaUgmQPaKoEBLAJD5IQ3bT7T+O+RE18Xw47olSyVej?=
 =?us-ascii?Q?BSlVhXLgPRy01miyOrQiEhlmrN5YW5jftLJJTQFA48N4FA3fzFLtB+D+N63H?=
 =?us-ascii?Q?IVuiTsx0/gp5CpL7f8KucZqzT7BEMfwFg1TT0+hpfWGJ0fCSxqKwBkdhW0mF?=
 =?us-ascii?Q?oJjeiNjoIKTF5xd+08GPmahiqYwWKI+MnRF+eCa/+woFe+qwEuAIAT8m1J4a?=
 =?us-ascii?Q?y/Fdmf7f37lp2s9Egkyeeect0tvjfC6qrLdqdkfMYn8mnVMB9NRmCfcdPvCa?=
 =?us-ascii?Q?gYDBm9LWFx7Y+VMLIesZCSvnDhqS3YbigjLYWiJrB8rMVRiQo71NLs2zqIXO?=
 =?us-ascii?Q?9Zv1KKCUBjqAJ5jrXE+fzzj0l49NnwtAKiCgPbcxXB+vlliyKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kedtl8OYLGvsO1a5sVU03d0dlY/Fuchm8GXDD9uS6qsiMX5aSCyaaLIq4Pbh?=
 =?us-ascii?Q?pNS+PMlrYi8toda1MQgrhJXavoauGw1ZzSiyzwOxRlYQ3I/8m+VT+jgYQbwZ?=
 =?us-ascii?Q?y7CJAJXpaoCtcomG0Q8U/pmT+3e3AM1Q+0pUUOI+uGo3eHABhcMvpi4R1lln?=
 =?us-ascii?Q?oLAm7lVH5ZDfCTN7vKn/NxKWjcnT5BsrAvkgEefuJEwa4AqM4jW96TfwiCrM?=
 =?us-ascii?Q?OH/yW0CTWpwpo0DbyW8rAMRgct1vgBJNVymX30eofDsHn9HDcK0yHMYqRQnp?=
 =?us-ascii?Q?U8/Evug+4xJzC33nFFSWocmcHb147Sux1JbMD2pUb+fJ+F48+J1VKlB+/RQz?=
 =?us-ascii?Q?pG2jcpcIp/bL52LAte6XTIoxbNoMD8CNCkdV5uSoo3yyqPvBcHoxJCKd/8T/?=
 =?us-ascii?Q?QIO1Trk/aSlXECLrVHx3wC19Ye36ISS9/OV0xUXbFgVzTyP7vNHsO+LF4Co2?=
 =?us-ascii?Q?bkg4hUvWrOGciMZC3ETerfh5uhWNQVQnwaY9EZ3dnbT8GCwMEVmeZ88MJ/6i?=
 =?us-ascii?Q?B+h1faVRq7/J6/YGwuCsIjD+8M7V/D36VDSszyAKfn1n+b3YdSEZyqwyqNac?=
 =?us-ascii?Q?ftMsiLZkIuCvUrguHMnWA+guxG348xdJdtabAO7lFGLLMC+37V5B1+gljyK7?=
 =?us-ascii?Q?JvPq4E560NIekXUQ14X67wDa3yTeN9GuGA2fCDhBGVu0St/8pmQzibYIfTiB?=
 =?us-ascii?Q?hplmtXxaJ6MTyoJh8UAGI+k2267vXWk+KaxCvg5ucxuV/NA937pmPmSGpkNH?=
 =?us-ascii?Q?WzNrgEmBP4UslTtQgZUGhRdFG6ZATQhK3LGJ6c/YfiFor7E7alMbV3CggOYS?=
 =?us-ascii?Q?iGd11MJcpaWEBMnjzeuS7WCqLIxKkkUGGQ6sTQvcx5WrmiOtwHwRhohJsQEx?=
 =?us-ascii?Q?TY6wuvCvERWfCLxRyrqfHXm4ejyv2g4f6Sk6goVR0Jy1Kha1yT+puatULlwQ?=
 =?us-ascii?Q?T2ezVUazx9wu9NkdRfcrWWrwPEYYEKTbnQJseY2w7en7rXPLXan+PaLTzGRY?=
 =?us-ascii?Q?7b3re7odAhReI28Frs6GV1MrDq6AU1WeCu2TGLVNxOlhZZ6js6jdAtRrwXJX?=
 =?us-ascii?Q?TWfi9yZwfWOlizeITIhkdGLzLx7cS5Z7f+t/JeYWYrIHbfJBuvi6va1MiIZp?=
 =?us-ascii?Q?xwvemJkhEL+eyLUe/L099dtKkfDX7LnPdBHXihb2HgHP7VBTifTbyuduPsPo?=
 =?us-ascii?Q?aRoYdXHdRenrf6PLixlc9YLrulGgHJnX7Y5Hy84K1ohfR9Z8ao5abBCu6hLa?=
 =?us-ascii?Q?LH4yaq4++C6jrRxdKnzVWZsfP8pMbKfqt7e1LGucJJVVWRi8mp6y+vD4ojqM?=
 =?us-ascii?Q?Oh3tmjgjdAiTgzRiNC99Dxl4TfaM81jDXmDMc1ffhSUnLBPRwVeM9Gtni5H7?=
 =?us-ascii?Q?d8mYtWP0deC/ix1Fy14EgRwHzxZcarA8NYCwe2xH6w6UdB7LzcafetQr8QsW?=
 =?us-ascii?Q?Z/QoiyAZBmXO+lRg1KAMhwLqx8C0iFz5X9rLSvH0i2MB93aWznjpd2EdhweE?=
 =?us-ascii?Q?ekxUcigng94UThJePzGui+M24nkJ5O2/TuPkYRRjqrLi8XDlasWgNf9+A0Qy?=
 =?us-ascii?Q?N2tGMlIC0QeieWYZ6H9041TW9bjj+LwHKtSwvwoU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2263c24-9d73-48a1-d365-08ddde5ed93c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 13:55:11.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMoqcknRCrBdw3BXglkeAsBzzIM5xiHnuc2NMOewKC+V6bpq4JBaHcyJljexVZ46
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7764
X-Stat-Signature: 1ree7mg794fbgsgwhyxmf7xmehamubq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7ABF41C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755525315-172176
X-HE-Meta: U2FsdGVkX182NjxcpRl0iVz8gMWkKK5so6PybKiBXQwqL97eQueiMkyMq9KJ2tfylutEthZp+L7VcSPe+XmF1zpxohWP2xzT7ON1Px8pVpDRxlEAHWhwz6YGzUG4fjc79gqZu1O5Lpu4IilG+fZF+hk6Swokv+w39mpDwyK9Gf0GRj3wK3MjG/iQ/xY3t7lYs4L0WtVo3mj26Xba7sebH1/iD05MBbiqhZJnISaftGCWCwd2maI+yRyWeyDyAAKJNkXySPifXibp4Su78pbsdErJCNGTohv4r1AXdRkckXgGE+DdKAqZU+MjZvOHkATPHS6UnTEQXyW+CeBcL/ehkG44vmjvHN8oExVPh1iOjLMji7nNJLokwJOWcsNrqWLxTY13wyfBGvqDWHy4NqHmFCSs3YdHbyyW6v5wTMk+EinnjslDpSwQoPYYtoYgvOt4c/6PodCE/32a+sKruSTwwEHSbeu51MOlffnSL1vVw0MGylx3ycIv1bBnr9Z3kgKcHsZxqGHgmiYxmEg4XnYkKIgPNKKqqSJ6EOGo1Fi+LnUxK7SuI/Iw1Tv6gnk5WD9B7GAhY6UNkdt43dPO7aHmxETIhhvH3LhQHyS4RnShscMqZGQyHgRVlqLqkQzD2rYQIERex84SVqa+GkIVWgQiiCGFluOXFmqxmEgOqFRFFYmim6/kCx10tr84J/bNbzHP3uUs//yAmWlinlcM49VclXG4cFXBWienpkeZnvPBY+5C0UM+sqNVPLTbAtbCrJsZvLoPA0a/Y/2jxxiDQ4gazZbH5HTvpkvi1k8g3ne0EXq7L9jzmC4Xc4ZiC46H0rp3Ls7uh6OFFEiMKh3yS6x8xrSH9z1OhHAh/AOcrnOo24WcD1BO93FGUUtUcMLfv0rUItkHUSLsJ2/zCLriDswD9gk69oQgBEFD8OGtfp0KcjKS/li7ocx/fyMMJ2YeP+ZasC7x5ZoA5a+WIRqMmJy
 kZ0k8/Av
 29zAm8siQTKa6WBLOuK7polZ6wBCTpTy8CYJ/3wgrM4AhAejAKt9uohmreBuG3DqtOK1IyWCcfcms3rN4FhJK34D/eloR9AoiQL+9Ud7lqy4YluGjVaCebbRwT7gsKm22jwaHwvjwu+1cwpyVD6fVI8X8YjJPIjHP6LgyrLgDXlbYo/qT5EujEUQtaxexUw5sKRiwBq3NXMhH/PiJNVJrXtLwdSuQa6xHOpAOrgW8ZcXw+hYVo+uHKKRdnK5Pw8bcug3AtyxR+fXihMOpqP5rQGNnWeVmf36NJ35B6Tt+VsK0wv5CqqezCAMO6KGkon0FflVRPc/AW3DyJ0UAF21nx4XffMnebfQiEDSx3GnJZTPfVWHWSlcM5W7OaUfZsPSVI/h08jyuhQgcA1wsPdVeKY2o8W/xObtv5aZzkQaWH8xhm00EeS9jaroC3qDRKvWj0LlURQ0tYh0uyAI30SOZmzJKESZUl+CsVpDWQsErRwyCeUuIEr+VdshByEreW+KXYvHs0FqhjbcOQKfriZunMH2qeXC1RMdx7n9sAaFs8ScNTroz510f5fqEbUmg8m4mEZJc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 12:12:10PM +0300, Mike Rapoport wrote:
> > Which is perhaps another comment, if this __get_free_pages() is going
> > to be a common pattern (and I guess it will be) then the API should be
> > streamlined alot more:
> > 
> >  void *kho_alloc_preserved_memory(gfp, size);
> >  void kho_free_preserved_memory(void *);
> 
> This looks backwards to me. KHO should not deal with memory allocation,
> it's responsibility to preserve/restore memory objects it supports.

Then maybe those are luo_ helpers

But having users open code __get_free_pages() and convert to/from
struct page, phys, etc is not a great idea.

The use case is simply to get some memory to preserve, it should work
in terms of void *. We don't support slab today so this has to be
emulated with full pages, but this detail should not leak out of the
API.

Jason


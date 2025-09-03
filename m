Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C089CA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372658E0003; Wed,  3 Sep 2025 18:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AC58E0001; Wed,  3 Sep 2025 18:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239498E0003; Wed,  3 Sep 2025 18:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F84A8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8C451A08EA
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:59:58 +0000 (UTC)
X-FDA: 83849458476.04.AEAF2B3
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0E5204000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:59:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=baoUVVz8;
	spf=pass (imf27.hostedemail.com: domain of apopple@nvidia.com designates 40.107.102.87 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756940396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hCA/EJIocpEyFXW2bUx3Bp/QPPSjxr1GRDvimIZOh6o=;
	b=eb4lJ1jBZY7Ps3ul29IGb5gNHSaOcHaNYNOmOyITd8636bfFSQwNjJxA71r5rB+1+8vE7U
	qfNv/IBtzEH7uK43k5MAhNdpgJru3Txu9ibtNclMVHJpz65sGUtXF0e25ncxKGwfFgUwix
	wxVcCUgznInx9D/zYRsRaab3afAZRzA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=baoUVVz8;
	spf=pass (imf27.hostedemail.com: domain of apopple@nvidia.com designates 40.107.102.87 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756940396; a=rsa-sha256;
	cv=pass;
	b=QDh09+puOFB62mfoYhgHYYX7iwpWzYOfc0Fc0VP0SYq3Qg7UfIAa5p2KM2I+7QAbQdicdv
	i5bZx3BXc1MyFVeIl8WEwLdruv0pIN9T38JE+fb99wtcI6T8+GdIzYLMA/Ek3mDVKY46Oh
	eVZDTYQLKgER21BY39z/4XkVjpXXhvw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQzKlIqLM4tTm31lJqQz0K9wVCfjU/XNLdX20i/xz1BljxuK2WUaP+M7WQCL1LlkpVvDg4//NCU26l0g9Qu68sgXMtuOeOH0+k1dMZPmo4WAHc1XISEVb8jojkHjN5D4a6hpgeBBGOSd9S/s+OCm2/ntJFNgJ6doL705KLou/Z9DijN4rw2xJOCGUb5KvaNieFUZahF5S/wGh0adJXLV1mPDBmfpIceR5HmNGBlvU0G4sNUvGnd7La5I3/GB3kWtwxyfFA2VsUwQHyln/wMhPlbfMszylFHqJy+LRhgh6oVblRRQtNXqUXncQd/3bgwwMHWeBhhYJcX0wQHJsVhH3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCA/EJIocpEyFXW2bUx3Bp/QPPSjxr1GRDvimIZOh6o=;
 b=hiJMifnw6faLxvBtUFrPPAO2uNyq16ZY/98rTAwmdmv5b2DP1CLpuKfvZlt+FVqEVSsbBIKafLneN7vhEHDCs1TUfGAuFbpfBP+e911q9K/qd0xmDkmIRzgWmv4GJ+mvpux9t9Lm+H84HzAFyrDBjrdGzFpJixJNAOmUzz431wtT9in5MTgPNlbHJceIf30hdk6v90SajDPMLP4FAxmr8xsjAV9DSUUv/JLVTQv6h8PizSnH2/EuAOjhxtwMfTvGov3/xxcPzfy5/ME3SWIs5bKnXCYetph6esQK2GH1AtNkiNZWeFCXEX85bU2NaFVrmgTk9r+pP8lT7d3RrxEz4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCA/EJIocpEyFXW2bUx3Bp/QPPSjxr1GRDvimIZOh6o=;
 b=baoUVVz8qJbuBSDGv3wclXpb9nFxfJktgvXAT+pyR756GdFtpgpEUbQ3eaiAm3OEV5Fx3k0mEGtXU3OqXt/7cDmn5D4e1r2QtvJkDECPiFrd/o0T0DCZvqBWn/jRLuzHamoTOqA90lJe2V61ZHG8vswtKq/FDtDRe7XdEXCEnDfcBiEPanFECjztG6d59+1MVyQmmyeq0+rAe2G6nZNGpepxEJitOhHS994RWS9feINCwhbOg9DreK4bVrY6bam93TdP2T+5w99rcgYBSIJJCWHLmIa4D0Wu/Ed/3H2WErqOdB/4Ri76Zg0osRmzvmWDpq2trRXemOO9HcuAtTZg/g==
Received: from DS1SPRMB0005.namprd12.prod.outlook.com (2603:10b6:8:1e3::12) by
 CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.17; Wed, 3 Sep 2025 22:59:49 +0000
Received: from DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f]) by DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 22:59:49 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 1/2] mm/gup: Remove dead pgmap refcounting code
Date: Thu,  4 Sep 2025 08:59:25 +1000
Message-ID: <20250903225926.34702-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P300CA0004.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fb::20) To DS1SPRMB0005.namprd12.prod.outlook.com
 (2603:10b6:8:1e3::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1SPRMB0005:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 03530cba-7a04-4e5d-f171-08ddeb3d95a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zT8xKlu1+zhRaSxDZqT3V5Fn6G8gXZwq+iay4UhMkYehwr+SbZIvjerc6E0Q?=
 =?us-ascii?Q?MPsCVOd7fD4QGtx0WmkeBlkKylOF39s79l+ui3n0O21rd70vKaTrEXD125HJ?=
 =?us-ascii?Q?ioYsLjCtb+YLlSoAyGa2d1wPt2qc/Mf4WunilWhFruq2/shF6QZiP26uw/pn?=
 =?us-ascii?Q?a2/2QMcnIi4ztou5LsJy0o2XAFg3t+OxAcI9ipZ/gfGw4IN1QkKyZ2f0GFG9?=
 =?us-ascii?Q?28d47s70D0bRX3kuepG6CaHaiZztrqBZ2ChHColvmvXAaDSYqAKgIEtwWTls?=
 =?us-ascii?Q?ELfnjiRhVy1PPJvWSbmD/g17jpoiwJRWSDf9/xH7oYLJLiIVcZMjUQrxVr5m?=
 =?us-ascii?Q?kyLq0eLSzAfhK/T96oyQfd1lpIBmAtWe0KfjKK1/3bECR6hO/4GAZJCSzwZQ?=
 =?us-ascii?Q?1jfcaErng/uYPidAtOp2DAHhait/ggTMBcuIe9+96iFoMK6bi+HYdDwGGfKR?=
 =?us-ascii?Q?2NECeFUlTsEwtDmIfhIUxjMoCLAijWQJzk6Ixq2mn1YijeWhe/qDvHuopEgM?=
 =?us-ascii?Q?4xuDTFQZ++bGJHWSDL43VeEkkOqlsS2h7PVgIoSKUeemq3fElWJCEzzlCCC2?=
 =?us-ascii?Q?Co7VArBQBSu9xemJkme6q1uFcwozrduwMrpog4Yes/fLpg2RfHXlIoz1VV5M?=
 =?us-ascii?Q?kuYHAkfLHHY1C0Sstuvr0wXqLssgJAySHHDxu/ByIABG0tDNtuED0eab2syc?=
 =?us-ascii?Q?xppBUi3cTXIGqVETjb4A32paYba0jyBkBoM1dc/cVivGLHj/5W8GoCcwc47X?=
 =?us-ascii?Q?GDyc4u4TO+YXLpqqpnmbNASanxvmPz+jrZfNC6FakOdt5VE3w95isU3i6NbN?=
 =?us-ascii?Q?5XfrTKlDqfzJRGaiKfJ4MvqJRDbc/874W3vQbvkpvzR1xtQkXyNX0wn36I7e?=
 =?us-ascii?Q?48Zd2BpFj13hJ8TuQ7xkkPojXVSGz9qLQyB9OQF8Dhier1E43g91BLgDbJUK?=
 =?us-ascii?Q?7J3FkoZzbCwklFHPnRS7BBQN2eDmaQ2blFUjVZZoVzS4wrayvcdh0o1nqOQS?=
 =?us-ascii?Q?U953FEvmSoJ8R5UMNZ8zD28x/U4M9+0RqzgQBUQwo0ndnLvgEpwowV7Q6B23?=
 =?us-ascii?Q?xVE7b/SdlsXp3GXbzIrzEd7GiEEqoqoJRowj2o6T1hEAjzGmp+H3qcX9qy9J?=
 =?us-ascii?Q?YM/bp6jGZovk0W6DJYHRIvWPs18eMeYCeD0yEKRFloSBjptXoGrOCcVmHc5F?=
 =?us-ascii?Q?4zuYR27PXaGl+wFMIf6H78nIlhcVG0YZVfwEZXYHYjNTvejTwexMx1XuOoiF?=
 =?us-ascii?Q?280F23CCPVPuUW/sPWwfjhAqpxQRD5ROTArPFUhX4X/7cdZzV01m9KZHIYvg?=
 =?us-ascii?Q?JDRlOC8SPALd7ewquY2m93ToqkvjnChhrXCZBr+79tiVKVNKwbzhIOo54ZEC?=
 =?us-ascii?Q?u6z7ShovIKQLrm0kspp4T0vSoKuODyJofzSW4CaUgTxDlFZ+Krlwh1yrFLZp?=
 =?us-ascii?Q?dTPbC6nip6k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1SPRMB0005.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LyRU2ZnMePASH/6PZROAej9c1vgs4cIqn/BYaIJjbS/sqDEzr1MTlFoI6U9T?=
 =?us-ascii?Q?iL4DZNX/mzqwAaacKTluU0s/CxnstVgrs2oRePgrrycp8MnaxvfURDEf4Me+?=
 =?us-ascii?Q?QxQfeUMz9ICvLLyOViQrtdIbzVDchIP2ggl6U1OZojyHAcGpUPT+Kwy79BTx?=
 =?us-ascii?Q?LV0UcZDM/P/u9NxrToPX/U5w1TximBN3LKaPj2JGgtHXHdcEwpjKulwgmvKN?=
 =?us-ascii?Q?cvsuK95gEagOMt4IsVM4Nn+0zjWzEnO86O+tVX2QUl/IIKEAHTp27Cq+20eN?=
 =?us-ascii?Q?PYnd1qDRy4pZEmCuyY4OTfSxR2t5TMEobA0TtZ8ca6mKJGoGW8bgN1N6YuwD?=
 =?us-ascii?Q?B42mBpgG/XRwp4ygjETDi8eDpM6B5pTC129MA1thJGksckBnlo2MDt+IkuQF?=
 =?us-ascii?Q?dPKGKuH7/PWEkBISbr34irIlRUhRY4EW6xpAcrbACPWVY1UsGsZz0CYRPUYj?=
 =?us-ascii?Q?REj4iCqcTtn2ecggRE63tUxbf81B6bFAmzmCsDHFohlIF0cFUoiuTl2H6ZIn?=
 =?us-ascii?Q?/rl1LWzD3H+lUXnV7ihXyhrQgH3te5fsW+XBeoIqFOFP3+l21Q9A5zRaTKHg?=
 =?us-ascii?Q?PngJgExvSYB4uJyuBVM1cYaXrPWs+KAf2zViv2fmw8qvmyhKLRkagAeN6mhV?=
 =?us-ascii?Q?N9DvGN5TihDIv/w05zIwsSC3+WnUbY9ONaXNrNTaaPWnX8yeKx6kRixZd/8x?=
 =?us-ascii?Q?r/re9DqwIWdbtK3VIJXXZgg4gY0juT7M2QmawLpX+E9i5lonpoBN6F5Ffsvy?=
 =?us-ascii?Q?cvHh5BA/dsRBiHQD0my7467sf9m6e3iPq2zK3sHpuITEE5KZCicisIom2yvk?=
 =?us-ascii?Q?6++yyThrdP5CrI3IzUztSUHiZnECaV5EoWoXvPYgVcm7mK5Vvs0NjACKcfw3?=
 =?us-ascii?Q?NhUyuc6aat1t/OxYqvgkG2MI0+HepL6qMXWyE+kLi4rBpRjOPMAaGZsJIkht?=
 =?us-ascii?Q?VmB4xT9IrE2wdda0gBLXdvGDSc1jFF/SSfkjsvAfFvUzZDpvZb6YOC9ZBx88?=
 =?us-ascii?Q?iJzs+bOkfHnJXkh5Am4Kh+hfayl7Q3SwMwHlIolYY01pE2Vxish1e92s1bkF?=
 =?us-ascii?Q?06vX1cZg4Il7hCifot8DB4Jdocy6Y45mds+8godjJbIdsNfpTwzfnLfbbUSl?=
 =?us-ascii?Q?jL8/Q3hAVX6tiBQUnmWMmj/eZzongJL5T8WD55QkXsWwN1y3LN/XSQx7bZpz?=
 =?us-ascii?Q?1am+WTls6olc52vyWfG5R9n5e5GgHvjfOF1az1LoIoWasxtnhKGpCGXkiSIA?=
 =?us-ascii?Q?am7XMl6I+PaajpOMlKRyQ/JWezE6OHNpMysCnzRjt87NwsOr1uycKuZwEsC/?=
 =?us-ascii?Q?TVgd34gEtAjWrL7h6gT9eLWramah1oWvzU+7ZxfdonOEIuNAHAHuQvxG6LhP?=
 =?us-ascii?Q?skEM0jCZRU3pzNTFM0wxSxeLEvS+hRffwPNg1y52qOIXgxWLBCfhxN540liI?=
 =?us-ascii?Q?kOnBffb0nt0/+qMQ1g/BF/qQ53MV5HNPBJ+ahQYpbHiC7SwqZjbjZbFqnLUF?=
 =?us-ascii?Q?YvgXOesofBvzEbJAl/ZvEv+Mk/BEtVl+Ls/7WjGvTKYFt6jS6ubcWFrItkdD?=
 =?us-ascii?Q?FB6yRuF0/m+7xSey4ohMDaFySJMCajl4wVsLuh1q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03530cba-7a04-4e5d-f171-08ddeb3d95a5
X-MS-Exchange-CrossTenant-AuthSource: DS1SPRMB0005.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:59:49.4766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMO2QRl5ZNkbuXPhZ0KFTgsIwO7b8mLbB65ZryJeZV1Z/7zQYP10ECmYPjBHJ9zn0o1RDscoYm9tZEE3eQYtKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345
X-Stat-Signature: i1xggp47qosgome6fe5bext5p334qcpz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E5204000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756940395-759174
X-HE-Meta: U2FsdGVkX18cVh3+U7ojAAOegLHAza1czr4ub2CMfPF4DHcUG8MYR19BnOA4omPbCSlzKoBybfkuuZt1g6kMq4/2MBVILgZaqQmTAZ4PwdwR/Jdz5SyrrxePyk4V0Qb3sWtg8K/irHf8qmtxspMjqrO7qfkFlLOl/gkAV78RhFJ6S0EKtt8XorDkf5atcd3CjFz7IvRC36zwuJfHzSGp54Fjp007u1TWZJt2eiieHpW14FaHChqJ4phb3mHbsH++ZqdPrYh23hAqlWvQ1STIk+jpQWk7La3E8H9SEPwzy5qMvOWZtxFpncUauJE6asHRtTO4c+ZRHLT32Zfj5qknlh3pAZabmniukXxzREPwoE5qyy4GKBTIFk1cToiIWO+YBL9HjzbdEVeJ5TneY7DE42WZaGqJSB7w38HBtXOdoN4hKsU2t3+Li643QeUBr7DGbZBXfrNs19g+pGj3aGoj+pdhawdusxQBIi6XUrOBFvBiJlPBEJojf0kIpnbAZQ8uPgXnETMI7ti87Ak7FJJxDqNyevEs1PL9m01yoFnz0rbUiYMWVrBUxmiIL6sT8O3KKQtWZh1ibnVlAcVXwpDXgQKiCXHtKEVOMlq3HP1i+SdZFvVHZvk2Bc2QIGfLa9IcYLredfOgExXFc9iIaVBlK9wliW8TqSd6bXYJt7dNictRkD1gqXg7cYQN/tVS2DPpv1bQtmEbnB86OojoFet0zImoHxtjaF+4x/VepSjIExnPEJvUzFqJDT/DfcJWHMPN3z2+Dz6ZO6ZA/Vv+GZ6hSlzmq/IGzoD7SSJabSfTMoAOKVwZrC4uTt5WZZtYHWtAoN8Jdypzl5zUXHPWDClA7CQg1v7V2Q+fGVEHOaMfjvR51Qama0a8ScUjYa2pmhZ4q9WwKiTuMrSsJydw7CzAXQFp7P70BadEhRSI7eVh7G4CisPJEw+iSagp4ydItaYe8MWk/d6ujEkIpfSmjjt
 7FDhbXef
 mG7cA1RX3hGMXYsZbX97vprF9NveuAgenyQqQaHjRD95TDWZZ/TYblduerR6q7o90JzGArV5YY6u/zKvJ4t7E8KVr0hLy+MvXiA7KieTI2rNpF9OkMiPD+jvQdUWoeJv0Vudli55Lk0cCOd2f0ZLhLXu+UVdQKjAfxiTuPYj3tlTMeryWM8tUoDsqqrnuX2I/K6t4XWcObwPDXwPMUHJCAEJogi8PTGUzT9Zv5VY0XMGMd6BiplGtpMMudPaeQ5xcGtvee0he1eeOx2ceUG6DNgOcpcJWCp2yCZ+TK5/3M9go3AWgTay5ddXRpNLMwSN7V3JrtAGUmM4ZHVpcc+GwAeLJcq7KNBhgtM+tqaup3OVR2M8OYcXKdyQz/anQlpLAjNYfZSjYVQ8m7M5M58IQn3T7Ab6GcrTB9Ld0TW+FuIsTq4x0QabsX5LTdTyZGy0Dr4rBLsD4j7U717NlmhURDbt8Ks8A1bSaSdjD1+mg+2hN+GbnDqnU+Bm+DErLDX2Zyug+tEuOghOnaYAs6p8++2njpWnWJc40w1lPhTg88M7+TT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prior to commit aed877c2b425 ("device/dax: properly refcount device dax
pages when mapping") ZONE_DEVICE pages were not fully reference counted
when mapped into user page tables. Instead GUP would take a reference
on the associated pgmap to ensure the results of pfn_to_page() remained
valid.

This is no longer required and most of the code was removed by commit
fd2825b0760a ("mm/gup: remove pXX_devmap usage from get_user_pages()").
Finish cleaning this up by removing the dead calls to put_dev_pagemap()
and the temporary context struct.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/gup.c | 67 ++++++++++++++++++++++----------------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index adffe663594d..be5791a43c73 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -28,11 +28,6 @@
 #include "internal.h"
 #include "swap.h"
 
-struct follow_page_context {
-	struct dev_pagemap *pgmap;
-	unsigned int page_mask;
-};
-
 static inline void sanity_check_pinned_pages(struct page **pages,
 					     unsigned long npages)
 {
@@ -661,7 +656,7 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
 				    unsigned long addr, pud_t *pudp,
-				    int flags, struct follow_page_context *ctx)
+				    int flags, unsigned long *page_mask)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
@@ -688,7 +683,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 	if (ret)
 		page = ERR_PTR(ret);
 	else
-		ctx->page_mask = HPAGE_PUD_NR - 1;
+		*page_mask = HPAGE_PUD_NR - 1;
 
 	return page;
 }
@@ -714,7 +709,7 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 				    unsigned long addr, pmd_t *pmd,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
@@ -751,7 +746,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	ctx->page_mask = HPAGE_PMD_NR - 1;
+	*page_mask = HPAGE_PMD_NR - 1;
 
 	return page;
 }
@@ -759,7 +754,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
 				    unsigned long addr, pud_t *pudp,
-				    int flags, struct follow_page_context *ctx)
+				    int flags, unsigned long *page_mask)
 {
 	return NULL;
 }
@@ -767,7 +762,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 				    unsigned long addr, pmd_t *pmd,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	return NULL;
 }
@@ -813,8 +808,7 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct dev_pagemap **pgmap)
+		unsigned long address, pmd_t *pmd, unsigned int flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -912,7 +906,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 				    unsigned long address, pud_t *pudp,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
@@ -926,7 +920,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
+		return follow_page_pte(vma, address, pmd, flags);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -939,16 +933,16 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
+		return follow_page_pte(vma, address, pmd, flags);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
-			follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
+			follow_page_pte(vma, address, pmd, flags);
 	}
-	page = follow_huge_pmd(vma, address, pmd, flags, ctx);
+	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
 	spin_unlock(ptl);
 	return page;
 }
@@ -956,7 +950,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 static struct page *follow_pud_mask(struct vm_area_struct *vma,
 				    unsigned long address, p4d_t *p4dp,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
@@ -969,7 +963,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, ctx);
+		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
 		spin_unlock(ptl);
 		if (page)
 			return page;
@@ -978,13 +972,13 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	if (unlikely(pud_bad(pud)))
 		return no_page_table(vma, flags, address);
 
-	return follow_pmd_mask(vma, address, pudp, flags, ctx);
+	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
 }
 
 static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 				    unsigned long address, pgd_t *pgdp,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	p4d_t *p4dp, p4d;
 
@@ -995,7 +989,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, ctx);
+	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
 }
 
 /**
@@ -1003,20 +997,16 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
  * @flags: flags modifying lookup behaviour
- * @ctx: contains dev_pagemap for %ZONE_DEVICE memory pinning and a
- *       pointer to output page_mask
+ * @page_mask: a pointer to output page_mask
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
- * When getting pages from ZONE_DEVICE memory, the @ctx->pgmap caches
- * the device's dev_pagemap metadata to avoid repeating expensive lookups.
- *
  * When getting an anonymous page and the caller has to trigger unsharing
  * of a shared anonymous page first, -EMLINK is returned. The caller should
  * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
- * On output, the @ctx->page_mask is set according to the size of the page.
+ * On output, @page_mask is set according to the size of the page.
  *
  * Return: the mapped (struct page *), %NULL if no mapping exists, or
  * an error pointer if there is a mapping to something not represented
@@ -1024,7 +1014,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  */
 static struct page *follow_page_mask(struct vm_area_struct *vma,
 			      unsigned long address, unsigned int flags,
-			      struct follow_page_context *ctx)
+			      unsigned long *page_mask)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1032,13 +1022,13 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 
 	vma_pgtable_walk_begin(vma);
 
-	ctx->page_mask = 0;
+	*page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		page = no_page_table(vma, flags, address);
 	else
-		page = follow_p4d_mask(vma, address, pgd, flags, ctx);
+		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1376,7 +1366,7 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	struct follow_page_context ctx = { NULL };
+	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1418,7 +1408,7 @@ static long __get_user_pages(struct mm_struct *mm,
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				ctx.page_mask = 0;
+				page_mask = 0;
 				goto next_page;
 			}
 
@@ -1441,7 +1431,7 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, gup_flags, &ctx);
+		page = follow_page_mask(vma, start, gup_flags, &page_mask);
 		if (!page || PTR_ERR(page) == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   PTR_ERR(page) == -EMLINK, locked);
@@ -1474,7 +1464,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			goto out;
 		}
 next_page:
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & ctx.page_mask);
+		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
 
@@ -1524,8 +1514,6 @@ static long __get_user_pages(struct mm_struct *mm,
 		nr_pages -= page_increm;
 	} while (nr_pages);
 out:
-	if (ctx.pgmap)
-		put_dev_pagemap(ctx.pgmap);
 	return i ? i : ret;
 }
 
@@ -2853,7 +2841,6 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 		unsigned long end, unsigned int flags, struct page **pages,
 		int *nr)
 {
-	struct dev_pagemap *pgmap = NULL;
 	int ret = 0;
 	pte_t *ptep, *ptem;
 
@@ -2926,8 +2913,6 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 	ret = 1;
 
 pte_unmap:
-	if (pgmap)
-		put_dev_pagemap(pgmap);
 	pte_unmap(ptem);
 	return ret;
 }
-- 
2.50.1



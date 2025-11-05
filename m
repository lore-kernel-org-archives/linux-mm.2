Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 887CECCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CC18E0011; Wed,  5 Nov 2025 11:29:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6528E0005; Wed,  5 Nov 2025 11:29:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EED8E0011; Wed,  5 Nov 2025 11:29:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A03E58E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:29:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EEB2C01D5
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:29:34 +0000 (UTC)
X-FDA: 84077089068.28.0CEAC01
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9FA5C1C0004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:29:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Hve1sORT;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762360171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M6zpwSWAAhnWx6LCcs0yKnZV8KbCMv2XVDMCccguS3w=;
	b=m3h0mCCLs9o5PjGFxNtxAtubErneuILP0CPI+AYDV148P97agDqeyfsNxU0u5lemIm/gLF
	5mUs7jYku3vEtsgKvR+Rm/WozEoJ5PKWqtgUuH9uJjI/bVD3XvklFg7Tp2vTbw1XnHOfbg
	zWlxDGQpimBvtJLGlOmhXFaWtedUjp4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762360171; a=rsa-sha256;
	cv=pass;
	b=1mgFBVVOEvv1MDksJIk/eRKvThIUcUskL0yoRY1ciR2Pon0th4AyeEH4UT+ClrUiIWkZVb
	TNgNuBaY71Db2mNoIDxt9JvyiV05E83DKyoKRvXvTs6Fbw3lbzyCoP+bS5/16bzi4pO5S1
	/6tvE34r/cqYutEu2uyymDDfsW9qB0E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Hve1sORT;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yD+KrchdxN7f+ABWdS0y5EEdMHeV3mcZaztKNJkiU2FQkvC11W8+4gDqw8i4ogPzgy4XDF0UGLMa3+k7qMO53nglf9puMm/yoiRMsK5jhQkMH+m6VRF6+tmwU+R0BRqNkJlTWPX28gWfexQ3+rWrR2BYww+pf83QsG//E85QVjQtnwDNvnas15rc5y/11cDULC/oxzqi8XcN+oH0Z1NKHck25Zm+qS+i60PMubhUJ6gxdMMhoojFP/IeaOSW7RD361vegxHQ2KcGSZXXlME237wGxpfnmIbcqc2NA0NFUMwYlf55vUljJFbNMrVCLlGx9KrArZJTk/osSN/SIdV1Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6zpwSWAAhnWx6LCcs0yKnZV8KbCMv2XVDMCccguS3w=;
 b=ZHzhhbg4j9d3ast85D7G1JD2Ob30lzWmDqjjZKP6HAvpFCiFFzHTTdANJ1+qFW5GkTmeDH8LOn/Lazfv6l7bVjRGKS/E3Fa+HIASExWrYwtHAgF3Smvu6XCGemnIkvX6iPlTuZayv7RA0e/opW+pp7nhnS/R4dPsoPwBgsJn/ZjkLQdaEJYReDtnJQ060PGZPKesFXX3oloF3zQvSWyve9y8Q4HPy7N/iVTrMc9cooqt6CHEVL1IBawUXvIMrL8D2N1zDAVOlaOu5KVxzQloNvvBfnGwZYLMPmcwJvVV86TGIqMJ1s0tM2f7Y64hfpc1AIfhGJAQY5QL+Glnui/nEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6zpwSWAAhnWx6LCcs0yKnZV8KbCMv2XVDMCccguS3w=;
 b=Hve1sORTMJWkKYkWU4mAN3pH/6VFewkxF/3Non/19aglw88aq8zGhF5p/dkE/rd0MQPcq5NquVlBIbWmR7CM7NKnUeRb6y9HkuCZwMtjr38rN2FBrrvZBz13FO6IrFXNB77CgdgNE+/I2Oqb974eeO1G1fKs76vyQO0Cd42xDXNyWho/8vN1dAuu7j9XGouObo80ZWixZYgK4neeW27zG7rx8blxe2EZ/7o/AMkRnn7b00RzouCaV5dOvJNt/3IQSJJ5qUpe43WSMDVBvPVP4OS8H2C5YNIUQKlVIzxfjqsnQn7BIVZYw6Z8ZYsm/as+6SLhnr2n2+HLRPdeZvW+Ow==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7330.namprd12.prod.outlook.com (2603:10b6:510:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 16:29:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 16:29:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/huge_memory: fix folio split check for anon folios in swapcache.
Date: Wed,  5 Nov 2025 11:29:10 -0500
Message-ID: <20251105162910.752266-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0333.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: bde60493-f7cc-4aa1-220b-08de1c887d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?twX25E5iZOoCFpBE+en3X0+4jYZkn16VEtwhc2N+9qPy6QjBAROf2ccuTMT2?=
 =?us-ascii?Q?q2mRidAt1CcLkTzZwPNvm4sWnRtK6De0ZBxAwLKtHLMQ7+/zHbPuZGDRKpLs?=
 =?us-ascii?Q?bGlYwTSbQOilXMGpYpw1pCfK0J9w/lNPikaN+I/ro7OkGQMta/dZSAW+lilJ?=
 =?us-ascii?Q?X5qsoinruCsh1kYQWIeQKepHkP/Kvo7mFJfgfrQSK9uhbo9fohk8ll8BuKf7?=
 =?us-ascii?Q?RUiEafHA28f5fkGXHcFduqoDS5zolcopvoBM0TKMcjLzvWdi99I5YgFPEB91?=
 =?us-ascii?Q?8WUzi7RgfiJnHLpD02uw71u9awhKkFRDX9YGikIrHyzacwpfuVxC0oi7hRTR?=
 =?us-ascii?Q?khyqsRedCWOqxN+zluBCzIONf4j72IqpxvJPcYb0QBgkhD6Ul4MlWeSXN/HO?=
 =?us-ascii?Q?Bii9DfNQBYdO0IYjEGiYuW5a01HqZs+VGXqmXFUh+aRLmFZtbMVFhccG7kbQ?=
 =?us-ascii?Q?0rkDdAlqD2AhA9i83d5QQbrGGX3FQe1/Qw2Bt50Awg3cASmErapVKpZJP1GW?=
 =?us-ascii?Q?XEiGVY39UIcKVD1iPb98fi6wv/pCkTQGiKmPKlxP32JokhUDl1+Ktba8+89j?=
 =?us-ascii?Q?9us20v1Wqrk++s8jt+RPh44x8iBjVf627KHqDo4rqk01eoGfg0Ck7uVcOeYX?=
 =?us-ascii?Q?MgJEMJdy+prc3KfcrR/0wFMHsA+1PEG0fOLCxz3W26cwZfBEJG7s/Mn+1nXW?=
 =?us-ascii?Q?xVOBcQVkLw0mA5ofatTKsOyRy8VWHs5xeMoBDhjIuMUOivWhicKOCzdDO5Uj?=
 =?us-ascii?Q?tnnTRSlzdI5MmW+MNCPFdFM1ALnaHO390U+kPvYCQzK/KCVpVWU2P2BiVzuQ?=
 =?us-ascii?Q?UW9r243GiTUexqdceagmZpjlhSuGoPYaYwc9WZa+4E/x1T6SHJFyKcLqypV/?=
 =?us-ascii?Q?OhhMWIIlcTYCMWy58r9m3qS3cxqsQ0NxR6Stzeu1rWGpVTt/bfvp93jomY/Q?=
 =?us-ascii?Q?dNz3yAFv6k14Hxxs/AWzFmBVJmskt4xpPGhn7Te4ytEYm0rFKLvPNkN3I6Q/?=
 =?us-ascii?Q?AoOAQOUfSMSaOWVQGG6o1Py2CZ200XPbJ9xpPQFf+wQUJkXR1pWaX092o+Kd?=
 =?us-ascii?Q?TcC4AmOSoVAHsmmdOCAliwo++vDRRGe2ECBoSxKlAVPx6AlOvY8DFDlKEb+D?=
 =?us-ascii?Q?PjAcmXtK/JqpO4puoCuzhqk3IW5/AloZD9Z/5D1ZDuOFPqyFa6QmV3kCZpKE?=
 =?us-ascii?Q?o6EzVbAE+zEGmFnrWW0qNgYLNBA/QHUtI4nOSFMEBjIA4V5VSIoVd8840n0Z?=
 =?us-ascii?Q?nS9R5G4xHymf9u5YbeLYPZzwmrr1slBzWGn/TAzhlM1gQnAl1Un+XZrR8xcT?=
 =?us-ascii?Q?q+GwQjHnkKM95Dn6TDDF6HvMk0k8Wogv3QpyehPfYyWYQEw9k8nYaVfgK8gc?=
 =?us-ascii?Q?1xM2/+xgPr7el8+EyjaU+Me9796a2q2q8at9YrcUNQhMuCRH09mQtBfHDK/2?=
 =?us-ascii?Q?9Nn3MdV1YwKi1tPVmex6R5EI1OIFCmQo3cBGOaW+hZPp6BLqlCDbZw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WYUvBnfkjl8+qwJJVABqhmVJJQIsKyXmezqoq8MKUJu86+M0Yr+gKXSkn6v4?=
 =?us-ascii?Q?Hl4nOEHku4Gn8THJJKKVmN+eVcafUbkL3lsQaESSReM1oAFSsjhCyK51lO+q?=
 =?us-ascii?Q?3upFqNAvAv7CfgJ4cvl71Yrmhyp7tv63NIuSQnj4utHhUFiwviZURIGbpG4y?=
 =?us-ascii?Q?ZOUCIHHQGELMYsXLXqv693+iBVasApzYuWtXQCWMSoRdcpPxIHZhUEgfboW+?=
 =?us-ascii?Q?LvWW2EHcQl+x5j0d07AjgTXW497XVNZVBlom5brSkDqBnE8OG/YNSoioI0D3?=
 =?us-ascii?Q?1tKFFhAOdY7XDNRvXTIAFTf42dplWz7x4j0JOiIxU+PAXfcLoReil1xw8cM3?=
 =?us-ascii?Q?QrwMlYfCK5VI/NWQfT7oV6awp/vZPUn47+SPOgAHxj6bXsJMnA6PFmQt67pO?=
 =?us-ascii?Q?bdZNCJSTZ8YMXSq4GEQTuemOpSZjbuXEQygSumgShDPG/pTZOk3LE1axl4FO?=
 =?us-ascii?Q?gCItwWf1x3zSUa6mFqw1YtO/ckzrHkEtzEhWnRqqismTuK2oGbXoAfRo27zZ?=
 =?us-ascii?Q?gpmQMerDuywbISDkpcU3mB8FYUFerewHGQdu8BVszwPkY+DoOoxWEGc97AoP?=
 =?us-ascii?Q?Cf0gTyAFWKBFvBQG7v0U/DT+XlhzNMLQsRguD/mHUEFkapo5r4s1j2W0SE1J?=
 =?us-ascii?Q?FKdduDDTWqhWLen2F+gIGLikCa8yPqbRKpQai6B2/wtm8gTp9rDT35kZuO3N?=
 =?us-ascii?Q?ytFo9SAN/1Llk39LPMd0y0TQI3lqyw8Oq1ZF0wWA44xpIBSaVwJL8LM0m6KS?=
 =?us-ascii?Q?SUNwYAkBE/kDasVKC1pX4hEY1kQ6lphhLk6s9ns345Z09gpaj7VGQIy7hQWI?=
 =?us-ascii?Q?sMYsYKSAEiSdpR2NrQSc3UXPkfWoBNXMqAaJa14wrywWMSLHct8y2Bn5aWh5?=
 =?us-ascii?Q?0vxWZqbYW87sibflsLxq5g172FkmyMCFDx7pOCrAUCct2jO6lGDW3be+9c0U?=
 =?us-ascii?Q?HFVhoQs8VPl/8fg7V3xmvzGp74MZoeUqU6OUttIoBgltwDzTOFr9dNfQAogw?=
 =?us-ascii?Q?YrjZ9xqhLcRc3L1vfuhM0InrrP0uweddn//mcgh7gaBGkzvfLIX+WSINuvOp?=
 =?us-ascii?Q?ZYyzUSf8gq6m5Q5cDmydeYwc3rk6+JLdauWv5iiQMOa9ZLPNPmQWXJueCOMk?=
 =?us-ascii?Q?+AsnbE1EufhcXK5Adc/LTpcLicD8DKrlbS3E6g3mEm7lRuxOTtxom2NkBfGx?=
 =?us-ascii?Q?ftM5UNKsj/x+iKaADnjz8GW4QiCOQ4UUWK27JVft8QAbRXlzPGq3o259cfOZ?=
 =?us-ascii?Q?dwQldVNntvl2200u/lues2U7n3TPp+TpJi5k3qcmfcE889cvtM76dYnkh2Le?=
 =?us-ascii?Q?yal5YcAewW9U7w8sPldwWQab9HEmZoSrzHmA1y3NQFsKeapvSkg+2BobmQoF?=
 =?us-ascii?Q?X4hRy4gJKmh+f8t2ktNZilxldtQWcMSqgzjZJuHX0v3JrB/W5DXrHDJSBTwt?=
 =?us-ascii?Q?wFvEKc1x3H+SP8XRNoxQ7tfMhOdiNP/RWX9i1IyeqDXIj+r85C2KjTJDF0lm?=
 =?us-ascii?Q?7au2C1RVwmYPtkAT4Izh8g5ad8vj0XkxZna4/I3GpwBzwEbGxElDGLYnVMf7?=
 =?us-ascii?Q?7wn2QTl3lczjsTEI0qlUPUMc4gcYCmyqN7MAPl9Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde60493-f7cc-4aa1-220b-08de1c887d20
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 16:29:27.4976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NVtC2EEaOrb5PUzBC8DdBbQkDgAA1WXM9z/EzZS82AnqTv9AOJ9eQiC85z0Ls6wC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7330
X-Stat-Signature: 46xcdwdr8hfeuhss5c6pjrhg9ian88gq
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FA5C1C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1762360171-365092
X-HE-Meta: U2FsdGVkX1+mx9CyviYnVWSFx0IfQlk4BTSqrie7w+ZWLeyEklx3DBBuJu56wj0cKsFQXxs5i1cyAZvvZdLGa4FfmcvcIzGrLHcE910OBt2EP92GSubwD0KdFiRbGNe//hWIqzkul4yXri+DWNQ1JwW6XSy24j6NnevqE0oIdBZc9HVP8blrq3D5xS13kZrCrE61kZeqdjHMy3lMTg2Bv1J+9d78W2BQfr0FBgObJjrgrHsfk1DFx1AE3DClPS4pTIbZ9gcWP+ukOB4O6qyn7Y+LOWLCC1TXZKbnv38+a6+t/8/fM96l7zeLNBvH/oluBgatJ6LuTfQ15EL9LW+9qne9dDVxJ6LRLVL8SHE3pYWnnXvI/rC5Swb2E+CAnP2bBQnrmp9KS+v/MqcRYtejLdU4PM1CqAAsSsKrGxrvDvF6KN0mGZr+1LUCb1OhN2HeIewb/KK5LoLtWEXqpzEGF8VhJKfbeBpN7rWqQAFQN1r3B3Dfeq8izd9I/bkJwoQ7yKvHLvWUQa6EnJ+xX/DYr+DN/VNmvuR6j/rzpKl5jfG/ebkOed3vQs/SOYTmP7mGXSZbsxVrN8Q+CTgvANaiEs8i//d7ra/gsNff4phm5il5U8sE4avvr5x3IYpAWrNKRmEcoS9k4A3hQDpmd7zzIvOULwNm3ee1eqTB5AQ/7PQjSjNk7Eq8DRtUPI2NGiPefkjTHCfW8KmyZOC1kilKF08ccW2ocRkdcqR5OoON3P6i95Xo1HWpDIC5YFVTOL1BUSONVqPHLhDAg3DdPMTU8cWht3+uHiHSdeG/aV9TgrZhaP+VZJce8PoTNO6c3aGriGoqUOA1tdaSBepy06DwN+iqPegFkV7JC8Q+dOT4qQjIV5851CakV1Ads7L+ctw4N2II/VHw0DegpSjPs2gmHP75hRfG8yyber0zh0+05Bd7n6pdVFOuVSVCYZYtKoEEWaCr0xtBe0rrNqdMfm/
 35U524OD
 6GAnUcq8GJbc1kwhEh8Z7sXrzUbzOSVVKsIPahGrgXnehIdiiFdNQ8WVCl2AsClSDuYUPUgmdS0GaMORDHU9mdf0EkJbyAwU2zWgqtu64UigxPm+E69BWJLkTns6bWKJXm5sL2ALv5MP4XmwRF9+cPbJSE74TfXLLgfGhSQtskkHRddXugfWDeBc3DOqkXGkgr2ClY98OEWgI1xnoMYwPYvGLIqOCujUfuLNyx00eD5PVAVa5Z54CvJINhmv05+DRK5H9qHlVmjOTgmkr3GAAGVbn965RhMFA5CXkOLJVswDVyqeVjsDeS6zkStpPCFFZPSkK8ckY3Fda4afmVh4QLfGvsvrBm2FtyA8jTN08Rcc3fIIWwMfvgN6bt5avpzRxD962QSf6e5S/PFatbEMexciaruPl4+JMhtuuz0AL1HM2eSfbG+uTkYVWtJ0KcGM05aBuVnytDJTZwfX+WpGFtwwwG5G2xHvSGcqIgx3dHmoWs7EswZgYMq5+PlpTTtBqiStXG8vHXKHikuTol92cQt0s2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both uniform and non uniform split check missed the check to prevent
splitting anon folios in swapcache to non-zero order. Fix the check.

Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Closes: https://lore.kernel.org/all/dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 36fc4ff002c9..595811c78f42 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3674,7 +3674,8 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    !mapping_large_folio_support(folio->mapping)) {
 		/*
@@ -3705,7 +3706,8 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
 	if (folio_test_anon(folio)) {
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else  if (new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
-- 
2.51.0



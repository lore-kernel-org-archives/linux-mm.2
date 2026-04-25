Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16F8FF8860
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 14:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345E96B0092; Sat, 25 Apr 2026 10:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D7C6B0093; Sat, 25 Apr 2026 10:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D156B0095; Sat, 25 Apr 2026 10:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3566B0092
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 10:21:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B079312039D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:21:24 +0000 (UTC)
X-FDA: 84697290888.08.28ADB78
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011032.outbound.protection.outlook.com [52.101.52.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id F1EBC100006
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:21:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HF3WPghQ;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777126882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maDg5RY4I9HU8J6iycHzyrWnoRsULlur5AeJpegaKng=;
	b=XGVihbU/qsRKcrG+A8fLc1w6C1QekhSC3B1Pk5LU0xRLYrH5z5SyiZuHGF723hI/af97pG
	NADrvYWY2gbe0MM+3M09G/eFScolfh5ZeHrv7M4j4Lf+LDzoF92hLVC9G7OsHU3iFVTSk3
	qSJ/b9BJFWveLt8I8sNlqJb581YHitY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777126882; a=rsa-sha256;
	cv=pass;
	b=ZnmTzRE64k11SdmesJjOri4nCmtqFU2obVcd37HOq9V7NnP4iBC8b3AGW7bdSzM49lfCv7
	d1fTk1sztwhipq26RmZhJtDY+Vmo9+YAybZNwJzea7jYvlbLUgeBb9XPvKCNabj7bW57gO
	R1sDTuFib9W5vAWBBi7eg74qCM0VMFU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HF3WPghQ;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JKD5YImN7puU4+o94SJjn4doz8nOn8w/DWPSd8q4172VxfDCq3pqN7MTShBhRPYdRlj9qyBE52Qk8isplWAkMi145M1I9Kfl4KUYDot84Ak/SF877keNiK0SzTg9gQrx3R4WNXkZ+dtfb1nI5x9f9GK9shJNDDh0F5U+T+xC+TYP3iUUeRNZP1bNJgH4pKLuog2CRt34uSz6vCiN7rEu+IzjX3HnVYw+F9/BLWK/au0bT8dvggD2aeuSbG16ayziKgowfwG034og8buxFW3IU0GjPJ/1iVP36IZcZ7ZESOU9WJXkR70+U1ol9CTwHiJynh+6js2QjU79iU8ToK5BqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maDg5RY4I9HU8J6iycHzyrWnoRsULlur5AeJpegaKng=;
 b=eGcGPQIKtybU2hPDa4/z9Yu0RVsmaHrs5oE8qXaQs57PechbmZbb7bMVsdYoKLlHl5Z3q0Lr2CkfEV32wm+qEBobNJCyvDZ4hf+Uj3O+76yM5vy0FHtny0ix4EY49CnBNOSV1yqy7K43lx5+qhOoK7l+q8ljXNpdmMpgGVhckxzvFZoaH02/3fC0fnEkTJnpE7EtSAafi8hbnWAjEYtAzYWeFOfSkG8JxiAMuOJTYKTO7AEhiaNSv5Jddufddm7BUlo25cbO18UUEV1JLgLFMWG7LohdPvTr/9ecGKafp2C6KVC9F243mRCxRwjNQyYTJSn/bgHLxvA2BTIQwFhwLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maDg5RY4I9HU8J6iycHzyrWnoRsULlur5AeJpegaKng=;
 b=HF3WPghQRtNLSGB+En+hw4vA0Joe//MXNiO3zLaUIuwj5fLIeuiYDVkPS58IxKgRV1V/H4gkX34c/8HKjqYNUO5JOj8eIEXbrqtfVviC1cL0liwrsJJoi+AkW6u10hFxyKSfcY5he2MUQ1r41PAfXvDW7QNJ+Udvp5c4wkIWAoKX2vkh8f8t7DQWSu1yqJw6chiX6eplY2bIx9f1tVMLw9q3jS0RgtYW4XgnWqLIpUL33ly33t48l9QKwavq6IpWoTt47h6BNkqEYyYHMf1Fhh9kwjBFQCfW5/iNspcEkOTRp5sr7VHmic6fbXnprMzr6peDLVBU2Szx1zCjGjuc+Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB7035.namprd12.prod.outlook.com (2603:10b6:a03:47c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.12; Sat, 25 Apr
 2026 14:21:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 14:21:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: fix spinlock leak in
 migrate_vma_insert_huge_pmd_page
Date: Sat, 25 Apr 2026 10:21:17 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <23799334-DD7F-4301-B361-8543C203E25A@nvidia.com>
In-Reply-To: <20260425133537.17463-1-nueralspacetech@gmail.com>
References: <20260425133537.17463-1-nueralspacetech@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ea261e4-f415-483a-979b-08dea2d5eaea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	A8HbYM9rs7/DwbDwzH+ASdCfDvXQ8dHDKD/00j7vSwkLwFMtvQ0euKdb1bWkjmtIJlwvsbsmhknJCw/xf+op+dJguagkCSSUYPU85+0FunDenXFiH47QPC4rEZfuGE80mk32DtCMFFUCKZW3IFwFmyc0uZfUMBcfgk+hJpJX/y7ZMS5bBYyUzaqH2B0QrcxWE5ByyDNHoIJj+EwsKm+mPZUX1UUiPQKwiPbgrBE6ApTb01Eyc4f7Ic6yUlr+jj8xY3FekS6bBes3qlWDYRwJN2ORp2Xa60r5KrltOUWT+OCZkg6bxJ0162cwClNBOs7gUsg+uBjXj2nuXFxHiQqy9F2vbhbaEd2GsERcZcO4s/B/jqcR7aTRmLJ0We61asYRrqGQSXFTNV/83CiPwFaTEzimPja/EbWBjjCBX5EX1FhAL3qzmlHPHfFlkU5YDj6TJaos4bwquUu4hmRFzo//tOOtKFAd+j0vLdYS9ZIV1DBWXSg2FePk46hiX0RE7Em9FDhG0DhSnA5IvEnEzeS+JKeHBG5SxIvE8e30cBaBvuO0n/gqVp2fgXJY1Q/fq7iKnWoNdcprXu0i0Cs4i7dk3rNaeO2GX56ujJLuTJFHKrxk4+PgM9yaJi/luFI1GcKPrR89OSP6njNaFpOq4GX+BIT19sFXazBAgqaoMXV+cmkV6WgT333mpmvtUI/NnSw3DOf5FdIx5to9B8pbYGEV1GIHYOnTIduH7KfVZ0jEJnM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l5+T0oqKnxMTTVmqWtJEzB5gPYWR8rHRv/wIGPPmDoPOr1JNstXCI/pGkVyg?=
 =?us-ascii?Q?Qk9Gy1RWhWB4Jzfc6Es3+qwZ2AicS3KK1Q96mlgbYN05ZjTzmXLKx+zDNILS?=
 =?us-ascii?Q?GaAR0AN1FuVZ57qqvs+Y8f3vSctJWppGhCrfWETOJPvEyWelvzBQBL5YhsN6?=
 =?us-ascii?Q?XV2aRso1dewXQvynBes9Acw96Bkrz/LOwE//LnFY2NHtWv4P0bKw1idlmYxl?=
 =?us-ascii?Q?8VTLw7NFsxyPYcwruVHd3Pm4wmJKNcAVvU53d6enzd1SHeAbdOyOBRFFSJXt?=
 =?us-ascii?Q?CnMm2o9nfzm3IhlVFrZ584SzxnifC4/rUQiil5VnNm3TM32f95O11pyiGdBO?=
 =?us-ascii?Q?+V44eob2A4KF1twbhye7AB3O41qA/gEtRfHPbai1DHWf4tROBqA8uYUv+jzi?=
 =?us-ascii?Q?Qfkxdbl6aJzz9GkBpWvxWaJUmiNOOTEeyHoqhJZOEn9D2u8lWS+7i/TfqzOA?=
 =?us-ascii?Q?smqeNS6x8ycvLBgmm+REWPfpCFYC6ljyYlLq9JAh/nyRCs+bAHjvmB+e4Guy?=
 =?us-ascii?Q?yFtr4UQiLJkXtvcGLasie0f8W3B3crls4CtOzIO2gqHrnsRGvjHK6Uc84MVx?=
 =?us-ascii?Q?MBAkcdIQAhUqefr9upNJAmyx8Ae/hsOHZBqMyhEeAZSYoTPkr0iYUtl0a1CV?=
 =?us-ascii?Q?yOnCIpFo/EC2DtFjZuGOPtvV7uyAQMDTcTprdYJcWJ+J6/A1DqiZBnp2Nlte?=
 =?us-ascii?Q?pdVsgDa2fcXIXHKI/XCwRpPmaWaVIepVXk7KUy9K5LoR8inWT0108N9Y0rjc?=
 =?us-ascii?Q?cMXR4KFOInOfNP4QP8ebQL3H59vOiuVC1uUMvLlryHYXUSZWuaXoY9QNbTAx?=
 =?us-ascii?Q?Qvnqt+utMynZ8wDRJEGZFud6EWB+zfiLkBlY8yWmbMJvkp/86ish1MomsC83?=
 =?us-ascii?Q?kADNOdk0IjcAc/gkRnoLIjrp66cNbXJQAaXEl1PGjuNZY7yovYe5M/5jRBUf?=
 =?us-ascii?Q?AI5UceqCgSMAWBTwHQt/Y4VOpIfDjpUFgMa2pCvVtSwjnMw2ff85b0E7Enjb?=
 =?us-ascii?Q?9OlGY1pN+wBSzdPK9M5CHKA98mrc+9kQC+EMt2vJFpVSqr1NF+eAt0moNC1d?=
 =?us-ascii?Q?yPpyyILkgevUrwcGhsUgFnzXpGlKc4wJm4DWdrgcH/3wd/hmtrvF/K++7yRs?=
 =?us-ascii?Q?z/mWX5xupG+NYXDNfE/MPFLcX2SX43z4QU25RDGvylvNKQkpzFRvsxVseoqy?=
 =?us-ascii?Q?MB/jVhbkxKUjpWBJkRHI5doo4GTwtafvT2/iXvERBjFEMOZ2MYFcuxwGGFFC?=
 =?us-ascii?Q?4MhsXTXFFdt40CG9o7xwm3LWkuiw7d4O9mtMZgjZGYgA5pfdhRQSjmaJQRRd?=
 =?us-ascii?Q?9KIdM5zGpSBSrbBP8RWwaHMOKBevV2UN8XOix3EOpd6lfnoM4paU+TjvdAAp?=
 =?us-ascii?Q?GLexAykiD5QLBCwdyBczjKM/fbpBKmHa6iaIbfL/juedKEi+lldRtvYiH8Nv?=
 =?us-ascii?Q?X67taPCfGFBSMnAE1W6pWc94kG8iBoJUQoW3JZ0Q+kVCEoKVvDLEsnAihEWn?=
 =?us-ascii?Q?kNTOEQ87DfR8UxMjVHLl4lKQ6yl+4v5UHXu4GSxJvW2fibocY9aYYLrfGDYx?=
 =?us-ascii?Q?v071mMQeaSCGcI01vKhi+JE75beIB1RiVyR0g/DUgMSiS4LA5DrNeUeaUe8P?=
 =?us-ascii?Q?KP5yeW5CNRk8VAvCDwaKTV3Dg86lBz8+eRzRqjNcVAWeDRDJt9IsBhjVDaXX?=
 =?us-ascii?Q?LYDk06MgE3bXujfvKZgJrGm5t1XmLxRy8ASzcxl0gkE4jSFL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea261e4-f415-483a-979b-08dea2d5eaea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 14:21:18.7110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbK6qjbWvIvPVG1BFYv04c8r7Oqvdjcc6N6bz3U4uRw/5r7juuKPTelf0CiOoGan
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7035
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1EBC100006
X-Stat-Signature: u8ofspy7kejpjq16rzqmrb8bd555zs4w
X-Rspam-User: 
X-HE-Tag: 1777126881-361734
X-HE-Meta: U2FsdGVkX181g4ZaTnBGipVdW8tFowZh9f872XEeyDfcLx8quvfXXg5JGG3grt9nUChTTEfGB7nnxxW4yl3iMY1CclWEKaiBh9On2LhPrvMoEBDe/Wgglh4ma6eAgzik2GB7o/gCJPP11ETzz96M2hrbRP5AXs67NXXLp1OxNMZPrCnicInS+Z/H/3QNmw1N+/XdJAIk4+FDFn/UIOITrBO85C9/0u872gRgjlNhH2ORsn26DpfMw6dmVUWh7wsFYgP4bsNbCIfAEG0CR+8/ova+VnCFwvtViOHGnCYqodANHmdYObU2JT3Z5o+Ey9KlZNKR/XufiJToubimMpnB14amZy+VP71OpAaaVOl8jQ7wsrHEyDQQTsL3cF3Fb0bNo51GjG+cU0llEG4dwZ+tacBLwba5Cvptk24TXH45CRbfEPUI6RBnpFyMPySGu9l0VCcUFG/ZwE19vCPDTeogTqVFBFwzmHDM277sHX8Sg0/hDio4kvL2myLZBYGNB1pnE/XPDBHQ5lnpGTPqI/KGklvtF/ScYvk15W0DWXA16bj6POpXOd+Owwm3YfoiaOw5cygZvffTxwoTwS/oueQo1m4wKglIEQJPn1sr5MBOfMTI5bb4IQhNJlC0SJ9m4PK1EN017AsvzvGXUuyN4L3sE9iG902KvihrwveSnnwKYtrgLPyzwzmlK1uEnOT3h6U5fC/0is2sjqj1Zm3AjhCuUEF2WnCRv69M/jKTTHpW2IifJ79HA/LUJK1FLECeVEikETC5yVhtzSwogKCL4FJwEg0F0qv7FGmlhLw1jdrw5rh27ne7LcZBDnGYeuijo+IhhpITcLOWrJhNEjrPmDjR5vU6fhEyE7HiyeUje8DVcQiO0U+2094CVmu+N1hxFuRhDe3tkcMvXQrLLwd7gt7Ts9kFai+X4nlUuERa5lMZnJt1z/a5bWKOs+MOiXQ83hlx/QP5QpfJgrks8I2B2jy
 NWqp0lAx
 MOky8j4UHYWP1AcI9lI+i1IoYYTmwl5qLSLOyGjGcTAYwM0hAsijN8lK9chjaaz4Ha20UGmRoD7roJbSRm6hji+a6FzpFRZkglxfb6hCJp+tTYLab2P3q5im68AhYbiURIzpUCjHEWoUtpb3Kqw26H/WLrcRCg72YpSxN6oNqGv497Qp7vQgp4XIOokhGhFPdpuvy2u3bByHtQg5lvqXe4gZQFgfoIGSpl6vjCMTNhMfTPJ7CqMtWntUNiTrvvsyD+8Fn9OOZejUNcaEc/sIhW9gQs1JD4QM7isKkmFuAMPOJ+aCOb7npttyCZJyzrfuC3GmYl3JL+zxYxrQR5o2O42c+N6YBjElcm1Poz7xxKGpx6ZSI4wNVx5OsZF894fdSIQUzyxqgrqCyDP1sTxIQ4UP6IxEnl9Y2MJTbSwAVDnrmRWmwZ/I1pbZJDUUdW8XJiMd9zzPmvkCJph8/g4YOvGYfaa6XlP06bEB3gcJXIKrydvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Apr 2026, at 9:35, Sunny Patel wrote:

> When check_stable_address_space() fails after the PMD spinlock has
> been acquired via pmd_lock(), the code jumps directly to the abort
> label, bypassing the spin_unlock() call in unlock_abort. This causes
> the PMD spinlock to be permanently held, leading to a deadlock.
>
> Change the goto target from abort to unlock_abort to ensure the
> spinlock is always released on this error path.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi


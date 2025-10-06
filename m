Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57487CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54548E0012; Mon,  6 Oct 2025 10:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05188E0002; Mon,  6 Oct 2025 10:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A59E8E0012; Mon,  6 Oct 2025 10:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE6A8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:14:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1001214064A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:14:52 +0000 (UTC)
X-FDA: 83967885624.20.8677065
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011001.outbound.protection.outlook.com [52.101.62.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BB1C180011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:14:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VKuHrsgk;
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.1 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759760089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUJazhpBA+L1TdgyQ/YwGU6mZIUMse3xy9YEV8/VFVU=;
	b=EIsVJLMFE8wpZuCn/eXUTi5d4xYL007EWeKDEreVNwgrv5mKo2NtlRy8w+ZoySPnc4P6LI
	mEuS+7E/x69UVELDxZqrKxI2p56PXg5pRlgbtTQBHq548MFvhyOurIYVFts6OWPYFqGdMM
	8GONnGtfoSfr6/PkLmrQPs3t0SvPnBc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VKuHrsgk;
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.1 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759760089; a=rsa-sha256;
	cv=pass;
	b=j/9diAGHKXwJ68iCZwt4RwBUGC+xY9gtd5R6U1e8B6CjoVIjyCKk/XoS4FaUDqbMoNvdho
	/9PPgGgt4OkyjHYlQHxttiNlTmQFssGI6Z4uY+ml9RS/1VM/SgVL2YfoolgpQPx7glhp57
	xL9veRKSZPdcHwEY4BDubigLhcmw7a4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ui1l3zlqMUsU1VQQR2k6rrJDLl8+hk/HnpLpxB9QvxyFpyRqLJDSrnJM0K0EPA0gek7LqmB/fIEpPlsF/Js61p9aWCCe/O56Cc2jKrj1eDz9CaRFCfIqH+k3hH8hlo6wHVBEtvu5ah7Wu4unirc0uMhzna7tPQimredloHSfFxnkzGndXq8ixPI6pTHdtN3J4g/291llQZvzs1YoHAO4Npiu5hrlXSYcc8dNOVGVeHQxXD0puVR8luA52Iuqn0K2qVaH8sUmdu++OJdpnWYC2JjsKF+4a13OldxFz1ceSQW4lCS4i4X1zfgSv+r9t4dElWBgxPG4F0URX7BdJARDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUJazhpBA+L1TdgyQ/YwGU6mZIUMse3xy9YEV8/VFVU=;
 b=xkeuHUqaEYbj8MhnyiXVcM71GdEkKdVFrZSvPzfcCry7djAIY+EAJA7RTwQrioSOShR4z1obfOq8f/Niv/LVTU2gc2XLCIUSuEhjrg++5kkTrm0mLJMtPhlw2uRMhXqEMg4mM+5XJLdsq6HZmOHFQXAi+CMtf9/sRhkgbFj8YrF6ZdhRTaQOLeryuse1KlwS35GJNqZxPCjEdKy+HD7w8RBVZkhW0m6wZ3YTO/xO8pZjnJgu4tCLAl9lssqDkeUj/bwjKskzCFeVbUECHguzkUFyYAyOFXrMi6A+1vqi2oJxaSLOzEFSCH+3CanJPQVAjU9TpF0UaqHv20JW0loXQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUJazhpBA+L1TdgyQ/YwGU6mZIUMse3xy9YEV8/VFVU=;
 b=VKuHrsgkXWi4O7HcgFwWuWDEWB89Qr5aqZrV4BP34eNsju0JYo6jwk9G2/pytw5we6g+csPuTT9tzQ7d10u6YMoIrBoeCyF9Id0+HFjCfWtlmxP85KSMfxjQIlF8gZr4xDGdLtnD2aLQt+S+s2ORyHn4o+weFxMG17m+IEG40uOKwd0H4CA2FY5U+sJUjy8l+82l5YpIPEIVNNzTyQPckFBjW4OY2fGtAoj+GoGuvqZlBC8bjt//Zn2yMRxYAo1TvNrHjdvJhi5yteHs3+STS/rTthgiqaeaykuDqRrg2oLqoaxca8JaNRlZCirPhbbNyXji8RlKFDFuu3A0JXrhrQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by BN5PR12MB9486.namprd12.prod.outlook.com (2603:10b6:408:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 14:14:45 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 14:14:45 +0000
Date: Mon, 6 Oct 2025 11:14:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/3] kho: Adopt KHO radix tree data structures
Message-ID: <20251006141444.GN3360665@nvidia.com>
References: <20251001011941.1513050-1-jasonmiu@google.com>
 <20251001011941.1513050-2-jasonmiu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001011941.1513050-2-jasonmiu@google.com>
X-ClientProxiedBy: MN2PR15CA0022.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::35) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|BN5PR12MB9486:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f3c40f0-8fb6-4b74-32c9-08de04e2b379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JzveNZu5pZVvF0TDpsgSCHJ+LTpDscNdlerUd07zx6ulU1n8S42UQJbO1L7Z?=
 =?us-ascii?Q?6blbUz7LBY44KUVrT9q9xTgowyhGnTbHiU+QPXfi+ptqI2vyQMpCZLeoN2KY?=
 =?us-ascii?Q?RH6e004Y+Zp4ENMGJeMW9Hs/x+jqPwc3ssvgx+hQGbEJEss1Wnklv4uj8cXt?=
 =?us-ascii?Q?fui6pX90szMELaT4DFwBKuccDVTL5U0RJWUS3gcQkgHDhokTAsZtlQ3n5Hxv?=
 =?us-ascii?Q?o/fozwNaHibMOn8/9EZpzutqZDwudZLuDuMr0eKAroqR0zp4T34whJUmKFaA?=
 =?us-ascii?Q?GJptn3oURK2d7D+btxjTmLkhsrGv6fYaB6PPMwFZsdDpK38bcyX9NYNKUEel?=
 =?us-ascii?Q?As7w8cYgh74hUZOxaII2Im22fVb9VNmPL+Ie0885rwCk41lAtYrs8UBMTnyo?=
 =?us-ascii?Q?q07Ii4VIEGn6tclKEZ9bEUUwcwmVpU/bek6RpU89i4UVA+zEHOGLYcVKpr/Q?=
 =?us-ascii?Q?P+3mXGsVlgJscXHifJGU59SwhTlg+3hQS8Xb7i2cyozXC8gQfmgYoyy3jxzr?=
 =?us-ascii?Q?9aLJBd2kv+AkFN7wydsiLY3aP6gN7kdujCRBolBNGrT5tlTF8awBJiGFFYp/?=
 =?us-ascii?Q?Zz/FUYbsBRPd9UMrHAYE5qZqx8fsN+uYjdKsYRM0Xx2ynKUI57wBVavp3HOm?=
 =?us-ascii?Q?/cTbR1RPSbH+fPsZolTkbbyrqvjYfeVQsH4GDpqFk5gyyyxZZ82M6koj/b1H?=
 =?us-ascii?Q?2dsk6rWX86+HdQUZSxODyRygUlcZW8AxmSzchqim//84rRjSzV81F+tcFyWr?=
 =?us-ascii?Q?+mz5EiSM0hdnDdK6erbpSQ2YsN95s+J6GZtXYPqgzm032djOo8XvfWEYB9pv?=
 =?us-ascii?Q?gVmH/1ocJ3htFGDSUAEpCrunkrli92+XaQKtTQXgyzHhsfZDWc+bxVERLTrI?=
 =?us-ascii?Q?ugWA0Tu/2V7F9XNK03QhF1mD/EjvCHjnsqsuXSpEX3PCRCEb3jyncOOHs+3/?=
 =?us-ascii?Q?crfDfRD1rmmyA9QHofoSBN9zcHt3mI3Aj5OWFBdeOsb3p1G0WTtzX9ELViXX?=
 =?us-ascii?Q?85B5K0AGP17p5/wrp8UUoIJkbBHhPwRo0Ft5INUFyMOfgItFPSAghA3M1q0f?=
 =?us-ascii?Q?6+76yuuHA2TzX7grxUEcjsWLEY78vu4hzqMterh5MLaSg5+0386bUM7G1Zlh?=
 =?us-ascii?Q?h5z6Bmx5K+UBINSVqBknL799417T2gjAqodwKwDFnnnLC/SsFQzaON9qUvE+?=
 =?us-ascii?Q?FRPI6XprjGud7wGzTlr7IYiUkEli3VzrcHDH20I2it1ce8APqk95h31nhJBc?=
 =?us-ascii?Q?gcdTWISCkwrYx04AvHYy0tHOCkhvmeDIkb+cEDS9bhGY6e7YzYetoHqKEJSZ?=
 =?us-ascii?Q?DpycSZdDagzBCA1ryRh/j9Zw1jI/7NW0Y7rosncmoZ3suH0EQbmVUy/kncyp?=
 =?us-ascii?Q?RWID9/ydYGhABDw2HVzezI8/HTwjz3NhuIqQFPbDA2v/M/qnaopQ8T1flYp0?=
 =?us-ascii?Q?oK/fTV5+roqbSiP4+xjs2f7erHnEIPJ0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?12WoQ/cGn5DH8e4YQ/MkZv9LPCp83ax9bRsD79w6KXeTn0JdvGOOM8mpB/oW?=
 =?us-ascii?Q?TP10kvqX1ME7hrH6zkz4JkvlakzrKQ9ZCjLAPJFOA82/IbGuptol3g1pp0kj?=
 =?us-ascii?Q?XeH1VmyAqr26EVjHG60s0JpplhK+2JnCJEHR+XStb8DeV2mJmz3+qYIrnZ4D?=
 =?us-ascii?Q?8Oi8b3UzaNVnER2iQ63321QSAjUtHjshhirOHJzse87U3Bk/ILb2okME3jf5?=
 =?us-ascii?Q?2gAQCFDb5XXLKvhH7QPA8aq3SyCq8B0CWKHPW0xewFTQIlWtl+bHDEpJVhfY?=
 =?us-ascii?Q?TRR/L8ZsMdxV4cO25fVBeDfsxG3A/Q3HKfSqHSgadk5t8BajqX/TCoMBSKMp?=
 =?us-ascii?Q?+qMIYWi/AkyU2CMAWtNxlkftADWUbBPbIfc0gNJeH/L0PhcfKK+Bed2cxiem?=
 =?us-ascii?Q?f5BtAP0vRMZJksou+CS5iRsUQAoWdqZ4IjmrdmeN96lMaFg3rqul+IGry/PN?=
 =?us-ascii?Q?op74cAPTeD8Nb3r7v9TWhDk6okXiWhocGqlZs3h/OLK4o0dYJVIn1axzp+T2?=
 =?us-ascii?Q?rF1nDnHT9gBi5xLzRQUlQ9Mai9qWdIg1txEG1RKYbSqZn3EWXwkUACTguK2W?=
 =?us-ascii?Q?30CWgpw2ox4wODUZH7cf2LOsNw5DpiOYphskdeskBeloKIuCGkjgMVJDmBxn?=
 =?us-ascii?Q?iJymqKXuj4GUsuUVaoFrcChzU5MFKWZw+YBEeqezxpPYTDsjO+L1SsbeTeq6?=
 =?us-ascii?Q?CbvDq70YwKzXjNd8Ws1z7M1ulBp9UkqWETZLKwjOfNPrvRFIKT1oPPsrlGXb?=
 =?us-ascii?Q?udhQSj8TvY5rSBeplQYMaH/ZmeDIe4tBkrBenPE2A7eidJ+S/QWcdYa1ceAY?=
 =?us-ascii?Q?JXwQK8lfUEgXlcJEB9bhOmHjJJiVdzIAyyRzNRkwfbqp+1HxAvOlaFpxFk5B?=
 =?us-ascii?Q?ak3CCOMdQTCfWAyjEEpSWz4NF0IIkumuq27YqMsyCyX0VD0Lq7UsEEk0Sm1k?=
 =?us-ascii?Q?8I0n33WbbsvplrTI8qPMBXSI7yU9ixM5MReegnrl1Hr5T6l0Maj1/Au5D92x?=
 =?us-ascii?Q?UYq+zlSWURk4gDeu+iuoFq7mFAhqMeK+hb/56FXZrKmUVR+mq3f98Q2trDV7?=
 =?us-ascii?Q?hqOyx4bZvQ4YwTMw0mRrRciibPEyRa3ptVeTfFBoPNU9gJ5PAO2QU8EiGSS9?=
 =?us-ascii?Q?nrZOAQCOYqC2KKG6wegmL+Op9OO3JpS4UQTqUFKi79tPjbfAMqpWzD12xSnt?=
 =?us-ascii?Q?x325NnXVn3vBIdcKJchxyTy/ss4hM25rCllYBAVYeQYOEwi7rTS/hsVdzLDg?=
 =?us-ascii?Q?FcOxjWfW/cBaSkeTtYKvTYzd+I4VJhBMrrjhyze+FmwoRFOkh2rSwA0h5GPi?=
 =?us-ascii?Q?lonfsRHYYN6oQ5qHrvk/u2LxQsJkaz/eSc1/c7HUENkBd+KkJfa37JfOpEz8?=
 =?us-ascii?Q?Asge0HX5uHUdTIyva6SB4+EbgicRpqciur2lHqfYUrmo/GN/hvPcGzBIXaW9?=
 =?us-ascii?Q?VVf/f0TtnBEMchYazasdtn2c5MdBICk0AH0H2Bm9Fzq8pWBI7e8E9aLjzvcG?=
 =?us-ascii?Q?He4F+mKn+ipQrzdjKf8J1OFOrUYWKQt4t8Rnl8N4V5uWnYwCufoydPOHQq9/?=
 =?us-ascii?Q?Tsj9LJKmowerqk6MI0w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3c40f0-8fb6-4b74-32c9-08de04e2b379
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 14:14:45.6281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r6D4KUCQgnIy/zIHw5zb0YKJ+lFBT0vCET7tx+0AEAsVsHQTcZKu0bCHz6d1hjLt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9486
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BB1C180011
X-Stat-Signature: giwfbztnz5r8fbyd7jakgam3up9hhrec
X-Rspam-User: 
X-HE-Tag: 1759760089-500485
X-HE-Meta: U2FsdGVkX1+pMG+nz8PTlJfEwukBNZlEq1Leq/TcAWluYG0H2JjCKmoGFomnZtKAbxHc19y4z0ndx4E9D2EJF02mpm+tE0eofFDmEVA89E+x+wAsWYltHfqLt7FTemRVLxJ3vsWX7iLvTQqLaIAYr4jQuor7hAqqYzZ+fFDnsTLBSrcDvBxrahCyysX0yabobSfx1cRmn+VrQrwoXKgPF7vbAwJv0xSEoAhjxACfhuccJlsUCsZdaH6i+SGiJbQRry6dD6lsGSCxkHMtIbXCO1/v55O8tA336hg03FK/724SkvaosQIb5YZfCspCtlEy/Py+FB+4pmGdHtg3OfFDC7KIngqw5m9FasUErYi8QgkHvMd/lwfpNchZTZAc5LTqVb9A64v4wWpWLJXz778fJu8D44Cw3/AkUeDFTwYC96Bb5cqRLfZTj4CUWPzAuGzAKZbLJtRyXk0HI3WdJceKr5jatnUgOfCoAW/UpuGZc7/tx+DK8rkqIshtZamGSUX3Fc9+6eViPnjbCyBHxWDgZF1dQMqMDQUYfBrIn37pCiOTI1bfSZTyhzlCFovUNpsR6yyVlInQj0RI575NnV/mpz4kLnkv+V7uxtgOZgKXvYxvCiJ4V2hlq2e6P2LhHG7w0hTVpQd8v5BRSuyW7fJIIANuezQNHE4uekxgf9KAifiVvc7EU26dReTZZ82U38sjLD2MWRct5kgU4/CqXvEFoAMkbhx/hM5YOOaKUchEeOET53xmptmGHrfk/jVtlJbIyErSNtxt95oBC2FFr49KeWrUrYIcqf8++QBLAsDnU89jnrWfKdZ6RK17qyv/aHXMvKzL4IAFkwZsNiPph6XdKAb39nWAQYXgj57I+fjJGAaoFkWWKVhVfTrYmI3G+S9MAwq0wlBzQi6k61LO9BFXxrG644XAVmKPuSFy6Df4Vd2daEo3TTzpzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 06:19:39PM -0700, Jason Miu wrote:
> @@ -29,7 +30,7 @@
>  #include "kexec_internal.h"
>  
>  #define KHO_FDT_COMPATIBLE "kho-v1"

We don't bump this?

> -#define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
> +#define PROP_PRESERVED_PAGE_RADIX_TREE "preserved-page-radix-tree"
>  #define PROP_SUB_FDT "fdt"

I'de really like to see all of these sorts of definitions in some
structured ABI header not open coded all over the place..

>  /*
> + * The KHO radix tree tracks preserved memory pages. It is a hierarchical
> + * structure that starts with a single root `kho_radix_tree`. This single
> + * tree stores pages of all orders.
> + *
> + * This is achieved by encoding the page's physical address and its order into
> + * a single `unsigned long` value. This encoded value is then used to traverse
> + * the tree.
> + *
> + * The tree hierarchy is shown below:
> + *
> + * kho_radix_tree_root
> + * +-------------------+
> + * |     Level 6       | (struct kho_radix_tree)
> + * +-------------------+
> + *   |
> + *   v
> + * +-------------------+
> + * |     Level 5       | (struct kho_radix_tree)
> + * +-------------------+
> + *   |
> + *   | ... (intermediate levels)
> + *   |
> + *   v
> + * +-------------------+
> + * |      Level 1      | (struct kho_bitmap_table)
> + * +-------------------+
> + *
> + * The following diagram illustrates how the encoded value is split into
> + * indices for the tree levels:
>   *
> + *      63:60   59:51    50:42    41:33    32:24    23:15         14:0
> + * +---------+--------+--------+--------+--------+--------+-----------------+
> + * |    0    |  Lv 6  |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1 (bitmap)  |
> + * +---------+--------+--------+--------+--------+--------+-----------------+
>   *
> + * Each `kho_radix_tree` (Levels 2-6) and `kho_bitmap_table` (Level 1) is
> + * PAGE_SIZE. Each entry in a `kho_radix_tree` is a descriptor (a physical
> + * address) pointing to the next level node. For Level 2 `kho_radix_tree`
> + * nodes, these descriptors point to a `kho_bitmap_table`. The final
> + * `kho_bitmap_table` is a bitmap where each set bit represents a single
> + * preserved page.

Maybe a note that this is example is for PAGE_SIZE=4k.


>   */
> +struct kho_radix_tree {
> +	unsigned long table[PAGE_SIZE / sizeof(unsigned long)];

This should be phys_addr_t.

> +};

You dropped the macros so now we don't know these are actually
pointers to 'struct kho_radix_tree'

> +/*
> + * `kho_radix_tree_root` points to a page thats serves as the root of the
> + * KHO radix tree. This page is allocated during KHO module initialization.
> + * Its physical address is written to the FDT and passed to the next kernel
> + * during kexec.
> + */
> +static struct kho_radix_tree *kho_radix_tree_root;
> +static DECLARE_RWSEM(kho_radix_tree_root_sem);
> +
> +static int kho_radix_tree_max_depth(void)
> +{
> +	int page_offset_bit_num = BITS_PER_LONG - PAGE_SHIFT;
> +	int order_bit_num = ilog2(__roundup_pow_of_two(page_offset_bit_num));
> +	int bitmap_bit_num = PAGE_SHIFT + ilog2(BITS_PER_BYTE);
> +	int table_bit_num = ilog2(PAGE_SIZE / sizeof(unsigned long));
> +	int table_level_num = DIV_ROUND_UP(page_offset_bit_num -
> +					   bitmap_bit_num + order_bit_num,
> +					   table_bit_num);

All should be unsigned int. Below I suggest to put it in an enum and
use different names.. And since the function is constant it can just
be an enum TOP_LEVEL too.

> +/*
> + * The KHO radix tree tracks preserved pages by encoding a page's physical
> + * address (pa) and its order into a single unsigned long value. This value
> + * is then used to traverse the tree. The encoded value is composed of two
> + * parts: the 'order bits' in the upper part and the 'page offset' in the
> + * lower part.
> + *
> + *   <-- Higher Bits ------------------------------------ Lower Bits -->
> + *  +--------------------------+-----------------------------------------+
> + *  |        Order Bits        |               Page Offset               |
> + *  +--------------------------+-----------------------------------------+
> + *  | ... 0 0 1 0 0 ...        | pa >> (PAGE_SHIFT + order)              |
> + *  +--------------------------+-----------------------------------------+
> + *            ^
> + *            |
> + *  This single '1' bit's position
> + *  uniquely identifies the 'order'.
> + *
> + *
> + * Page Offset:
> + * The 'page offset' is the physical address normalized for its order. It
> + * effectively represents the page offset for the given order.
> + *
> + * Order Bits:
> + * The 'order bits' encode the page order by setting a single bit at a
> + * specific position. The position of this bit itself represents the order.
> + *
> + * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT = 12), the
> + * maximum range for a page offset (for order 0) is 52 bits (64 - 12). This
> + * offset occupies bits [0-51]. For order 0, the order bit is set at
> + * position 52.
> + *
> + * As the order increases, the number of bits required for the 'page offset'
> + * decreases. For example, order 1 requires one less bit for its page
> + * offset. This allows its order bit to be set at position 51 without
> + * conflicting with the page offset bits.
> + *
> + * This scheme ensures that the single order bit is always in a higher
> + * position than any bit used by the page offset for that same order,
> + * preventing collisions.

Should explain why it is like this:

This scheme allows storing all the multi-order page sizes in a single
6 level table with a good sharing of lower tables levels for 0 top
address bits. A single algorithm can efficiently process everything.

> + */
> +static unsigned long kho_radix_encode(unsigned long pa, unsigned int order)

pa is phys_addr_t in the kernel, never unsigned long.

If you want to make it all dynamic then this should be phys_addr_t

> +{
> +	unsigned long h = 1UL << (BITS_PER_LONG - PAGE_SHIFT - order);

And this BITS_PER_LONG is confused, it is BITS_PER_PHYS_ADDR_T which
may not exist.

Use an enum ORDER_0_LG2 maybe

> +	unsigned long l = pa >> (PAGE_SHIFT + order);
>  
> +	return h | l;
> +}
>  
> +static unsigned long kho_radix_decode(unsigned long encoded, unsigned int *order)

Returns phys_addr_t

>  {
> -	void *elm, *res;
> +	unsigned long order_bit = fls64(encoded);

unsigned int

> +	unsigned long pa;

phys_addr_t

> +	*order = BITS_PER_LONG - PAGE_SHIFT - order_bit + 1;

ORDER_0_LG2

> +	pa = encoded << (PAGE_SHIFT + *order);

I'd add a comment that the shift always discards order.

> +	return pa;
> +}
>  
> +static unsigned long kho_radix_get_index(unsigned long encoded, int level)

unsigned int level

> +{
> +	int table_bit_num = ilog2(PAGE_SIZE / sizeof(unsigned long));
> +	int bitmap_bit_num = PAGE_SHIFT + ilog2(BITS_PER_BYTE);

Stick all the constants that kho_radix_tree_max_depth() are computing
in an enum instead of recomputing them..

> +	unsigned long mask;
> +	int s;

unsigned for all of these.

> +
> +	if (level == 1) {

I think the math is easier if level 0 == bitmap..

> +		s = 0;
> +		mask = (1UL << bitmap_bit_num) - 1;
> +	} else {
> +		s = ((level - 2) * table_bit_num) + bitmap_bit_num;

eg here you are doing level-2 which is a bit weird only because of the
arbitary choice to make level=1 be the bitmap.

I'd also use some different names

table_bit_num == TABLE_SIZE_LG2
BITMAP_BIT_NUM = BITMAP_SIZE_LG2

Log2 designates the value is 1<<LG2

> +		mask = (1UL << table_bit_num) - 1;
>  	}
>  
> -	return elm;
> +	return (encoded >> s) & mask;

It is just:

return encoded % (1 << BITMAP_SIZE_LG2);
return (encoded >> s) % (1 << TABLE_SIZE_LG2);

The compiler is smart enough to choose bit logic if that is the
fastest option and the above is more readable.

> +static int kho_radix_set_bitmap(struct kho_bitmap_table *bit_tlb, unsigned long offset)
>  {
> +	if (!bit_tlb ||
> +	    offset >= PAGE_SIZE * BITS_PER_BYTE)
> +		return -EINVAL;
>  
> +	set_bit(offset, bit_tlb->bitmaps);

set_bit is an atomic, you want __set_bit()

> +	return 0;
> +}
>  
> +static int kho_radix_preserve_page(unsigned long pa, unsigned int order)

phys_addr_t

> +{
> +	unsigned long encoded = kho_radix_encode(pa, order);
> +	int num_tree_level = kho_radix_tree_max_depth();

kho_radix_tree_max_depth() is constant, stick it in an enum with the
rest of them.

> +	struct kho_radix_tree *current_tree, *new_tree;
> +	struct kho_bitmap_table *bitmap_table;
> +	int err = 0;
> +	int i, idx;

various unsigned int.

>  
> +	down_write(&kho_radix_tree_root_sem);
>  
> +	current_tree = kho_radix_tree_root;
>  
> +	/* Go from high levels to low levels */
> +	for (i = num_tree_level; i >= 1; i--) {
> +		idx = kho_radix_get_index(encoded, i);
> +
> +		if (i == 1) {
> +			bitmap_table = (struct kho_bitmap_table *)current_tree;
> +			err = kho_radix_set_bitmap(bitmap_table, idx);
> +			goto out;
> +		}
> +
> +		if (!current_tree->table[idx]) {
> +			new_tree = kho_alloc_radix_tree();
> +			if (!new_tree) {
> +				err = -ENOMEM;
> +				goto out;
> +			}
> +
> +			current_tree->table[idx] =
> +				(unsigned long)virt_to_phys(new_tree);

current_tree = new_tree
> +		}

else

> +
> +		current_tree = (struct kho_radix_tree *)
> +			phys_to_virt(current_tree->table[idx]);
>  	}
> +
> +out:
> +	up_write(&kho_radix_tree_root_sem);
> +	return err;
>  }
>  
> +static int kho_radix_walk_bitmaps(struct kho_bitmap_table *bit_tlb,
> +				  unsigned long offset,

phys_addr_t

> +				  kho_radix_tree_walk_callback_t cb)
>  {
> +	unsigned long encoded = offset << (PAGE_SHIFT + ilog2(BITS_PER_BYTE));
> +	unsigned long *bitmap = (unsigned long *)bit_tlb;
> +	int err = 0;
> +	int i;
>  
> +	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> +		err = cb(encoded | i);
> +		if (err)
> +			return err;
> +	}
>  
> +	return 0;
> +}
>  
> +static int kho_radix_walk_trees(struct kho_radix_tree *root, int level,

unsigned int

> +				unsigned long offset,

phys_addr_t.  I would call this start not offset..

> +				kho_radix_tree_walk_callback_t cb)
> +{
> +	int level_shift = ilog2(PAGE_SIZE / sizeof(unsigned long));
> +	struct kho_radix_tree *next_tree;
> +	unsigned long encoded, i;
> +	int err = 0;
>  
> +	if (level == 1) {
> +		encoded = offset;
> +		return kho_radix_walk_bitmaps((struct kho_bitmap_table *)root,
> +					      encoded, cb);

Better to do this in the caller  a few lines below

> +	}

>  
> +	for (i = 0; i < PAGE_SIZE / sizeof(unsigned long); i++) {
> +		if (root->table[i]) {
> +			encoded = offset << level_shift | i;

This doesn't seem right..

The argument to the walker should be the starting encoded of the table
it is about to walk.

Since everything always starts at 0 it should always be
  start | (i << level_shift)

?

> +			next_tree = (struct kho_radix_tree *)
> +				phys_to_virt(root->table[i]);
> +			err = kho_radix_walk_trees(next_tree, level - 1, encoded, cb);
>  			if (err)
>  				return err;
>  		}
>  	}
>  
> +	return 0;
> +}
>  
> +static int kho_memblock_reserve(phys_addr_t pa, int order)
> +{
> +	int sz = 1 << (order + PAGE_SHIFT);
> +	struct page *page = phys_to_page(pa);
> +
> +	memblock_reserve(pa, sz);
> +	memblock_reserved_mark_noinit(pa, sz);
> +	page->private = order;
>  
>  	return 0;
>  }
>  
> +static int kho_radix_walk_trees_callback(unsigned long encoded)
> +{
> +	unsigned int order;
> +	unsigned long pa;
> +
> +	pa = kho_radix_decode(encoded, &order);
> +
> +	return kho_memblock_reserve(pa, order);
> +}
> +
> +struct kho_serialization {
> +	struct page *fdt;
> +	struct list_head fdt_list;
> +	struct dentry *sub_fdt_dir;
> +};
> +
> +static int __kho_preserve_order(unsigned long pfn, unsigned int order)
> +{
> +	unsigned long pa = PFN_PHYS(pfn);

phys_addr_t

Jason


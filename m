Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB9ACA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 17:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ED4B6B0172; Tue, 26 Aug 2025 13:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4C86B0173; Tue, 26 Aug 2025 13:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3906B0174; Tue, 26 Aug 2025 13:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9AA6B0172
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:08:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAA9B1DA170
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:08:47 +0000 (UTC)
X-FDA: 83819543094.07.56E6A4A
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0E2FE10000E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:08:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ouF1RLq1;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756228125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH2IWF9H0ASDVqAeYaJ8uSYGxAxnr3OC25u4GoHQhts=;
	b=oSUuOwgm63pAWGAsAXZw6vfDM3/jnvMPAGLueHkz4QpxqN8jfpprTTYbNeOBkVS36U2cnx
	QaFYfnTODh3nU0Vp7rKaKmKalEuZG5wZicfEZX5LfpJ8Bj5lQck2PvLxbgQ+QmmMwQRqqW
	mX0Ah/lLSDslwGG8E0xLPO0nUkHJzbs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ouF1RLq1;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756228125; a=rsa-sha256;
	cv=pass;
	b=ZX0VIMSZ/SOOdQJPDpQ52HWLPeR9y5HI/A1zX3l1HOtssZtDNSjjBAW0Mg4Bt4bsqrdJk9
	qubt+iCGKg68j/eHoJg9tH98Cp+aykki2LaBy9owuFSRrfKe1Yz77H5FshFqUvbnlJgWev
	A4fhya+KrsAGmZtsOFOPUWKk9m4r/sQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V6q5gCy8mZ9cOQ7h//qExVXWEuYs7cqPGp6KkBU52lnFdXYhA2S3sj/Q8AAbkGpl8FHQ803FsIXLCKI2ois7yeb1t42ULp7tjOcKkqS9QtM6cLkyrDEQ/0iKmbO54S+hMik+0SKJTwEMRE3z9nmYzsIDcC7QS9SALEytKzm8tz+NoLUC2MvmPZ4QIZ1Gye/Dqk9iG2wc6IP6QHh2th3vlVX4uFrb7NmsEbqqnfeBlZ5BEvAHd62pBCJnSTQ2+aIpknJ2FyL4NJzQjD/eZw5FTVsUzskPtBaI2Hmm+M8ONkENazF7dlZ6qDpHAtfwk81DGRKGEsJVk8y4OUzMkbxmLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NH2IWF9H0ASDVqAeYaJ8uSYGxAxnr3OC25u4GoHQhts=;
 b=sGb3i3yt1C05Ry37tpWPIUz4pVbZ/HLFDjPruAyYGQjJJ5Vg/wrvcPZJpVlvaNyUAB1qXK/cITNKwyKn86ZbYkwERj3Nm+TsLCh4ze+ctCWt+rUjgzPohjWLwJnFkkUcoPvXKb5Zc69vLZC0HIXHU075uW/qZH4HbfQ9vr2ubdTLgwwj+m+n1S50j4qoQkhqYwAzVE/XaQzucXPixgMgkIXuKrSN2jJiC80dRZm928w1Y9GVQ0n5jRcxPtcEv1nxiL9dBEtCS4Fv2P5fZEFpPRcVJS/ZKE0k6lW5x228o0TJrb/io4lXkzD+rHT9MzVxeVhsieWL2hp6VQRbedlEcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NH2IWF9H0ASDVqAeYaJ8uSYGxAxnr3OC25u4GoHQhts=;
 b=ouF1RLq1/jxOOdZJtbi46t8WXi5Iir6RrGXtn9dlFpnGsgc1+mFnYbdcmQEyy4F9ITdRRI6G0nlzneNmhdtHInwGUJWosKw9nqLDA34GGysrjYIWLPtg/5hrOomeLyYlQEHXJFOgfKxtdWypTIFKk/2HirU20h+28xyOtXKsaNTbsC73WH5FDwE/1DkrUH8s4J7uNi1iYITN8JGJ0jI/D5/02kAeSRHicpW66J4HyeU3MxW934hlIBqyCK2BSImFP1bY1ykI6L/hpEvZJtjkQXSWSae7IY4MsyPCRAShx5HFLYS/PAeGAjPokbosgnXnGpfDXb6WBBqJx8yDqnHgvQ==
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:08:41 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:08:41 +0000
Date: Tue, 26 Aug 2025 14:08:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
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
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
Message-ID: <20250826170839.GF2130239@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <mafs0ms7mxly1.fsf@kernel.org>
 <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
 <20250826142406.GE1970008@nvidia.com>
 <CA+CK2bBrCd8t_BUeE-sVPGjsJwmtk3mCSVhTMGbseTi_Wk+4yQ@mail.gmail.com>
 <20250826151327.GA2130239@nvidia.com>
 <CA+CK2bAbqMb0ZYvsC9tsf6w5myfUyqo3N4fUP3CwVA_kUDQteg@mail.gmail.com>
 <20250826162203.GE2130239@nvidia.com>
 <CA+CK2bB9r_pMzd0VbLsAGTwh8kvV_o3rFM_W--drutewomr1ZQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bB9r_pMzd0VbLsAGTwh8kvV_o3rFM_W--drutewomr1ZQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:a03:100::41) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|CY8PR12MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: d266cdac-556f-4aac-515f-08dde4c3349e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H+36CWtAAt1w+RUBXCp36JOnA2yTgdbNw3xaCU3BoksqXBqvz2TSmxiuIcFJ?=
 =?us-ascii?Q?CxNPwGvQnbmUeogDj0v20YRwfCWJ2hXdjb+x9TrHu9lV0wz5T32Zc0Nos0Mj?=
 =?us-ascii?Q?VinSeI/0/qD/iMep4HXSR9wvZIFc1ZOYq8LAFz22w+Wznd7JdZ9mNPoZZTTg?=
 =?us-ascii?Q?p4aTzW/RqCPnC/1mB0tfV+kONvEVLcR2LdXkf/XcWDqn8axVwsjFwGKc4gSd?=
 =?us-ascii?Q?R+SgqvAUsuLEVpdvTIMtBN42Q3vbdm3XqlSdhfL2mbV/vozfl1zvskZ0SPMw?=
 =?us-ascii?Q?EfHokAHHuc+Vm33lqZnm27ZhXn7Yb5T8M9kSkEgyYEKYE4kQWlkqpB8T59c7?=
 =?us-ascii?Q?TbZY/Z3Ub9HhO/pwqYIUW1EU1xmyfn8hyYFj0qj+91glYbxjIfNxsxyD+iMN?=
 =?us-ascii?Q?slhBgVQfwT22apKIzt0l3+HMh/tcU8sA/SSos5uBpW5EGCBUvPy5Akeito7Y?=
 =?us-ascii?Q?z5/fsA2hna73J2IvuzTQZzUACULXA+NiwexyfSYGxIo2CD3WOqwpyykTEMGz?=
 =?us-ascii?Q?z2qpV7VgGFPFpeXXTelaq3m6gkQHXiHgpuIiVAE9RJNLUPuS6Gs0yMt48mAZ?=
 =?us-ascii?Q?sk8EO8qoK328q0A9JmkKsHooMRPXgIYhI1orEqSTqzMcInfgZiV1BcIr6f/p?=
 =?us-ascii?Q?pkOZUO/KzBNIH3l6nyhOL7kEiRSdzvAcuWSxQmTZ84gnsY3B7duv2RPBbNRd?=
 =?us-ascii?Q?j2DzvtdumdB8nmSMqYIjnTwW75OwjqKhND5zomMvUhEIn4zUDfeBvJ0QVinX?=
 =?us-ascii?Q?w2YuZQrZ+F1TtPk5Rx/T1s6wt/TjVEax00AhiXp/c20RSPnyC2X/Xj9/qarE?=
 =?us-ascii?Q?pMeH08gEIRSvvSKW6cNFyaxJxV5ArJ+pIgGNyjTqZdfZQ9LVVzrTA/r9sH9Z?=
 =?us-ascii?Q?HmEDr0sLrYaIwdFpSny5a+hjHV9yHVAlIsRMyh762012tk7qXAts5dcOE3Ys?=
 =?us-ascii?Q?KXVOnToOt9lpxlYeBqPERHOvmBuEnndTs7Ocq93B1+J5VtbVmonAd02ire35?=
 =?us-ascii?Q?So0Mi80BbhRNHY1JYtfZeajAi0gBLTCgnAVoHMwtnm+92iAOzAqIvFRarMYH?=
 =?us-ascii?Q?geWeVxBDlqdn7rpr/piEJwQwJLKI+HEvhmWWmZo/yidojT9A6ZjdDjTwMwfi?=
 =?us-ascii?Q?SrjTkU8a7ERUeWl9/pmvJegozgleSDYJIzUTGBsRue1TL5RqTTr7NnZkMxMA?=
 =?us-ascii?Q?NdIMR1bb3GfLRjxvmlY/kilM15MNPBalmBO4dimbikmgwCQ9iWTOpo9ZleuL?=
 =?us-ascii?Q?broA2uh2mCrskZEJ4a6gbXUeb7Bs5ObgQ+H5rofHKlfg9NMJKFq9qAM/x668?=
 =?us-ascii?Q?U1IZFGs6cZR220bmOGcnfISEBpkwMr+Z/D0AU5wW2IADSk9EaN7bVPmGlPeC?=
 =?us-ascii?Q?0oATZqwbh0A92ipeZaM5eQ8zwjaDWwAvdwyNLLZSibw6Xin7hw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4JjRLjhdJu8Ta6FhTNO/9VCJvIAB0gTDZSbg9ITKh2biE3fTrDcLSeTRViwu?=
 =?us-ascii?Q?dytPQBEDEzsHmXGEwE4Xga7sxRGGeHv446+fgygYpUlZU7mfXWE4T5qDx7lU?=
 =?us-ascii?Q?H7JPjW+PQl745id2fEq57+UOGNwn1tIF8MjTz+gz2Fvt3igVVF6rTtMWMUm/?=
 =?us-ascii?Q?ofdoU96/Afyytb7FeB42ZRZ2100C9j9xJoffq2r0KKGN4TKcXzFPawrUGxAN?=
 =?us-ascii?Q?mW96kNyB5w/iCmJOwyQ+b4ldhvoYy9iaJxAJvXjgmMwiiKlrhjrDToLColOj?=
 =?us-ascii?Q?d93dDiboQwXBJFsRHOK5cE1q5acf82/hiLSzeFY73OElZxEzgRdDWj2+jnb3?=
 =?us-ascii?Q?LYfmcTs7YUlOG8EE2z4s/6zcxVKmo9plDtQNQHxF/hPTXtqTz9lBBLOg80HR?=
 =?us-ascii?Q?yef/8Fd5gJX/0YbQxS6G4nEw96QBbO6OFaEU/MH92VcAW7y7yA8FrTi7T6HF?=
 =?us-ascii?Q?TauzynGOphAbLOvjs1+BdLR8JQ/F+RbRd+NuNUJ/kK1Pctu9SkwWQIEToBDc?=
 =?us-ascii?Q?mfeYb+OG2cr2RHHSFnNdDYqmd6gLKm5NR1L+LESsb7KjN89usdjBI1dRPbzH?=
 =?us-ascii?Q?70dREKYIHyrwdTDV6+XDrmoBgOxAQo+XOKPbPf0bijUBDEqvmEAXSNUIdu0r?=
 =?us-ascii?Q?rKb8r8va4a9XyqvdWpw744fdegEYOdoRYkQWiRzUPpXAE7fj7CIZKtYEtWsY?=
 =?us-ascii?Q?jUNh7Jp0KuvScoBq6cjY8Y7VjdihvbSbK9/G7okc4HmftW8XBL4JRxDVKNkQ?=
 =?us-ascii?Q?nvpkSP8fblyX6FN7Rg/VijdNZOv76MH6cgTFNOrm0ayjzer45q1FBQDhdQnt?=
 =?us-ascii?Q?7BqfdA3tXvgllPbuJ6+PlJ4KJiq5lJS2i0ePXva3+sdQghJMAqP2X9ZsN+sz?=
 =?us-ascii?Q?3RVDYEilWEn4IG7YQK2r4yyaMFX6u4lnWZgJOmaB6LAodLubCej3c9eUeswr?=
 =?us-ascii?Q?MLUgzP2m//W3udnolMpOZUhItaV66B+MVQzC86wkKmVhotBBmO5PFFP+bk6f?=
 =?us-ascii?Q?05WKVSEN9mIQg8keVdlbJioNuNrgJxDL0/6S3mmxzpkc0QeimRxFYbzVCs+Y?=
 =?us-ascii?Q?fFgPN/megyNsnoKNuULDwdL8foat22zp6YbFoLyl5wReJ0PreF4ynrcEQxKT?=
 =?us-ascii?Q?EanNRyA5JcvcAjOU5CXc2OJnYhRptzgGbnRvhtIiS5G/ki1IrT4VOHe5Xw/D?=
 =?us-ascii?Q?uwoQs2ftyjenKsScmKHdqL5I5ECQOWkY1Pis9m2MpSgpC/kA1zNgaiyu/DvF?=
 =?us-ascii?Q?uWti8zBFT0EDbO2/elQ1emTplcs0g4Bi8YhMeaoBsB1Au+G4MAfE/GiP6OXK?=
 =?us-ascii?Q?SdkmJMQPrSHOGQGvY9KoKgLbB+EVBgoQzdIhmMmEeZpxW26Q2WIOnE1lL60O?=
 =?us-ascii?Q?/HGr8P2dcK/JQcTkwinm/PgmPI538llqlr9+PY9mtmU8AlvDWS899fdtII6T?=
 =?us-ascii?Q?Uucn92tYw6atXdEk3HYpW7CIY9QwY4mhZVvROnu/Z4YTBx2iK10NRArm9nnh?=
 =?us-ascii?Q?Byz2Ry4ZBgnrrxOgJE8HibO0eKX/JV4DeRFXjViSKNhaf7alshVsgh6H6SIh?=
 =?us-ascii?Q?3pKq9oeiEYumIK9Bk00o9YFeVCxIX78F7qyaiH76?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d266cdac-556f-4aac-515f-08dde4c3349e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:08:41.1431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nnHM3t2Xk0hrbI/1WXgwM38tWJuEjvSRDJIbTgJtdnJK7DCMLzj98qzF/iLyC/I5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7195
X-Rspamd-Queue-Id: 0E2FE10000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bcbjykucbgfotx6ezhj19yzmqmp33upk
X-HE-Tag: 1756228124-431093
X-HE-Meta: U2FsdGVkX1/0UVOXxEiqY18Dg2QJdJnRZul5y+zQlgL2OjyU85sRdHZ9qNLOzE+0KSuV0YQop2PZxwEmLbGPGHCop4lhdilVyAQ1A6IQx5GzHctWtR49l+w5dC4wUR6rTvBcxEf/HMnOJOaKAqJrg6/YgUR9TjvlVGGElQ42Htkx44sOwA2FomR3b+ZJ+PdbcTnH6XJUmuz8xY/h7x72KcdTNNDGqnkJHaqpUKWYy9DRuC2wtXg7ztmWOGKCczr7RVN7k2qmEEKcNMl0aDXDe9oTwLz/3E50EeESM8aWWCB8ZQpzROKQFbHkJEBNqH0h80YUvaptDFVLDoxe0Rlj125nm+7J8vBeZH7YIPArCqcJmTbFd4gQ4ono36mc+CKe/B//PSWkoYL7F+ME0shUcPAL5y9rbAcklQnDMBAjsfN83L2f0utyVZJ2yD7mDoTM0UrEKPOSolAehzZS0X6qu9ROGAFQ5Z99l3DRjzBTLvKG2cLjy11klWU3w/yjsmJFqbzvd6p6W8QzE0bGtP164QEMlVSb4ZtrYVj0FerxqOItxi68JVdjr32Vqit0vus1hjaG5OPGhcFY6qnLQAdvePQDsNbXVhzkHLjFw2l9XuxJJwKel0+btS8As+5VvgQ2q6NkoluaD+lknnlp/lGg/nVFKagBiAMGTPsVOoCLvwTuss6JFzCpXQOfK1k8m3AiDWXpE8iQFzIAfZptkRxBbKBo6HTvsp/6K7MDQmjvP2uTkDWNzo0QxWDfKcjd+FbdYhTrMMoRmGM1tpFb7xbKfN2j7pvdrfq+RO5eLVCrUSeWmjsfIweYt5/w6tCtuG2ctNmgqWydO3Fw8R9QAKUPV3SRho11/tY5krPFqnFVNmBPGZIKcpLKXHk3BtVHI34yEmAswatmKJHxEobF2GsmHJwFtrJWs5zBJsP0EpSjVabFDEDcM3VcNOfos52VZBBZ3FghmIgnxoWLEW2QMmy
 eKpgQOOZ
 bqpW4m1N17pEFhkXOtLFO387fKewWdkN3SOhF0X+Pzi1z1TZvkMQddDB7SXv/Bfdgt/wPYS4ckjw9KYFQ+b1fs7CQMFkBsNX7Mf8JOIomkpMHJqC0OBCGKt739SpZ0FyZc4XCXBimb94t4vFg4Y3I0DC143N/cX8FL8XJSl6pS2drfMjhUsWIUYyRXYBvd+hDt//iUnnjEPvYTuPn9RTmP6nEwWY01mTbZaedTacKWlK1B6ZsSRSFlvToqRd0dbIXSpTlQqqYxDpieaIhmAkz+ZiW/yDK0lWLTlrnscq/wjVk+CD5dozjUiapk8rjS/VjKnG0v6Vnbf2kg1QfxMsMsxG+LX2ixMQVLs8VUiAzST25RzR4wJSehzyhFGB4sOscYvlImi+rw0Edur28lc8ZxpStHzd+RUoNCEX0L1HA/47Z84A+5u+CaEFtdjcQGdrpH3O7gufMe/y/clAUxfeXyk5lP/Vxi97IMJAytbMgv+0oDOUjthTOIdLbzdvNWc+3O0YeDwaVGkqPr1Jn3mRoYBbo5dTNu7dK+EUthSJIKUGkmbWicPygqBwdgyjEwWzDegkF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 05:03:59PM +0000, Pasha Tatashin wrote:

> Perhaps, we should add session extensions to the kernel as follow-up
> after this series lands, we would also need to rewrite luod design
> accordingly to move some of the sessions logic into the kernel.

This is what I imagined at least..

I wouldn't even try to do anything with pid if it can't solve the
whole problem.

Jason


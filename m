Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E673CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC32D8E0020; Wed,  8 Oct 2025 15:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B733B8E0002; Wed,  8 Oct 2025 15:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A143A8E0020; Wed,  8 Oct 2025 15:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88E648E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:36:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E2BC140700
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:36:05 +0000 (UTC)
X-FDA: 83975952690.12.305B61B
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49A05140014
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:36:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L5XX8XM7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.3 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759952162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+lgYAibXwQIpvIIm3ukGnNLCz5PmNROJeh8IVOxdoU=;
	b=pKImWw2DHJAIZiCf/KQop6wxQhYx22oq+eSxGzn1/lDeFJtqWonfcwSBkv+cJcU/7zJIa7
	KNCzyXYLCZU8+CRPJaSnszM9Kxg4zB3kOm19pZGErJbmZx+zhaZfpNKgSEI7C5dpWIIia+
	aXrm7J1Ps318yAosWokvrCNxBVGHSdg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759952162; a=rsa-sha256;
	cv=pass;
	b=zfEBytzrOWLgVNwm0H8F0bH7+64C0UmgegBB6EAPssgXV7Ky4efSbH6ep2pIRXiGrtpwkl
	urhzfKngJH3u6bvRv8XcU+srqBFGqqg+H9uKvHeJC8AnXN4JuUcKx3Hvt8TwI4+wko6VCb
	2UBrm+xazNMDP16CD981t8kF1YGnDBg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L5XX8XM7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.3 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUiz4nBG4WOkhosJVA3J3BQa/PH11kVhhNI1ZYfjc35WUz0wXhNES0yPAsjEUCTVr+HXr2mEGV5ujtmRmhr630JU9tPzf0An88RWd5U6+zsIwxrJZ65T4xDokVIngCmiRTxyQ1wbMXPKc/dJQzjsRtAEn1QMr5MmxF27YDTho1K4bU+HPfs5xSOjcLd96xysRava3dvHj0gkJ7cxTaSAd9F87udJpi8zWFV1N3FDea/kFuFKEqGnAvmA7ZiXFas7drZ9zE/aKme4q4O7EVoUyDEf72c7fKfOz5V3uOqDPVZwT3g0DcyU6RACO/LwMfZPuAU0gC7hfbelwjJwDmOZnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+lgYAibXwQIpvIIm3ukGnNLCz5PmNROJeh8IVOxdoU=;
 b=TFDYcmS0Ff/yK+y98VVLNB99pIQYn1hfYpk8Qu0y0BHEEHeFgZCzSN8jVCbwovGBJm45xFBQv/AOndCn8fOWdXBVeCCtnV7jtpBDXAB0ljgCCrkC66iIUauTuoO2MXFvvda1WImM3+TTFIgD38CNT6VK6ue9gZbmK6sCe9SGR90pFpKshBxoUtKpc9MqmMUYQoz4LJUbgEQjpIQ+q25melZmxpb7Ho53dEAQbz+2K+OhHSSgauGnOW9pvQPjq4+uebsPwbr37uRVnhhII47FqkP+xN/8S9W0iBwZ4TZJwIbUMD2pKFYWwtoBq0HcZ+cJ5BcCG7TqNbAFQVcictS7Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+lgYAibXwQIpvIIm3ukGnNLCz5PmNROJeh8IVOxdoU=;
 b=L5XX8XM7EslepGZ1IF/wZdFuDj0PmoN4RyyZKvEYYaRlPH2Rpyxtt7oM5bADnb3eCBlifuPqqu2GUNvE6BmSnlZhst4PMrrssYvZzxuojEQLPeowr4nfJ4NohbogUb+0D0MwuOaiCCtfTsRkC08tKSrrwLA6iLI5+2CePvogk2VsSr/OJ38kZRXIQPjiFeF1Pw7q7kD0WJ3/iXEXm8VdmsdvwvSiUU9V+HtxKuG84HiGavEO7YttsNIV9p8KGsqbzkK4rXKOtjhtaAp54VilhEn39sIFw0bHfyq9IUQu9lRT3iFYADzgdoK/oqr4pRKJta9iDA6FxjX0Zb8KUzu4cg==
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by SN7PR12MB6669.namprd12.prod.outlook.com (2603:10b6:806:26f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 19:35:54 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 19:35:54 +0000
Date: Wed, 8 Oct 2025 16:35:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
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
	witu@nvidia.com, hughd@google.com, chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
Message-ID: <20251008193551.GA3839422@nvidia.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
 <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|SN7PR12MB6669:EE_
X-MS-Office365-Filtering-Correlation-Id: b2ddbe27-ce71-463e-423b-08de06a1e550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QMql/sVp5aeTE2DQRW1hBeguhp9Z0CxkvSr94WFxRN7nqmdaTPWx/VIf41o+?=
 =?us-ascii?Q?CgiVcppLyBz2oPjR/R0sDu2bgBIIMcJ/j57B1gYvHAoOxHesEtAu3dQMpyAx?=
 =?us-ascii?Q?fqYvl1E1PLqqhsgx5F3VrV6eTxgt4sKp/v2Xzj9HldDp45I8quV466af/da0?=
 =?us-ascii?Q?eW7Uw1vjjGPTMnH/h8hA294+m4DBYhpTVpD6zjSLIzX/9laRgbqc18i5xdGo?=
 =?us-ascii?Q?CHjwkvnQgoNkoR7oh3pyyAlZotyaSd8G0trBdxx4fkDh095DQ5fEJu6hz8H+?=
 =?us-ascii?Q?tsNw43DLOyT3Evks/xBMM14kn0TCv9HtJbT67AAnN/j7Yf16hUsl+qrY9Adz?=
 =?us-ascii?Q?JCgYlMJMDDEmwKjGB1xSMintryWc6dUrNPD2K7xhSaxRMEV+bybsSmI0X59e?=
 =?us-ascii?Q?x6Za04hWM4pxvmFwSQPNvQzNQhY9uGNI6lRqaU6vjzJ9pieX4SG7lUB1IQgC?=
 =?us-ascii?Q?ueYyamQ7k8+k+GTKOL8cxbzW0GfOo4VXn+ZWs/w09WqLdnZu50+K+4RpANZt?=
 =?us-ascii?Q?QRG8LqsFg9Y91fz7Tz/Soof3BtUfKmOw6KJGfK7iofir0h7cnFIsxJGTXnJm?=
 =?us-ascii?Q?hTgIQ2uADDAKVGvv7+V9JtqHCm3nxnZ0iG3k2txQlK95ygxWyRomg/X9lj56?=
 =?us-ascii?Q?wVp6tTyIyfkUtT/eDWTZJ54dmTBDfvs4XM+vWUy2va22NrZkSgKGo5ruPlGH?=
 =?us-ascii?Q?GC27ZKqVNgOtBfCM8Won7cqlpRwFkbv7cq4WMCvYcbJQHvU1qx36xykEacXy?=
 =?us-ascii?Q?9cc4AQBB4BCdshZR5/9KOImIQgTWMNjtlLyIxRbD2CMs0U/MtYveZsBN8cRx?=
 =?us-ascii?Q?zS5txV4RlZUSgvwAnjTYiQg32JvC3s041zwemPzfJwxAHIVWwvPEG6fvzFj9?=
 =?us-ascii?Q?aqQ//+3SyKNZrzN20CxtnxiK9PC6/TFyMk05HW94qwCw6J4IJwU0ov45daPz?=
 =?us-ascii?Q?gRvlIKKdY7kaZ1vYdC0f5cb+RvFdGOmC4gV0Bimt1IJd6Ul686rIHemQ6Oso?=
 =?us-ascii?Q?JSDDUBvcLwaxuaZ27XO4WLVDrTHPlXsRz5/xvGL8kheczcZtd9w4/6Fa2BxV?=
 =?us-ascii?Q?kZjwPuXJ1OrBhIzNYLRPqzUovkNmdBm1loqnFfmOp0ZfJRoK+ntljh4mqUW4?=
 =?us-ascii?Q?3IoSZ7z8UWUSgf1hNc6ExjoFP0YUacXyxpUa1a2CgWo3BPxc5c5jwqV+qyEb?=
 =?us-ascii?Q?PgVWrpIY6AsTG8jxv7lMF9FBDZ3egnSRRGw3QqWErgg4RyZBZA8VNF7gy2PV?=
 =?us-ascii?Q?OUVAn3W7c/0542I99G1DHKX7oBsa9UH30AOLLIx23LCLhPECs+XUtNXA2xa9?=
 =?us-ascii?Q?d9INEsJzpYwm2PRvuFl+vQr6HnT8ImewtiOWktCqdLQBeQVXdNOheUP02sxr?=
 =?us-ascii?Q?f3DGjDwlMS61ItUIwmruGUmh8/Aj4B8JOht7Rlt09Sxxxry7UMPtBW93khMQ?=
 =?us-ascii?Q?mDJAozhft8eCc9AusgMtMPYmCxPpEydF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B31ShBGf8lJA+QAyPOfJBeeJdUtiiskST0AmrGJXnY9mDUcxLHZ0kcgGYFRj?=
 =?us-ascii?Q?cY3KNiQdmj30BInKuZA8ppy7z00KEq86aV1M3NmXa0GuuCXnPtGvs5AUg7tJ?=
 =?us-ascii?Q?aqlbXF9COZTguXCL1a4x+t6t6F6czdMtkicNcrznNFSVayxKVpH39Wnkii3a?=
 =?us-ascii?Q?9mdpMljk3hYxx2uX6+bT5akTFtk63Vl9zhtHITSPlld5b9Lk6EaYEFWL10wx?=
 =?us-ascii?Q?guw98rlMB1WX7A41wK9phrCmQhOO8DwR6+z+N8pHe1xLAT7enanW17PyWeth?=
 =?us-ascii?Q?tOQfNuPz2YaoZuP4lfNZCtDC1ijcm8ARLIpwAo0ssiExlzYckHcH7NYy2AIE?=
 =?us-ascii?Q?IMLCXQjnsNUFe4cB5y9xTW8IqnwQb6MZWtUYyvwGbW9Q5QXiz9ESwXcURnfb?=
 =?us-ascii?Q?GRUw2Ca1h4idkaE3hNdxVlZdTKwEou1SEblNgwvwWUO3Cxz51Vvs0R79haCp?=
 =?us-ascii?Q?QvOsZWuIB058VP+y+S159GGvU2yUFC9KfgzOvBpHZrdW77BUyt3xr1nC6Hpf?=
 =?us-ascii?Q?hB09fOOx89TGp1Q+0ki0QWdGqEFK37tzbcYQSVH7jiQy63E0fRn+5LvHFfHY?=
 =?us-ascii?Q?fQgliqxR044HytFdokayn6iG7Iv0J85ChxxC01qtC7lMu8wWU2yJfW2FsmXb?=
 =?us-ascii?Q?TZrd5e5+ndR8wzHrPTbhCj9GcCGyzYU9jQgSIGS2F35HEsJhifskTvoE2K4K?=
 =?us-ascii?Q?iveipCGJ8Cv8mrxcYt2f7C+u/EAcUZ89f694Hm/th4xEsZItyS7A/J3Id+P6?=
 =?us-ascii?Q?YJ+OdyNldbHK/rV6UXMpXH/aNsbqGjVDC1/7VY2CXguCTuvzFULC/b39O81T?=
 =?us-ascii?Q?2UKAmL6XFDN+aYJguOFUMkPZdGuKjw3cTDCOvZp6fQ1M9rSaX/4wHs+acCU1?=
 =?us-ascii?Q?VqXOUT/47wnOopDn9Eq1lsL2SPLdtUuBLcAek3T5sn4BbOw8S2woC09MWMTY?=
 =?us-ascii?Q?gD5OwpfPfNppfW0erI6AuXggH7pxydI2AAxSi/PvGBLfAM1uQrokaEeYp/4f?=
 =?us-ascii?Q?sH0rETOdGwPPEynE3nt3vsGmXlQMtyqxFDNWGVIZx0MTt39QkZrGTj7Q1FgS?=
 =?us-ascii?Q?VYoCi3ObFBFf8P8+wBDK8Ar1b5GDZ0DoUTRRlQeXSoypPoCiOOoHZZvqYdDE?=
 =?us-ascii?Q?U2+PJ1d5DSnCjPobnc9TF4OvVkz//9BDUDx+fiDqBZB69WORPcBSazGee8ls?=
 =?us-ascii?Q?bNhgkWSE6vdFW3METY6ryQO4rNhk8eqr53GHKM1rvzgTLqcCgsEcVwOGJyvl?=
 =?us-ascii?Q?57pdPSg/QoxQIXyNef1xI3ViIF59wfZI2LC5gWoSCx22hIMXM7guTjrXANVg?=
 =?us-ascii?Q?ploqT2EThmogfZMc8S/lS+uZS44ju7BdD7z9jd0v1iPQhx0f8wp2vl8K9h69?=
 =?us-ascii?Q?7iIJXNzn7mS50UBXNKw7zP8oDlaCjIUxvUKybqrPy21a+tol7TjQRGy32H3+?=
 =?us-ascii?Q?bzytdVVTMPaxpwqCfMUq80J5A07GLK2h4iVi3eoMOs3fFauh74ilINcpoew7?=
 =?us-ascii?Q?vd6qx5naQyXtfCbmXPKEqE41f7FCqPm3igiHPJi1XxCq9VMPmjaWdhVqqq3O?=
 =?us-ascii?Q?GWrrgHt3MqBUpMAIXpENNxiks83hxivrf2KArTSn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ddbe27-ce71-463e-423b-08de06a1e550
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 19:35:54.4565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NyDJv+Wz4VQrLU6LfZy81J8uYpz6JDea1aiVAR6pNbosWOLDCSCT/oUc2ao3DdtD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6669
X-Rspamd-Server: rspam05
X-Stat-Signature: xy9n1ufobn3zcndnaaaopkmqme1mwd4w
X-Rspam-User: 
X-Rspamd-Queue-Id: 49A05140014
X-HE-Tag: 1759952162-594258
X-HE-Meta: U2FsdGVkX19obwqfSSmHoRvrjBkrK/UDzHBjx/nqRNl7OBxoIbjC0n84Gx+QISCdbvC07SpkbnwbytzkHJXwhdrYvUSBNWj/CaYYUa7lMlm3Q9txU7Njr1iUDd2ojbSlxwzM5txOiozeoC884/Ma+A7bIn7oiaMPLWEXmm+NrnJQDts9DpAI3zHNa91vK5i6oYWUMRD+Pel6FfVOp9e60spKhXC+8ub1xnqHzCmjamCyfDDxYBzYU5REHQxppQo2TrxGjZBiLM6QokiC2cSY/QlUksHQLNz4wI34rYsBAi2H7WsM+AqJMzl1C/vaFXFR5pbQyy3+zca7F+VnpkVSOJlDWBITx6LgHNj/B1Ps0FBjIPVtDtNTkGgYf9QaVL7KEoPPjytGKcyHl8ek8FDggRc0bU/LlNEclAOvhkeKyhUM1/i90Q9OBOB/oivFaBRYfZsi7WOLGl35zCpU25VF/Ve6C7OoxYvgEsZTmSjio71qPu2DMAm/yVvWj3Q5c9ql5y73GTHeisfVgiqelWm80XdLdtUBtFMHnueKRSLBE0jf+wfb+suh3cSgOBDyrIE7VTUc2B3siqnFK+6QOXGlzNNHibaB8vl/V8ao0TO+QFnOprEFVtv6mhO1DgBLZAJ5LaW3KI/OU14j6L18IiNIhg10GKURtvcNsQTJSRxeOoqs9VeoiLOuOMnQWDpM6hHvnzlhafesT2HxBdcOoxjECf3XaVikly8QdjPP9SD0Q+q/FXBbr/OxUMhWTvXfxT9ZNvzQhAIn+2IhnXK4M5ehFwEdALl10CKuqyOn0O8T6thEvZb7a/bHY7Jesng2U2bukZQOK4mtnuU/Jo1evKHYZKX2TKmxuoQRW0Dub9hO/4wG2pO0vSJIwn4LEE+l2+fvM3LSzvu6fhe+YS4EX6XFX388PPet/zHxGEm04SQikQf76k1ZW0mTBC4vZb5qbJz4KYm+q3F6WK2GZMf09aO
 Y7IigA1o
 2SrB2AB0b1kD1MbnwYAs6JLe3Irri5pv//8WZdhSCK3fwuyFe16z8NtegxjMYeQIOXVJenaCyP97w/LaRGSg4BkQzqSAAlLSWebib3J/uKesAPfRxGSZ8EvA6UuMCCudUGZjmWcoV5NcBGmhDc7kfdtJHsVj5gMdH+O/mZOVMnEVpJtYzxhaK8xkbCrGhGNhwuWkrcqIFmsBCgNVIzB4Qv+3uibYVA7nDOhrxJNAfqkW0/1XSfqvL8fMeZCLssRMg01aELEDAurAn89NAr2uSU1CiE+NT657p2Db5fZOdiqAkhqIin6wPuoZiyrWY3/HixhCzQdETaj7nKDq8Wad6wqOP+AbyhdSTrCqdgFPnYY1memS+KygnCb9PutbxO9apFG0aei+7hHgldl9vMX6KabVhGjV86fuRCcrb8tq/1fB0Xa/59HfTgaVwWozc8WkxDN47yucwj2TEitEzV8Nl47oevfw6+pVMMv8S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:40:34PM -0400, Pasha Tatashin wrote:
> 1. Ordered Un-preservation
> The un-preservation of file descriptors must also be ordered and must
> occur in the reverse order of preservation. For example, if a user
> preserves a memfd first and then an iommufd that depends on it, the
> iommufd must be un-preserved before the memfd when the session is
> closed or the FDs are explicitly un-preserved.

Why?

I imagined the first to unpreserve would restore the struct file * -
that would satisfy the order.

The ioctl version that is to get back a FD would recover the struct
file and fd_install it.

Meaning preserve side is retaining a database of labels to restored
struct file *'s.

As discussed unpreserve a FD does not imply unfreeze, which is the
opposite of how preserver works.

> 2. New API to Check Preservation Status
> A new LUO API will be needed to check if a struct file is already
> preserved within a session. This is needed for dependency validation.
> The proposed function would look like this:

This doesn't seem right, the API should be more like 'luo get
serialization handle for this file *'

If it hasn't been preserved then there won't be a handle, otherwise it
should return something to allow the unpreserving side to recover this
struct file *.

That's the general use case at least, there may be some narrower use
cases where the preserver throws away the handle.

Jason


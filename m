Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66218FD0062
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 19:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE9A6B00B3; Sun,  1 Mar 2026 14:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BF96B00B9; Sun,  1 Mar 2026 14:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9609C6B00BB; Sun,  1 Mar 2026 14:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 844506B00B3
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 14:22:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22D1C160728
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:22:48 +0000 (UTC)
X-FDA: 84498466416.19.815ABD2
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64D6D140007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:22:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c2+ypVPX;
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772392965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=viYAM9CMMrheWaoJAuhbUd7ugZDuQps4PQRsLmCMHtY=;
	b=jL+G3h0b7kfLZaCKYHBF6af3NZ5BYs8s8V5t0ItGfNAt+d8esqooOuhzMcSLPHCSfzkXaY
	ZqyeLpGO4FpKY7G7rroZbftqVct4HuQkVVd9rtufLFuBb/sCEccIamsIaTBxqnPZ+ay7Nq
	2llPmnoCkIaASneEmQkLq/qWuEFIjkA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772392965; a=rsa-sha256;
	cv=pass;
	b=Dzw3N6FqB4sItfY1yKLLpCFUx+RO6yh4R3l/+k7XnmbWw3xrzesCtlA59/iU88sw54knkX
	Avz+SiMuhB99f6foMilAUcPtlAQfvJP+rue1q2Ea+yySpZSWiHEBWKTvMNuXvXo0mCEkJd
	xMcLiqYzJSFYJ/thwPpF5MGb7XlAvnM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c2+ypVPX;
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dkWNq30D194C6xvSahys8Tqf3HbejmBTTsnPGc44ZNPKiM1EJawSSzZdz+R4tP0Er5S2Mln4XBct3sxHnUl3z4Eq8E6w6y6nYN/77MttZcS7x2FJt8hlz+myupAIIjX96tb0+zi/PaCVhxpjjv8+ZX4qoRn+qCrvCwVG1rBqZ/5SRakuzoy+Xos0tAJWlSx9R8CrCYcZEccw1XbNZ77aZkO85JYhWBDcBN13PROy1Lz/yfthl9GObP7qNgRaKLIaRs2iPmJqiffkSK26vpIe1GqXc2g7GH1oWnO1WRn6TLE15VFipKiqLbA1pSPICvHgNzoms9QpvwerNc6CA0ieyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=viYAM9CMMrheWaoJAuhbUd7ugZDuQps4PQRsLmCMHtY=;
 b=nA94cp8l3oFxzK9E2bWpEW6RcXeRM84X3oNWD33RY4zOQocx3ZanDFz7hnXLoOi3o3pqrZb/bFxbqJtnbxg1NVrmQaqRT1rqX7eJeJxOODRFFfZV4l7GSUY7Xe/oQ+9Cg8IYecPCoeovqI+KQLwS+zJnykQVBPQ/KoOy6OgfiGb8BntaQHDun9jCb3YZNb+OkkF1z9BHxzwQ/vNHU43uFo9vmHNsvzfGnsF0eTWWQ+QX8TwbdOVb5uu+HuAe/tclZty9LrN3zQyJmi7FC6+AVkuLgwgofWzSTKeqi74dDEhRM/zZmw86W7ZftuF7Z1STnRGYqEyEgJ6miEQZVEJRGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viYAM9CMMrheWaoJAuhbUd7ugZDuQps4PQRsLmCMHtY=;
 b=c2+ypVPX8cbAnblaKUUmgL/nKP8PfZ0JEhmfhyckGaT6x9ocyQI2TgaSdR6AG1fYNxney1LRz416lut/vm4uYdk9hlMZ2nv8pw13QG3wPYqc/EQRHBKaRo7Wyqh/KuvUa77wXDl7YLX4ofpAAEyy8BgRDOJVv+wKZMGNFKPleGSWoxFxBS7C8G7yB3NGNpJAHvo8k6RPo8/Vde87Mdu9NA1hR6IQq9CBQVcYb7dKoSv01tS+JAZHQrkL1cwNKyj+0B6K3/VDNSfh2GxOR+OnaUjO6+SZPMHc+cZksFoDPBXz1tsj34bkfg1NBNehuxLZFBV3iO4Wi374p7KxklcfQA==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6591.namprd12.prod.outlook.com (2603:10b6:8:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Sun, 1 Mar
 2026 19:22:37 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Sun, 1 Mar 2026
 19:22:37 +0000
Date: Sun, 1 Mar 2026 15:22:36 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Bjorn Helgaas <helgaas@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <20260301192236.GQ5933@nvidia.com>
References: <20260129212510.967611-4-dmatlack@google.com>
 <20260225224746.GA3714478@bhelgaas>
 <aZ-Dqi782aafiE_-@google.com>
 <20260226144057.GA5933@nvidia.com>
 <20260227090449.2a23d06d@shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227090449.2a23d06d@shazbot.org>
X-ClientProxiedBy: BL1PR13CA0314.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: fe80e150-6143-4081-09e5-08de77c7e5de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	OUx9x/pvjOujW2q/tHEaXG/+dMuozxR4F2zht1BCOAHYzK/ERZ6RgCWcZopEBLA8wDrbp1EP7ZYV264wA/8V1/1NIFpxstOP/kIswdZl9Yx1bzJ9xNxpQkfUVpw7DEJEJikWSNGCgyUmXVcp1JyUDPdAa44emdkDDKu3QAKe+ci/lnkCvlNhysLo6I0wZMqZTodXw3+uP9/Ot3XOMbyez57ylyCK9f8kOVQiRRK+LsdtK75q7xcjuGotAurl5ROqtKh0o6VIfqPkGIL8wmWW2HDF5un4AdTbJf+5LDIq5N45mnBTnctTJnWEFziiP59ZlIdTxRqEntb0H5LXe1ttF2AGBSE3cEieNgNZojg9eN/t23ecDAL465DOz4h7XO4p3GYZFZYxiezRYVm1NTzuJP9grBbHrGBC3SE4FR64GStCqiQddF5ou2ul1T07Dv/K/93P9Cr5PqvwHHekRZxbuwA+iq5Aq1KpPlQneZe2xsT6KEQ03DqQWUcm95qMgUGN0b6youmAtDoP/PZiXN/kbkz8qhzxlwRzbcUGnTQbISgARGV3YZkz4yNtE9dhodRdo9AW7kYizjC4Bwh5P0Qrs4wePdnEL1XgNxHvklSTzBEQ42ilEqvvYNuaVqzJkmDIbdMSfsyi7LMcdY1lBO0F4JczvkERlzbLJr4YFHgP4s83ItX05AF5BK3+4h+8W1bt1+fgq6HYP90VTk1SpaC2JwN2ueGq2xH6cuQ8jXIfSUw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5ul25RFEe+YelWze2dRfuou8VUlEhs46CNba3cHVkiC0UqGwSdPUh07fIrqZ?=
 =?us-ascii?Q?s6SAhSDeJXTLegREOeg4jr+qsdsUpZsy4jogrEl3F8nbTZzaGPH13hSM9cQB?=
 =?us-ascii?Q?b8CS07wZEjJPUtxlSN8NuzO9Q7naHt8t0MIS8IYKt1RmPOchFIsup6Chbj2D?=
 =?us-ascii?Q?VituVbSkINt/GSWoJblCV4L9+EpNvqQaegFbWYfC6yTq5wkkoPQ60+anKqJ9?=
 =?us-ascii?Q?pbTyZALLRDEXB+2FCLc8nBtPsUXJWoAOnVTuhd0p8RqTnXtxLKe3RlEH5lqW?=
 =?us-ascii?Q?pHjM6f2jRAPbk0cHUZdAgUBzCgKX7weAhTlaugY0O4SlyT6e4eXVSYirJY0/?=
 =?us-ascii?Q?KBxgi4cBNoCIdZU5T5Y7NTexAfpcs7t9j2nwWu4acq/VDWEkked7dZAm+LMH?=
 =?us-ascii?Q?rRl8zqmkCBv5R6bsRJcDegH3qEXFO2gKPkx9u+2BbiAB5J4SNR8f4W275QRx?=
 =?us-ascii?Q?Uz3FirwZBhW5Vpk4xHra5ETRM1UswSRi0pToq2rhcUgYlyuczW2VsfqhLsBn?=
 =?us-ascii?Q?MUSCLbfESXOo+g2qMY1SmqoqsoXQ89dkJ/3TB9+LmL9hKC5RaPuzOyb2HXxW?=
 =?us-ascii?Q?kUG6aJW8Sw+FNAjtHUE+IYIaH4YPh5NzFmP/IUlzkuC6Mbsn7GqXcGQVLLxP?=
 =?us-ascii?Q?vYgQk8XHZ9IHZZEKPOfy+KPmNiQZpaj7tpK3DP0VgYCFTSzWwwaRWcT3BP98?=
 =?us-ascii?Q?JM5+Qs5slMDacUzuYWTyQBgy/+xb6Ux7NZtpckq7VQANL5oC62oSug8ezZc5?=
 =?us-ascii?Q?6vK9xGlFBbz1HhPWJm7qiEmBBcPPBqzaV66297NFFG7+Yw0uVMBlA8qJ7U7n?=
 =?us-ascii?Q?JPWep7IRjzNmiJaeXTGmxUuBgOTz3bgHkH/EwNqmy3+MLk8E0FC/BLbz44OV?=
 =?us-ascii?Q?0ZI9TpkHldmy/omFF6ximM0zdPIXKIqsnK81AVcRxBcCAhcSxLvNcHlosriH?=
 =?us-ascii?Q?Xwq8jlsenrHi0i7pIyz23TQdushE/6HM2GsrsglzXb2oEONBgNUsUmG3GVNW?=
 =?us-ascii?Q?LkxTiJKfM94QiVn5WsSHQ3hCuc8uI/PCGvog8ON8rTEmo4TAOEcVsjsdjD2t?=
 =?us-ascii?Q?QTYIQvb2hgWrCPCjEE/v9CuHkzZ9VD3et8QPFCoXViYYvOXe4HL4YAemstcd?=
 =?us-ascii?Q?tdCNnXvKxmM0QMncbeTTdV1r5o7ZVvO2InxlyYHWIKEm7566MlHuuJLSpL0j?=
 =?us-ascii?Q?WfUr3+VAhIUEVNiL1cqjlR2R+zgk0vUsZC8WjXCsiJ1eZDBIxBW1jDpDmbS7?=
 =?us-ascii?Q?ublnQEaBWSnzLDOJfobYBexkZRkBeO5tyuMigSlLMJZNByH3TwgdJnnV17cn?=
 =?us-ascii?Q?JLmBc4t05B9A34XEWwe9sGY/Nize9W/QqpqljhpJtiobb94foMD+r6NswmlZ?=
 =?us-ascii?Q?JPU018jaqnnmS35Kx6lQcwBwn0tGy2jmd/AEmRn5qFlsGgoLXJONZBZjOi4N?=
 =?us-ascii?Q?CeJPHBX4ensB0fRdRq2yIAhswOgF6MnMqWE50TvYdtsDBGmIgCA9EI61NhBL?=
 =?us-ascii?Q?t1NiMc2sdLbyFVNi5X+XS3CYl8edlnaua7iyHM4qJfJtWmfef3cG3EKolFom?=
 =?us-ascii?Q?Rojk7WLL4K08Adu2qYnPYUYw/acOQjVuIJRJ/L61wUQUoYqhr65v88Ta97hO?=
 =?us-ascii?Q?IH0++R7RnF1he+UErcoBK0Kdlo5TZYKFnSYFHgJ01GT3s/Mt69CI+OORDFju?=
 =?us-ascii?Q?C31ePlWLEhQUroOQly1W46bP/ZWPrAiq3tdBXXt0Gr26MUn64ARZdCb7dXVn?=
 =?us-ascii?Q?dZGUAEjhcw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe80e150-6143-4081-09e5-08de77c7e5de
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 19:22:37.3998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGwK2QFNUuJsDoDyJi26FipSFf/XHp5Z0k4/5ZOdgJpdv5zkwN+2BaN8S8RwmPFz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6591
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 64D6D140007
X-Stat-Signature: s5ochzyfw6ohqoskri616k989hdwajwq
X-HE-Tag: 1772392965-342449
X-HE-Meta: U2FsdGVkX1+KhMcazxFa92bHo3nPpd0etSB3YvF4odGJ14eianWXXPw+TqIyMJenzLgk+4sROzKq5AZtTZXrHS6/Xo47N4UmKJrHQeCvPKVQzDLeI4HhQ981Tc6k/fXBxHg7yJmU3rCihq7XXLa/hSLgwr42WdXq22+F/B4xYupftBZYaRjUn8a1/Rg/iOjMIuAmBYL8WsoGuPOZvmLerACfhioUfhj+qJfi8AXT66Z7zMu0ylASbY3oVH3yJov3vVboKnYhznlNghRAF3Cuw3fr5VrwcqhmY5x9p9Ev2Gtctd6Butz9LQS9LHmapD/mSFPtLesdnrI31q/TFhNLGoMx8rimnV/7EDd882beU+it5yHLheXmAsMc2CIppdiAr9ESzUVj/wnHPeMdrYPS0yvFCYYZxDreEfTEkd+gKjlcIzduVfbvJ91ZRvwjLW1sXISLIzctECUknk8rxJ9RymiTdD5BV9ibXMR6Gxagiv/IN4uMz+YLbj7njOAfDZquYaI99KfZQN0isV8cMq4sJIIC2JGMXcB4Ku5dE1Q/64+5MSyxOllFLF5nvuDQEcPebgMOnXw8AT3QauUN7e+mBGy9V32LvSejVwm/JtNKp7dODW+saB/tkaRPEu8hrXgSwgviPUwXJtkq82dRvdG6/T/qWP0EN0COPkW9FP1j+ksVjyJnowz+uuKJfz0n4YoboKvEcnuw9mM9nDN+kdvjrD5znHStu7Dd7r929LuSESsKuoG9/qNiCMdvJYbhZsrdkH3yqRW3qCvU+Vdpy6xkTAxBtR/oREhlkdeSTPQbfFxec+m+Wyz9Xe3JnfDUY+PQok2tJKA0Yj99RpVsdSkD4nH3t45fSJXzhMr0DPf8jqevNosnsuMwybRL2u9hQ1SJUWap5fTKtYcjMnDqihJZtkeJmGcCTWVtHln+qFqKDzQCOR682UDxeAZBIJVphFO2t6JS3+4EXdoLIj/YI9C
 RYMC28Eq
 ULYvsdKVsor6Wtr8mCb+Nxp1SsEEa/NOmIiV9F0P0nVGTIx57i1VYDjEwAe/2KqNG+kpJW1bvZpbC0DEvmFhu0BQSSY65IJDqG8YDWhZhWyaxkA3Zhu2ur9a1SdNrWSSnSfMbljO/RhULeZGNbGfme9zv652I5Bmc/I7/NH+BCNeq05vftUuh7XpT5kwpdzd0JEl6I6Ek5HvWDp8HDBAgF6Fi+x8ghZIVPYc//VtwGoshFznn8ayBEJDYwaSzbiDBDlIv941topaWFrE+196rcq4KQyIC1sGZwnX0NQjVED8X/zG/8PPaTb63TDNXolhyQpBFERAZC/8w46ut2H1uSXfTviT7qidlaix1zUitPFz67hJQH9i5MPqeQIh+9NjKlOdSEd4tWhUz07/AMjdGgRwziA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:04:49AM -0700, Alex Williamson wrote:

> Not only fabric topology, but also routing.  

Yes

> ACS overrides on the
> command line would need to be enforced between the original and kexec
> kernel such that IOMMU groups are deterministic.  Thanks,

That's a good point, I think as a reasonable starting point we should
require live update preserved devices to have singleton iommu_groups
on both sides. That is easy to check and enforce, and it doesn't
matter how the administrator makes that happen.

You also can't change the ACS flags while traffic is flowing because
that changes the fabric routing too. This should take care to enforce
that restriction as well.

Jason


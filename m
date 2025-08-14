Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09DECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C97900164; Thu, 14 Aug 2025 09:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B641900023; Thu, 14 Aug 2025 09:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DD1900164; Thu, 14 Aug 2025 09:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 435B2900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:30:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F23C1C068E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:30:16 +0000 (UTC)
X-FDA: 83775446832.07.D232B09
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D2AE2000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:30:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpEH6Ew5;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.67 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755178214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaWi2Hgu8Xn6tm7LGk8SRKLPh1+z+t2fs6Pbs6V+xpQ=;
	b=8VRF5AH6TaoSB+S5mKcN5AGvF+vxHmTk7RAGyYn+w7zgcPVhB7h4g9asFK9oNq1uRVY8Sx
	oqnKx/OrGSIRKv7diXWngimvSLtPH0CSpOf9sMM9curpVEJhun/hgCiVf1LuvVnl8nDIWM
	CQs1IcFo9uw5dZYvqEmk7SG8/ntjPgo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpEH6Ew5;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.67 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755178214; a=rsa-sha256;
	cv=pass;
	b=3f8P3XUwDodapgPXkcwioc4cC3xqFWp7YoH0hyHBO3nVkrNRuqfYHW7P3Vg8/y/IXGKIie
	NGkkaRFY3QAjcD07qzwenlteVwGihAXu7e/R9+Y+5r7PRKlLzAXFf0YdepGpNS14k7wuiD
	Xy2KDgZ6wonGqAPMdvfZ7FoKJKqQYlY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZlPSjHWB5Qd+sjbT1IdPWwAr8ro89/6SprGvO7pfx1/rOtE0oUZpJI8zkYtQnbcH1el90OEAGGqvQpyQuHERhB0JfCe7Ms32QsbjAUuFLGNkUMw6+BCk6fK8RSfJ41k+4auWa6mqHHotc2NCouXHuqlrBXkluY29icxAsdG5HswLYZhbkdzC4ajvVVosO4wA4XG30Wxra05h5+jlEqG4ghMz8sT4DpPhcbx50RSov7yUx812tr3xeC0D95PixUaIk8bM/Eck50oTL586AQWWfkZhmWnIIvlu7IEuWKXyUO5ggfia7wkSR+BpRgsqtx3rHFoMk9XoRJ+AAHc88rvdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaWi2Hgu8Xn6tm7LGk8SRKLPh1+z+t2fs6Pbs6V+xpQ=;
 b=hQ6s5wU/a4dPZMAOMz/tBIGKPXsngmSpUc83kC6Bn1/YuRpGfsIibkz+vT1e/oEP1CJix5H5XZIjfEaAOyeP9x5LoycOov1BulB3uaDu75+/ui8J4toLO01oQucip+VhmVCvbhT49h2TGKiSh35Obml+R6VUlxxWWD6VSlN0yscI972XIac7z2ufFV53+N7s6Sh+jbtUj3cjn9ol6s5g+SkfiogxSrceepy+ZYRNnkQkMEsPd5K14s/PrBYLnjhHxrCg+i+GED7ywSdtHpyqG2o4xMqs9+GRzown3ka2HDJKLfB8lxfXeomRoL8usuv0Fe5Ku081nxYxKw3RnzrOSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaWi2Hgu8Xn6tm7LGk8SRKLPh1+z+t2fs6Pbs6V+xpQ=;
 b=dpEH6Ew5hrWfUXa0n3cpN48azlxf9vfriS48jSlDD2jh/fL6uOof26bSlVCSoWytE1VVTMV/VY3uEIX4z0jNcQ3LJRkIfqm5UPugaxmsxLnh+kuA2ZkrZfQsnvYO7MNf7EEKJUBOju0aAKQ//7IFayIDiPM2Su6BYhxul1VEIjBODzQTtU8F3O+kHTwput5wvDr+BosmJT/ReeU0cAylgfIs6XbixbfPSxv06w+8EA7dTNDgPNPJ61XVLPH10TLxo7iM4YLDDcZ+FERoZBB3qW60HGZTjokZReJESVp1NWSN1hXchmLNlEaPxsYU042cN5rJ5vd+TXWVSqYx51Whqg==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB8965.namprd12.prod.outlook.com (2603:10b6:806:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 13:30:10 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 13:30:10 +0000
Date: Thu, 14 Aug 2025 10:30:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
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
	witu@nvidia.com
Subject: Re: [PATCH v3 08/30] kho: don't unpreserve memory during abort
Message-ID: <20250814133009.GC802098@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-9-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807014442.3829950-9-pasha.tatashin@soleen.com>
X-ClientProxiedBy: YT4P288CA0014.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB8965:EE_
X-MS-Office365-Filtering-Correlation-Id: eac63462-1ef3-42cf-1346-08dddb36b11a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hVrjPVA/K/SJjd9Q0XnFuunrK3VPQI/nY8d7Cd6CJrzAXPwn3ukgI0FWCt6g?=
 =?us-ascii?Q?e0aKTu138b/cFLUjh7nKwqyOV7U6YAjJ9A6uOn+Un2nJ/cECnyeKACIIsdLq?=
 =?us-ascii?Q?SJmkxzeet8F6MjEw4hYjzLFncf+4A3IqWuZfJoZjEDNaVBFy3BBjNfYZnL/1?=
 =?us-ascii?Q?1xCe729aW2RRJ83YSzNdGnCSXr/lcL4AMqQba/258jHdatwfKzInuO6IOenS?=
 =?us-ascii?Q?HNjbKoZL9zIWAQ5kShzXSVqSWMAvgs+OYJKnflsVKQtNDwrYFlZ3A6RQ66Qw?=
 =?us-ascii?Q?/MYLuKFM5qRjleNUZyE/oUiKAFFF6suVnZPzvek9iCWyHMbY3fNy62QyWvLF?=
 =?us-ascii?Q?7QyGnE1G232F5uUTxpRt+s49SnhZCAjGsvn4lk6ZUm6PoGNP9OngXaPDaySg?=
 =?us-ascii?Q?G9MVEbyUZ0UHSbegSx0QtCsCerk1+nExhC9y8TZNpL5VS/acK/WlaYTg1Tyz?=
 =?us-ascii?Q?V4iEJfTsfoKK/fFfEo48VLSb9SuU8SMdkncdXSnOoUpSwHqRm/JlVHFBvXkv?=
 =?us-ascii?Q?r1Jozk3MrlMuqRmB/KcquAQ5xJiZpFGw2pXxITbZZbFgSLWTbthC97f5cRcg?=
 =?us-ascii?Q?taW0Ulkf3oFX2x9Nqif8hi+DX4v7G/bPiMqIr0+Yf7lrZV0rmDtMC1ZpVRh+?=
 =?us-ascii?Q?wvwcIaN5AbMi1jNLlKihGBXl6ejvnpCpTL179uwKtao8Re8HUqwgxQNDwfrM?=
 =?us-ascii?Q?EYyGW94IAaq1LANhfpkhjQqCcxjzOz9wRByuzKqApjr2DUuGovo1YM1Px74p?=
 =?us-ascii?Q?CVjmtCUDW4lc3qXWfNFNc2oHamQ6tWNRpr+nS3xvyyZhNMlWWtGk188CFlfR?=
 =?us-ascii?Q?/3ZnHkDxozbJR1R+9KrS83z32rFwmV34nUbLKIL2gehpY4UV4OvP5W2ULwmQ?=
 =?us-ascii?Q?AJPqgJJnQ2cqei0P8feRgAJBJh9h2h4mPNEsunPBeBrSC23UdELTguSm5OqE?=
 =?us-ascii?Q?OFIZrnsnhfwUP2oBQNMV9UTSDc2+zBYkEK07QTqTioyQWyGk0lEzTHnKAUr4?=
 =?us-ascii?Q?PUKSQgMA5Bn7NEDrtwrSmx3kwCrLYf9yWzbqea5n1agqU5LxexCGJD4M28cr?=
 =?us-ascii?Q?h/gXVwphEGALLLKSiqppMwyeP/qVU4rk6JmOTLQrczUC56noJUPCldIijiNM?=
 =?us-ascii?Q?475pTNJ4WlCWm3Uw1n/zotQEZRplOC7Kp8sCA7GNVGzGqZ+fWe6g0W757IHs?=
 =?us-ascii?Q?G+KchoHMZR5TCJ06uUrHW6kmyJMAk7opFvs2B5kcF+JPsuSxVasLNW7hA/TZ?=
 =?us-ascii?Q?cWIs17e5TuW037hIGKMM5opRc7xhzPrrdVHa4zGIxYbgA3Nmnf6PEyBkauCD?=
 =?us-ascii?Q?/f0xeCY0RGL5x4Vr6Qo1cJPDwmEwHuDw8QBquoq5IbxhzFddFBc8SKU+zduS?=
 =?us-ascii?Q?hK5T6bSfvV+6bEFwBwwoRamzom8WG3xiqHo2h9x7+gB0qVcQ2042BAQJZ5xt?=
 =?us-ascii?Q?R3j7OkW655I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?skhr/BBQQtDN0L/xF6PZ6y+aMn4qA026N6/e9sLH7JNUGkfI0nH8Zd3BrXEa?=
 =?us-ascii?Q?dbfFa41TM1O78WQWS9W+7Bi7iOgP9aEGiPoLChBi/NB/CFMWa+fiPnpjbc5s?=
 =?us-ascii?Q?QCZ4PcU0pPvMmA/LZ+jRbwKxXEWq4U7HIv9xH1fKH+voek0CE6L1moJcNOZP?=
 =?us-ascii?Q?bPIAY5sFYEL5KvBp6Ika7apMpzqqnolixHwidDm9hcBtwKpUZVT+iABF6FuO?=
 =?us-ascii?Q?znit/K59C2hI0lfdQ/mlZLqNjF9/UDYXXvzx2sYzEmI5G4ef7xG7lE8FESFJ?=
 =?us-ascii?Q?rL8vxzWRfOXM/ch3C2LkyRR/c0bCeknmcxPXGm9UG+tR6f9nqF+iOZJQ/ONn?=
 =?us-ascii?Q?5kedcqZbAWyFcK7qc3++luTE5reKaNbSSH+JuxKcaaZIurn93I2Z8RtLADaI?=
 =?us-ascii?Q?jaXZjMYrnv5fk7G82k7ZZS56nutAXC9ZLRhcc1mU9EotpJsqoNmEmVphpaX0?=
 =?us-ascii?Q?TPwbkhkRdIPFPN9OCDx+i++2OqhD2hXYW4gJo6UQ5ZsCarzJrM8m8I7jJi7b?=
 =?us-ascii?Q?tKCKN7qc1PqiyoaDF9Sk2/7N0CqBW95TJQfe2c3UKNZ5mmjh4FmuZDSmBAth?=
 =?us-ascii?Q?Meji1aLJn3LVoq9xuu7WlrFtmxPNB0K6lIZnUw/Rb6KeqRNal0qvmn2TjVeq?=
 =?us-ascii?Q?hvdOJD9C3dK9HHygr2CbYDhsl18QKYVhrTPJgaIX2pHz1FkgD/WDFjavEd4N?=
 =?us-ascii?Q?9ernIalmO6W01omURdrv5eMze1LLLEMMjBHwh+wV/YjQwE2BKWplCl4Ta/Dg?=
 =?us-ascii?Q?KGJxvA3HQngTIyfdnZUi3aT9hb2kNRUJQuC+ZYBLtRTxVuSxdvp1D4BQiNOs?=
 =?us-ascii?Q?klEft6Ky84TMjrQ+ZQSIjuy3CQId7mwP15sVkfcXK34d4o1hEGbfrJUFPiw3?=
 =?us-ascii?Q?SKzxdKPc55QezNkClEmPaP4sDCHblSB7AK7uRlg3ArBT3XKJyfezxwTJGwt9?=
 =?us-ascii?Q?S03GI7oVTi2AoaaI6ZQQBpMY+UEJc+WWmpc0/lAcI7F5PFaQ0iGYGX0Xs2/B?=
 =?us-ascii?Q?OIFU3MRR+ErNU9+R0ebtjkUE11MdUWktmxcdYuXeYvHmLrjXEzKW942891RC?=
 =?us-ascii?Q?r0UrWnOw9PT/Z5iy8c4QAC/clJ/0YMhvD65coeAYMH/tCsVz2w7t0z1OYrwj?=
 =?us-ascii?Q?FnwBxV7kQNLQ9duijXCbD7Y+OxftXfhmdLLqs/i+qElXfGL6nrcyqHATbYx7?=
 =?us-ascii?Q?YmtzvdDzkgKlaLTdn8DiYdtWlGziQr+/BcmA/oaVRz3ErCXpSvsFVZib+IGB?=
 =?us-ascii?Q?5IWM8ROJwn5THwLYqborIV5HDAww3WeCqGKZVcMEI8I9gtJ1lOhNkqrE+Ron?=
 =?us-ascii?Q?Em8n3abkP71z8PGNXoZtb3FpRnb3LfaNTwBYgVP6ICVoEMqxkIH0JlDqaRfa?=
 =?us-ascii?Q?uPTbh7ed9TgzltHV/reuQ81uYimyTImh/memm0n0Urh8qHnv5FKvMXsVLpOG?=
 =?us-ascii?Q?JF0188tNTeY4NMIicjliZcEiPTNI/jtORildoCWjODVSc6pYuat9syVA7WSD?=
 =?us-ascii?Q?dJ5GxLyP7ScTFk3BrJkea8g8+BwJr8riBvFFTRPp0A5Bs5RxUYo7AXhG8ktv?=
 =?us-ascii?Q?PUOmSb83orqk+URsZ4E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac63462-1ef3-42cf-1346-08dddb36b11a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:30:10.4712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnxGlkL1O1CKf5TQNAu78IN1DOjw/U6CXTTsjmAXFdZHkTlSv5r3kRFquJIoEKfR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8965
X-Stat-Signature: nf6zdo8aq4jhguzw5w1pmzizhir7ijxw
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D2AE2000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1755178214-115471
X-HE-Meta: U2FsdGVkX1+C26sxdwC6cbErZ2sVCcD2+/r72UO1HRjAOAwefpNJjeYZQX581SeW+ZUHU/USCFD9sYTI4Svkeo2Skgn7w1dGdyMSrUgQDUO4nEWjciDE+sjti3UDzngRsoTuNvSk0TgCPDpVBUi0Y8bil5F/usd2bN9ELKI2qXEkEETi3GqkGD2Zn+R7BdJ8EIH1Cx6f6TMTGq1UX8x7hmb9tqM9Dz9fO8QG7NB4gcxSvrhCTJLCQ50saDxKGfJG9gj0Eca4IkvaF2X+rM8HVld+jOT3YmJ46D/Mzpe9XvukYL9669nIewze3XgMYkBXgGmdvNjGXeVO3vICkXvq1QIU4SAUvneDSs72oD8+ThRqK0GbpkULXT3fZcp1JJiCS5jQv4aAXupH24quWz7saAX6/BXcXbuY6cadtz7/HNMqXGHb92kMfOd4HKru6Wh+aN+lkXEEK5FV+y9abU9zP9/Lj7VALDXyQ1FE1Wtoqu4kctJxTXR5h4TeaKBQ2KaoHHJENRg76tppBt8/Su3ej4dWI0zc9COuK7ZgX+p9a0qZdRApMIF0w7zwuBkHn9NK8pLb4UmuAwdzBp0g1+kUA+LuI7Y18G7WW4czMeD9F41G7W/5wMzPIm2AAdVttfHCnLyHKagcMqLdejeUOgJHJiQimQjauv4/0f81i8fEYFLBRv+kqDuEeargBl1Cu0Gf3FWy/Tu5Hm9xJY8zQU0aSpfndLD5loNanbB3bPsDYfAz+DfgpV4yvQY3fhBYsTPAHBGsAoANSNaI+jCMUXZCdgJohAvGhUOx4lLHJT2yHMrH3LEXXWgSBN27z+GOyvrsB3wMkJV3qNSWtNXay2lrGvBVlWUXBbYRyurw6MGL0ZxnYeERu1n5vedlEcvZndJPaai2MA4bFJXPklcCskbrheHfCt7M6FeCd8tD4i9QCMcP/iiAkFPAQQ/UCoCG85qXAIdT1tCfinzw/YVt+MA
 ACjSi5/h
 vVAXBx5bhfUEr63t8Y7mlfyKINy8d26yJkz6FeaI2bZt0jRZybNm3B8pzwSql7T0vWuMRZ+c1QTSy2Xi87kwc497MCg25ZEfjdQfMN44C4i9/c5K1/GB8jcLdPbnK4r/t038AaMR/1njk5PVHi1MiOjCDRsROIkT+7fM9sYZpPD+P0N9sRYR1i5uVrNOUabfdOAyRyBq1wJRRRMS7kJqRGO3VNL7BX9Lpw44Kj0LI0kTDrV1EhB+UBJ+dO29qOX+rCzLOUGYxQ//+E+vJuuqe3QxhkB5P4sf3GC0/hGyWdGN/rzGarKi6lnbAiRgis4qHkDbSxYCj4p6M2pvixS5yYPQCQI9AKP9BE7KXXn27osMl63wtz1U2XkGOLFbF0y74zAiJ0TmUFhk5dGzGpJRydhd/ivPHSY5Eq8w+7TULKNeuM7Hu+BNvtp5RXd4b4s/l4Ves988cmReTaXY73IY8PN0EzhTgmlB0tayBRY668zCzV3xSunUT+XNQ+Rr/Y3heOzaV3WT86rULv5xcACCgRURcua/NYss1NdK/pdXVIfhErc76EJ2sDqExB0ArHDg6ZFXg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:44:14AM +0000, Pasha Tatashin wrote:
>  static int __kho_abort(void)
>  {
> -	int err = 0;
> -	unsigned long order;
> -	struct kho_mem_phys *physxa;
> -
> -	xa_for_each(&kho_out.track.orders, order, physxa) {
> -		struct kho_mem_phys_bits *bits;
> -		unsigned long phys;
> -
> -		xa_for_each(&physxa->phys_bits, phys, bits)
> -			kfree(bits);
> -
> -		xa_destroy(&physxa->phys_bits);
> -		kfree(physxa);
> -	}
> -	xa_destroy(&kho_out.track.orders);

Now nothing ever cleans this up :\

Are you sure the issue isn't in the caller that it shouldn't be
calling kho abort until all the other stuff is cleaned up first?

I feel like this is another case of absuing globals gives an unclear
lifecycle model.

Jason


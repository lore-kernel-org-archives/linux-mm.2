Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E426CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C91900068; Wed, 13 Aug 2025 08:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC71900044; Wed, 13 Aug 2025 08:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CF6900068; Wed, 13 Aug 2025 08:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70968900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:41:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E157582732
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:41:50 +0000 (UTC)
X-FDA: 83771695980.06.F86D5C0
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1AB4D40005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:41:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mUD6XpB0;
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 40.107.102.40 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755088908; a=rsa-sha256;
	cv=pass;
	b=Lt7GqK+NAUOiDI+fkik2Dn03y5DwM4zi19lV69AAFT6KVWp+Yf8y7FeAG3GcB1chk20gom
	LwbkiUdLEzdOgrDSJnMNQZ6hMPJmdapgeqRD8YULQd7y18lSGqHA7y8qeqYlAwoFuqUvSy
	QbUpO0uirRFl0OBX3rhXY4B+qx0XVJ0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mUD6XpB0;
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 40.107.102.40 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755088908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdf9T7ME8BRCiWUAFsRCEhtSlkJ2FeYPQu3FwgUXo8w=;
	b=f907KVyvjCQHLbO5RS0a06entt3oGJsvTwudkGALNKL7oHTgiFPFeEyc/RbSxycGyW0ohu
	MWExf8fUYeGFB1KAICr6GxBKoDrWv8w+Ab/s9NCIw5xhFQ0Fo07DamIm6CLgdbn5TzkAEy
	y+J5M6VALBU7lGJ7LS54NeTLfol33pE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJvEL5rJeFGhViBm0Hlc0KHHgmPunqO+VdQKK8lZQrEiaO0hXWyP2ColAhQHsPpfrft/x4HW9RK98UNJeWgX2MeY8PPsMOuOYR+AKtzRVrsLxT3CfcZ/DRJ1Vg1oAlS2tbgZatJC5UL5graTQ5VHsvruEQEuRoRiMqFqhH3SG70Y7dYm4M7ROmb7HaQT1HuoLKFYp0G2rLKG/ygFENCizHyDTM6Wm6nzHPZcbK2y4mBzh7nNz0d2jMnxsHxb1/q1xtBMrd2yEXAY7yjsxbt0oR2XuMrOVKwl6yrCtjXG5MWC4A7zAj345py+Hi0skaXNvyfkLV3TNmQAw3sm1GBd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdf9T7ME8BRCiWUAFsRCEhtSlkJ2FeYPQu3FwgUXo8w=;
 b=O7Qso3TYS8DEI7hGWNUYzscEqB7Pz4k/2KY7ZeTdnmoZfMvJmGKA1Z4QlbOMmw3uyvMQEIVg0eWEmusytDEfhcFjt0fa+K5RLneyr567RWOzyYZrptXduCok3odEdsaO5m8+AL+Urfbt/oo+li3sjoLfPueX0x36iD5sjRi4irOsJeZ+3l9OrFbamieEHXFnRxvM+tP04F5Bv+ZLoEXpWiGW73M2rA8N5AAoCzKTaMtFGPwHCLNphu8mSbXfV7FW/c49m3ezGIn1Fp0hUI+L0RIGI+h9mbuymHraXpvzCiHBZzqGZ1ZHuXBJkmej0rc9tbxWzUvJUbS8Ov5hU9RsTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdf9T7ME8BRCiWUAFsRCEhtSlkJ2FeYPQu3FwgUXo8w=;
 b=mUD6XpB0L4G9kUERyu7g9084CaOEUP/6fB6yNRAsNDZSgQuDQyb8X5PXeBlbTsTJgeWGmnelHiLm0qMubneLKPi2x8JvjQhT96FdJlQTtLzHmgxAp5yqKMwcw9rG1DxmGIM3mFhtBDJDCidm2Hyj2gZzy/mQtqhmujWVLLQPIjRhTGOUUbC7CPdMYdp+OpEUBj/0iEFrx33YhsevMCkNXXp98LRXNIVaWd8jTNQoKiZ+6TsfSCdto0msYTJurpdp9zOJqSksGwxMuBcCK7Yqts7SR0u6URcmst/NlmOowFWZqOM36htA+CklRIs+PfPuhfmmRo41V3Dj0dJnC0PmLA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 12:41:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 12:41:42 +0000
Date: Wed, 13 Aug 2025 09:41:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Vipin Sharma <vipinsh@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
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
	linux-doc@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <20250813124140.GA699432@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250813063407.GA3182745.vipinsh@google.com>
 <2025081310-custodian-ashamed-3104@gregkh>
 <mafs01ppfxwe8.fsf@kernel.org>
 <2025081351-tinsel-sprinkler-af77@gregkh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025081351-tinsel-sprinkler-af77@gregkh>
X-ClientProxiedBy: YT1P288CA0003.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::16)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: 163b8acb-f6a1-4bda-af58-08ddda66c126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ugFNGM/wlMRjeWApg2BwhY1HoqL4oSFWygoIQUE1uorRsUOHLGg1g7sxSv3Q?=
 =?us-ascii?Q?9E05A3xXX9vv9AAHtRXizizuQapup3BCz5Ca/3K41H0DLgS6KsmPsYzqn88q?=
 =?us-ascii?Q?AP+FWYt1ZiUAbJkZzOo9i3WlD0rbiXmOb9LDL461bdWdJCfNE6M1+ZuMht2G?=
 =?us-ascii?Q?ADkx4+HQtoJcuu9xp0tN/b+YFhYezTZlnXmn9Vr8qLRUwTsdXAEhyOCFh/19?=
 =?us-ascii?Q?SCWu7SqG+0eiblK0JmO6NJvOroIfeAw+XCdbSbqVCHccO1C3QENxBj6sSizO?=
 =?us-ascii?Q?sgN/0LqNQM6+hu/rUgFiU5SP4MfH7oGW2wTggB3pbjlCXmmUccyiADnZ0fyx?=
 =?us-ascii?Q?1Uy58vAZvY6I4DU2/qDH0uXbpTgCtmSSK91mR/qsrcFU17BdF3nHog+t58H5?=
 =?us-ascii?Q?viw5X4krr316NSRAdiWT6/GLcK3Q4QIfWRdYMztXLnDCpudbFxsLp9rBmFa5?=
 =?us-ascii?Q?RQHzfhHwe0bkSfPnvL8F7KEL2ppCZjmKYXASKnBK0BPwELcns5xiPPEnmvDm?=
 =?us-ascii?Q?laDnZ2rPgUwWhPetHH0KlDKr/hM0QBx06Lybz4GaZtdhRsgyynHtw3lmTZIH?=
 =?us-ascii?Q?aHI6AgJa5KY+ej4YW1/gR3ZFfXLB0UWvfLh/xXtVM57oTgOv2UT0hpoPDAlf?=
 =?us-ascii?Q?oPb2vfghsuU/C+ipGtPa2rysUfMVBnjGa2PZHCkiaVCzOxDkcu4dJb/U1YS+?=
 =?us-ascii?Q?euRYty/Bmts4v8jOLFe0xhePCwTR4TcpVgfIk7uAtNuKmVrCpWU7RolzGgkA?=
 =?us-ascii?Q?IXEE2tVuakmfuQZQQaTMzi64nwiji5l3l+r1b9Rylbi26Yaed7FIzqRGpZDX?=
 =?us-ascii?Q?ZheGE1n03DjHA+1vEIqBKt8sMe9TVdIVn6xcZ/XMh8TyHHwi5zasBBWbsxLu?=
 =?us-ascii?Q?gbjGtDJ7lfWT7ddkLQLVvC+v2saGpypUznw03SY1TgPmtwDQO0B8fCeF/kAZ?=
 =?us-ascii?Q?s736KX7DTnNGKggu4AOgwKKVET/Bq6YokR+NU1aNVKaBfoZGGRaBWfNv7U/W?=
 =?us-ascii?Q?75w4eNICC8S8BSKfuSGB9CyBgJxutFGRFI7aS6QZfcMPyRiCsFdV4k0idi1H?=
 =?us-ascii?Q?aXWUgPA93/HtlXr5zYueg95mjb0aN9+F+McuKBWqy4UdtMjimzxBHwQMiFvt?=
 =?us-ascii?Q?cXrR7uAOSRQ63FSRLA1mVQf3LPZaq/SD+Crz5knXMtWBt+PTmvIRq1BOOOlG?=
 =?us-ascii?Q?ODnT1cT0p8pVrsQhDzHoizDutCLSAkeiiaI1lC8Xd+wXcFbVjhVVV8RyMaOi?=
 =?us-ascii?Q?Mfpzr/nnDkZOwuYtmzMaPUWc9h9Y/ysVvbbxVoChBx93UAc6RqiKscIc993v?=
 =?us-ascii?Q?fOiQ+DoQ6Q0EqQsv5DFCxqEucccGAFjvU+hb0K4idCwpVkFPG0NaX8k6MCQs?=
 =?us-ascii?Q?7g+Zyatp1dyfnbqeMjMEXjhlbKmd0eQ9FjumWVSev9nJhJGIfeUPkRTEA1Pt?=
 =?us-ascii?Q?aNy5h+er4wg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+fS1BKVV5KErWoJaMc/fISM4Ma2tPj2s9NU4+yjqcuR2IcIiy+tnXcCNhxKz?=
 =?us-ascii?Q?OwOk5qiqYkKglpfcSaQF7OBnjxOVwCU+BDJd4WPw5EBjHy+pBV232wHF+Jhz?=
 =?us-ascii?Q?WofmjWOksKV4U5LjSCGh12MGm26PHQDNiqHOY/ERpxwRhBYgsNhVNeRnvkgZ?=
 =?us-ascii?Q?4zMAhiMdybGKHHjTMS3zVXU1jK5vERtghfrHbZDM/IjQGMhZ3/1g4KLRCS6m?=
 =?us-ascii?Q?6agGKzbodgHVTFEUKc7quSmhMUVDm5gktm90PbdHLsHmD3pLccOpBYh/vDEh?=
 =?us-ascii?Q?b4ngBkH8KW5eLNtPlKgf7w3zOguJAyOXxgVnT/MjnuG461IpHKk/SYULKqkM?=
 =?us-ascii?Q?RNVhDC18/e/QN7iMMbyOTDKOAts8UgElLAbPqH0YpusmfUbtJy6fXwpyDdjT?=
 =?us-ascii?Q?YWRVDyhB74I9Ek1n7pN9wbfZTHIzp/mJn8M+IERwR/f0ynaK8mL7eoqRq2pu?=
 =?us-ascii?Q?fMSmUG7dEjOIsn01DbUd2S9WpOeXVd0uLeW7Ey9VPcAOihVPj5L40vROV+5G?=
 =?us-ascii?Q?kMSWrkZwXhApTXWwCStLygdE0xm/bAoycJTvqNy80LyHQTT65mlx23DyFgI3?=
 =?us-ascii?Q?y/0rx/fIQ31TcgKg9Uh6nHg9wKTcwaWRqGwWSYFjctpkXoBfXr/YPsOs+qCm?=
 =?us-ascii?Q?T7goeaJuHJVvpyxGQnM9KNZFuQM6ryrmjdpJRHQdS5Zn+DKo0x36O5uDsa88?=
 =?us-ascii?Q?wMK2yTN4c6OHSvjzOhY605GLF3AABmjpFRhsALOV/TbG3ivbuZ46Et+iBbj1?=
 =?us-ascii?Q?l69jrxJ8a1GB1yFqYkkusc/FcFsQQAekzkZLdHeLbPJSfHHPmMpaMX+vkt+L?=
 =?us-ascii?Q?CCDbAnx5JkoMFnqHNkFXIQvpKULdfOyvNSM0pBxvW62Rlr9CjwPxPoMK3eso?=
 =?us-ascii?Q?PbQlVnXchRrX53n6N30o7Snc1ik1BBo3+IfEpqV7ZTk2UTf916NMF2gC/lAG?=
 =?us-ascii?Q?t25S3S9gOTYT1HN8Jcn4uF3IdayoMG3Iz4Jw0jpqIvsKtVcg8vlPqdXzkGbD?=
 =?us-ascii?Q?p2Z4PiyEHNoAKBmOQTS7GlcgnfQEaexfqHMqItuaitslk2iiOKAZjzfZ7zEt?=
 =?us-ascii?Q?GGsLOn6obhT7nhcfYB2dT6ZkZzZ92oKgplORzJn2SgVOM9Wm5cMNgc21GN9d?=
 =?us-ascii?Q?oQSu1b4rvHCz5kMXVosbf+4T7V/+SliCtjbZSS2uXaYefqF5Z5TDXdDvhRTH?=
 =?us-ascii?Q?RvIInhjBgsGoUpVWdmlQp87dH2fjFtraA9A3H26xuIqeidJ8fmalme+bRMSN?=
 =?us-ascii?Q?hBdAdL9QHs6dYX+WuqXkuElyWWdEPBOlKbHAmVHw+VvmnT9QbfqkgIV/Qdkn?=
 =?us-ascii?Q?OX82G3S0zJS40q4wq23uiddmA0c38+xtEwegSUDD7KwDz4vzmK0vRl64a796?=
 =?us-ascii?Q?Xgo9pp/oHBZEq7k8NWhbzm/g8IoF/uXgZfRXFEQEhy8LOUvZnJzqdKxwPOkY?=
 =?us-ascii?Q?b6pmS3pb7+vBe2cJicZreUFrCsXNFRygxhKoc3HvYL3mLoMjmDl4Ylq/aBcD?=
 =?us-ascii?Q?GU5cVkgytBaW4kYiqto8W0nE3xtu8IXWmx66si/nQqLYeacHVg2dt8X7sjyd?=
 =?us-ascii?Q?jg5AUeJT2qkdPIofgLo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 163b8acb-f6a1-4bda-af58-08ddda66c126
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 12:41:42.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Eg7q6XJ6vzFoZEC1qPvNNP9S2mPfcPGhmmtJz08YCDD17dmrvyjJkUxDA0kWNmQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1AB4D40005
X-Stat-Signature: 6u5eijowisyk5ki5yrrz1j3fkm5pdcjf
X-Rspam-User: 
X-HE-Tag: 1755088907-332887
X-HE-Meta: U2FsdGVkX18AIoWv25LYQ5UAnV/cjNGGJze/BHKQA1nNo8lt2ved72+HRFoVNM8FbFzxvOqD6QMhh4JYrlG2YYYvg3j2JxNUDJiYzNvof/mVCOcwW7cJQAAJE+wUmA1DyivMBEk+lWv4FCoyx0G3wZE3wBBp9/aLh66SOrzTkFe1zvWmHvkVANsHEY4nVGUCpT0675JZc+0GGzgzf+TZGogbG8c5UFhORHTVK76Ou0tThm7IJI+3p4+bHjXN72WKcSOFvhZdkQcSMswNR4dKaJwktGrUAUfhL0Horvdo12hS4LHd7MAhAO+5RDy5RQvjqzdx5c6gejdLipZ418OBEUzwkNwgU8wD1s6mg7NhnfhyFRNU9jvWm3WEN7eaulLi1UgrMQ8ipti85SnvuG+2lt6OgiZYtREgfoCAg4KVwvkIjOSECZlwLvIub3lDm8y5265/9cTwGjKW8OVAxmgEbC9/WoUrpr6AMRhx/iBhu07VhwPlP8/PKzoWXoJbLvv3ZCpp06c+/KEFIPON634ddY2k4yQjLv2zMtE7IjEsq6swq9DZs92Bhx19zg2KEFHDUHHUdx0xjmCf9Rp6jXceXfdINmyIcISiArtmWv+Afz3RcMttWCi7IrNhQiegeFnAee6ItWjFZRGfQnKeLL8zX89fNf6cq3tKatrg+nPnIq4VXS1qD61xpChhVw9TC9jdvNq271LjLoGIE62LcRT4XjOrhp9nUM0JqOUwl/mksrc615PgBd/oJF9/gQcg6XByFkJJWrLpYCs7lSirYZHAzlp+m4p5CiCRQAyX/LMBwp+NBpRY5+MKdxXuE6kwU4MHanHIvg+Ocvg93cOf8zKq02ASDtsRXF+GTgtW5YhRMTL0AY3m3kDKe8UCfL6dt7xluWZTaXDbn8DGPQsIzcNo2XhqRVSdG6lNaBuRnK6vli6Sbv+aOl4DJ2k68Ka3uDtFg/YZXBmO7R/ykXt4Zj7
 9Dy7VT4Y
 8lyLTebyRWxkw1D8gSnwqKwfxHzzUQifDhKvJOIzeKTeyN9NGu0spTIHi9r5y43ekj3Tnj4DOwXXVO80Fek/j55zue49TkgA4nKoCHZ1o53FgTN27W5901qz8IV4pGSaLO29qgwegTQB7zjY4yh7FhFPefh9+iIlz5nISdC/Yk19lxAXze17JeO9KFJr1E7zjHmB7nHnr7rdqDoiIPR+TCVGRTl1D0Yun6uA1A3dED2ZWKComPrjxrbqLfa//gI5+6pz632cysTJ3L+jGBJhjBj0aw4NkRUOtQ1CHdPmv43EISS4SffueA4ukP6JORuu7Gry5d7ZGq6MvzVg9DecE2BVrN/+Xfkbw2GyXuNzhkjkjVd4smzeMh8cQ78tkLQwvH5CELnXvfSfJ2QPpwxVCcBc/ZIapbb0Y9Dekqa9XMLdJrJrH8lBRuy+B2YOb/etk6+f92pErSTMlbyNxRDAE8xKvQNUEihmKZttu3XBc4x7IVTJ+Xy+6xlv2CVMD0XHtpKkc95xZC94TTEquJBqpaAZIrKTH4nIj0cZx81He61Jijmz0JUVk23/4yqkQNMA9xs3vp3Oeoyx4buOyZhCe9c05gASg6amEIe/7Lg3h3fzCKj5CgXcf5M11hCf6WkFG3nx0usyROp8aSrjO2abIv0G+BPkiXlQAPsyuCM+7z5KeYpV6r96beypZPPJ0IgA3qM6y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 02:14:23PM +0200, Greg KH wrote:
> On Wed, Aug 13, 2025 at 02:02:07PM +0200, Pratyush Yadav wrote:
> > On Wed, Aug 13 2025, Greg KH wrote:
> > 
> > > On Tue, Aug 12, 2025 at 11:34:37PM -0700, Vipin Sharma wrote:
> > >> On 2025-08-07 01:44:35, Pasha Tatashin wrote:
> > >> > From: Pratyush Yadav <ptyadav@amazon.de>
> > >> > +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
> > >> > +					unsigned int nr_folios)
> > >> > +{
> > >> > +	unsigned int i;
> > >> > +
> > >> > +	for (i = 0; i < nr_folios; i++) {
> > >> > +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
> > >> > +		struct folio *folio;
> > >> > +
> > >> > +		if (!pfolio->foliodesc)
> > >> > +			continue;
> > >> > +
> > >> > +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
> > >> > +
> > >> > +		kho_unpreserve_folio(folio);
> > >> 
> > >> This one is missing WARN_ON_ONCE() similar to the one in
> > >> memfd_luo_preserve_folios().
> > >
> > > So you really want to cause a machine to reboot and get a CVE issued for
> > > this, if it could be triggered?  That's bold :)
> > >
> > > Please don't.  If that can happen, handle the issue and move on, don't
> > > crash boxes.
> > 
> > Why would a WARN() crash the machine? That is what BUG() does, not
> > WARN().
> 
> See 'panic_on_warn' which is enabled in a few billion Linux systems
> these days :(

This has been discussed so many times already:

https://lwn.net/Articles/969923/

When someone tried to formalize this "don't use WARN_ON" position 
in the coding-style.rst it was NAK'd:

https://lwn.net/ml/linux-kernel/10af93f8-83f2-48ce-9bc3-80fe4c60082c@redhat.com/

Based on Linus's opposition to the idea:

https://lore.kernel.org/all/CAHk-=wgF7K2gSSpy=m_=K3Nov4zaceUX9puQf1TjkTJLA2XC_g@mail.gmail.com/

Use the warn ons. Make sure they can't be triggered by userspace. Use
them to detect corruption/malfunction in the kernel.

In this case if kho_unpreserve_folio() fails in this call chain it
means some error unwind is wrongly happening out of sequence, and we
are now forced to leak memory. Unwind is not something that userspace
should be controlling, so of course we want a WARN_ON here.

Jason


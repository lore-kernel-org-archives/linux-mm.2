Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407DCD3ABEE
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 02:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BFE56B00BE; Fri,  5 Dec 2025 21:54:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997736B00BF; Fri,  5 Dec 2025 21:54:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E666B00C0; Fri,  5 Dec 2025 21:54:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74C196B00BE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:54:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1800BC03E6
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:54:46 +0000 (UTC)
X-FDA: 84187528572.07.AB75BD7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 67EE310000B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:54:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S3RxXo+Y;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.47 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764989678; a=rsa-sha256;
	cv=pass;
	b=8ONDn5lbpn2Gu9oyBMf8mQHZJeO6B1GyL9N1dKRMJbDuZhbuJXWcZ6AOD/TU9VtfJVzEkk
	9SqIbWt3z6Abjv/8zPfKdByHQ322rQJlxk0EWzkQjm8ax1wKqR/sXbMBoGFDvGLCu69roK
	ev/EFX9G7WqLr1xkHBAcQBFYzAK/50U=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S3RxXo+Y;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.47 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764989678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzSByxFKyasbrXs1kTNpBkXoGLHTeljXDCj158B8KxI=;
	b=lXSkRSg6rTBrPa/iPcUnwP9jzuhkFae+8fjTNOUEWdhHkQNpSjV5484u7rCfc2n7MmFD9f
	xFW6tE1anL+lNVhNBwHszB+RO8nUwdZimT6rGt40iDSXTCbG0s8KBsgpyMeeE4IU0c34VQ
	zx0JU/whh2HVRPyGbeRgiSVWNt+us3Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncbpgYRMN0P8WaOh/GDQQkzxyjrPiFynLZ4nvPcCl7MCdPwuQQhcTUsQ9tCEqhYyFM622eXFMWOdvgpiGu/++5eDQRwwfE1foi0eXaW5azP219fykIkhq9yGmhmdr6rnTES9pAYBBaZOkvP7dGCIb7AizeVco5N+w4P+5Cvo58nIdJeNgJKd9QGcWXWNByjhQUAM5qtlJ3gKAMP3krukFyF9FcrKkRB4Sd8Wt7bp2IuvR3g/NHYFwgVLxoVTnG1E/qU8iV++SJgm9kcNCzFuVOCrVVa5chVY6StoM0r+5IWn0tHvxNxORZRHD3e+6txycE2ug2eqvlVgd9HW2jrbUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzSByxFKyasbrXs1kTNpBkXoGLHTeljXDCj158B8KxI=;
 b=TEQB6Z7gg8jN64xP0lfyrT80MwN90u61BID9kfw0fLVPEHq+SGUCdgAD6J9Z7EGiciazaheA/WM330wUdnjS4uyjwprvi05eHOGgYY9LXRlDBqKS/s4NB2UU8oyzTFpMni9LgyLxi35TCvluuAl8Y5+ijJltrN9Kny4DykH1SwuVsTF1Lgs16TJOHtQJnHD/puv4HuwApgrR+sTaTTdjMiVjOmSvDnYnf+QBj46v+wPrQL2+6j1ZX2vbhPMxL6JODo7DUG5OUop+/iuAeFIkGA4iw5/+NkmWmd6CH5y8RmLmGmWYHQGJ13xKGzVzeTcpRARMRyE3LKyqzJMSZmAt2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzSByxFKyasbrXs1kTNpBkXoGLHTeljXDCj158B8KxI=;
 b=S3RxXo+YGmLa/Q2IDc8W1h/Qv/qca9+09tpAJxmmmsVywWE1Lv/SZKWH4rI2+vYOPtWyn+2MZCbGmfqZ0vstdrplhcCwIAKvmE4P2xzwopo90wukao//CT+meia8K0esqF509qgH0M5tV6kipvG4DBzTDlEuJs8PoarWHGlccF/dJ2agoG+dDb0ecHZoJ/HGXjIw6mOP2R1Murvprm8nuaS5PS9Mno7oOspJhk4m658TqNtG2X6ZMpZJ8bV1sLPrifp2Vl3q6sicSmKpdw8su1oLSVUneiU1ePGnaP9c4KroCLtnOQcw9490T86OhbxOgTE2X+g9bP5Ae207oU99Ew==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DS0PR12MB6656.namprd12.prod.outlook.com (2603:10b6:8:d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 02:54:35 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9388.003; Sat, 6 Dec 2025
 02:54:35 +0000
Date: Fri, 5 Dec 2025 22:54:34 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
Message-ID: <20251206025434.GA1422789@nvidia.com>
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
 <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0206.namprd13.prod.outlook.com
 (2603:10b6:208:2be::31) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DS0PR12MB6656:EE_
X-MS-Office365-Filtering-Correlation-Id: e49a0863-44d1-4915-b042-08de3472c9aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3uTZpn6TPYQuJhcfUi/yWrg/jBC7qWjx76DZ9LKLsD4GDMGOtJFn8LBgbd5L?=
 =?us-ascii?Q?5N1FH0TpHmZrOOsDgKYQc054r0yjMk+xEftL7Fc2mBXWJ0R5l/V/+3N/rit+?=
 =?us-ascii?Q?83QksiFSnQYroEv4znBLoNCUrXu5uxy+XgAkGQeiSOa851sGGtNUpvGrMp+A?=
 =?us-ascii?Q?71CTav3HwgqxWQZUngHGPk6hXc7PqCneELQdzxfDwThCBRk1sbKIN19kSnWn?=
 =?us-ascii?Q?/sxhacRR7wAydlR4AsoUxbZI0QWPrzty8QOu/uGFR0NeqhC7xTRrRIIr9qTx?=
 =?us-ascii?Q?VIx3EN9QuRItpy160yt7OZ5MKagg3yAU4/mgCncX+Az6ES4CsH4/YgyqL02Q?=
 =?us-ascii?Q?jY7rnaOm7KtGRZUtDmJgxqF2Vm4u2UL5j8KuM2JKL/bhBSCbNpVTiA7QjOmD?=
 =?us-ascii?Q?P4nC9d/5v1E50egGEzX/H4+O/+k2eMxgFf6Q6K6WnR+5dFDMWQWXDp8Lgqdv?=
 =?us-ascii?Q?UttoXXb4ZMJGsPOZAL1AIvJBGjweUDs68XV2d+sZnWfOlsyzC3+oEcFrGoiW?=
 =?us-ascii?Q?gQxv9TpLayjOPreIiBc5cHzZo6Ca8QxH9z2yiQZnsZo0keB99Hl48eoqrw/e?=
 =?us-ascii?Q?w1Ia5ktFY1ssS0we3dhW65/0FWkqr2LGKVQDZkiWD2Zwk6i5TQPXp9pXDIf+?=
 =?us-ascii?Q?VAub0R6a/bHqXj+dt5el/CfazrZ5rGw1HJbthbkMrbkgfWmleY8Bi9P9wqQW?=
 =?us-ascii?Q?sgfWqcCgmgy0Z0wfHIyOXn5vz4QGDRMxoRvWvO2xlM1Cx00Ep7BYy+V4BGK6?=
 =?us-ascii?Q?dSwJ7bWT8oVwR6+hNrF8t4KXp7N/YRsNU86CkMXVoB6QNGLv+hjQcg9RCZmE?=
 =?us-ascii?Q?LpnO3reMJciqtvk6ubaWVKS+5FvgPecsXhZQvz9n2KE/VTJYzAgpLA0UavG4?=
 =?us-ascii?Q?xNGBjb51lwAY2vKrAg9I9nu3RXGRln1Cq4ENmW4ebtPaXcR1H3HJRun6LL8s?=
 =?us-ascii?Q?DOlocbr+PtHBR2W/zz+T8aVd9s7XzRekpK7F8xsJfv22AsJ2ttPaOGCaVvPe?=
 =?us-ascii?Q?LfQccp2cTxE8LPWTyRNb67dloDPYTEcp47R3IwpJyWIebEF7bLndwIEgzwV1?=
 =?us-ascii?Q?CETSYgkgJppx3nGvpAh2MtRM3ka1iw/pCVhbuwS1t/y9hGARBonXzI0sNoGp?=
 =?us-ascii?Q?gZju+1YtvTxG2NohPypi52vflKoRdRtVA63VQW4VG5Qh5l/z8WpjlCHkEvxP?=
 =?us-ascii?Q?D8KK/EYW+Vxa6LOXEKvryJYg/a1RbPlO7A5NkPF39vTCHnNBzlqhAnb9aGne?=
 =?us-ascii?Q?qZ1UQASHIAFtftD2PgLwgwKAvilWSZAXn5WWbXSdbEUsTXRH5ztqd4PW4tiC?=
 =?us-ascii?Q?RlpNVnnfoyXaGWJQCyUIjjKDGWsle1fixCjdZ8cLnxu5Q18Y4+CuMBpCBrjO?=
 =?us-ascii?Q?/h7Zp/L4AXzU99eYOzwB9OmgKhXSexu9vDVGlUZ3b7i/Bj2gwNMJsDRnO8lx?=
 =?us-ascii?Q?LjU3wnFGQ5iBpx/nTveLafupmGI377BT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?33DEvPIJnClRmqAXXSdKCQ+6wBjeDQkwcRYDxlCfCOr7Zncb0IVZNY/voDff?=
 =?us-ascii?Q?mG+ui4g1QEd4U/pz/jhSbeBEasMfehYV8WWllQtnMVXwi8UhWMmBa70VOIqd?=
 =?us-ascii?Q?nFc+v3mwO55iMkR/5lk7pzroowN4ZbT8ALHGnoHYA7QGBrXFTr9oDKKGBZMQ?=
 =?us-ascii?Q?sKs6rfn4haSuCX14TcyfQQnLdES7mHIGJTg3oOoKe/9vy9+eIMQzA2RkHbdE?=
 =?us-ascii?Q?kkTuJGS+lj8IIDPE74o2cTQXJMzs2QE1qh7kzMu1auY6S4EGje1ib74Ul+4R?=
 =?us-ascii?Q?3+bG3dc6zWawd0lU827G/7xwpwT4jg9ZM5XD15zp/lVNccmg3YDOhtABmizX?=
 =?us-ascii?Q?mr84cDnMVQ+tA7WSRNvmff04E0Foheo44RVTA0vFg+tZeYz09Nwfw0wr9FWR?=
 =?us-ascii?Q?KDMtDXiwEJTKAkENNqr15y3RU623B01sq4H/WcEg7TF716Q/nfmXsaIrtpp8?=
 =?us-ascii?Q?WV12nyqgxVoJ9+nf9mRf1tbdyfcf3xUIg/ybhK3rpghmqowQbgxvLRuuthsD?=
 =?us-ascii?Q?86fUgndwOv2NmqAOaK6PVjnzo8g6fog393ZUx/YYRehnWIOGMmZb6y3NnJTJ?=
 =?us-ascii?Q?NIPeQ3qiEBItB3DzsfRzX9jpiJ5uUdzx0kCNaYjweikhzxKOc/7tQh65R5iT?=
 =?us-ascii?Q?3hrKqLVfX2VMIToLJVueE+2Ojcbf1ur3VDxhDtWw5ccce/LSGbVzFUJQdHK6?=
 =?us-ascii?Q?8SpRKi+rITqHP7HouVwjqkC13U8RgfYWamQ60VgtMdpVJl+MB/IMqLq5enKz?=
 =?us-ascii?Q?D5FV3SDjZfdCilwofuYAY6LbUNanGcTuKaW3EYvCHDwEJnOPLek/T3bU7Lky?=
 =?us-ascii?Q?DYaMf3HybSRvCTG7XYyw2NZqu+RBKJYVxmbiyNx92O+2NtOIPUMaxhXd0RYZ?=
 =?us-ascii?Q?tiI6LWSzBKOtWZsBjAXz/1BJqIezfDU93BHqdhR7dUicaYu3Bd8fb1m5QhEp?=
 =?us-ascii?Q?SZfEnVGMn7YF+tdR9Xx2lozJoRGC91uPsjSQCEJzbdsZSiUiVq8Gy2Ei/Kne?=
 =?us-ascii?Q?SRWjGW/aHh2XhbeiOM769PLmH+Q5V+Ytja/kuvArKv0MLzbmfUltLFEjFBY1?=
 =?us-ascii?Q?XtcoZ1+kCDudC51IVlzUgyIIFYuUqPNImv+pQepPy6EknnF6K3TpRR/5WsVF?=
 =?us-ascii?Q?q9n/de1V7zW8YqLegCi6InXKwefSNINhU9QNHnqpXeR5Q2DxKSEiqch10uF6?=
 =?us-ascii?Q?iESWlkwuuw0bD3UNWi1LHWGNNpgCSz4i68myqep9XVTiYUNh7tq+Oper5KVz?=
 =?us-ascii?Q?392edD5nl2BZUjFaTBkvOMeE2JCwgyK4B+E9GjYwtT73dMWP5BFQPueqg38/?=
 =?us-ascii?Q?+PgmMcthOu4RN81lnfOL6rauOFdvrFf5K/xjJgpbRsAlx1Nj6tzKMZdGGXjX?=
 =?us-ascii?Q?T7qyo9ZZY0TOTJx/EVGYQgegBwnRXflvuyMa0oHTC2DSVEw2aAhYMveembX1?=
 =?us-ascii?Q?WzuiX+mEqFu2Ze+DuMPhicYGqefsEeeAkuWqwtz/b0tIEgnydJ+5kcdAhwAR?=
 =?us-ascii?Q?3AdgNSotMWjjPWvUx0W17DVWJ3h3NnQsalO2g6l2ekw4KnYjie5NHLhbjcWh?=
 =?us-ascii?Q?SbH76aqGTQ348zRhmsw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e49a0863-44d1-4915-b042-08de3472c9aa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 02:54:34.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8LafdzqVEzs4mObzc59RqpaTqerQ+MV3tVIWDKyUQP2eSL95ekYV6NQnboO/y2a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6656
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67EE310000B
X-Stat-Signature: st9smqf9x3x39q8qc55fhuo73676174m
X-Rspam-User: 
X-HE-Tag: 1764989678-985616
X-HE-Meta: U2FsdGVkX1+YtF6HDhq3zm/gYebPta++Da5MNvLgGHb3MfUeZOBKIsf8nqiF73YyVnqF81hZU6UHEeRAEO8Wx1zWYd+rbAzf48q/VgM9hr37qGpuvSV1BsMfSKEXsEACez5PiGCYx/MbahMayPCamAoY2LbrjUEoOWeSPSr4Hn1Y3UAohJlTtkRFrq6LNAxLdz7kXES4uQ4FG5NmPW6932uT7mspo/Nhd1o01OeRj+s1VDWWYtrFbJvlwWIxdGoHH2GBnY4QmvCQOGaYH/qtBrqUfNKC0BKPHw3fhO5Igverm1uBD9oxMV+8CNMACyM7nlEkL4iinVHnt1oaB2SxI3E9R7GapTfLflm02ysKrvXjqS+eJn52ntWdkVelLXK1hx3gc007ZzC5QUzKh8FcVfLtCyidMzIoFITxnQr1ilN8GzcPt1HoZmud00F9p3XMpI3ezF3uL67UrIy0yISY2KNWcmEMOMgBXTIwIWinpoAqzTjMmkK2z7jdGq68LhLixhnpnvh8/FUG+qxh02vj55V/zs9c9YPmHl3EZeR1lszXA6AnhxfhG4HVFGq4J5HTBqcwZNU7L6UoRjG45OHxNylF2mWz1g1GqZviUC6ya7w3sxfH0AIUVAmmv6XTasDf0od9zbHhZ5+BoGqWOlupgdzoSbcFfotmIDcyfFcqcigVW7bncJdkYXmaZ+qofaFoXE0eV7AkNyybA+Nn1PUNAxmOVFkg/dpFU7/SC+r6rQ9b/cbiDjc04H51xcE9+kITwr3Cr9dH6rR5eLtjUOGYzdgmgpasOACtY0CEmf9T3r4/6qY/nUsZqeq9ZlWi5NHvQ7F+cr8lrw+X3QX47NZXnohcvNFvQQAu+0kwwEArWJ47c4dfxljfP49HqEXkwGsTfpbdUnmoppnEOcTPZyx5ZnG9g4SKPYH4oRoeazwNIG0s0cQf6Z6qApYohV2IHL6PnbNGm6KXZxPIJuYHGTR
 zA2fqa51
 6u2fyqfdDAR7+VmXCgcx1uoIp/B018QZu6w2eBk8KQr6i2aMjl7mlmEQY8x7B/vCWvA38QnGlR2GT9WOtrBpyUJYB7v3hWCsfitsBK5PnitZBuzwJdftyGGBi7EE5GKYCqTr5x5Ezy+tr9ipSSLo1N4gL6jFaWfbAArkB9TdMxB5ygAMKH5B4uRhnJdolzYMbtr59yYVIp7BLyNXSk1dw5bCOPsUg8W1Hn13we419KwZgUs1snzejhVcXGIK5YpzdQBTBATYeKuRYlk8uHV+lEHyjYqp3ucRYGgoMUPRnAZlRFdenEPKBagwGbL8TfN/sSX8gzeNjqtikcLqyx3jaEvdQ4mKveqljafrjhUcmkKGzxBprgkt9ftIhRDYlAyJ+/ZjaVq0m7lSFC5pZ/tpYh1bXRZowICQeQku67I6EBsiYaMCwTJQtvSsV+n1KV/E0qt9Rz5Kju/0hqoXmiuDYVL9uFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 01:56:17PM -0800, Linus Torvalds wrote:
> On Wed, 3 Dec 2025 at 21:29, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Ankit Agrawal:
> >       vfio/nvgrace-gpu: register device memory for poison handling
> 
> So I had to look at this one because there was a conflict ("int ret"
> had been removed by another commit), and after looking at it I ended
> up deciding to revert this patch entirely.
> 
> I may be wrong, but that patch looks *COMPETELY* broken.

You are right, it is security broken, it worked functionally in
testing because it used qemu which only mmaps once. mmaping twice will
corrupt an interval tree.

Alex and I also noticed it this week also when we were looking at the
same conflcit. We also found another serious bug in how it uses pgoff
that renders it functionally broken after merging all the branches
together as the merge'd tree also changes how pgoff worked. :\

Ankit has been working on a fix this week and we planned to send you a
fix/revert in the next week, travel permitting and so on.

> Again - maybe I'm missing something. If so, that commit can be re-done
> with explanations of why it's all correct.

Reverting it now works well enough too. Let's see if Ankit can prepare
a new revision and perhaps Alex can forward it next week or very early
rc1 after LPC.

Regards,
Jason


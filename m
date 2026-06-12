Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E7F9CD98D9
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3376B0005; Fri, 12 Jun 2026 11:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38AE36B0095; Fri, 12 Jun 2026 11:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252586B0096; Fri, 12 Jun 2026 11:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 161BD6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:02:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 936DA163713
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:02:00 +0000 (UTC)
X-FDA: 84871575600.10.E53C108
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E0D7A0028
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:01:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tRHx70tn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781276517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70ErZv9D+4g1OzCtk/vx92fLssyiAKLSiAsE7lF0t4U=;
	b=Mj+dMy+V8dl9svUVCIM3banm239CmJL8SMxWUZWCReVoKv7tcud2MnVxktEpDcXVGYswh/
	Zz9n/Bgn9dhEkAYTdRo3NQXBNQSwNdvaQPD4IXKgvEzaVnV1SZxbwLO01ojjsDGdVzDffj
	f8iazqXyKlqDzYw+Y3VxUrozOxY/PaY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tRHx70tn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781276517;
	b=s+oOtkCAMsySU0e9MKLTpW8DP6AnOiJL30D4nWvOOEUU4MHKajJ2vQQcmqaZK5h4VpRrLo
	vydQOploVIzLV78c+Srbi/fI/npf9303oaoPVVHwHA63xBJS/I/PciQgnmXngtmqZcITa3
	oZw1JiFA/qmrSTz1iG+C4/Dx5miWWwg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A6UR/P6u5TgtaIqNdivx+ZYohirDUFaY87TThgGww8bQ76MkxOosy+Jb7eX5ATGud8+XFHWhiV0quOpAKrI8W5OFY8MXYFP9rJ3hsCCCPgD2l/vnWacvhL3C10S7dzxIN4lJA1mU6rYMbBAeDUspFO/T46ADu56sPhnCXpLxUd4F32pANAA8bHkxBXe54zBLdn0+fPOFKrHzPGRdSY8tUvqdLTaUh30YhDyGDRtdX3HHvT8Z06ivTx6tE9APRJNIXStbkG6zzaF2UupQNRE1kPZswaXn0l2TZR/EZTA4y535TcDGFOxAPS0yN/8dEXVjFeNnNQ56s8Qks3j0xVn+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70ErZv9D+4g1OzCtk/vx92fLssyiAKLSiAsE7lF0t4U=;
 b=DVpqVXFX5efPC3HQUfI9PCd4IYIw6yzzKWLudeXQxRQuSikEZfZwq4RDFUzhMmEePmvozlnx2vl/Ti/iAwvEfq+S5ZWWsTHhHLVYI7PKRY+FrkeQ0u+VJfUtGeTgLADcDvyIfbsqdqjt1CUa88UZXRDn8+JH+XVfALOHrSClEd7+jcGPEI+FtAWmxuIkvyCfsOw424YRr3DAsZmINHxbTBV6GEcrCiZas+TaAl/35cqoaOxQZdvRX0p5vrriFheW/4Bwl74X2xH/SDRnBASfoqAlZpdLFxwMJNp1vkYzMt8cC2nnPcFWpLxwo//xlssRA5zgJ+cMBMFZg3iq5feQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70ErZv9D+4g1OzCtk/vx92fLssyiAKLSiAsE7lF0t4U=;
 b=tRHx70tntO820KiFEShriTp36Z4L/z0JNXZ2UNk1IJAYawtvSdNg1js2y+Gz9rb3xqJnZ1kYm/K9zMxxzPfbLbKBxpCAQvtgnuJoHGA5OPBuoiei2UMLiAsm8a5pfMR1FUlDDFhhtvau/JVE2aXASY9jzobTrRerV/j4rBqTLb1snmLdcZeCSYmYisDalh0jw8SsU0AvyeVUNAnwBEblSo+vR+HAY+UhGUWszDd1sIobuRPID0YnT+KUfebp7dF2JVPHyQWxpfdGxDmfrQ0pJn+H5xk9G8zSYEjUdJllm/dkcaC/EinSVESDYjrA3GTwWg2Je1sNcbrP9AeD49uVeA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DSVPR12MB999191.namprd12.prod.outlook.com (2603:10b6:8:496::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.21; Fri, 12 Jun 2026 15:01:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 15:01:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Petr Tesarik <ptesarik@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
Date: Fri, 12 Jun 2026 11:01:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <34223C0D-B52D-41D4-AACC-943A4BEB3472@nvidia.com>
In-Reply-To: <DJ7549TJF9I5.O3K9X2TP8VE1@linux.dev>
References: <20260612085052.59291-1-ptesarik@suse.com>
 <DJ6ZMH9VU0BE.6Q8EHJIL65DW@linux.dev> <20260612133155.71958e80@mordecai>
 <DJ7549TJF9I5.O3K9X2TP8VE1@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:408:fd::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DSVPR12MB999191:EE_
X-MS-Office365-Filtering-Correlation-Id: d3ddf2d5-32c7-4725-0ba2-08dec89389b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	uyG1fJUTacIw6Knv/Dr+9J19tmivYMEnaMCvKXfQelRkpico0knbxqEZiCGVi2syfN9/KouEbZJfPx5wqn7J5sWqKZ7Rjc87njDN44UIrqq+GP8N14M49Ln++42wk8SOznlUwo9wgPXQm/zf0zUVk2L95KU95Pn/vRV1qJ+RmpWQgTTQBTSaysIyx8cFL9WD/Ow1ERKrCEpAm8uf28MKs7cLKMpz4l1aZlq46rUX0I6m5YkNtDAMukKAxM4PUbsNx6GVOZkQOyaWZa3n3oXtFj2PEiQRFrVhL0vCJ93Rrsvj3UHfEO4MuT6rA7O1+7inIk4MrqNeNH2lLNmDRV6gxfjkjbuIbPCkNwLI/2dhloAGH/NzbF72eVn0OGVFUo58nBsClRY9uNtbjRt18QQd/YlWeQgc/eu8jdamxQZMBzlTPhMtFHRnRUf/lZu1s0a+C8IWn52TQ+NWZltLLgCdkpJ0/oJKCw/1oVSST/mQGFspJejqki9pvzxXYKu5D7vgWhctSsAN0hpaej3rUdy2frCvqT51MTnWrEmi0BhZK70ox+T+CAArqkgbt6Jp6/zqg2n79ARu9Hs8r4zswX++l54v/pAr3v9u0wc3QcJHdHmD09tHaTHj2jIUGIcAfqK0B27UzHKull5v7zHwsWYdufglrrbruUiIyY6NyJXWcRCZue+IFnD50E2AUWsoEzYO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F217aEvJYDyDuKj9Sj3FEhcBUqQCfLiSm5pM1+N64Dvs4o0pUpWsHAXp5O+Z?=
 =?us-ascii?Q?SbjbZIMZwsz7U39GlaO4e3DnyJT6K76AD5I1cjGh/2prQ0uJf6gL+tfVHYi2?=
 =?us-ascii?Q?E0d5KMHBs6x5DZt+K48U13AzxoZOap/qh1WQt83ZfUkssn/VlDzILKrVtrPK?=
 =?us-ascii?Q?uzQDuTYtDUDv8h8LEhiDnCgVRiTCn30SWN4zJQXBOVi1pxb2At4quCZ7qz52?=
 =?us-ascii?Q?HTFN6ScDoXKRW/WzT+y6z4EJo2gg1qBxoNZGfRe7Q/x+U6mbS1vhEMdVDfv1?=
 =?us-ascii?Q?fMAgeMzQtBPeviZ0Zop6dVeIqkc5SxMMOTXZnl73JPStsBGWDQuXbkeVPEcF?=
 =?us-ascii?Q?qe9QsiCVXBZfZg6EWz/Z1P4FzBP8qDjNL1/m7xly2C7YcNAzAeAwBH9F11dU?=
 =?us-ascii?Q?h9FZT8yBjPCnXKlv/mVFl2eHaJxLb6XWPLSN7xtu9beJ3afvzhASZ1SqxDbx?=
 =?us-ascii?Q?YBuNZaeb3M3nlv86LSNrtix8gzjBBjf06Rpl2rTE/4YJNEWW+EA7T/Pk0esy?=
 =?us-ascii?Q?8MpOcZWgUp2Zzc3E9nYmx91b16cWY5mjzvnGtpS8K+jJSwIN1z9tkJTFrEPi?=
 =?us-ascii?Q?HWY1XMlp+Bs0iLZjBSV7kWMm3oDUQukkHjvmnCB5B8xPo/mPwhcNobDwVzpu?=
 =?us-ascii?Q?jqIRJDDF77PLACOi4fYYl7aNcEy+bfyDKLdq4EyqGccrPt9dPhF3YiDH0LcJ?=
 =?us-ascii?Q?f3hq9ES0CfOLdEqAeD5zR6oQRyjf5E+zkQM7MjFo5xC6eAHGp9yq9y0631BW?=
 =?us-ascii?Q?YmBiHG8LOu86YBJSBjV7YwRLoV5AohZGWKBvs8kGRMFouTsy7bkZ8xtcbWN2?=
 =?us-ascii?Q?Mls9DVfuLKV/29PKzKsobGKll5eZMG/k1j6K0iHIfy55GiDaeESMjNw9BrA8?=
 =?us-ascii?Q?RoVR7CP3e8psXDVAtfkeU3WtFy92FGYjwy7YrZAnCIfQdFuLGCj44EC/9HCb?=
 =?us-ascii?Q?LgK6EoE5cpDo4JK2p98kKKHq6QiMhGr8Sc03lyti3YgKmAo1xFhG7ZStnNQc?=
 =?us-ascii?Q?37AepQg8Q58iF5nyiVRk7MJ86+va8fVh5Up6sD1zSkXpm/Z2cwgC+ezcxhi4?=
 =?us-ascii?Q?k9Op6ayLfBHQIZXrLGrzMEThCEhXirS1p+4kd1D2nbMzA4ITv+sqi+E/EPXc?=
 =?us-ascii?Q?d4ru/FQJcAfrbDDL62V7Uwj7T+sgfEcOm/ji/kIe3aj5MopJnbZJ9xfiNkpC?=
 =?us-ascii?Q?QBWcw73vokZKC6oFiKsXgMNWJZCdn+50Nnk/Mscl0ReZjIVssFafHjpFr9/x?=
 =?us-ascii?Q?wulVYYMrvENCOUuB06KHpH00J/NPlDSe/XGjiYN0cNbS3TgH6+6tJQTUaU6z?=
 =?us-ascii?Q?w+cKh3l/5jtPcu0zCRraI0MrymQ1ALZZECCfQxKI4gXGeGKbWEyLsDGQaNOA?=
 =?us-ascii?Q?6clq1ZhZ3TpTLj78V4P8H57/1TLNIZnBvFh/XPVdjvEM2IXfKzEbC3Xs2WPN?=
 =?us-ascii?Q?kAZjPXBt4IJsI7G6Ld06bt/XuBjYYhosR/1Aqy3U8CYhNT92ZqCIv4x4MjJ3?=
 =?us-ascii?Q?rzwCV0T1hYYTouq+r1NrIfaQ/v+Q40MHLnyCx47zmKqZ8s9SYaZYxfWrh5D5?=
 =?us-ascii?Q?dKOpgfdTljoRKG2nbZdaF3WgbI4RtMKLTd3M3p2PbWniG3eomVgoRzVjxB65?=
 =?us-ascii?Q?zMU2IlrLHdBY5W0chThWDxqrGL1zl4mzHfT3MQo4wIo7fYsIvKzZB4VzB85o?=
 =?us-ascii?Q?hzUjBqUZiZcav3tT1Qv2yVp/gKlkTjhYlzbV28YSfDbZW654?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ddf2d5-32c7-4725-0ba2-08dec89389b8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 15:01:53.0670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ipm8dAq8VLQ+LiEZhqbtFHfuVFxfEI4jrvTs6OyNmImnOMH5MSeRXrtXyKbPxJgu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999191
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E0D7A0028
X-Stat-Signature: 1dgj9yexm47xtfxu5ynixcdrzp4ami7n
X-Rspam-User: 
X-HE-Tag: 1781276517-466118
X-HE-Meta: U2FsdGVkX18nsI9aog6HPDP5+t+JzwZj5RZuaJJrLc2mR4nv7kZXr0p/+h5xMDlT3cCpwGelRxBn02mWb1qVEqVFNhwUC0AvECXBWbAAiEqVN+2g9B6dlWZf1SwejkXuWol7NdAY0Zes4mZHmlV9LorfRa+NKH7VxU52wTikkV/yEhksdSGpHEGlfJPO842MdnkfFgrWWYuvQlvnevV9NkF7iOI7gYKi18pbJSePY2QvCF2O7B2c+MhyA2/JWQsg9d/mxGuNpAQaYYgV/HVU/jLFvDLUmy968b7mJdw2UmijCWkKN9tPAc4Y52n0FaheLzyx7rdmtyHEzYcM4f91ZLb5+F7H0NbEGtP2UZSdsP6K8tFUSZni+39isi7ieYkQEUE6i63p8AsUAweJMrlGe1GxBni8kjWaNl1JzWmfwEGrnem+2sZ/ysM4IF9HD4M+8S+m0CZgtBV0LThvAx2vXNqjgCeZtKl1ayEF+kTYlB2JP7/rrPuDGjYGb6s4vADokbTKVDdSDBmvPHi6mY4uOQLi28pABulnJVrWNVXL7erkF+a3mfd0OLx/uTrTY557KVHgGVlviupl3/icG5QakTB9YRbNFH9slGbZ8HcV+sMnKj4NByGYucQSyqdoUU0GwXwd3Rl0Q4f6Zm0HJrYI1LgiLiAVU5rLV36Q8GGK6vLGuNjlifgLTWokacliXhFtEqGNzJfWm5mWfEZF44l0M2XDojb9AFCv/rBN7UMR8gy4MYpr4e1BNV5T9Vu6+4MUn0NbeEAb0gq5cjmzgODuzBVj51IkUGoB0AAAHv+KQgkGmObI+IgslEHk6xVRnjd47usbtEvLzC3WnJpb+Np8JIBFmNd2VwEvXzbvScDLqtK9sfRc4Z73T8bFQXUJE0lZVnH05wDhbhkqY6L9lhfsmAtJ67AnTxwmO3Nq0JtjMSf+laiepu+iUQDLvI/4fJp2u63V3APRJHKW7hj9isx
 foT900iD
 XKasRTyr1lGwZz1Qn/IsoM+m4iZ2Z232TmmV45eQqws/x98ykiEiA7Ld9HtYUJcBvUM7Eq7L29d+74aQDTHmBnaZGmuSC2z63IWTH19Mr2ZNu+Xx4Q2idn8LSdbkGISOuV8Qi3fYZdEO9xKVAvYnr0H0ZzaFLUHwjXFyyX4oFW7Ggugb1SUWwudSqV7XR/QEFXGjmf9eOMWG4QY7kmuBmzwas06U83P4Fql3/j8oBdL9useRX/8JdmM8zCX+WUkjcD3qqZHH+pxc6DFpglejn77eBjcz4lbF//vFaVw5ixZgk72PJhCO83xRzzaveBMwxnfRudWeTR+brGu+bTDRqFprngXFW1wIaCgNLyzENdZfCgMbE7b9Z1yRUczF8KyZyBoctrsmRJ4FUEU19Wk3NfUJU7YlkV3u5JyM9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jun 2026, at 10:28, Brendan Jackman wrote:

> On Fri Jun 12, 2026 at 11:31 AM UTC, Petr Tesarik wrote:
>>>>
>>>> - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
>>>> - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
>>>> - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
>>>> - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS
>
>>>> --- a/mm/internal.h
>>>> +++ b/mm/internal.h
>>>> @@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(void)
>>>>  }
>>>>  #endif /* CONFIG_DEBUG_MEMORY_INIT */
>>>>
>>>> -#define NODE_RECLAIM_NOSCAN	-2
>>>> -#define NODE_RECLAIM_FULL	-1
>>>> -#define NODE_RECLAIM_SOME	0
>>>> -#define NODE_RECLAIM_SUCCESS	1
>>>> +enum node_reclaim {
>>>> +	NODE_RECLAIM_NONE,
>>>> +	NODE_RECLAIM_SUCCESS,
>>>> +};
>
>>>> -	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
>>>> +	nr_reclaimed = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
>>>>  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
>>>>
>>>> -	if (ret)
>>>> +	if (nr_reclaimed >= nr_pages)
>>>>  		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
>>>>  	else
>>>>  		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
>>>>
>>>> -	return ret;
>>>> +	return NODE_RECLAIM_SUCCESS;
>>>
>>> Should that be returning NODE_RECLAIM_NONE when !ret?
>>
>> No. That's the thing. Before my patch, the return value here was either
>> NODE_RECLAIM_SUCCESS (when at least nr_pages were reclaimed), or
>> NODE_RECLAIM_SOME (if less than nr_pages were reclaimed), but the caller
>> makes no distinction, handling both cases in the default label of a
>> switch statement.
>
> Agh! Sorry. It's good that you are cleaning this up :D
>
> So in that case my question is: is it intended that we call
> zone_watermark_ok() in the case that we reclaimed 0 pages?

It seems to me that zone_watermark_ok() here is trying to
confirm the number of reclaimed pages is enough for the
allocation, although the return value of __node_reclaim()
might be able to tell the same thing like you suggested.
But nr_reclaimed >= nr_pages might not be equivalent
to zone_watermark_ok().

>
> If not, maybe what we want here is:
>
> - One patch to stop doing that.
>
> - Another patch to switch over to the enum.
>
> And then it _would_ return NODE_RECLAIM_NONE when !ret?
>
> Have a weird feeling I'm still being stupid here, let's see...


Best Regards,
Yan, Zi


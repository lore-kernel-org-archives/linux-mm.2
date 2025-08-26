Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0484CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 16:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2026B00AA; Tue, 26 Aug 2025 12:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BC36B00AB; Tue, 26 Aug 2025 12:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952AD6B00AC; Tue, 26 Aug 2025 12:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 827E46B00AA
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:03:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D51B1A01CF
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:03:18 +0000 (UTC)
X-FDA: 83819378076.25.0177344
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2058.outbound.protection.outlook.com [40.107.212.58])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75F52120003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:03:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=X0fcF+Oc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.212.58 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756224195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duktDTK/beegoAJMxNkbC1e/pQRXCgK3sKpISky+p8s=;
	b=ggKvAyJ95iidp+cG3CkFOrZX19noAYysO7/C98jx1AL4+Yth3HjpUsWLs1wDPA6PPId0B2
	LfkaB8PpCsHtwNMigm47J0ASXTvVEFsBH3jN6qS+dmGl5G+eIrOJPcA3+CbcLptl3JHDHo
	fYjD6bk0t3Cwa1mQG4/OTo3X5aw9nx4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=X0fcF+Oc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.212.58 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756224195; a=rsa-sha256;
	cv=pass;
	b=6zjTLiX2hBeknq5W8cSCIl8/zMEiIqM8bQSVARTWnC/3GDGtBxpCMW2MY7OAC1W8uUcaxy
	b5HoASuxcxKBAwcQQUt482HpvdtO/q5Wixwj5iwnuddSnGlajnYHpmOQa28WuAQwfS4V44
	4v9LC6YjAoQLcu2YTh4BeIUnN1qZ1TU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QGl7pnfmezEEYfRsU2MibV5lqPZY+C6syEKBCRaXKiRyLgQmAZQzU/k6tyLiegkAHlg0r82iB3mBosjmF63Naolvpi5j0izWMGW5auSJiYXLCLX9ko6iokVpTksVKLg4gb6Eq5zSacEKxDT0nDV6e8iElYOxsV1x4QWXgtwrGuGxi4IbTp/6a7hm4axdZ/1m7uzyjSk9+KoHiOX0SGZSef9kAZvb5VnTw2/77gROEdOSH4oKG4fdsRh97v4bUAF3qVjgyINbYxzt7hI59mGho8+KN/MNCgEG/mqS1WVuXqlyU+818rjF9wQ+tK8c40U8uzxfHJwZpoXuRMrgjZitCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duktDTK/beegoAJMxNkbC1e/pQRXCgK3sKpISky+p8s=;
 b=b1k+xv8EwQsR+1YRlgBmfKO7wszxWjfGLDHqJKDNPgXwqU8NNF6KjDe2Y5NZiPTDTCxLa+US9i5EvmMbxXPqeevdUCwt/KEuGXZpCdjtBZXduhMXlxLPt6K22KpOCcjz4d9Wsy0ETxqR45CITYD4rABJjiDjnFGjKVhswNyX5tOO7/6glwNr4oATJ4xWmScEizIwrc5hXBCRSYHTnfBCphNoojnU2rAd7zdKcPJg1pmQYwUt8ZIq2CVesq6XxNnuzf7R3tfFXhC2txzPQ0yKI60eJo1Ho+8Fqz8164t2mWiWWjxqHnM41NpqbQPeUI/ywk9qmWtcWzl3XwRxiOhDDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duktDTK/beegoAJMxNkbC1e/pQRXCgK3sKpISky+p8s=;
 b=X0fcF+OcJ9NVM+AZpT8deu4G0WxaC4ZrAcNmrOHwNxlDmEQ4WYfaXCJ+0BGk1EKj16+aYOgo/BB34o02M3xTtwFq17oWx24KvtNvX80AoLYUwGgPw7WpQ4Tu29SSp7U6b1wHXDZsVqg4qoNtloqcGUutFY3g0MheHkxM6o8vWoMY7U8yYzbCLPIUj4arh9RN5I0gjALUcENqgu6p7thn0xvoG+o3W+rDrE3z4emgusivjRqSm+9iuDdgH3BT87MfGO2LNFXRuopbN377ycxY/WQ75uOW2M2PCpoX95djIyXX75WTPH3oHfHJCU7QF4HTXzDIALr8aV8GuHb6PfNHWg==
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by SA5PPFCB4F033D6.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.30; Tue, 26 Aug
 2025 16:03:09 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 16:03:09 +0000
Date: Tue, 26 Aug 2025 13:03:07 -0300
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
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state
 monitoring
Message-ID: <20250826160307.GC2130239@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807014442.3829950-20-pasha.tatashin@soleen.com>
X-ClientProxiedBy: BL1PR13CA0168.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::23) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|SA5PPFCB4F033D6:EE_
X-MS-Office365-Filtering-Correlation-Id: b32548f8-81a4-40db-ccb0-08dde4ba0cf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xAt4qi5ZJmF/ZCyP0Wuavgznjv6BaHwoy4w7neUxOW7vReNw/vn4tQtw+gAq?=
 =?us-ascii?Q?+FbONilYjcibmRmw371ErZ/aK49XFIj+lbiRquaYXqZZrkg2GyI/dNBfU96K?=
 =?us-ascii?Q?xeZXsSpYKnFVd5770ymqntgT8npUtyUazxxcX+wphcyL1DRceNOAuis8sl12?=
 =?us-ascii?Q?vF+bcmJFEbk9S5oMi01mLd//1zlqU9NR8uieqRRczknL6nQJ9J/qmH/y6iJs?=
 =?us-ascii?Q?TMVut+SWCHUA4sgyA4orP8W5N/WP5TWgHxbQQSuSmfRYzdx5A5l6D8Su7UMt?=
 =?us-ascii?Q?PeTFj/W7tjGoqsMvjsgrBNJIlsvn0LMylGL5p1wdXgq8jHizdIbNm7y6JE3l?=
 =?us-ascii?Q?obqQwcp/yxV37aSLSUQzJLIbIP4Es7xEprSk9ZWojDctmtCuboPbq0W078zH?=
 =?us-ascii?Q?sk+9C3kOaYS24AODe/o78UVpAyqd0RFvIA+jxYA0Wqr4G73IDnHZcs5z3MfM?=
 =?us-ascii?Q?EihHePtSfwYhg7ppt5n+NfIxS0PZPWVHqJK/OKD7X1p+UQrYIRNQRny+msPI?=
 =?us-ascii?Q?Oywrndf0VBDqpqPUZouHefaat/EJwBBcz2JpHJnmuJCtGSyXJxnNTPhRPx/n?=
 =?us-ascii?Q?H+hJsIheJUaETF/aqzEYNHGuxin+sOlRy3X/XLWc5nw/mWdSUI6y2oc5JlzU?=
 =?us-ascii?Q?1feDKEBEBukOwWJPby6aaRh/POJ6FrZ4dyRU76+TNV54mjJT7h88IAe/x0lH?=
 =?us-ascii?Q?hSajeUTFR/fVAZ+uR6sJfuewR4jIh+WfOxfDBnJ+uRiXqBXHYzNjsmqmkqAI?=
 =?us-ascii?Q?mO1RvGE8wm50Ai4af2000MI/vnbQtq6Et4RkNzwBS4qp+zyLZAKox/n30eUO?=
 =?us-ascii?Q?JL8ZuLDxVKOdMCIFJICYeUoTJ9HDqClRrmC0ARylZgEgXDRdVJkE9XK3XppC?=
 =?us-ascii?Q?FimQYbPMUIMtgmoymCTdEi42Oj3A1j+XHtQfb7cEZH6atk4AhljiaPJ6ZfDn?=
 =?us-ascii?Q?bbdww7jdZ03JlOG1RQWAmeBOg2vzn0gCcl5KwIai9CpZyddXNeXEWCOPN7CG?=
 =?us-ascii?Q?PQo1CexjhLfT6jlNI8CiWZV+E2mZxjUQ0SHOIzFAeqWbhNJX98hQSFRs4PC9?=
 =?us-ascii?Q?nqF7wHLvEtMgxeJr0VpvrihHjTSXEoVilfafA8E4U/slLGnsasjjCu8ouQK+?=
 =?us-ascii?Q?JQqOEHpqjDIUawQHnV6J7PF/A+S11GlCOrPWeRgZaD3sMjRB6NPBK3Gb//Bn?=
 =?us-ascii?Q?sY6zhsbRZLZlVXcOZPFpLRV2VEAz+JoKdYqfN4EDE6azFzo6JmIAOyyiNM/c?=
 =?us-ascii?Q?RYz86E1tYoxB9eeywTILPSZtx0FSyuFgpFi+SzSzYrI+7CC1BnQlpzGeXSmJ?=
 =?us-ascii?Q?iaRpFIv/hz8+kDXvGI6tCnsIZVn3/sGeDjKO7+Oo3X9P6yZvI/My8w33PGDm?=
 =?us-ascii?Q?obZN+GCDsdzYRR96cPkiv4t+JbZ0QsKGy7OS9+OXlhvkL5EpM+uY+aDmbII6?=
 =?us-ascii?Q?ZDTQhxrqTWQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mTQaMPy16zG1Sg1P6WHRtpB7ceh+3nn7I4+ZFd0eJoqNRDz+GttoV8qLT9t1?=
 =?us-ascii?Q?R9gfwTIsWSUTCgphM5NB/uCMryHoJOxNyVhWbcG9nf722CfY+CmofA1UcJMb?=
 =?us-ascii?Q?cp8Z8rk1QG+P5lgCXJRPmbrCzIiYfYqEz9tWbwBwIzxQrpalMrlKWdM26tS6?=
 =?us-ascii?Q?rBO2NrTuoRhcjqKdcGBSfVWwNjj5DRVkHuzc4YrM4P3wmeP58sKT5dovjP2K?=
 =?us-ascii?Q?eKSJ7WJRe/O5Eor0VDVAwWCk1h4v5lnQ04fhSv+p7dhAZW4WUmbSvDIDZMQB?=
 =?us-ascii?Q?wQnC9c3FJH/dS92OCSKFSUgX3U6p1dBnU7LvnFVE7kvHqGQtcB/7Cz5o52jF?=
 =?us-ascii?Q?+AMyNPNYJRVv7CSH9Grrx0q0SwjntepPFP3X5L2nMOjWPVc6x6cfj/lpSNUQ?=
 =?us-ascii?Q?b2bgnT3PZyfbiTP84my0u0K7OzAj1+tnEZ92k3sFNeLYdEaettHvMOf1Cso7?=
 =?us-ascii?Q?UMVAtNZNM9zDD1pdc5hK0Qt76juhoXUV51EJ0my7A5D9fyZBp5sm0tJ7qh8Y?=
 =?us-ascii?Q?m5d+Ti5QL79oi2LBPPbc9zFZQDZRDxa6+DBNvqwKnJuywQ9mFf18IBFEPGdo?=
 =?us-ascii?Q?QJlSTpAK8TOsxOK3Zo9AbrrBc4AVpx1dgDzuUI3AqcNDpkp9GSRbqJfwj/ZC?=
 =?us-ascii?Q?knbgGRImbVuQpVPWZe9X/XMet4GayU35QN9dAJ2Jdl3mY4v+QxhpYFB1lVKp?=
 =?us-ascii?Q?M4wVg7ZU1V8H0K/GFUjtYx+jIkPBtfz2v/f1ugI1Uig1baMband2Npn1NJBf?=
 =?us-ascii?Q?rwy6HSW1oWpIlk0stCvcL8xxJ58NXEQL8Hj122fDCP1B+rFUJOlMVWwfsKlK?=
 =?us-ascii?Q?+RXdZbBMuYcmbmy3yzq5LlD3tpnwbX7So6rhV2wIbG49RsvQTC9OOyha5A0K?=
 =?us-ascii?Q?sEb3ROAhkRUf7kARhNeleNeytZ39CVPT0KXyzjva89N3cScDRNwWAi5gjGTi?=
 =?us-ascii?Q?QIhwybHFtH9ysLDRasKg+GSuZnUYoRnnxSMkQXhHTzz54kQH2EOasbEcaPAk?=
 =?us-ascii?Q?gUMjRHEFAAvCQZ5PVOx2wtVsRvQl1+nviH5jcnQufET/BigY4Myf6Xt33G7q?=
 =?us-ascii?Q?IdWQLBMEtFRlWt99/2202WJY6y34Vacv+j2Z25wHi1FvvyOXSPGDAGaKGQZK?=
 =?us-ascii?Q?br0o8VBClSjeItpMaAFGV2fkiaHIuATHZZAVjUmF7HzYSA4vftlqKQDVK+X2?=
 =?us-ascii?Q?yXo9Qo4kiY7E269WWMgpc8VxySOjPIDFeQo3rGLDSrSpO58IDhYsI06vY4eL?=
 =?us-ascii?Q?iFJnzEwjcycvom9kUl7U1doWC9+/r4rnkLG8EaYhmoXkww995C+32hTX8kBr?=
 =?us-ascii?Q?pUVnyWHQVGmj0y1eTxjMcThDHNtgmaAJQXfdvoEVS+NZfb0fGIyXfJQipOie?=
 =?us-ascii?Q?eOMZY4ZG7VZdQDqvc4OHf/48nhLOeWfCikzF/OOGQYt12l2BHzNzkf5RyQr5?=
 =?us-ascii?Q?T7BwiGGXMc/Om9Ys0OY0+n0L9H4+082DuABii5yqk8SYjyuzEbKfXnDJ4GLi?=
 =?us-ascii?Q?pzaNDBjlgK3se2+wJShjhik8p4tcr4dwhIsXmOX1+uTGKds/Mso3Gr9iMjKv?=
 =?us-ascii?Q?aa/HOwwuAKPN94puWXz/MX1AWZJLJo4p+6XGbcCV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32548f8-81a4-40db-ccb0-08dde4ba0cf9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 16:03:09.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x42cphmnf5ULCkuMbP3go75nH6O1vf8Vq2sTzbO4Bi0amyAq4C9FqGu63O2nTjBl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFCB4F033D6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75F52120003
X-Stat-Signature: 17gnxzzq4tw3jy45f5cz9njmdjyhj756
X-Rspam-User: 
X-HE-Tag: 1756224193-899939
X-HE-Meta: U2FsdGVkX19kyE9qgBYdcw9jXoBLYSFD4coF2dY1W7B9QIZucklqO6CXDUtUfFLSVjHhhf3O/YtreWL+F3Z0akutps6tss1z2AmsSs1WpWivDvjoD69TS2vqzX4VzB88wH7AQ2vxiESlnoaHVDNHDpVgw+14I0i3ePMBxGhidqIijstqGywv8NiLU6/tL1bnnQ0Qbp16aRpjOzPTzLOwmr7s+cB1SvT3M90N3UhySXY66ku26HKwELTu0TEnYb51mczAzJsUkSVgn/1z06nLGJDdB/RBiC9Tsl0rpwitxRcJsZVAixe2C6Lk5WYzffZkVqXlEBFetp4NWrPTj4hvX0g/eOBwcK/a8rvLBso5BYyxJ4/nkdCxu29CvHTFD/mTEQUnis7uoD0KVAvadIOmqkguFpSkQPgnJJBlKLqAHW/cy60Se1Fqrji9xvPzh9/PK8BuZpB9e8+ij5BKhF/MZhHfbZoC3NNpwV01o3OcQbAv3dilleCoMpOg5Eq2cL+CUH3ntuZ1yq4YYkbVeJZsgViAxdsGBWUklbeq22IfDXtu/iZm0eWLm6Lg7cZCKD+bI4P9Ga1uXtZbwFyp2VWzHFkKn7zQkPxWTPdogSXyvLAcTmgx9VEq4sL2YGc1AUlksVXW0KWLOeo/5ERFsTn8lqBaEKu/7FAR1GZa6EUonqTu4eoFbxW1bIVYp2WwqEihnz2q8FvmMJoBf6SuTD+HflqBs7EQ0DITevEiRSeGQK8AHie4BbOtSkrJsPDhqsrjlf1U520qoDlD0hdjjD4Tc9AWUIPXuKhSyLsyYVQ87N4k2OTjoXGTvoIGGqhfOkh+hf4/yJErRnwO+nXQaS5dUXvU728JXFtliQ8lP1JOaLdsGBWunVZap4IdFLTeld7cnUcacrw63vfRmA+Oei29xYY7/L/4DygrgBqrHaiR+lzJkZySa1GnkXLTe41yCkLUJj8ipR9Tj8ko/o4hpBW
 ht6M3vmA
 v08zVxvpg8iZYqC91b++8trmGjBwesS60nCDb1uCk3B95i6T8nG7H3V0nXc+1V/usVW3v2swgnRrPKj2tv0cI5jQEbsLPPxV8A3sYCnG1C4C/W/fXd5MoQfGVCas3ihxC1PK7Hf78CgsFkJQvb4dlPQwcKPocDuB8+Qe/A38NBX/9f9I4Ox2E/o08Vz3+BQEzQDWXcBbeEXqa5g6tjMSoOYZa7Xo5EJQ3V2RSfj18V6j7UKE0QH6IPCdK+3NUqJyEjbFZzVjbQSGy3nN4XfHYBfHnZKJlWuzfBmqi9LlKc8ubQ8SaEBVK6hzhGWbjs10ecZT+rDMonRoPavN2yyeoRp9P2La4J0NlIFU9ilqSjyYKbICS05UrMoQ/Y/viGV0aGYeKhdeoHdl0z+jJZqoogrtBjtJrWZmgm9obYYfDpRUzRivYXQ7/px6o/TSxkqSHXaf8rrgOQYJEcdo57lJX/5bwIEM4HTfgEdSD8xaIbz6dbZpDiW5kBmJrXt8rW5CZGBv6lzzZa0iCFRtukenHbRNnmgUWhvQeTASjOoyUvPxOwLz0GEkaK7mz4k3EYw1ThhzGQnmK6hpWWmwQJ/nrU3v63ZEEZJzoGOrhCdO59cH+IZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:44:25AM +0000, Pasha Tatashin wrote:
> Introduce a sysfs interface for the Live Update Orchestrator
> under /sys/kernel/liveupdate/. This interface provides a way for
> userspace tools and scripts to monitor the current state of the LUO
> state machine.

Now that you have a cdev these files may be more logically placed
under the cdev's sysfs and not under kernel? This can be done easially
using the attribute mechanisms in the struct device.

Again sort of back to my earlier point that everything should be
logically linked to the cdev as though there could be many cdevs, even
though there are not. It just keeps the code design more properly
layered and understanble rather than doing something unique..

Jason


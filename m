Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F4DCD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADD76B0005; Fri, 12 Jun 2026 14:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985146B0088; Fri, 12 Jun 2026 14:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84CA46B008C; Fri, 12 Jun 2026 14:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71E556B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:34:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E4CC10BC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:34:57 +0000 (UTC)
X-FDA: 84872112234.28.2B9E277
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010010.outbound.protection.outlook.com [40.93.198.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id 06985120003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:34:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mES1WEkQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781289294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uEJBGidTuRydWiiU2snpHL8U615cVtMVhxbBaIz9O0=;
	b=vJ8UJAOqiECD9e3FSMnlccAWcq7giNI1D5haqhPU9oeKMY9IZpL0Zdf5I1JQDMcUHgPNPP
	9lcYKZVu5CRM1LlfqevUTe9UaCsppc8B/hzlQK/4EB3ssZGXJWYZJqxqVRr42y3U4pDMFt
	Ol/pmtpd4CFEfWaa9Yb+vn/p1Dh/0PI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mES1WEkQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781289294;
	b=33PXSfmFC4q9CuMuCoduvQ4yibPefnQHITZKW3pZpUxEiq6O2glcIdT5INxjeizbHcNh1U
	jzFoqui7AQ81ry8LqG2TWQt77BQMisaHxp2Hf5wdWWykYKMIKIHmwbatQ1LDn86xDgk7Fg
	r6p8qYAlvtRp2QLLQGdLfMjVtCT943g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpsIFNeMK0NBsP3hlS5IqoG7Avj6/Cpbobi/scyKF/vw066tOyOkSz05EpEijs4h5nBpXT0fLGEwxJFA3bfyly79pZfvVIybDG7Bicu348PRJPC0juVSvpfx00ngJKq7K6dBEwTDW+VW2tM45NcSOfP8+DGO/bbKfGRfjcNHwfNjPJ86AdTDi3bcInZX6UMqPVQCG8cSkTUSEXNh3yBpzah0IRBTGdK21DYWIoNzf4s+uy1iUHCUCaoU7QNAkTM0ZMN3MzwKWggb5ajNgE7d91C03mXBK4Lj8hR3w27M0PaYcTNEQUEnEsXhjzgonXF/yFfMw9bhUEJEcfnUbsXKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uEJBGidTuRydWiiU2snpHL8U615cVtMVhxbBaIz9O0=;
 b=sDZyRkSoU2VDm1vlFkdnjEdxpLWxpUHziY+kdGOk7m8RFIKIg6dF6CGldI5ttMW96BdCCaBQjUoF5WKXrDfleEjssrhEWlI5y7tr2WVaHhoxN9X7JwG6R76oMPcovXyaAR+oCIJ13GOn2AwqBQ8nn8/vc7lsAqarPTbix1hxrFin2e8MVK7tZ3Irq7Bu5Lyr0raJdXf34cTKvndGHuG+meKvbrVHYkAvwc9Yg3XvXgx4CAEXLCR+IL1o3cUh+nUI8hXwilmUtSTGIoimweRCP+gWWzzRXNWGBciBwpR4CqvxHp6m7LFdQRUSg9TeoyY3I9qD6JfPXVXtNyoxuKAfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uEJBGidTuRydWiiU2snpHL8U615cVtMVhxbBaIz9O0=;
 b=mES1WEkQyJ4/rtqrZTxP9IENj/1Slt0UQUJCuJGiObLbe2FLhCkiee5pPMMxJ8D72b6AoC1B3gCpZ7jypZi+MmfaIeQ1E4FN+YrjhvrakxYUb+0teB9mb9XQ9JseFCN9P9wBs4Hi+NZ7iLFbcMhrAE1ssRj24V794c2gDZZz7WW5VLXwwpKS7bAzlN0EZf4SaGxXTtHAkihg6YKzTLuHvmiJGtSPGdgu7b5CPbr28Tm7HMFlfVbTvKbVqQigT00ZhvgiWssNCj0Nzvj9dmgGhsmKEE6rywgCPhcPhltc1iIeUoJi6kt1IM+hs+hTsGG1nNB5VaLvjR6vLtMYGLiL3g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.15; Fri, 12 Jun 2026 18:34:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 18:34:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Jiaqi Yan <jiaqiyan@google.com>
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com,
 hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org,
 william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org,
 osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Date: Fri, 12 Jun 2026 14:34:44 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
In-Reply-To: <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:208:23d::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c4d140c-1fc2-4c1e-a5ae-08dec8b14885
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|56012099006|5023799004|11063799006|6133799003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wfkWkCd73RS5u0SPs+hHXoNA8XXmZ7ohVwedtO1iC4P/wwNbqIgHXT4OqDUTpJ+8t8gOJtvyGeT/SrG1Ml6fVrY3F5W6hBM58ofiHHSwTnDAk3Ecdhj5XiL5wMhVwoOTVkt5L+lJgtdlk6rvbk/9BPgzAiG3xqYlE9TFdtvwj9gazG33YHPD+kiDTjApU21Ovxdl511J3DMGfIKkobJfpFGLTaRnrqvqRNaEdmytUm0talnheoF2s+wEYEjKLLTIBTIhbZb3VeZPjoC8dlrPVJH41XVNrbBq+E4pKjOhAUrJHIhOI0BNkbS+D+Y74404FJAPgWEtbYh92Gr+lFppWkzh7OJRJCXkilE+W04GePYxcWIHYgKcDA5sGMeSoRlTJZxAQMzLNWPHjXc6Yv5kAPYUDjiH0MJOjySyN5uQFfwIowZM3HFBrZmJkwfJlFnIIui3JYa8lPCR8lR+jNGZ5au56NoKAulS3xju+ILVHklQ3mccmvXwVGK/TnR64cLADYRDWO9+I/ZJDaZzv/WlPdbf/DRtPBQ67t06UsYFv6V+G1cRPQNQJ7lTw9auqQGjt5qu3Vb4n89iphTmZqFtOY87/g5Yjo+X+RW2dmmolpAJ3yqlR0coWsuaFONBlJsA3IfnhL2Lio3US66j1Pv4dZBtOJ4OAiuIo79Ya5Z8P4G4A+JGoSfbDxOHUp4YYGAp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(56012099006)(5023799004)(11063799006)(6133799003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fsuK2dWxO1qV9aT2szXk2zmSSoVhqTJDb3uIHJGUOhYlhd+/kpz+TPQcE/x9?=
 =?us-ascii?Q?aRv7V3K614aQohl0LWt6IawM28RCFQeihOe6+nU+Wp2w3k+lwhaIogVCeNw/?=
 =?us-ascii?Q?J95RLkTWJSzUlj7wl1mKoLXoifK2OsMy85qhqIPflcjjJUMVvZioPmNpmr3P?=
 =?us-ascii?Q?duV6NchsqU9If0YlMTmX58TxXxy9+oRswoFmdN/CtYZkqxeCbhlTpkI9bHnY?=
 =?us-ascii?Q?OLyadc67InbsTAkoQbi7zMcxPQBHzISqqLu3Q/ot6qVfOmNAiFenF67BPIok?=
 =?us-ascii?Q?lZTKNTnJOLcM3+cWNNcaRVeguBQ17yfqAoSnbIfyeLhv3Q2S/+MnQfqkQ3xG?=
 =?us-ascii?Q?p6vppNRne9ssxPR5ak8u6GDv6q81qHyeVronfX9/3fDKnFSfADHjrdQ4XekT?=
 =?us-ascii?Q?TzTajaXGTtJkIrwpcH9oUhpuhC3mCWiW7K+7MyDgjRmqCn9a1I3mweI2RPY3?=
 =?us-ascii?Q?c+XrR4iO8ucxHoTRNmj93oyF/QQ3PUSy5c++TlEDJokA7JlZy2wcbx4BSo2k?=
 =?us-ascii?Q?U+pTtnA5iJlbfPJDrlP4G1wQAVlxybo1zaNWW8uw9b3oUaEY2pXuWKyZgyQl?=
 =?us-ascii?Q?je1Ih7sHQg0B4XoVvjfQwzTQSAoMRQYL11qAy3Z3+RvYWVZAmHL9t/tXkJQK?=
 =?us-ascii?Q?ehFuib0DBoxBsSTlOUBYsGpr99wG+oL1/rTsjCk0KTTrx5jvD4impTeprTxb?=
 =?us-ascii?Q?6kyi+c0/l3mK7l+mHeSyYAV8Z06owJQMiLiMF7GT5DYIdwK2lj7MCYfFlhCv?=
 =?us-ascii?Q?pM8pcvGeLeMdcLpr8vagBfADrcJIoRo9vCwVTNF2Zp8zrMN4lGrHzvtavy1d?=
 =?us-ascii?Q?AClljUOSEcx04GjQKGa0fxlsbjQfJh8i2ITv3c4edmHtS4eDR/gHaKbtKI7/?=
 =?us-ascii?Q?vwaKEYqfsbqCEhG8UXd2FQRhQrHk9sy3L9GSA7aw72RALaFFJ4laGTUu7cG/?=
 =?us-ascii?Q?hcXaZbpwbtwt/aLcQZXlIbYMF/OkjMma9x9ASZ+MMULTpw+9G7xczK+Ta8yg?=
 =?us-ascii?Q?k4HgdIlQXgYLRvb8Mr/JRtRV087kLUHh2uCeyi+89GYxtcwfdNowKHFTqvMb?=
 =?us-ascii?Q?oEiJIZvfYcIPt3WtMje4yLvGwGnuScaPI2UW3u16yftmxDZS7XAoWqyWllal?=
 =?us-ascii?Q?zdmituito9zBfQ9+XBcVv3p8/mSlqyekdrpnwMIP6jcPthHt9vWfzNvZ2aKb?=
 =?us-ascii?Q?I5TiZlT7WRa3njDsI6DZ6N+sFwxbkBKYy5Rf8XbfNc4YWZdunN2HkFW0lUgl?=
 =?us-ascii?Q?EDla84hfnf930Aq+P8ec1i0q9vCotXGF2yP6JtDHAcuVshdSeCz4Qdmk18eb?=
 =?us-ascii?Q?7k6z3wUSA62fl45gIuN3vf3RQcZy5Vc9Oo3WgBdyluoegAqvilzv/9YQhQKt?=
 =?us-ascii?Q?/02tkO5nZ9tTt7rpdxNXK7iREEjA/DTC/NbSNOxVSU+S364/ruV5FvmBjjcO?=
 =?us-ascii?Q?FlfbyUTfVWOqNHtgB6j2vAbW7VZN0gA1Rf4qzw/5Gq5GHL/xEHQVYy0EFrAv?=
 =?us-ascii?Q?BgzxW/ZRiE0R5WmeBcClTZBS7PgG6H7/zeGJ88kPotS6WRhFpngV4nf997rH?=
 =?us-ascii?Q?C0fACDbGptbGaOGneRx41hHpZqsZX9FvnHWzMHOSzPM8CTsHBEGWMp4yfz9o?=
 =?us-ascii?Q?2OrucNqTlnN3lcm/CSo48qyQLpfLPvpBRx5YRNaw/DBeKbeWzegXtfQOE+Ff?=
 =?us-ascii?Q?BBau45rCweqhPzt5NZYsa3VaiYPNzbkaeG0on8i1MVvKzZHF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4d140c-1fc2-4c1e-a5ae-08dec8b14885
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 18:34:48.6123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5iDTNRx7/IXD9MMRPH+cUMRp6DSciZwxBh7iNG4Xgyij18JhUdV++jE2wC543yYV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06985120003
X-Stat-Signature: ondx3arw3nfaane7bw978bdu411ercbn
X-HE-Tag: 1781289293-689213
X-HE-Meta: U2FsdGVkX1+rVVBlsosBqG0OHyvqONod9i+NJIJ9lJ69UEq+lqts0367noaCPxF+fsYVlLRAK6IjhSNn/S8dkYKCX20uS/FLNBbDIp5rroIVFIEJ5S1z18myVCu1JzR3JqoXXCpQavUWvjBSf4DXq3F59yntQ/kD6NfqEcic52RfDkuAB549PVfROK5RE0tcbkqD0Jy3Fw19OtjJIFcM0GB0ByRkHkFnMaNMGqYw0lT8pPnIUsCF6XHg94UQJn97Wgu6DnU4PDPLQNztNkrumU+b9Uy9e6PlV517k2DUUer+gAtWsVNviXk3GYYUypqU48g0l3FxWWLUvn1hNMHfcXYmOjpaNRCqnUuiFiMGm6e6WCpodabIqRcg8aTuvdn/Bo/NStRqmbsGJBXuDnovn15uenCzYK21gzoyx8ZtJ/9c6mi9jZoXnNkt8cEkdED9nlfhO+xAw2Hh8bN5ccjQI0HLMC9MH2T7yn07e11TOFrKsDJsxN92/aX4XAXgJ1bxWVtPHyRAAmqF3YHoU/OhxVqo+1l7Q2jkJO8JbdaPulu4vNKex8YsOtWuDbr37e7/unkxfh57DxHBCfPDvmPscMsQdYclTva4s3D1/t0Xz1jVPUHbTp46/9gGFYbjbWutJrkmOqy7xzRrzbfmBIcqLwyBoAvTPmZ7FhuDMVQpxLSZTwziaVwFyOxd6Ha12QeVsPKTScK4usT43W1sWRSh699ghXV2nnms62pFbFU3CRBVvyGXXyYBG7HQE5GAzMx/dR2oVtaPVmqYvwc+j3iCdoskdOJsgH4RtPhpQJDoTU0zaki4aQLhBQgAVCp4nvL0T2QesNfCIX/g1Ny2wSHplmD/shGkmBcPCDIk3m6AZHRdKSUJEd/F5e8ZDU2HUoLh5mAsJPOhrNbv4qj+x4nObELGiKsp7ImOPPmCc1EYJSxtEr31nHRDbwUpRX+YjRb2iWjPoEk5qliJ+UMrmQn
 nl+m9ePy
 nMqivltDJGVYddNzlI0W4D+9RabuvPZpJmT4LJJnD9lv4sMDSGiYk3wlIzAbXEvdHP8NbLFMBFVd9n+HCJSojif9ngX79NdpjgePeaS1ko5d/dn5kmk9mCGbvw835lVf43vptAuKJ2WF6Luy5XTtx5tt0v7+giI+V6pYI7AzTjihzfXybxre7AFK1wWbXoQqIv5FM/ogMcKPj1nReRM31rBbeBfAyEOQYnrOIqQXJPJ0LGe/4vWbZcJnJF+D9uSxQtTeyhk6FxzQsQsmhkYlYdvcLv0SG102scheVb6R4Bta9Z3pxO4gZ7QnUiMdWZv6jztzLcYjuzmYnbSEODH6L6EBPzVMm0Rdn6FJqXbGVazycuNROtW5+k2XJmeVXJ0AMWfI1Gkx92WUtesBsk4Ms6d7+qFzUsUsBuztoBo8F5aDzWZdzCYpxI8l0NEybs8M/yFrs5IXKiHc0gYV2YP3k+OsG2qHgW9EsBbKblh1i5IIzLR2eSf121nbkYS17YZkQLJY6xG6s4eYdfYOQOTGuazmeoTPQcJtsZGtuNpqeWlhELyRYLNmEOO4geNSXLV6et73O9OSOJ+3VXRLI+rrx62uhbJRS8rCj0qPIAqVtK+fcrVogoJO/qeuDr78ASpmFVvTeCo0ZNPvQOTNULf1DSWwVmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 23:44, Miaohe Lin wrote:

> On 2026/5/31 13:58, Jiaqi Yan wrote:
>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
>> becomes non-HugeTLB, and it is released to buddy allocator
>> as a high-order folio, e.g. a folio that contains 262144 pages
>> if the folio was a 1G HugeTLB hugepage.
>>
>> This is problematic if the HugeTLB hugepage contained HWPoison
>> subpages. In that case, since buddy allocator does not check
>> HWPoison for non-zero-order folio, the raw HWPoison page can
>> be given out with its buddy page and be re-used by either
>> kernel or userspace.
>>
>> Memory failure recovery (MFR) in kernel does attempt to take
>> raw HWPoison page off buddy allocator after
>> dissolve_free_hugetlb_folio(). However, there is always a time
>> window between dissolve_free_hugetlb_folio() frees a HWPoison
>> high-order folio to buddy allocator and MFR takes HWPoison
>> raw page off buddy allocator.
>>
>> Another similar situation is when a transparent huge page (THP)
>> runs into memory failure but splitting failed. Such THP will
>> eventually be released to buddy allocator when owning userspace
>> processes are gone, but with certain subpages having HWPoison.
>>
>> One obvious way to avoid both problems is to add page sanity
>> checks in page allocate or free path. However, it is against
>> the past efforts to reduce sanity check overhead [1,2,3].
>>
>> Introduce free_has_hwpoisoned() to only free the healthy pages
>> and to exclude the HWPoison ones in the high-order folio.
>> The idea is to iterate through the sub-pages of the folio to
>> identify contiguous ranges of healthy pages.
>>
>> free_has_hwpoisoned() is added in free_pages_prepare() as
>> a shortcut and is only invoked if PG_has_hwpoisoned indicates
>> HWPoison page exists and after checks and preparations in
>> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
>> can re-use free_prepared_contig_range() [4] to decompose healthy
>> ranges into the largest possible chunks of different orders.
>> Every chunk meets the requirements to be freed via free_one_page().
>>
>> free_has_hwpoisoned() has linear time complexity wrt the number
>> of pages in the folio. While the power-of-two decomposition
>> ensures that the number of calls to the buddy allocator is
>> logarithmic for each contiguous healthy range, the mandatory
>> linear scan of pages to identify PageHWPoison() defines the
>> overall time complexity. For a 1G hugepage having 8 HWPoison
>> pages, free_has_hwpoisoned() takes around 1ms on average on
>> a system having 56 Intel Skylake physical cores. This is
>> 15x to the case of freeing no HWPoison page. The cost is far
>> from triggering soft lockup, and fair for handling exceptional
>> hardware memory errors.
>>
>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email=
-mgorman@techsingularity.net
>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email=
-mgorman@techsingularity.net
>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@a=
rm.com
>>
>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
> Thanks for your update. This patch looks good to me while some comments=
 below.
>
>> ---
>>  mm/page_alloc.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++=
+
>>  1 file changed, 85 insertions(+)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index e47679e7a9db..03df929abca6 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_BOOT_=
MASK;
>>  unsigned int pageblock_order __read_mostly;
>>  #endif
>>
>> +static void free_has_hwpoisoned(struct page *page, unsigned int order=
);
>>  static void __free_pages_ok(struct page *page, unsigned int order,
>>  			    fpi_t fpi_flags);
>>  static void reserve_highatomic_pageblock(struct page *page, int order=
,
>> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(struct=
 alloc_tag *tag, unsigned int nr)
>>
>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>
>> +/*
>> + * Returns
>> + * - true: checks and preparations all good, caller can proceed freei=
ng.
>> + * - false: do not proceed freeing for one of the following reasons:
>> + *   1. Some check failed so it is not safe to proceed freeing.
>> + *   2. A compound page has some HWPoison pages. The healthy pages
>> + *      are already safely freed, and the HWPoison ones isolated.
>> + */
>>  static __always_inline bool __free_pages_prepare(struct page *page,
>>  		unsigned int order, fpi_t fpi_flags)
>>  {
>> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prepar=
e(struct page *page,
>>  	bool init =3D want_init_on_free();
>>  	bool compound =3D PageCompound(page);
>>  	struct folio *folio =3D page_folio(page);
>> +	/*
>> +	 * When dealing with compound page, PG_has_hwpoisoned is cleared
>> +	 * with PAGE_FLAGS_SECOND. So the check must be done first.
>> +	 *
>> +	 * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND.
>> +	 * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is_bad() wi=
ll
>> +	 * confuse and complaint that the first tail page is still active.
>> +	 */
>> +	bool should_fhh =3D compound && folio_test_has_hwpoisoned(folio);
>>
>>  	if (fpi_flags & FPI_PREPARED)
>>  		return true;
>> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prepar=
e(struct page *page,
>>
>>  	debug_pagealloc_unmap_pages(page, 1 << order);
>>
>> +	/*
>> +	 * After breaking down compound page and dealing with page metadata
>> +	 * (e.g. page owner and page alloc tags), take a shortcut if this
>> +	 * was a compound page containing certain HWPoison subpages.
>> +	 */
>> +	if (should_fhh) {
>> +		free_has_hwpoisoned(page, order);
>> +		return false;
>> +	}
>
> When the code reaches here, the hwpoisoned pages have passed through ke=
rnel_poison_pages,
> kasan_poison_pages, kernel_init_pages, arch_free_page... These function=
s might write to
> the hwpoisoned pages. Is it safe to do so?

At least, kernel_poison_pages() writes to the page. It probably should be=

moved up, somewhere like above kernel_poison_pages().

I do not like the shortcut method, since the pages are freed in
__free_pages_prepare(). This causes confusion. One alternative I can thin=
k
of is to make __free_pages_prepare() returns a enum
{ FREE_PAGE_PREPARE_SUCCESS, FREE_PAGE_PREPARE_FAIL, FREE_PAGE_PREPARE_HA=
S_HWPOISON}
and handle the return value in the caller.


Best Regards,
Yan, Zi


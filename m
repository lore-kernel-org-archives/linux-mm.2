Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC78606A335
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 00:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LCAIASZQ
Received: by kanga.kvack.org (Postfix)
	id 7283D6B00EF; Sat, 14 Nov 2026 19:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9006B05B0; Sat, 14 Nov 2026 19:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579A26B05B3; Sat, 14 Nov 2026 19:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2463C6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:00:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97644A0473
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:00:25 +0000 (UTC)
X-FDA: 85435396410.09.52D025B
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013069.outbound.protection.outlook.com [40.93.201.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6D5D180008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:00:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LCAIASZQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.93.201.69 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794700823;
	b=OV/sxuxac4i11k8AIx6O+3DoOGYzQDpV/CNDbZIqFeJPqTGozaSVjlfPU0Ght8T2zpMkHl
	xDxsjRmzss+Xj9jTKny2cNqWixb5sc3VY3bZAjRVkNch06d6E2uFmWP+aB/Xvvjfbt3hh3
	ZkF0qaQEAikymo+aRHAr46/aL55BIXE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794700823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4p/ZrzWv+7I/PwL/AzZiq9a/zXoUz1s7R6mVyTlBt4=;
	b=MALamtEREiE933IIuJsfU+B8BCPmPR4DVwqpsYF8WEqH65daMAV1qbP6cNmWTPxD0v1/O+
	asRkb8uvbBpssmAZCQ2dSjOVYCdL0LeC4Y4Gp+ei7kI2DIg/x1Gmwu5IzEfW7TSzXmdg3/
	V6+WXQGZUwqH9hewAkreTXYv0JwlyNo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LCAIASZQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.93.201.69 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Av8KJUKCtHc+zGzV0/6gyeXqm5JvGt5sOfPV47WecDB9A5EW73VzxJ1c8ZUGQSVUXKjaELRHEpnRj3HvqGzMwUjivjkyKXD5OhqjfY8zUxmUQKgaDWFQjbPIipq/qn+m14N4j8ASNRiThZ78wGHbMG/ELHapShq4nhaALDubx0qKqcyuRuRn+WCWXvqKZJFIsd6TAczQDvp9IBfaTANegJ47md1BG/z/nUw3RoFzSey242VExk5afW44uQowVrO34U9+Fgbrorp579Ya/GoLYhyFOhmSBduDePwtf/dUM3i5yXw71VrINkK3WXnLThr1veIMaSw1d8xSlMW6XftzTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4p/ZrzWv+7I/PwL/AzZiq9a/zXoUz1s7R6mVyTlBt4=;
 b=lW3qT71LPgWjZplWWvwG2UlHOw8IYvnTV8PtORhmq97FfXwUeGtYDVo3PSyoYINER6ShMD3HmioSi4j7dzbnWJbxuHU2DZm6TCPCubMtX3E1g2IVFeSrY7f0RFgRmrMGjH7VHi58l/CPqlRPafCkswihXX+fwhyDOL9QSFv0qH9cVtKTADR6ipahBty+eXu2y1w2zWWYjFDnmVwE1bnVb6+LjjYBqt/fQ2vFVjsqIL5evKIA/JDI/u9o2Qefglhc0Yv7FZyMvaBmPu4o7//R4H7z0HZhinpHe96HNOfYtaj7zgcRj25cL/0UIC+5IRx7+XrxH+uB25ob6jfmX2Gp/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4p/ZrzWv+7I/PwL/AzZiq9a/zXoUz1s7R6mVyTlBt4=;
 b=LCAIASZQc8OliH+5bGA8Em6OKSfO4VcMJpY5T3Q8DX0+KYRfp3sN0FflPtoMSqREEITVCZtFxS0153Xt+l3jEka7myIXpxIXWUCKWeY5D2glV3ON+psJQEUQ4xq7HQbySlDnFXipNcEwLNgz+fFZSx5CgvZlT0DRNvDXFx/FOtLZ/3tW/pf7dYBF6vpSf9XtoxQ6lomBKpw9/BHhbvTx33yLlT+Itok2C5U0rFKk0saIrSDxYwXMM38TbVIWRoTejT75hoWPxxy6kyOjv6maHVJ/+nSR7XkkNttWO8mnP9uCC0+4LFjYpqxYj/RePkD6TKcLR/gAyfIdXuA6Mrp8Gg==
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV2PR12MB966079.namprd12.prod.outlook.com
 (2603:10b6:408:3a9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sun, 15 Nov
 2026 00:00:06 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.012; Sun, 15 Nov 2026
 00:00:06 +0000
Date: Sat, 14 Nov 2026 20:00:05 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org,
	david@kernel.org, kas@kernel.org, dave.hansen@linux.intel.com,
	bp@alien8.de, rppt@kernel.org, stable@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
Message-ID: <20261115000005.GG3706007@nvidia.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
 <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
X-ClientProxiedBy: YT4PR01CA0199.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::23) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV2PR12MB966079:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c60e239-9d11-4286-bbe8-08df42ab6843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|4143699003|11063799006|56012099006|261026121527099003|261022075727099003|261021121427099003|261102123227099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	++dRsn/B61Dvn3ujJnYcGqK+7QjOqdpcdKuC1NnguvPrGLS4tSAgVFjAP0yzVjzmcnEfffznd/ez128DKdPbEST2lFg4RolNHo+21rndJ1gl0lx4zRIKFDb4hHka+BsSBw8/y7NVF6PZqW9JpXTAPBgOOvn4k9wwYIhpJ3/PQyZ3ciJiYNN4irh/Tf7uRrZQc/OOPjvw1VmL/6ir3Io2PUX5AzTut+VvAvfIcMS3aHZZb3apGPca0nEliLheyYr1YUq4w+GB3K1yqW+2xkcwnEe9lYPJ6tiZhpExeNBbNYKxgwjTi/gG02mz5+0AwXwZyuiDcr7KziwJoIU2V8Vc+xpD95qklRfwOV3r3h5DX01hqDK8TQbsQ0STK3OoOU3Wirs0SANpaLJ6v2Sfv2wz6aJEWuwZVD4pzqyzbS0rTLLqbJAnppVZcigP+TgkD02u7VZqr1ra4gisaDR6Zc2Ex3UjCDp9S3o1Rzk5MhVAG/dmGjWT3JsLBV04kNhplGFuH/uc5JiBjlHjfXM3nUpqs6+FnWJOIKEUK14JqzZPbcMfxEPfeZeUDmbsku1xNFgDKsf0vBF3CzIMkzOUsnHAal2O1kgOocAqFCTUf/Jrqwct8OikFahW3QPmOFEukZHQMwRQ7D0g9ER+znuYQZydaA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261022075727099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WSmFnDPMJjDXYgIDWj+HdFw8bpDC8+/z7kWy9iEcRf/FbaOly3plJi1NlqUj?=
 =?us-ascii?Q?xgvYZ/4uG7t4dtnGZU7d8smJDt+cuApWYFfodauSzJeppPMg76p5Fiqa5Ncw?=
 =?us-ascii?Q?pqvljfcii2+6w2QVq+QwWE7VwVgO8pRLods3vH6TJJfK5y7mES4Nj+NTRhKu?=
 =?us-ascii?Q?dGdORrFaEoq52dMwtI/Lo+ScJxNuoncHfWMQUrtbHHHk7DbYvTPorsIyTiwc?=
 =?us-ascii?Q?ybEBj7FVRVuQrzbgy8zTzr5Rv/SK1ZNmgMHCuVrul7taORPDj5KD3eY/jGxb?=
 =?us-ascii?Q?fshJpYHRbLwnKpbQufaeXZhhLTpiqlD/GnSBBeTB0hCStcGn2E6lcGxsJ/p8?=
 =?us-ascii?Q?PGu6rtNJvyB4iDM9kOi5+Ys3ZXnWSlG72C8l3wxWUIX9tGFlOizaBZgWDgbI?=
 =?us-ascii?Q?gkaxUOPgB9gtenout5btR15+RASjMgaqV7jPEszJ0iv7DzHg7V5XFu2SBxgL?=
 =?us-ascii?Q?tUw2By0LFK9/dLTGFd9GYpPloDUcS1JLLPCTFmHWx6h9g3uslcFfGKJKWLxV?=
 =?us-ascii?Q?GNurYEbTRSdqolGxv/ucJjXFsV2T4J/vX8PhlszGHavrcWgTaM8qqlvMgNa6?=
 =?us-ascii?Q?0LCpmkkZrnHQ02IVwkPwRb+rXahiKzj7K/bqL7tCsi1KrpKgAwwxP4e7oQ0F?=
 =?us-ascii?Q?l6G+VXaAgC0w5mB5fj6Pv4Gbkq0JXgIthBPKBoQg0iZYmh7kGkoMZI8sYfbz?=
 =?us-ascii?Q?ZhZk15EfB/GLRah2azOMbA/XhvEViJN4tZmgqwU1FnYD3e1tXxbILKHaO/BE?=
 =?us-ascii?Q?x401KHxqHxJLZOKeh4Utq7CVYgJAy6AuzWwq4ibxWM5bD8bzaKCysEESsh3V?=
 =?us-ascii?Q?mjrY/HwEQgQLqy02GGS+I3zO2tdMRv6FRASXkRbJsyLVmLnNriw5zivR/VEK?=
 =?us-ascii?Q?oD/tQ4FXnQiLAHbtG7ab1CpAppWWthiL1FYYPHfZzPLHddhzYGTW8zy2uchu?=
 =?us-ascii?Q?zVWF45vPc/25BtgXCMdum4UWQHtQ01ErGrH9Sdze+IDZ87L3QW1oL1OpFKDC?=
 =?us-ascii?Q?pzgo3DFEaAxO0w6ajPM9XMiXdHdGFPycRpwMDWmVBqLIq+Yh1eDs63El2SWb?=
 =?us-ascii?Q?x60QacfEQPYNv+9T7n6h2vPKnWj1hLIjtii7mZq4Bg1jr74Wew0ZLAu7w/wr?=
 =?us-ascii?Q?jVEq3kZgkBXnvdV8++Zf6bXY6GulH+D6oU5ikZ14cvbgORQKjL8JbLSULYXr?=
 =?us-ascii?Q?KGz0jhGncKzd57mg2wjdH3WyoahzyunjKPhk3Z+0geAz12D8DLgpg06N3dHx?=
 =?us-ascii?Q?16RZq79E534OskJ9Eynbkq6j9cjLbzwIx0UfaWsE9Q+Vv1uJy6TjpWdLwg2f?=
 =?us-ascii?Q?pSs3iT+rnQ2AKlwEbBR/ZtDQnM7aFCMdSarCIpQrhnkM2J+G7N4GikKWL5Sj?=
 =?us-ascii?Q?sb239cCONid08cjXLiLpvbjRurP3tZ7GuSg59xCAvrwZTCfsV+gJlL24D7K6?=
 =?us-ascii?Q?WS5EgqO7b0JOPO6LrgUT11MX25omDlNqE5xM99D2DWQWgVoY2MvbO4zCGaz8?=
 =?us-ascii?Q?WGWln5CB+79QgdLJk3UyJuNlbFdrcZHZaLwdGHl7ZMBiqaM3iAuapx5b7o7Q?=
 =?us-ascii?Q?8q04rDvy7+DpPLQoTKlmYe1rQnstom9FTwVK7AjdGYjfGh+hFwCemmUXk312?=
 =?us-ascii?Q?Dr+ywzdWqUqk9yGSzALDCxzqqnfLlPpaWdgRCLcoeafgUDh7esTjkX22aLQA?=
 =?us-ascii?Q?0t+HVbzSJ9ou6gm4hG1I2LmKO+09qUspuvKBdkY6A0MvAVuo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c60e239-9d11-4286-bbe8-08df42ab6843
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 00:00:06.6799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vS0zo+EzwEMgz3cpqUfKsYONpdgupQ6RWa2PqCP0s0SbuX66w9De7JPYNuFf6zUR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB966079
X-Rspamd-Queue-Id: A6D5D180008
X-Rspamd-Server: rspam12
X-Stat-Signature: b111at9ay4xiurgfndjw7pyhq41zqh1k
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794700822-329761
X-HE-Meta: U2FsdGVkX18nRFEov74wJ9DKWBK65Us6hZkg5+2D8Dytxro2jrduisvK09NSXAXdXcmiw1gwJHg6WFTuM9G1BPL3JncpM2aBUvs06tXe0rGerv4Hr8oiFvOc7SA1mtECNNw752k+18wcqmlExRfjdtkOn1bMShVxvfYtvzzZ2BGgGPH/uB6wKWbb9ZE514JnBqCYkxFQPNfkOcrELCaSSnS747TX3DXdhidEXjtL6ktHdzJbSgPWzJtCZgUfQ4g85q5/qiT8KpiduQ06yVaKzg5JpTpvcQoWUPK5iqklFbDXFrjmcLKtRTSY8oNLI7uT1WbxSjNx14sNXAdG+7EFWQBYJ6xRr99CPyBLYEZHSAF2VOvTpTB9mYDPu7j515FEiS5YEDkWzrxRgCPgM9tSqXDLdOVdMR1p2q7P6tOMOrdB5OQ4CcMoekPwOZueGSpetcLstPMX3VfbUgtma5RRPY4tpgVDLCkGHCqgNM8m26r8vqUxAPHo5R+B4zGKGGYOy2bp20f/xyiNv+eihm0Aw23F45/LkRgBOSiUVpWygZdOaq3JGSgGDB9DJpZNh2JsLg4WmfJeBvTQ3AJwUAoTgS0lwm5JXPzqFDjZpsM3fa3rR9K1OQh/DzvEXdCfBARkvuCPlUhmFxIW60jcqzeZpgqa8dCAcBvbyhboVLiOlqtGRFuOmOs/+JQ7w5+cranrKlETBPA4RQ5+eRchUtxFrQ5+quX16uFzDr8EYjFOi3dfReznKKKi/kM9ZVfG7CCXzHTgUo4AuI6pk92Vw6dJ5Sn6KKfXPIE5wQTGsGLW4XyToonXtiiDmbUclEeJVfTJ8cjRS1ev4JJwNp/2jBmO2TuMJ/fFhm80NJoPgzklzji44+B9hAWNvJ+L8gwuz0jHFJDrpailRoruEGU9eum6IuWYEoe4RzkMPr84HxlTyBKlZDMGnVe2IV2polYVYj+OFALF8+U/I7IS5vNAkqz
 8LeJe+55
 IU2tcDpB6k4rXJug0P/BGbefnSm/ob1OAjNqXwds/cu0LCqwcUtR0OrlYQ0fXQ6LzCAYw322f25w6p2ietJODzlz3p0T4taufBDXJV3XWhv++LRl31v8IbkWehOM15nPrD4PazApGXDQNcXA/dRYrHHi10jTZBf+OU2czv4b+/KUba7h5t4zKaU1KMGHStB/ilSIPPTVXyH4hL0HzWqgHymSj64VsVb9/H6lAb8385dT/WDepdV4saz6OkGwaCp0FCgcHG8m/CiB0ceGUO7wFWTXRuP7EMA9PO3icfvl7Zyq/jxBxIeYV2CX3ne0VV7j+a5LdA5CkGs/PKdDHuzrQ6CxRUyO9SCH9J6DjQmNpoxJUz/mKOaTUURLaadrWvEkc/FPbAQYy2/ZwLjjQV94HMQgUvThjde3WRSpiL7ihKfefT6RDDshlI2Mr5cji6QYFbZDJirA0rIVnYLAGNnf2Ki3UOlXGVBnqIHJ9oMcNa0xHWhfUxmx+TF5iT4aWji37KDRAn55oQmdlgeZ0pXbeFDOGIxyFWq3RtBIem4fHFjKi05BCIDubcGWe+t3xz2lZ+qJ/AUgVneYldMiNJdH3w5GzpNvqUSfDXm10ymWVXQSD1+L19Q7BqEHoitazVkoPJdnaUplSVdG7G3r8BJg9Ugse9sE4WIk1kawfLpFogmrRoisuHXJgKTWi9A/v8HUoIH3EBR09qHaNA7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 06:10:25PM -0800, Andrew Morton wrote:

> How does this look for an altered changelog?
> 
> : On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
> : rejects ordinary stores to it, but pte_write() reports it writable because
> : shadow-stack instructions can write it.  HMM consequently sets
> : HMM_PFN_WRITE, which Nouveau turns into ordinary GPU write permission.  A
> : process with GPU access can then overwrite its own shadow stack,
> : potentially corrupting return addresses or bypassing that protection.
> : 
> : Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.  A
> : requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.

Yes, but it is not just nouveau, RDMA user can do this too and
that is far more common..

Thanks,
Jason


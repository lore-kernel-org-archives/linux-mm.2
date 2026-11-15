Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22124606A331
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 23:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GUaR+v49
Received: by kanga.kvack.org (Postfix)
	id 16F486B05B1; Sun, 15 Nov 2026 18:27:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120976B05B2; Sun, 15 Nov 2026 18:27:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2AA66B05B3; Sun, 15 Nov 2026 18:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC2626B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:27:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2398116086C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:27:41 +0000 (UTC)
X-FDA: 85438942722.10.F49864C
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D246C0008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:27:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GUaR+v49;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794785258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fl6eSTMU/fmjyMNOFYNvVEb6RZkhHYOSLflB/dPQ4fY=;
	b=HR8YhRPCHoiKEIdssEexyqf4QH6irDCCDfYV4+wP+/r/Vcha5yBYNXVALYc8SDLCkgxsuB
	oWyEnqJbtih3zFMMmbUyCLMnQlFdWWZ1+9Uoj9U3iEmZOpQC9R6AgW7ZsilGBqVFXV789e
	5KLOTWeiFNNHwgbMSbi3wV996ZC4bS4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GUaR+v49;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794785258;
	b=YjNfTlTonbjEAnshEb2AJyWIV6+S3jmAoIwFoCotKP705xrizEsw068fYYR11YOBbrKNMP
	ONucTIFMWw5sNPEDYoepV52O6/CfXKmzIC6Y/crap+oLIm5Rvasvwv1a/VQtFuWMYwYLo8
	whaYvJ0q52OLHz/h1YccXsNkGZBD8uI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7fgJ3CDj1WPgEzsG02+krqMspD7i46Ze1cqm7St+ecsLzgKONHXQ06irzxAnI5xke6kyMx7fU3heva+pc2F5RWHUXoJvOPX4frzV52dufB9nCxysmTuVvc6R7FPqq8mLG7XHus2JtBxRTZwiGcxbCrRnhvy4CuqH2agOQFBl0oDfAyxZYkbRil1bbc5NqoAklm+27ELpIZGJoKLI8y05AxFy/ZN8B4KWvelW9h3esfH0o1JKl46jlxx6uZNEMEbD8hxVSPvOAsqDxyE4dJYOXcpwMH58osI528JOqLIWTJ2ks/w4oxWP9TvtgZP9l4APHzs2ue3mOiILkdb2zB8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fl6eSTMU/fmjyMNOFYNvVEb6RZkhHYOSLflB/dPQ4fY=;
 b=JaG5xPHvdNMMryyioMqXTuoIadeYkkk/HHKU2+rl7NihhKbqLRsubkDFLioWs2PHPEO/T1cOufG3KccbFekdMuyK2Fyv17Bjqj2uPF7rxQGXB1J8wYI8zWDhfxy0dIbNO+TopvkBvGu/OHAtjmXfQ17sOTlvi1pmiLOy/HJMsdO1U3FHtiLve7/ZQjzLLiAA6uof0yUCqnVOnOvn5swbFfmfgFL7i5bxas76zqGI9UpL4d2yi/COXGJT83i8VXvcD/3/yVwJsXUBhNNuH/Pt1NhewKyCZno7Wy6a58C4YPy1dONExJIO4biw+tbFBYWO2qFhcxuTWjkiVvDMtj/iqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fl6eSTMU/fmjyMNOFYNvVEb6RZkhHYOSLflB/dPQ4fY=;
 b=GUaR+v49U+JaTuRUJLH+RBqVaTTMrKffqBRK1wEa3yPfqhzGsHH+KBe3fGm0YKBmkKmtddj7Zs66KImgHsTNezaEFc2XhZs4zC07DI+J1zjPKoU2YYfABfSPWo5hS9EXS1ohwLCs3mfUvvd0RqGAwNXxPMknPr+FQnq1xjdUCHoJ2isge1lAoAzPcJFw+f4KlV8waEBhJlqZmnAdpnv+wYFB4abkiN5gstRxiunrhF/ubhRnzWueYtjTgSRXBdwQqfRrFwdnSMFTcgHJVC6Fx8+D2NWfPCT+g7wM1KreHKl25V11Ij3UJzVAFt1EP8r4hpwGy03YAo0MnUhxaKh8NA==
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:27:31 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:27:31 +0000
Date: Sun, 15 Nov 2026 19:27:30 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org,
	david@kernel.org, kas@kernel.org, dave.hansen@linux.intel.com,
	bp@alien8.de, rppt@kernel.org, stable@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
Message-ID: <20261115232730.GC1239159@nvidia.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
 <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
 <20261115000005.GG3706007@nvidia.com>
 <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
X-ClientProxiedBy: BLAPR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:208:329::17) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: 57dcd6d1-15e7-4b3e-0462-08df43700555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|261026121527099003|261022075727099003|261021121427099003|261102123227099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1F1NMMcVwK2CxZJFJcjB0UsHec034gk8ETZo5kCGFCIXPkNSTt8Hz1c15XtORFuMLn/EpJoDyrQ5Bl6mKMRQcfyLzStcm/MsoNZ4W4par5xk0bDOdFGm372hNp1gpy649sfD48GBHAIbd0mKgG//v/7YM+3knTvvJmmWSKNOPD263cccPtjTfusDH4aOXuFeeqDJptnu+cbpjOOmKDssg+hA2E3bqeiQthZV3CgMdib6n0029WQ1Op5RYlHH/8taT1YPEZ9YEjpn3ubH6ZArteHWO7XdkEjoClsl1/CrtyGBZg1NN6rKBlGR3VNisjjW8SOpydJejbSu+NInUR3r++CY2qChNsdEzAHJG5blyOGyF03Kr5qCiIUE9/DKs6Hd1xZZEkaMIX7FXpJxZtGwxFFCuleYajcsB8g5coSPPmh+CdALXfo7FmvK3Fmp7e5ABgO3Q2J45Q9nQJX20cgZGLvPbW/2t7+vI4W65SCPIfRdgkDeLEM30s3lKx3RIuMs2Q2X/u2mz9Tmm3Jyhdqm4NpQ53j4QfMJ6Ngw9gZXNFS5avHWb+inlV90QxiCE8m0adrPZkqda5coGmO7770Z0NWT8O+4njNmA9OGmoKehCJ4ev7wh0ZB9afqhjeFpM8Zk3UWAg+uM4Dl6EQ75qsTrb4taGHUMXwDU0wNPb2JtIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261026121527099003)(261022075727099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8U22XWlOagtrVegvaghheBxqljo2dbcEPVBBDz3c5ZYfifEeXh9+fEoIixp0?=
 =?us-ascii?Q?k6z/HVm0DbNG6C7MmSqfhH97iDsT8JOgv2JYPpVbMUHhug6Pp5zKjqJD6QGv?=
 =?us-ascii?Q?1+fKGnK66oSzq7cmN8uSWOcOAQ6mpX80hP73anTyQe+80U79flubii9XnXse?=
 =?us-ascii?Q?aqVwMdLy6JbjcAyh07MZ3M2bS0oBcQFgKQtoRQp95R4ScUWUZ+S6HRiCE2pO?=
 =?us-ascii?Q?MwbJFYXbnAYf8od7JTR/Q7kPH5iU3ytahdz4+Qpr+XAhpRQLjYFbhQtgiipK?=
 =?us-ascii?Q?qJT7dFw1xNUmzMj72wU4YuDA2oZhuml0RuWjvSiErN+u1+Dz3BbaCEKsREVl?=
 =?us-ascii?Q?bPCUEnk/a78S/sZczqwoBTAHMhNL5LFlqvcVsXnOyrYoq2EMC4x9k9ysUhrG?=
 =?us-ascii?Q?uPFhZWGn0vmmXCWCxIdz4q20V9P0r3mRNR5cJILrHOwRO76oQl3dLLJylBCU?=
 =?us-ascii?Q?jGJFM1qBgRyskWJHMzSPIdB3w2ve4ZfXAuC2/G+45bkRDsIqlzU0SLzO3qFZ?=
 =?us-ascii?Q?TpXhyjp7+svKmdZd5+vJx4cKiNN9QRAD1H8nXep9g24aZl/XDFZRI9AiBcC7?=
 =?us-ascii?Q?2Y56SAziis5D2ZfDYwR3aAFU/4E04Zytfigb7fY5TLm2QVLD8AVkon8rHyMf?=
 =?us-ascii?Q?gqP5+WQfMKqV5YjFEcQJYQW6euQ0xS7bjqYNXG5IqYR3gJ39hCfmph2bA3Qs?=
 =?us-ascii?Q?u3Jf1ElQ+40163cMTgJ57YTR53C1xUJg/ymhUqhSG40Lb+vv3fuQJOVcUoiE?=
 =?us-ascii?Q?y3LGPaueKAMU7ChZKTzAaRltFtzn8MHGy8KQtXPoOQbzFnnDSjNOlAY1TeDI?=
 =?us-ascii?Q?K9bH5DRB/8cTPTtVYXrHI9HCh0AhXX65Gfi3+9qq1rU3hCifhjLGi3Y6LBcY?=
 =?us-ascii?Q?hgz/b5AD7LtSEt5t2rDiWXOnjGwIci5hiKTxzyhOds+KOc9eWNEVpQF5yk97?=
 =?us-ascii?Q?xDZ9IWWAHoyj3R5FyRB5DDQ9NySS+9AeKpc3mnUR4DBEOVXN30enNNv9UsCN?=
 =?us-ascii?Q?S7tSWNcXuXFqbIMdWcMrrSrJUW/lO0taeQIRn3dyNe43yWqZvrve39JV21Y3?=
 =?us-ascii?Q?P/6aB4yJzZl6yrcAzxZ6EarW7Rvd+Ex8VP0/O/KdlbR9MUMJWN0R+R2qmHHj?=
 =?us-ascii?Q?B2wdA/kar5AWThitLSMADdLibWLjDtL5lpSktUYT5SOuJf7ZhVEFXnuhOaSb?=
 =?us-ascii?Q?TJUZzxlN8Vk0hhpsVTzmBEPv+brSE1LzcNolzc463wGunjJzi8hCq6tGNDYs?=
 =?us-ascii?Q?3yEdqgWeDioEUTVzmTD4Koe+uKtulUQaj/D8sggb6tWCEGlLCmXDH1tfUi7f?=
 =?us-ascii?Q?eEnialxxilGRcsSHfr7UWp2KP8yAGTec99bf9S7RuEnlHoXUrEQksSwhFOzq?=
 =?us-ascii?Q?517/NPZpGjxFM7QdwHRM7enH4ZIRkgxeyLsg3ZjGp4KKKihEZDrmibrVn4nn?=
 =?us-ascii?Q?FX2G3iapOb/1WeTQnYIocxtMP/JLgKQdzFkXLBFEoT8b9nCl9Bc1ONirUSKI?=
 =?us-ascii?Q?eetGhxDN/1/DxZrEK+t4PJQI7TRuGhS7NhY5A9oeOW7ySpUb8e2LnAvDu/K4?=
 =?us-ascii?Q?OJw8NoCxOHc/TH/E7tDtnq936gi2frTFDDskbXVYeGx30HObtV4Qnz/JS6nz?=
 =?us-ascii?Q?7Dy4adTPJMOEjiZUizT9bk6G1YI17FgGrUgGq2pGDIVaXo7FMaPDEJZk4Er6?=
 =?us-ascii?Q?VWyfHxrR+N0MS0TITPAI43dFpoOYvOwwnBC+CPipHai09pUf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57dcd6d1-15e7-4b3e-0462-08df43700555
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:27:31.5694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhafV+H1lE4cn7SV7Q8JEdtmoQOYI/M/bLquUWorFUIc0WTewie3XYkxeqecx7Fl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D246C0008
X-Stat-Signature: kejhub6qzoh664egp43bwc3rz1fautjk
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794785258-935893
X-HE-Meta: U2FsdGVkX19YdFiwqMJ/pJwt1B4k6LHVV2UdqJfDXCH37z+IYbcXWQwxo8lv8D3BZeEfpepBQe78YSULRHKWQ1Z58l9pJ0o5CJtiVxh3nBwpdH9QI3ZmAB2qozriye1H2ZfwP3PokV0GG93QbHtl3Kd0egZlXQkK4lrCcfma/a9TKhVK6GmuoGAI7LrXi7Yn1swy+Db6nQoSYc7D7XmWSLgvWmpOZRxviUpksJuoJKctIRiHSMTvZHJ78c/Enf4aJ0s068Y+9qYp41pAsc0/lVQLKgMFxKKyF12r6fAHGKNHDpThaC54ScGp7GiQUG3peffuhxqpPiem/pM4lQsHup0j9l6vi1EeUmYqD2y4e8eD13jdINTomvieeIk2eLEKs2s2GJIU4ju5zwXz02Y7pgHK5aqgC8/2pdKufEUDEd7XTbGpWnBkHyFH6MsaVp8aWwxb7jWo6DjTPOShCgCTp4/2IdmhIaF2eV0lOv3EhrlWiXJcF1HuGPsLwVdNeAVxQTW4EFi48GbmfkaVoO1aM/QflRxB/S1UnAMMH2JzK9ctje0xhaJK0mpHWvKq9jiKok0HXA4MyFb/n9zH1UHKj4BwwC+Ed8mGUh5g46yRJJzL+JO7KhpysCudBhOtC+hHQOFnHnZfeBjOJcteFZjbNRelWAaJNoTJUKGbPWUhw/BGvaDiHmdT8TGdhx8b8AMKYyid4ZLn8M2vZDqaDLkxM6ZLUXOXCeQBxF7OD9tSXJOR6SivQW26bEcY5htnY0XqzDa8FCq88XJjIShJZhrf63ilLgiH0d3XVD2w08YQ2SPeiCpFf4Gk6nuyoue5J9uJUwDGauht585VUfIGV4a1kVroPkNgLbwpiLxo0TMwC3/YsYCEbl8wXANq8Yp4YS9qXrzDlpU48BYTgk+632sSoYugvsyJCbOzrCSA2AIeUlN5SJSIsYsaXzBEeBjIQZlAIGvw8wcVuSSsigb9GAZ
 an2ApkrK
 tOL/ibqi2aY5nYrGGWuwfSSFyx7FVNeMb0HDxyK+/VAe6JaDd6/gr65F/aUSjDCWXm0AVMUsZouiRSDMjHmkV5FRIDLpbeE/pw/Esc2knFEw5nmPmrMdyiuHB4VC2mZ5g2QogmIDzEcd3YoI7hu1Lod5O/dvo5auW1npSL7B6jHccchE2oElMcjPef470sDpL82CRgj+StYgJ1A/cVSCk8opOguRFsU2QQivcs/5ZYtjNbPqs9petuvVHphPklG9hZxY/gB6NHL73S3lfNNGbwC//b+4mHT/FZdTvQtjsgxCGPPA5DcTyZ3sgrqa4nfjDp9dYkfdc/gPctibkUamCUu7rHS3g2CNpTnZJ2jVeJfUQL+kLi2+hLy9vHc/4r5XXo1MUELgjZusb5s0vMEEffeu6TwWMZNhk+eKL6N9G2/PzHfEAxLagS6H/cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 05:01:27PM -0800, Andrew Morton wrote:
> On Sat, 14 Nov 2026 20:00:05 -0400 Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Nov 13, 2026 at 06:10:25PM -0800, Andrew Morton wrote:
> > 
> > > How does this look for an altered changelog?
> > > 
> > > : On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
> > > : rejects ordinary stores to it, but pte_write() reports it writable because
> > > : shadow-stack instructions can write it.  HMM consequently sets
> > > : HMM_PFN_WRITE, which Nouveau turns into ordinary GPU write permission.  A
> > > : process with GPU access can then overwrite its own shadow stack,
> > > : potentially corrupting return addresses or bypassing that protection.
> > > : 
> > > : Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.  A
> > > : requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.
> > 
> > Yes, but it is not just nouveau, RDMA user can do this too and
> > that is far more common..
> 
> Thanks.  This?
> 
> On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
> rejects ordinary stores, but pte_write() reports it writable because
> shadow-stack instructions can write it.  HMM consequently sets
> HMM_PFN_WRITE.  Nouveau uses that flag for GPU write permission, and
> RDMA on-demand paging can use it to grant device write permission to a
> registered memory region.  A device, or an RDMA peer with write access
> to that region, can then overwrite the process's shadow stack,
> potentially corrupting return addresses or bypassing that protection.
> 
> Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.
> A requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.

Sure, thanks

Jason


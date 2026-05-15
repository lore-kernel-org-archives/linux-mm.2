Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F74CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 05:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506B86B00A2; Fri, 15 May 2026 01:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDC66B00A3; Fri, 15 May 2026 01:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD7A6B00A4; Fri, 15 May 2026 01:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8766B00A2
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:53:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C62DD12085D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:53:34 +0000 (UTC)
X-FDA: 84768587148.10.8B1C0E8
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012008.outbound.protection.outlook.com [40.107.200.8])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D004100004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:53:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZBWNs9As;
	spf=pass (imf05.hostedemail.com: domain of apopple@nvidia.com designates 40.107.200.8 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778824412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjpWkYhxb+DEFfVJvYG+GQzTfcidF9fWN+TOq/YdmNI=;
	b=KlgAUTiIZ4tFfoYZ7XOca+aklpQC4ES1L0t3oKL6mDgXK8DT5A66eR/y5/y47KllURMEff
	nleTFsxa7NSfPFYhxGnqZ3tF2F9uCUAW7M5ZVrubJbmleDZ1fqnc27qL24/QU/PtLWFhI4
	0FHe1TOwwSeqcImQ9ZUbm+8l2CbfxW8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZBWNs9As;
	spf=pass (imf05.hostedemail.com: domain of apopple@nvidia.com designates 40.107.200.8 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778824412; a=rsa-sha256;
	cv=fail;
	b=ej6D1QMnjfB23aVCds/fNwSLXJ+wPPdBc2IgszBQmwz7U6RvJzb16fbR5De33dwjuKMCyy
	K9UQzwBSRzClweMsWPhEG0nQTRgCIs/GQu6o+OBioi0GrySqIr5v1CYLVNT0IbVTO+z1jm
	+gfFSi+9Oxfd7BoOQx7xU8crBmdYvO0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDa+sn6TApuHWwV3PD88Ml64jJFANdVxbSgP8UfEwjsEkWaO4ARnk8ZECkuE2EcrXcqb2mICNq6hmyC8i4WSI3Cd0u4oTjHHDNFfBPTa70fIVmPdVjrXtaChJOZ+h0Nb5+xv5/BDu61Ere6bac7onQf6pf04rSJQXcGaE1kvTZmOxMNom2K/Lbsg8oXhW9QHImJPMvAIEj7GFR1eHmLjDx7kQS6GAaGbUI8jnbOjvcTFQ698k+WWGgViT/lGtvTQT8JpBAibIPpWGqJkoV5rDrguIizqCRihSG/QOr0KjH/jmdoI7NxEhNSJV1xqSOX6y9x2P2dbCjYmzJjzES/o6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjpWkYhxb+DEFfVJvYG+GQzTfcidF9fWN+TOq/YdmNI=;
 b=T6xkFIydXdsm71gxqIGrQJRbrzPNzZpew8Piutd8ghSFt8EMP3lbGRlxnDHLPzCyLwTyyq52U/tViJ43Q4BWtzjz4MgCsddEctz0PZ6xi2/v4QClFCO+BPHskdA4+belNyrxZGhFKCyYYVRLCov0X1SoSvwBERJPrMQ3qifUzLTtpJ3+sFoGJheIRtyMJhv+rEWa5Re9N+VjaiFWV+/Rj+caHRqb2mwMRzHPy3ocZb37dRQKtyrimAku2qry+Hm9bLsAGaAOAk+cWn292brh/DoMofdqvzfiLnrhqp2qYjDNXb4VRBbBByMETtXYIT/tSwszrcoTAlBfnkrZdCkJSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjpWkYhxb+DEFfVJvYG+GQzTfcidF9fWN+TOq/YdmNI=;
 b=ZBWNs9AszDU9dcSPRjFV23La3clTk3ES9yRDT4G5Gi82EJXd2GcfKx67URQi6tpgnymN7jMrwqoaUFK/9NaEhkROEAiokkoaFw2njL7e6v8VH5Y52Tp7aIS0SmICCvQXzgnJ86t2rBM49Uvcnsei8xn/JY5cuZKarvLSDjxBvg7hMoAIcemaPz0FGMbtzph/JbvM8xwZZftlqY6+dTgqMGLFq0zSO+z0kkg0dKrw0psMPHpfRkxkk/uuXceISH9AfOrDpfj0XXTICgcQivLuMfcX8kVDczwNFCWoEUxsT6aXceepIfspZXhv3v7udDYwi6TuJ4lKIj4mEZWSpoIoQA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Fri, 15 May
 2026 05:53:27 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 05:53:27 +0000
Date: Fri, 15 May 2026 15:53:21 +1000
From: Alistair Popple <apopple@nvidia.com>
To: liuqiangneo@163.com
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qiang Liu <liuqiang@kylinos.cn>
Subject: Re: [PATCH] lib/test_hmm: fix error path in dmirror_devmem_fault()
Message-ID: <aga0TE2s-NldUtsk@nvdebian.thelocal>
References: <20260514025328.21175-1-liuqiangneo@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514025328.21175-1-liuqiangneo@163.com>
X-ClientProxiedBy: SY5P282CA0031.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:206::6) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 561f06c9-e38c-4d54-54f3-08deb2464898
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RXNL/TUgqQIWsREJGvDBy2GZceac9BOgZIv3eUhQvxJP1h3QM2Uc6UdtxRmEtcjAYjyWL9+vO+mFSXgdDbyRfoPxWmwj3wZy4IBP6ST7mX1tppVQ5XsIDomC9csTBwIGOzW0tlTB492OoCulWDPDtBnY/DtYXb7VLIZMoQx8+8Ej6dAo9mZyHSEFhaTh15AvyCNbMr66w7THBlIbZcgQczOf+uzogN9yks6ytvRYTJOTzGJ/vnmlYMb62LT4WKVOP1QY2GAxOt9OTE5mjoCxvBm7acU+uHGXqO9XZPLsCuMpbXKPES9SUO+risk6iodwKKMtR5Nv6gkDEz0pBtWjxrV28m+ImRCRww9rnWzX/enQ2JBt+rkdnx+SiqiV9PyoVjfYaNox2B53JPGZsw9BfnmbXPmWZzZu9sp6quGItbXbkbGw+dPYbgY2cbqHpKnOFn18W0Ff6V0iZ/RsFxc2F6qUo6oQJqAqjQxxq8E6/R0p2Gw50f3OeRReIyDZdnths21EwVaA5P9FfAiXEZab688NFthuW6YvJLnVUjpDusvvdSLKwFUCiPWaKTimRqqXTbg9CPkt++lmdrtDspKNEbr0XImSQUqGMtrgCoelVU4H2YjuX1+Rtg64G9r+InN8RLoBAFPszFPqW6NbMuOzGcaFXVrCY7KGAyNkbrlYmJ6rhXTL8ppeacpDJOaXroZV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yTXdW5weQTTQylYFzPDmgkK6ttbG0WIz2HRZsewcxq352XineXEr3fRggQrm?=
 =?us-ascii?Q?FVDM+3RenUUHoML0CkNXkA8sEXV35Jhld2NPHI/+SQgsuFZxqTMhqc5nGbqj?=
 =?us-ascii?Q?w9DRtmlaYKzrDzisTH4mcBLiB8sKRIn6Hak8MJURHFA//f0WBWIvWGTdguFl?=
 =?us-ascii?Q?a1dBFokLWsbqsXFcR+3xn0eRY10iX+lqbJfKFaJm5hDyMC8kB2aQVJN6qnkj?=
 =?us-ascii?Q?0tIqixAUxa2W+3GNJn637NlXJTEidedAnMpyLpPjZeTsYEaMoQY2YzWjOYjo?=
 =?us-ascii?Q?s/hiWaGb5kdR//phl6MCmquyQWZIb635jwFeUxFlY1v3ItRMgzySX8ro3ipy?=
 =?us-ascii?Q?V2JCX9Jce9sj4aTinuo1UBmedfko4e36js8l05wTfkP5WFv+/Rw65bFsyRFb?=
 =?us-ascii?Q?TZJw+nvLl5LwhKR8lp+hwPz+Jy3nixVzbKsUFW7PBm33sjVpjLgXcnWs05Cb?=
 =?us-ascii?Q?22AGsmTDXSwGXBMJ8OW7v22lbutfIp0fM/pobt3fcqKF4zabpTY3EN1TbnvK?=
 =?us-ascii?Q?YELKIqztNpdqaXvO/xQQVxzSsTp+qzlwISK1b3HttvJjesWQGhULG6wLs6G7?=
 =?us-ascii?Q?V2Tom9lKX+9gwNRwI15fvss6QGjem9/svJypIvvMxWAjT7+3BfTJSxy4tO/s?=
 =?us-ascii?Q?5/4CddGNscL0JO/QUlH5ZZzcBQi7JOCaOfpwU9VKaXeNI1kl/vdbF7cp9dPz?=
 =?us-ascii?Q?I73a/6f8k3IeNfBPrDr4qQg9ylcJtZcxSKs0xgoF04aP/aIfe54nleYbpWXE?=
 =?us-ascii?Q?QlfLioD79Qf6t9GjW3hMj7kSPcG4DPdg1Fe0IXpmjZZr7WxDUsL4AVloUZmn?=
 =?us-ascii?Q?ls31d1A/Up35/2NU2KkEVHzWTMjrynXfgrUtjnL5LUSWgie6fb5n1A+Bzxqm?=
 =?us-ascii?Q?OgIgZW9/vHPm//iTPIPRfZZpT4UocNWy1PCZK1e9yIvS0qr/HfwGtJcZda00?=
 =?us-ascii?Q?tv7I97vc2XVaCi5pOixLIpZU8CtnCN5IPDXVeIkh9FO4C+1prMSEKeztfPd9?=
 =?us-ascii?Q?7/YeUxTSqto/PjhC9JXXuiNJkaXl/+H2A80MCDoqAUSlxpDb6XPb7Zm4FRxj?=
 =?us-ascii?Q?wi7qjOPMzP+md81eW1fLhwgNczEsmYKaQKNqB9gxEF1JphAW54K5PeC8qx2X?=
 =?us-ascii?Q?+FkQDXgpCNuVJRQBAcDGATNMsA/DkIAdiA1hpZaqHLp9ZWvlIRGJlINvoWXN?=
 =?us-ascii?Q?nu+7Hk6RwQsGM4e2X93gMyhNzMsuKchzwMFbRxYBg4XsRESN5Uab6Wzprtqo?=
 =?us-ascii?Q?bsIx/QFwqgDg9OzMTgSsG60p+WS7V2LMNtuPv3YW9v6Vk1zmau8M1hVMNXJh?=
 =?us-ascii?Q?mdwNLJMF5vsVE3/D3o6hg37jeoF5QlZUYz0oPFHtRLVG/CT/CR8PksJdK2fs?=
 =?us-ascii?Q?gGyNggcLnqJBqBYPyiSi/Plu/dA3h2RBHfZLw3VefmxFolcgZKE56wR9tft1?=
 =?us-ascii?Q?vTtrcizrrKnRnrfz6u46baO+SsjauyFfj78B2Hzv2/vdotUz5AzyQ636SBfM?=
 =?us-ascii?Q?sOOknDXX/cHquLa37++3Of4UWcd9Eb2fI//SnPMjJKPGuVp9vgZ5+t4Jcbve?=
 =?us-ascii?Q?YPxzdK+pBcm8lGD1+iN/5nd9XAuVTU1p6d6fA7PelbM0wlDjF4HyvB0AdQhf?=
 =?us-ascii?Q?as4cigO76LcCMYu5Nc1m7z7IHjnHoqJ5caDVXz60eOqlrJePwflECKKequqc?=
 =?us-ascii?Q?80dNDKEQk+eQ+8waM42BOEPnn1nluaaCYy/8dyIDYeteV6V4TB5E6b/Ty6vN?=
 =?us-ascii?Q?g/90i0rTcQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561f06c9-e38c-4d54-54f3-08deb2464898
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 05:53:26.9980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZ9qNLgWhIClZjLnBPN2uVZTIAwwrkYzvYaRrBWTw6oj48nSEAZQaitWDQt4QlYuWi3MRXVIK8EI0Z0dp9t0IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Stat-Signature: thduw3o1r7ex73a7nz5mwfas8s1qgjnw
X-Rspamd-Queue-Id: 1D004100004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778824411-894106
X-HE-Meta: U2FsdGVkX1/L17lh/KnWzr/tPcj+5VxiGYl37/3xlF8rGfB3MAuX5BIMnsUfHfz6ruwOiSlH0vubGx8pnN39omXUsw5rNGg3xdTL27/dvtoLLVaC3MbfDceUS5hfNlxnBz+uQQq+Hay72uy+nHV1su7rPbsZvtIciAL/2qy6SsOtR0nHGZ8vkQPIGdJo1E51Wtgue88+ksvAyAn1PSHEc9Nd2vr2Z3MmpwDv1Hx1hYuYdBOAF0EyGxPKnm8TdYnxSjU/f3PJG6m5ZZ7qSMCRzBde03EqTmwU0XtEQ9qvw0IVrBEUQwwtIER/amjyxy8DoEUNAachjE7S6+3ItDrvWio8egYazr3gzp+hYbOob9Cwyk5j3c1j/JWb9SSJ0/VGydRBv8oP/HpLNz8gGpic1dcgL2rfMOjxcM5e0VLqR73gHlb04vQgq5emApe3/kMVT0UZFN2pYyEOuPYLk2SxhYiNmtJg1MQbvJ1LjgpHLhZ2uyO3J/1GP1ACGN43ZBInWzR93HzgxiP33IcV1p+ZPzgeJ0JbyzTu3F0DG1676EcUMNrDMDQGbYnh+jMehaP8zajIEOa8uMXwKwJETSRnWemNEzkZVWq3RqBmShzpdnU3JSSYhyqWrRShBY1sySn7aR4gKdNvLgJ0/Y6RQQNlRXDUbyzlRpb1KO3D0i9pxEk4nQjIKHqUdTKsga6sl1cjOpu7m3h1/Qo1YzkI1D0BPtbghnah/btBfN8WCZFDpgvSkrgQDTvMZMtYC70xJ4Q0ytiJPcJhiBwLZf2lsCm3gjRQNtWOgR1DzAr9Is3SgzBu9j9Xd0YEcLu3sshRxs03vhJ6NeKlbfBXQqvYWNGtt0hMMOeA7qUXbh3C/VpiGJyN0hFbC9HeejnUWaxLvPrj9t84GWWP9wnQhT1gDu2K9r22EGRi2px774V0W7zLiqseMY5vdNYobTDFoa7tcEtPaiCU88Vu+Aw3hRGp5z7
 8zBPlU4Q
 dELTlNJ8ApgFQ2pQNGCp1B7p+DyB8uEBG3zIzsB8hTUu/zE5OTKeyCR3Sv62sVhPlN2PyUk4tBJf1+WF+KwPgnCk4tv8Kt6csFpEE28dh36UyQaZ6YKGS4Gyfg9fTZuka8JgmoZLKM1mtptkMaRv+nDoUzQEiDvkBoTMOdXzHhKKC1ifjK0nDkfPnAibkLaiZ57UACX0118oBCKgfivX0DaYQksz+/+CwxILIeoaPDEAtEPBSgtMy59aIcvuAhZQCMJoQzVUZhGPH8VzvBh3laLqkUx1Vnmq5EvJn0DhhAhflPLFAexvGJnjOI9ctwt8yKsXQoJ15KFYf63xfomPpkSkWl034LimrlB/KaQ6SyE0sF6hCNIVa/4RkgNkS87ZfdLha3RVxMpf568lwDEzKFCBYX7CKeaoSiwv+bkA/kJVO8jUv1OIuAyLU83rUnNhJ3f4efUchTPFggdwKkuC9EtmC+ccp73BZcTHmPjhXqXk8XNXQhQet67krvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-14 at 12:53 +1000, liuqiangneo@163.com wrote...
> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Handle migrate_vma_setup() failure via goto err for unified cleanup.

In practice migrate_vma_setup() should never fail unless the test is wrong as it
just tests some static VMA properties. It might be nice to add a comment to that
effect, but the fix looks good so feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

 - Alistair

> Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
> ---
>  lib/test_hmm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 213504915737..5430ef97bbe0 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1679,8 +1679,10 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>  	if (order)
>  		args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
>  
> -	if (migrate_vma_setup(&args))
> -		return VM_FAULT_SIGBUS;
> +	if (migrate_vma_setup(&args)) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto err;
> +	}
>  
>  	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
>  	if (ret)
> -- 
> 2.43.0
> 
> 


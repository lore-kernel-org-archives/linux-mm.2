Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB78CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 19:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA3F6B0024; Sun, 23 Nov 2025 14:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82056B002E; Sun, 23 Nov 2025 14:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A222B6B002F; Sun, 23 Nov 2025 14:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89C5A6B0024
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:40:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 204C612EA91
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:40:41 +0000 (UTC)
X-FDA: 84142889082.20.8B2BDED
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012051.outbound.protection.outlook.com [52.101.48.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1ED7DC000F
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:40:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IBlBsgB2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.48.51 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763926838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qvhsw9h2oOzhOkb6F8igCI2eN+CJH3bV5fWAHLOepzg=;
	b=1J/PRwnPRLAMFvJABlyK400QTkCDHJVM4vRXRNb+rhrOfriwcxJTWfdbp2qRMIQr7izik/
	pMQaUWdvwJKA8Nr0iP13BDa1qE24btFJ7sixDZNhjMtNd7/n94HqwXzAj+03T6tKScL4Ag
	qiUn1kvErroE5JwbQM8uNaT9HiMZ2WI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763926838; a=rsa-sha256;
	cv=pass;
	b=p7XaPZ09QADLENpSaLFJkxkAin6LYpmmTvP/o3pjEY2pByL5hFClM7X6jutv/3CrE2vVYd
	OJ/aFboGwF+z/FS0qcAul5lQx6upOk4sCo3dJu50HRW0UNFrgEtOJZNTnFwgSkNRsIpbTE
	61RMG7twpDivN42UzZapxtjJJyeXH+8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IBlBsgB2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.48.51 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mk/9MMwo4gRsakc4oWHdxk/D2kxBloA7HKAKTVigilxi0+pNBRSnoUhrNoaJA+0vwyT8gJjeNRxzSpUPt6pOHVVm6QE8O+A077Udb5Qfwa9B/h3FEH3YcdIw6lh+kvB6quix3JJNrLXnGWQd5BJseD2sogqOrqJ1XLY93rrCsrQBfHT7DD4m7tmuNR3xQyPFbrxjNl2EXvPewoudJcEqww5dwKZ4TyONjLVLRlUKItTxGJZiXImUTGiYktI0V3M09xoC50bqZy/GJn0e8KiyIXtOvlCdLEuWp6SEHtHHYwiSHoXjxeiFqz27YoDyy0hrQP2V9d1WOlvzwsN1BcX4wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qvhsw9h2oOzhOkb6F8igCI2eN+CJH3bV5fWAHLOepzg=;
 b=s3en92Prl+0QMRALwRDcnOTAEoBiT9njDWgjVb983LIwKuMazd9CCBwxJw7Y4j+sTNBhbpmgij2mAysQ/9A3ZyqvZF+PdNGcpjQfa9kCXGRRSuImTZj1JfpDMARznXKNGH6uRlpIDBff4F1pgvpaWRtyM132Rb1qUR+BfcNchptVLL/l05I20uBYV0J6Os07l4l4lfoJUF8SaX+mgynAyxwbYHsDvgkCbt6UuZAOmZa3BqwxU9tEagG+tG2x1GGxPR5KAy+vvr0z47Mh004Q9y76EJDm8kBKPfgzKU3l/TsQkytk+lpYi8S4QbPflJOfE89NrLL+Ts7D7DqgX8YGrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qvhsw9h2oOzhOkb6F8igCI2eN+CJH3bV5fWAHLOepzg=;
 b=IBlBsgB2I9FwACvYbQGKyPr6VwTDGJdv/A3SKYd9LmoAk3NfAZnBTt3c9psq7G5+481oMLkEk0IYNSDLIHcL3OjNM6e+3DPBKjBkpFPqU37Sa7xoPKmZhWFMPYXRM6aQWr1MKm7aBujFbjOuicYgb7TQtpGkl7wpQAIekgPUhsEnoGDi8FA/FR59IE6XNk/aISVXF5AdSdXnOlVTvsAseEb0H73RI8g6TECLeCMA2e3nkoXqLKnvuPEBp1RSXH2Y4otWSwTZEsSbNNxRPIHLKjD5xok88yZSHrrDyXCXn2nZUcGa1UpCxjLCX7XlpsVnsG7Kfw1un24oxH4Ea3fS/Q==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by CH3PR12MB9731.namprd12.prod.outlook.com (2603:10b6:610:253::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sun, 23 Nov
 2025 19:40:33 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Sun, 23 Nov 2025
 19:40:33 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "muchun.song@linux.dev" <muchun.song@linux.dev>, "osalvador@suse.de"
	<osalvador@suse.de>, "vivek.kasireddy@intel.com" <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Nicolin Chen <nicolinc@nvidia.com>, Nathan
 Chen <nathanc@nvidia.com>, Matt Ochs <mochs@nvidia.com>
Subject: RE: [PATCH v2] mm/hugetlb: Fix incorrect error return from
 hugetlb_reserve_pages()
Thread-Topic: [PATCH v2] mm/hugetlb: Fix incorrect error return from
 hugetlb_reserve_pages()
Thread-Index: AQHcRPWt0PhJ9d1ujka7QfQHRRuYi7UA1hmQ
Date: Sun, 23 Nov 2025 19:40:33 +0000
Message-ID:
 <CH3PR12MB75487DC9A0A8596471A37B21ABD3A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251024094240.337630-1-skolothumtho@nvidia.com>
 <20251024145119.2315897-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20251024145119.2315897-1-joshua.hahnjy@gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|CH3PR12MB9731:EE_
x-ms-office365-filtering-correlation-id: 256ae028-64a7-49bb-5681-08de2ac82aec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hEUsZccencMl2sXFprJgWzWGDONLqugCh9erfNI/ZTDp2Ghjp4Ddw+jrJlv+?=
 =?us-ascii?Q?uZ2WEDbAOaR8+fa6AHvjkZjQnvbxESk2LeNwKgnRJGTM9N8fnrN9eRCeIxl0?=
 =?us-ascii?Q?YPmm40mNw07pniGa3mVIta3EUqRiMlvq5z/6xmkW4R+LjPAIz1QmAuLr1LAs?=
 =?us-ascii?Q?RgmY/yn6bMpYx4F7yz3VWndCZ0nLJ/LwMRZeH68WUI09cCIuUnRF/TY8gEoN?=
 =?us-ascii?Q?iXzI9G56+R8nZIz2Im6mXdMwUaXxjguJxMIgLI8EcQ/JRqNuzLetkU3RYIIy?=
 =?us-ascii?Q?+04Ck1QXRPoKDOokDZQM9s7ZoIZzRzP1ZBq9csOth/6/EM1zJ2m0izptjpef?=
 =?us-ascii?Q?5gLJihuPqOK8YGFdoNzZGAFpPeSbEGH7aRgZvFBE1RsCcJ/9j9xUiqSHevrO?=
 =?us-ascii?Q?ppxQSRwiOxAdDfBfe2rBalnUENiFuw6m6X0fFwelmuSAPX0NOpGSVDzDiXAF?=
 =?us-ascii?Q?nTAnlfPoaXsiBTtSbjIOxKm3c9w93rw6Ba4eJpdu3D81i1osTQINOMOZMA15?=
 =?us-ascii?Q?x8DkU0ry6+KT5uj8vTLbTaL9uyAuibOVXke0/zAhIqh2NdJxGPn6m0BbZQEi?=
 =?us-ascii?Q?+k8i4amrQLiLXa+nPR09uVqvM2YVe9SGX9WRcsLAgGcg4LDHQhXU0/3+P2L9?=
 =?us-ascii?Q?OUPC0UYs8kNcD+qYzS4j28GSvJFRskhpAsq8x9moUkDtcJR2hLwpug1DONav?=
 =?us-ascii?Q?XMey3XLolb41egnbXpQP185d+6W1MmZN2DwfEZ80YGCXbFAlgUtvommJtOs0?=
 =?us-ascii?Q?waYq8Alvik3oYJ3QH3hBRpHt9P9p48ZaQWupHLuxUdbys4lvhAQT0mK+cCt9?=
 =?us-ascii?Q?xwj2bjYG5UhcuM664faqhr6Yd83nA1ARwh7eNrNEMpg3b+YF3BdoX3FmPB2z?=
 =?us-ascii?Q?bF0d/EPGK/gH5qK/prl30QNvAqjOJrLfaLUQQTKVYrMO/uNGEsJ4rjNkfcWs?=
 =?us-ascii?Q?hKLaIyqH51oc5msSZJRJ+HmpfdUajJKYHK4GxD/kFP4We8RMKmQ/AkEZCKdN?=
 =?us-ascii?Q?YyPgNJiHfg20sUYUKeAlwtuQDfdFdDLCtEEFbqEevLiCQPxu2SNqCHFREJLr?=
 =?us-ascii?Q?rHyKFSll5JWjW3Hmca9Yk9jpHeNt0zMsv3zzTir1GLw58k2u8u13BHTVK3qW?=
 =?us-ascii?Q?rL0VbigE0rlelzckrfiOUc6fxjUZzDBjG6UNjewFZoM/8qBn2DAJVb1ZUMY7?=
 =?us-ascii?Q?/s2WUHSG0AdFZoGS+9M+weEuC64qG3ZGWClDfG++prosGqQ6o0sHfGABU4j2?=
 =?us-ascii?Q?hjkHRFqY/B52Q23FuGK8vAdp4OeRHbxxR00cnOqVJwiV3NnlzJ8ElilJhEei?=
 =?us-ascii?Q?bCtPaeMRQnoKY12XBoms6gYt/2FiLS5RjX/lSOvO/QUexF13rotN45BI1Td+?=
 =?us-ascii?Q?g9nvORSMpezz1XHrxw0BunU8Tc64IMnaWLhofjFNEX8Xi+Nyf3Wo2XFG2jF3?=
 =?us-ascii?Q?GwJkTyp+5qXdApuouJmWUFQE2+KGLifcW+UVGPByg0n6w/E4l7YJwACZ0VOy?=
 =?us-ascii?Q?TiHfOqHXbIAnSVFH7872iDagD+/4+yOcAGI3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?6WucxPBLpo0oNe+YP3niHVd5lHsbP4TpDVxhRH4EpLlBHBj/J3bSTHJDDm/j?=
 =?us-ascii?Q?YU5zQALxaE5uwlp5CWymbCQh3vU/dvvt1unPQ+hEDChRunRPA7RowPB83x3q?=
 =?us-ascii?Q?jn4C/rJP3AsdNIQ/QcfAV17Cwai0y9GBBC096hyYGGWxKFTiNNE0B0e/KCiA?=
 =?us-ascii?Q?v1Dkt+3vE0uRPpDcnwFURGljPFZwamCPKyu7OuiX/Avxjd5AkZFZ7QTaED/U?=
 =?us-ascii?Q?f3LU8rnVeRbWxUPtZ2OliJHKvCY3Y4ytEWq0kvD7220dwubsHzbutdNOWywl?=
 =?us-ascii?Q?cytJ1wJAr+4OvIgkG/ZVxoIc89SB5faNYFoAY2UOnsimKh0BHy8oeeWLBviG?=
 =?us-ascii?Q?uHPcyOFdt3enRun+muan3/iEJfp4i7LN6jJyMO1jk04w+4kCB2t+7XyyDDl6?=
 =?us-ascii?Q?QwDRunte3QQ6+1dz5YIeaNuNGzT4X/k0P0uv6hl0DI762ZFpOFCXPeQhe/kc?=
 =?us-ascii?Q?eWCvlQfrnlDeiLfMaEulde9SxEvJtaK1qsq8JjqPhhu2eCvjTsFT08tJ2cGW?=
 =?us-ascii?Q?+XDmEB7xE2n1mrez7sNjVChmwYsUcJgH7aqkrT9drqnEt2mkrXvP72z2fpHo?=
 =?us-ascii?Q?mBPDjIpdFalGOVWQ1CDPTZ7gAgP127DYV44w9bAljKFOV9/qo41ltHzzNaaA?=
 =?us-ascii?Q?4h+Mw2M5Dzyiq79OltJiMjy6GdGFpxOJurMaqI2dAbpGFqutFcKXeIaD+N93?=
 =?us-ascii?Q?dWPAphIQ2H0NwXIS1726poDoclSljg5craWKK4EQR7qd7hs9O54CdU4h17pL?=
 =?us-ascii?Q?Wa1LBKciZzAMx0Cw7TIPBvXbPYZkPHGB/SD+4ZZThnNI2A3hTpVnCAwEb+tU?=
 =?us-ascii?Q?pYvNDuEb6EQjzfDXXc0lr9I5n0FxuIJD2EHc95aXRDOBLAyU2W9fJRam6sxl?=
 =?us-ascii?Q?shSXFJeXPAm7cjU2wR+wRHokBTjh+qhs/atenre2Vdxs7Q9qFixYO7VvdVGW?=
 =?us-ascii?Q?AuDV8x2wh6Sdppv6Z7K8s51CtgcX3AuTOsJ9ITjwT1pbItz6kPOJ/FvAJQ+D?=
 =?us-ascii?Q?E1g+MTZnOO3hXgpRlRrZo8hwP/cSGEp6ZjAERVLB6C00Uppf9VW648wdalv9?=
 =?us-ascii?Q?LmFr5GzQDtNuMMu7Ka6Me4VoNAoIJWLPopHPhAJ5NlbxKteq/wk+EPBsMxXI?=
 =?us-ascii?Q?AvqwWX98vQBq5FprRSsHtsbe2nfpGRSRxYZdRRkJ4AIS4i5QIR/PKYrjKutO?=
 =?us-ascii?Q?tOO94kMoIaXHJnas6F+bz58nPb5VF9D2FJlPBKUahx6rSBJnxL7DdxKZGAMe?=
 =?us-ascii?Q?eiNbASDxTLIhksR6g1Gkuo/Mu50wVmVPW8Wo0Vpsm3bnrgarMf2WzMJEHFNz?=
 =?us-ascii?Q?gHT87Si5Q/uIjK9AtIoozTALjvYS8uB23UCyHww5G9NBOy45APsv2aiAenXJ?=
 =?us-ascii?Q?boVlVVbWozRLWbN+FyeXimViFvBg+qDm763e//bvoev/e0N1VOCDfB9Vz6uo?=
 =?us-ascii?Q?qXzDSkbVDq1eO/l+TRVsBW+c9tZws6Q4kZj6Sz+TxzahLWaFxo+a6E+OjDb/?=
 =?us-ascii?Q?1KmprlH5kupyjvHGZiZnzmF6qxJSBsE6vKf3LId7T8GlavrQRAw/l3CNIkhV?=
 =?us-ascii?Q?iRcgdqpJiWDdRThX8tvXu0KTMAMqYEfRYpRJZm35?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256ae028-64a7-49bb-5681-08de2ac82aec
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2025 19:40:33.5077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o9I8RsN8k8Js8PQOewL8zInqQh0ncBqpUmRoo9FvrrY0h+3Uw6ZUzh4zGnk0+PMHnDvM7NJEbdDbfQCAQHiuhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9731
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ED7DC000F
X-Stat-Signature: 7ezq8ttofyrww8wi47e85mf7nc3k9hy9
X-HE-Tag: 1763926837-874375
X-HE-Meta: U2FsdGVkX1/3jK2EQbsjngyHL0qYPNGQ5KfRBPMPsuW5wAUlzdsraNTAg05e1p02uSR9moGViet5dGQgPuCAXge5eAuTpfvPNpjiPSjoRdO1HYm6u5N0EfMuCz1maIiQ4otb/ObKo63sft9IA9SU/HcpDt0/cG6YxcfYCF6hgEo/iv79NEU4pQORCdcND4+EDgWCq+r/+9Sm7UnxH6LZFHbgpnk8l6brj99QnmB6veoypWUZyDFw1m4fDcFhXofsnGJfSAPzuVVjxPkLs578jpEUP6dnRkYyzalIpx3dX46tWNz55AJCBNvn5/IATyHS8kY4oZILx606sLhuGQZZ7Hf44YxDk5V+++CCUpMFWVI5YIVj0SWn67vT9MDA8g8vn4UFIqUS+TS6VUNnqsgn/mz/LrEQY7y9dPXnuoo4Oz3uIvE5SkgI9v2NMjGdj5Z6z1tY+lWjoywws5C36E83VQpdNKIdVqBVW4TC7ml962O/qkfcV1ch0ntgoFm5Am+1iJutHoQg3r5rQ5vH8INKbN9FGk6rUJ5Gf2J/GBwQyy6ix+nR9T73Pl1dZlvy9vZ9V3CzRKbWdzEXaTzE9hdNnFFaoGEQT/qAzD/bEwkk8seasVU4zFTKDCCzZqEpzpskqVbNfcQAsI+HKygTXfHLITXY6Mlff0GtbJiEh7ldCO5Lz6dgOXsRVljjTeadx99FdmNo1K4f8qZ1/Gtv6LPfR5id8NARs4/UWGod5V4b6DL5f5JqWCzZ6sYpwHaeXHiC7CnPShS70+iMmLNgRuQ5CaKZpPLGZ9kYL+uxdGyXXFrLIdEZVC9LoCFwf8N0sxm42qMBcYrjzmuYINVYPuV8JvjCX27pESGfSM0DCTTOeMSUOr5h0Sm+yUsbdkPVNpokr6LfjkYtRiNbD39xA3jAwrzZ63ReG+RATgq8EeJAq0p+o/aTFKNNNCb4S1MqmDgcRc0+Ls6e+A5BE9oJRoD
 5/r4HxLB
 hIakJQESfGSE0SfQPuwZzzxtPDo1ulvJ1sLSbvxIyQGwLvIlay/KWxngEdL/gl0qaRzGtu52T5exCk1okf2sPmh1whGW2jBIMiqWZZWlULcZn5ILTRc8DXhxDeUjpW6q7ckgXKrgSZ+Zo4LUUynxqCiOQERwEHUueBUnmy8tHHO1Y9bcYXOXvHCH1nOIU79gG+zNnUC+HDUp5515OKx7858vmW+VCGXwSOaiTNITipbjpPSqhI+uIRwiT4U8QSgLJYtAStj8BSquOBgPt0PvAf27jgbpmjeP3gwXE2ZtZvGp/Ur9FAHx28uMCKOxVnjbNC2O+jmoDyN5ZFLgaFERMXLkCc1fwbPqrhfh3CciFLNLUs42+H5AK3YD0x1AyDvDxh0hTZFIjQffRy0hIjyJMYZkB82gWflG5M8hWfes9i7Edvi7VE4mWp/xGUhI3+NZjvWzi4114wqbwB4Ve+v02VoFQ50xj+USPRK+UBKyak+4hZ929QOFdbEf708+jOf0wbvXz1SYEQLhZiNAJ8CGnDaLFIGWLZUrhY0Xiagq7Q+cVu9yAu3+YJx1HiM3WCeTIx2G28M3J0YMpX3pzYE6TFWV3upCSxFAziG64uaabNBxfBTOkRZ4li6md+i6OMtMbTScckAaBAW0e7KjZa3FStaXiYlcAnZEjCgSIhel4HaJq3BTSpDBBEt9OUbGQTxdzOr3Cmxbr8NuHAOH2nmFBuHlNAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000009, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A gentle ping...It would be great if this can be picked up if there
are no further comments.

Thanks,
Shameer

> -----Original Message-----
> From: Joshua Hahn <joshua.hahnjy@gmail.com>
> Sent: 24 October 2025 15:51
> To: Shameer Kolothum <skolothumtho@nvidia.com>
> Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org;
> muchun.song@linux.dev; osalvador@suse.de; vivek.kasireddy@intel.com;
> joshua.hahnjy@gmail.com; Jason Gunthorpe <jgg@nvidia.com>; Nicolin
> Chen <nicolinc@nvidia.com>; Nathan Chen <nathanc@nvidia.com>; Matt
> Ochs <mochs@nvidia.com>
> Subject: Re: [PATCH v2] mm/hugetlb: Fix incorrect error return from
> hugetlb_reserve_pages()


> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>=20
> [...snip...]
>=20
> > +             /* region_chg() above can return -ENOMEM */
> > +             err =3D (chg =3D=3D -ENOMEM) ? -ENOMEM : -EINVAL;
>=20
> And this looks much more elegant than the version I wrote : -)


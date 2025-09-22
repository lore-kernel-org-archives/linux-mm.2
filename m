Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F22CAC5A8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB978E000A; Mon, 22 Sep 2025 09:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD37B8E0001; Mon, 22 Sep 2025 09:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8B08E000A; Mon, 22 Sep 2025 09:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC4038E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:19:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F66611AAA6
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:19:57 +0000 (UTC)
X-FDA: 83916944034.11.07461B2
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E3DA40011
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:19:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pdrya4z+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.18 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758547194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+Moc9BSunqJpw75iqcTAe8J1McxIT0EvavtWtrPnUc=;
	b=yT9ehqAt+8r6fxvaQWEzf0XtnTMi8g2cOQZdyTfFjF4nm+ePZSlDYJWTOImPycklQiGDpc
	lgMLMo4sn8QqX+wku+PANoWSAFrwbAMnOQ4ACpVNueaMBm+XBiqHHcbbTI1Kd5GxtEV+Ku
	3Rr2EgXItTO2nUCLUDbgFeAH1IiFce4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758547194; a=rsa-sha256;
	cv=pass;
	b=owE63inKMGgaDf9FCijMsMXa/4zauA3DlyiqrkwB0MxXAdNQQFQI9zHIlqLNr1ZjiXGhze
	fSy+IA61cByVpmdYFXVXN8gPNzESi/orDjlY9ZdvWq6UlDpSY/J4aCSCds3shDVo30RzeF
	O03w9wyP2MqOonrxl+j/4rqy8q/ejgg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pdrya4z+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.18 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seMkrQkUZkt9eBHwi7tq100dp5HFGG08NgKcYUb2K9AgClCy/2ZOE9aMr7zxx0MnHP5GKqPb/AGe72E1A2ni+WUNnHN0otdt1atQNievReGYlZc4fJLfBoVawoxdQ7CdPZ5miHzyNekvBkIyvt2iE4FG8LKGU8ZWxb0cWY0d6N6m4PICBjoag/aFHagucCIZV7QYIiHmDTvAnRcTElX1dX2ixBljHEUXQ7odQIzWU7bdwVczPdoIBqYKdT50OU4tM7GezYoVNaZ0K/uy2Xs7/574P+q+1uP44+5V+S1ImkoKzq6b7NrOO/v+feujS9NfPv6IGzkfyvYEqtDJpuecNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+Moc9BSunqJpw75iqcTAe8J1McxIT0EvavtWtrPnUc=;
 b=sZIKtdG9hkW2k4gFpXeu/Yhns11o4DJ0OndlXDvA9+pFpIjAmlU2iCitnatdh109UWjM+a8tWDVlaq6tW3zOpAjXZGWkoN4Vu9UPV+DDI8YYcBbQf+dY7pVB6kLWZvgZZkSuwuy7yXat8YfJukyhjkELvwZaAGBVSJDXgvkD9kINFglqOz3I0qQKb7Go4azOIrP1XM4RgMpYPQQaUuO+HwGDty9/pG9KKo7gtre514DJ2BadPGxIzLz5L0ZP+vyi7ugLhIg+az69wZJZrybMew3ZR1C6OGmI5IJd3X6crcijWK9wsWZnISDtPyifCu/5BWjsOgZYS75ti455DfYlWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+Moc9BSunqJpw75iqcTAe8J1McxIT0EvavtWtrPnUc=;
 b=pdrya4z+553dTfWToRltU9ZIRWOOi1sCNTEJkmCyDr30I7GrsVi9jjPUn17axNgARVMVWY3ouGczP2VYHuoSBoFtI6Ku5BNknMcf0Rvkz7elHtSKxAybaOZm4JbbF8vMYYWzWaWwi8/1DzhMHruKtqWS/8hOqQrnGdoqbHHUDhdy1A/3Z3GCb6nCC7+VXjFPOE+kBGQOZNffum9T0UOukeGD1Uf4Mr9EFicE/CXcRtx3fCc9P1d+2PKcr5iH3bcKLZb0kbz7eZR7rATsMYpq2JxRuAni95LxDRRbGFDjSJWt8DIDvhk0LcEwy6t1T5p9zL59kzYQnw3lxQZhm03ndA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 13:19:51 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 13:19:50 +0000
Date: Mon, 22 Sep 2025 10:19:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc
 allocations
Message-ID: <20250922131948.GX1391379@nvidia.com>
References: <20250921054458.4043761-1-rppt@kernel.org>
 <20250921054458.4043761-4-rppt@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921054458.4043761-4-rppt@kernel.org>
X-ClientProxiedBy: SJ0PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::10) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH2PR12MB9520:EE_
X-MS-Office365-Filtering-Correlation-Id: df27103f-f92d-477f-e060-08ddf9dab5e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MVCTRUJxN2Q5eslGmqyXllwyLrZ6ZQKJ3KFVVXLPkQCVTlEFn4FEb8VQz/3t?=
 =?us-ascii?Q?47Yyzwup8WsKxVY/JSPxdIzd8v6JW24RabzeRNlkaCIP5BPoCoutjD16rI5m?=
 =?us-ascii?Q?21IyaGcC1R/8rD8s/RKC2UxTmyWWqD02a5wXSzOWFFe2HHBWQV55ENCmEr4C?=
 =?us-ascii?Q?KPfx9qnNwRKkJ/M2+dqcTw8DLdJL2fqIyWdgRY2+zkmXbu6eORfqkH4PbSm4?=
 =?us-ascii?Q?qEvWym5dqIvL3UhK0Mvje8Tm0sW95l9Z7vQtLu/T9Vn6ONItQy1/BOaCwaDP?=
 =?us-ascii?Q?c3IBZifAxlIkg0ttnu88XMCJ29TjwfoRoXX9Ercowqlj46eK0wYbY8vqYAtA?=
 =?us-ascii?Q?0ViARPTLQsey/zJTYOM8QmzS4dezlfTW2yM7vbS+WhGkGClWw6Di4/Yhgafl?=
 =?us-ascii?Q?fs7N/aJvd9QVbRplGt/hlzONynLwGU2HylLEK1SjXgwSjH3c/KtCRy1W5xTI?=
 =?us-ascii?Q?Ncvw+l05AsqzUYfJMNLQ3oqTSMKlB6RdUVxBjzQi08nv1QZWkhhk4zhypl3D?=
 =?us-ascii?Q?47BhoPHFu86jXzbUkpt2mJW4YKZBGOjW7y/121EzgWHqTBzHFZlOgQqdJHRq?=
 =?us-ascii?Q?Xsph4lTrOnWYkjZ+UCCcEO5sU4tkpXK39SURBBQD1vNnkgBjKV7cbsHCmbyy?=
 =?us-ascii?Q?VZMmcJjr5LkhmsCmQq416BsfpueDbxmyS3Om+BifaagBnNopNNnrzTKC9t38?=
 =?us-ascii?Q?5OUaOsgNIB0ohuL8CpCQORirY09YnCRwtHKIJ67xh+CbQbDMKUOK2y6HPwrt?=
 =?us-ascii?Q?61bPZamvL/RKgXLkxCq7YL4Pz3UzDJUSWn7zFkCtII294f+1WVzYtha2orw1?=
 =?us-ascii?Q?W8UzCJmQYA5XC9r14zLYi/xyvvL9crDnD7WydzNFVjxlCOxWFBtgZvdR9gTb?=
 =?us-ascii?Q?lPgslSxsfPtI9BfMBZTDAKpPGJS953Uzmn87HsiAKR+7PJbgNHn1eyw7I7WT?=
 =?us-ascii?Q?44kfofuVrqWXAASP+c8Z2/Uw9s1K/DmAuN6joFVhZRXT46J7qExwNdj2dmOX?=
 =?us-ascii?Q?SryVEzq2h4L9JfyM8fCyGBlVeAkwMG2EQO67yMWquOBTW2xIBL5z2kLfm6ZY?=
 =?us-ascii?Q?XPt0EBHca0V20nflYSmDJIqtSzYXFbWFp92fDnKcA4R6S746p6IOok2DLvku?=
 =?us-ascii?Q?4q6ttgLBeTc3vCPCjdBO6A8OJA0aX8FH0w8nac7dYcd3q4ey1GuHEKESU2Bm?=
 =?us-ascii?Q?ZbQm6IaVnhl6ufCHIwuM+i6qQcgJOKVZkn93rYPrSq6p/m8kUs0+U0BOIsQQ?=
 =?us-ascii?Q?8LzAXLodplJat4Gx8dFg72C4cUqrL+p3JRIp7bKNKuW7zwNzf3xLTUo/IcE0?=
 =?us-ascii?Q?XMC6JhXlU21jHtsPRni2K+Fqiy4r1dNBXMduCRcHVHInQhJzCYEhhIZgE0Cw?=
 =?us-ascii?Q?tXgbk0i2mlMjHKiI7sosYF7fjYsu+maJTpEa7MS4XRV5HahwEYN1A82lps+L?=
 =?us-ascii?Q?22Z6Au/zC1c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5RuNLLfUHuzDj8DSsc3axagblY8pKL5KaripE7WxVjD/8KH21CJPUym7Idtz?=
 =?us-ascii?Q?d2Ice1K+0ghlQygRcVgpJyi83fML7ivUutC9O5xuc4/qO/NuPBw4EJprxaSN?=
 =?us-ascii?Q?kdKNXpphVxjb6r3Qgzq3FRYufGfj52bH7nxNc1jQLUByzJQV4AaVngTeu+86?=
 =?us-ascii?Q?a3N5ErH8Sv1nSQPPYbzafGN0OGDrx3JwuC6AfVqhYyjyY7GavBJFljHozE6Q?=
 =?us-ascii?Q?P9CPMWT+QmDsCjyy1Pr2JpRhrYk4txobvACn7WRS7GcKKhd8AczZdTmhO5j8?=
 =?us-ascii?Q?tvO85gPAwrUGNYAJBNE6nbk3pwn0QKEhM1HMRdp4xCAovnq68KBDf7KzBQTv?=
 =?us-ascii?Q?gsMgBU779vjqwPwFDdo8m18R5ds/KIpLz/38IP5fYxGNg6ziV2a20U1AfzaV?=
 =?us-ascii?Q?VKCLaFCWv8o47QocHqbv+QVDy5Vxcc4VNs1j4ZbCnVq76M/4gqxWUuvrbw8j?=
 =?us-ascii?Q?noOb+b8q9U5uau21/Mw76ZuLh9byEOMr558LBBUgkhjrTO+22f1Esbqci8e+?=
 =?us-ascii?Q?g8X0sd8T28AxbQOzco5fDVIQ/wogZ/RgOn53X5mN8PIxlmpRNvabmSEuJYQA?=
 =?us-ascii?Q?qSs1m0qmr4PeIqzsXMQ/UrzLS2+eJf3kLpHFOkph2uOUE/IaKG64cq+nVup/?=
 =?us-ascii?Q?O30WphAPGMHpQ4fNmwbVle0SPoAoUtkUqz6cl19d5kPJ84oM9JW+E/Y1ekzQ?=
 =?us-ascii?Q?Gbr+3ytHvgqKXB/Kj3ahfG2KFOsxXA21G9zCZbwc0/LtHykkTTx7WIV1pIDV?=
 =?us-ascii?Q?nkwIFWbkjUM8tzyyFeilFqqTB5ZP/1BJYhn6NiF/S3zZJqNErBVMg8Z/3ios?=
 =?us-ascii?Q?BBCtE/U3WVsjBZTfKlNGr3iC4wMRAwu7NzC/qIEXth4NwbtBRJvW3ghk2yyU?=
 =?us-ascii?Q?uAPdSFU7HAuiO0+XMYkCCR/TWokpbnlUITrFwh+7X8NMWz8O61o/ql3r/aJ1?=
 =?us-ascii?Q?EU7PuQaBcerNAHHyUx0+UmGclRkXcApWswuxELBMrFXHgxCrIWu2M+/lx7Cq?=
 =?us-ascii?Q?Nou9wOBeiv0CG13HHPq9NP8ewnniw1YNs6CP/2n7XMm35gTnSAKv5EYPKU7Z?=
 =?us-ascii?Q?Xk439YtkYNnVVG+kJ43qg6HpW2OSr2g3e7EAlq/TKI5FWiTlU6R82EN5Uz7r?=
 =?us-ascii?Q?1v4mBAExqhUqMfGMHGcJc3I1lXp+Z/tSFcwGzO5fX4wiL8W8naOsOoFHxXw0?=
 =?us-ascii?Q?upKNOTQio7bkzws4xGyHAVnjcupOeGLH+Ep+Gp72uGXrHwQwahiDmJnC8aET?=
 =?us-ascii?Q?rereQ2f9egdfImqk8C9OvaGfasTFvFvrobVEGnV/feH5SjAqPpauX/XEfwmq?=
 =?us-ascii?Q?Dn0oju+iFwz0bQgG2plC8mBSbWFnmrQN7DEO+XVS/LlPUrVTe+j2bbpGRAcY?=
 =?us-ascii?Q?rGe/+C9W4lk2oS62EQx3CNa+iuf0sP2pNIVKiGBUgstTU8AuN+va9kjQGb5u?=
 =?us-ascii?Q?YfNKXr88vvVYQB+O5pDYSQQHAFOTNXcVCmEmDjgs5CpwazGDqIiyYOT++8aX?=
 =?us-ascii?Q?XJ4IIFBEr6ntxfGErB0Uepk0vnGovcbmIUmw4mFe4utfG5JlPMF4icGk1FW9?=
 =?us-ascii?Q?TJPQN+nItOiS/DpqXq/o3trikAlXW4hH50u029di?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df27103f-f92d-477f-e060-08ddf9dab5e5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 13:19:50.8178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjOrA2M9Wmj7JAJ5Ig65t+RvF9v06wHCVg1EUTRV3OY+ZryTFU50teDeqATwVXFq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520
X-Stat-Signature: fwp5mtyqkraajysn1ccwm4khfbqhkfu4
X-Rspamd-Queue-Id: 9E3DA40011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758547194-903730
X-HE-Meta: U2FsdGVkX1+RNpNZaVbJhv4x6s6aCPwjWMQHYLXEMIlUirEjMslppajgcFwd5cA8hYN2ZaW7I2tXjPIHcgAQZOpTVT3UIBThxnFMYatc1+m/58yCJnZH9WTO86NRm0AKIJxFtMpno1b+P5k72R8fhD3y0Qe760B5M5M1GOlI6UGskhPiUgrEqpgqKiVSnyUvhiTvah6zWCxsN6r+qw+MC+9Lobq4/N3yNkq4/+NhT8Vf2lttfs7M03rr0Ko/DNCO4iqntS05otH5POuPlXXKbnaa7gpLYsI88MGopDkWpIUj55eqhV6oFurseK6nwhNADXC8FDu3m8t+0KpibvdmxEy43rkqf9r5rjGnId9F4kIzWEdDTMSWZt9YFdFslZdmMuaKuDFmauMRO0onCiaqdcAG6N66GdABFb1suPnSQUTb/MKKLlOjgCO95F4h2TKDqLhAZN+2gci8S0jNsBE7wRfUW7ealHMk0wUFbWwxrfoEsZ47HEefXzkIm6O345f/ZCnjJRjwMYezoIbJrs99yJFJCr+Bi1Og3SMu0M4Tc98APQranwjoFDJEtuWewKMKIAqHp5fToXEKO08Nhj6rznQnboJQrdggw5P5Kz1KsY+V+TnHCSJq05CTrum1r8du7/2y4BHEcdFJFbkP8saChITWobQ0sdTroa5MdaCXCmqqsfUhqggYHTLmoal7/4UxxJA5zQQxcZlQJNzIam2vHqbCEdcHgYKCT5iWuIs4e2A3YHuReexmhuF/Z1L3MoaZOMNAesRG7VHX8sDRdbbt1+ej+Z57wDPtPAq7tiyJ+ViYpQ9kbc1KVrgyeUsB0UB6AMYgaf/sHAi82y6QDaL6nfc2HHFUgvia90UyrFfrmspu/jWmA8CMkJOuBp3Gpij+D06PJxB0UG9dxTKbIGY0sPTPTnJmXLOrVmp1mYK6cFnhw0hkwbnq/G+oBnuSlMN16QG9CUji9QZkRB0LqcZ
 zBpUiI+3
 hEEmzyxV8NCX4k+wbGCXhQ5/ZnVFAZGOLswtwFcqGbr+0mmwH7gdwZw0SuWozCoz6MQ/g0HzQuca1AmGvSgo1F+HiBa5LU/AGRSPx7cyaGzU7cwHv4m5twLG+ZqNvxrfG8dNpwo5KPyl6u40GWN6bYm06u83Yv7UDvRBWmK+M6mDtaUdAVvQ+ymxGDbtq8OXQwhZw08LKhSfFqRSAYqPD5dWnLxURxWfgKhDpJFLU/FN9xH0UwpLUc0hq0iBU2NlvcrSNU1riPjd9wq3WVrAXaO9hbve+HRI9eFat4fbC1bd1gq4g4ma+WIjNuZ8eK1Mdad1p//sIgcCjKpcB2T2MnW+b9gMR8J5Jiu2rc5cYOJanEXFf73zLGaPuziOUp8jrKJzLwMa0AEvtnCq0Y7lhjC/WpTwzxnvKklAFhZFaMP6C/eIs8Zd0Rwp0YWSZACa1nPL1gnamYErTTTf31Dd4zogxSb9a2Pc7Q5xT+q34X2FgNCSh9E/EaDMOZNOcVljI//SGJgPGaEGL+0GnRFELL7YKig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 08:44:57AM +0300, Mike Rapoport wrote:
> +/* KHO internal flags for vmalloc preservations */
> +#define KHO_VMALLOC_ALLOC	0x0001
> +#define KHO_VMALLOC_HUGE_VMAP	0x0002

Maybe something for a followup, but we should really move all these
"ABI" structs and constants into clear ABI header files,
include/linux/kho/abi/XX.h? 

Having them sprinkled about makes it harder to notice when people
propose to change them and that makes it harder to enforce ABI rules.

> +static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
> +{
> +	struct kho_vmalloc_chunk *chunk;
> +	int err;
> +
> +	chunk = (struct kho_vmalloc_chunk *)get_zeroed_page(GFP_KERNEL);
> +	if (!chunk)
> +		return NULL;
> +
> +	err = kho_preserve_pages(virt_to_page(chunk), 1);
> +	if (err)
> +		goto err_free;
> +	if (cur)
> +		KHOSER_STORE_PTR(cur->hdr.next, chunk);
> +	return chunk;
> +
> +err_free:
> +	free_page((unsigned long)chunk);
> +	return NULL;
> +}
> +
> +static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
> +{
> +	struct kho_mem_track *track = &kho_out.ser.track;
> +	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
> +
> +	__kho_unpreserve(track, pfn, pfn + 1);
> +
> +	for (int i = 0; chunk->phys[i]; i++) {
> +		pfn = PHYS_PFN(chunk->phys[i]);
> +		__kho_unpreserve(track, pfn, pfn + 1);
> +	}
> +}
> +
> +static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
> +{
> +	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(kho_vmalloc->first);
> +
> +	while (chunk) {
> +		struct kho_vmalloc_chunk *tmp = chunk;
> +
> +		kho_vmalloc_unpreserve_chunk(chunk);
> +
> +		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
> +		kfree(tmp);

Shouldn't this be free_page()?

Otherwise looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


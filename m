Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F49CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 03:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2378E003E; Sun, 16 Nov 2025 22:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2D18E0002; Sun, 16 Nov 2025 22:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5922F8E003E; Sun, 16 Nov 2025 22:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 434C88E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:21:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB4F51A0AD6
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:21:37 +0000 (UTC)
X-FDA: 84118649034.21.C5BB638
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C4831C0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:21:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O72U+xE+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763349695; a=rsa-sha256;
	cv=pass;
	b=rUU7HO+jLdqEph8jNGdQT+2+nOn+3wnqflXeXzElYMg552Zj5BxmdIQPh9IwAyK9q9kUuM
	CkEj1x6FjVOOh4hpmmisWh1jH+HoGcsoDEoqfFWVUYmo9Hd/x09xBf1oIsg74gKdaXnqkC
	Zk2Lm57O3Imb3z/zzFJrgNqZ3JNLoks=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O72U+xE+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763349695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vndOqI5q+dp2MCnA0TblRRSFWK1e7arUU4YF1Qfmsi0=;
	b=hdfAIS5Oau4J+lvAH/vqwCXNE8/yv+J/iRG/P8Q2pRm/t9+pk/ZJo1KJpVGtmX1P1J5BTP
	dXDQRFankAJ0Q2DKxPomz+qfznYkFs7syrnh/ArBryK2ggrc72HxREv+I/DtN/AKRPVzVr
	cao2F/DTyKmpu+33MKu1A6smClCl3bc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l0ZxG25jb0I7CxnZldK9rSYwNGAm9p5BgQcjSIfZEKhzKORkoErS+HgaQG4w3VnVoBbObk/YyaneNnRLe0jrRF6w+UfrRLJ6/G6g3SQZf3HnG4/B3Uoskxi1PH9vTcN/P+Ew278m78AyY8breXDinFDiVCp84u00GguMEmG4KPy305kqHebcQJ62PMASYOU0J2POj0WkTuKa27w3iNP/1Lnik3yFIqcvFNBRoEjpqb+HCQ7WQMEOwpcvrUSo+V+jKsS6o8i2qFdawIX/lYQB2ZIPPf0bP8IeEIjSbmRuaCBijQ0fLbVlx6kb4F8dU3HUWXJooRdNQCxZZIpsvHARxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vndOqI5q+dp2MCnA0TblRRSFWK1e7arUU4YF1Qfmsi0=;
 b=UYits3EJPHFkp8L16Hz7ZTvrMcZ/3tXo0HH58CXGdr6pNsuhuTjOWI+O8xYDz9obipl1/dP/o9mv9lzzmM6U9J2RNeAA4d0wfL9vgFLYayQSRWbqMhVxrbVrpjOHSt1oPeUtUUUykcOFoNTKbflhYqz2l2tbTAh91IyhNn/E/SWvSe2673Ok3hnQcOQP9AmkJGrofmxkefcAzXl59yXv2NnbW4t4VFMhERhKmiBwUHNuty5AQn+l52uzASNPuVsiwuGxqECTg/GHFm4blEfmULFO7s5kM1eyAmJkZ5ZYjJo6xNUrbdoPRSGUEN3OwEnCeGlEAjCULqziWmhBpOkO4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vndOqI5q+dp2MCnA0TblRRSFWK1e7arUU4YF1Qfmsi0=;
 b=O72U+xE+ZSFhSkPdvpDqvu7F6TeY4kITbt6uwAtaAC2LMAVm1uyxFKbGugKhqgwRfG4orVcdJx6NWurGywu3TaakmBdRDLJwl8z/FBxEuNyDHFC9NZ2QsdETobJjb5JFGRhSKCyoip9LMqUxbyO7WlNVNEW4X5RsDguRjSkXLKKJuUPWjCPyvEKDlLZ8yx8pJbKrp+bH4wnmqssBihnV4JE6JntV1Qqgqu6Yl9xceMwClFe0xwXGOp8qG++Yb1Zswk74dUJue8fDKvszxW9JqcM9lF27/dCFUOXRTZQbhVUkoP4epdf3SfchWQ3/X1/svP3uJ8/fspJXqYrGfyfWaA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7301.namprd12.prod.outlook.com (2603:10b6:510:222::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 03:21:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 03:21:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jiaqi Yan <jiaqiyan@google.com>,
 nao.horiguchi@gmail.com, linmiaohe@huawei.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, william.roche@oracle.com, tony.luck@intel.com,
 wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org,
 osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce
 uniform_split_unmapped_folio_to_zero_order
Date: Sun, 16 Nov 2025 22:21:26 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <4C3B115F-5559-430A-A240-A6A291819818@nvidia.com>
In-Reply-To: <aRqTLmJBuvBcLYMx@hyeyoo>
References: <20251116014721.1561456-1-jiaqiyan@google.com>
 <20251116014721.1561456-2-jiaqiyan@google.com>
 <aRm6shtKizyrq_TA@casper.infradead.org> <aRqTLmJBuvBcLYMx@hyeyoo>
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e124c2b-36c6-4b69-418a-08de25886649
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HakTxN15afcE12us9MZEvqyk+ZE+x2VA23Eh0gjpMpE1eDOiV66KjFZ5hDm8?=
 =?us-ascii?Q?Hhxpij/twQVhHabkSTePWhqjr698UAKTKI3SAHI0QV+7juyQDaThYMc2bmIB?=
 =?us-ascii?Q?rhQfyojHTbFFXvSjNoQ2nY7L/hV0/iFtRlfNknZtvV9AZoJB1syL6SiJQAqH?=
 =?us-ascii?Q?wwn1eja6AW+XgZITqraFhNt4viaMjSOqmWmvaTqwdMm3QFcy1LhFZBA/P1mB?=
 =?us-ascii?Q?7K6S1L2wlPNCIdIOIWKqKeIPENBhf80jgx5yEKDSiLYd9WEe52k1Tvrqs1lj?=
 =?us-ascii?Q?LX9nJWxtu6+wTc4IpwT8yA1xSPn7kI+9mru7xmZ4Mnx4MJszo9yogISwKpY6?=
 =?us-ascii?Q?3bwMShdtE9fx4/zKNc+wiTtZUZxXU2OhVKkzd2/P2uJ4TQyxheXAHMQk0Xvf?=
 =?us-ascii?Q?j31yJkVhNwKvuGc2ghc8Z8rXLazrrzXhdjsjDhBNWscI2+A2VGOO59ZYihey?=
 =?us-ascii?Q?pSZqA+y+Dby7DCwsHINyHiuRqD/gwaxHn0TfSpt8bcpOtQIiRAeExD9WEihL?=
 =?us-ascii?Q?0FsxyG1gWkM4uQ082fC9W4L80LOXjH4KD6ovrFiaGjHonUD94+DRozG+s1Hx?=
 =?us-ascii?Q?ZlJ3/vbt/DeTxLLBq2Dt/Fky2mMXr9+uKLr0s1mdzM9sG4S256H3X7zYe+7H?=
 =?us-ascii?Q?g+UwL7ie+5didpofrYQOCEC6b9ihJiYS5qwnRMjHUi1kbUMUv4RVldxztVBQ?=
 =?us-ascii?Q?f3c+dJWGQanI7zBr1T4l6jiTzl+fiH/Qu2xr/RxKIns52gBjEG0GKKyXyiUw?=
 =?us-ascii?Q?Yx0FKRU02qRbtg989V5g8P3q2PUpbSihGNduZlCC0tjFSoklpIVa38KXj6Xc?=
 =?us-ascii?Q?plzA9kWpjjoYaVRiu/LsuB2XjLdJ7+9I4Qk+mfTyEadnQ6LdefH87LraaNJb?=
 =?us-ascii?Q?9t4DvA7ZDDvsbCE/sgSzIFIIt6HPb1z8I9B6lqMdK2ZpmwAneMrvgJcRlq9g?=
 =?us-ascii?Q?fMvJzGQwxSd/0KuVidMPy/ouoR1ivK9FPDxdYOeBtfbCwNCGWWc0NHToihfx?=
 =?us-ascii?Q?RLGLVCCsC0ryGeLGt+zsNn4JavqYj8HpYTvcmEAO3NKbG4rkmvLtdDdHe4lA?=
 =?us-ascii?Q?VlTaYUZg1mhev3EPV6Jv9J0vREW24hmX9P2mLDlvh822o5WGuwd144xeS1zJ?=
 =?us-ascii?Q?LUqxJmp1KyQpsDmQxqFkzikCfpAcKmK9hu09fsf05ZSNa1DBgK/ohpnWqLfW?=
 =?us-ascii?Q?/u2Tneke8dMuQANFfCFYgJ/KIZz8Y7yyWKI0c7WQ5An5RDjGCKEicFr0pf4A?=
 =?us-ascii?Q?9mlOSyB6ZLsDEnaf2iU2XY6UVgDi44Ur9wajSkdFpt8bVV6m3tG9y9tb2HWX?=
 =?us-ascii?Q?NJQ2GwUkKV0jP7qIfZum+7ZIsQOwtdfi0jGFryXG//tiimdgur9+xySAmXuB?=
 =?us-ascii?Q?eAVAhKN33mqFVbMot9X+HjfqKqc2+V0/weRtjZfRpaxoWHENNwoDuqE/jGlL?=
 =?us-ascii?Q?zIdm7fkOUcDRN4v560xSMKc9bYu459Fq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T6Gsxi0qgZwZ0jV5PfIi8He0DsLGtlDkJ6kD9PGbQJiFViSN06cnFhTrdODG?=
 =?us-ascii?Q?omfzUKMb6sOXV+GYguAAM/cj9vo5mbJzzABJsFwev0UxS9FRBGTIr0kI2NqS?=
 =?us-ascii?Q?JDbEiC0GTunRASW5cKDp4xJYqH1tvX4wV958IB11otv/mugkJI5USd0D9rAN?=
 =?us-ascii?Q?3XqDxYamHmgb1NWXV27QxVOCcw7zsPNqX7Pli/a6OZUzZQtLwdgYe4k8Z2K9?=
 =?us-ascii?Q?UjyM9X+JlJR/HP+qFzdzvnsZ5SPkqlnJvkH9bWb9R2kk73jwk08N0CXlW7+8?=
 =?us-ascii?Q?ZXwQFb8y7OPBp7eKv2NWbuwNoTWB83CdlaepqzDkh9ChPpBM89B6VK+OcED6?=
 =?us-ascii?Q?3C6680iN/k65MBR1x+Q7LBDuO2OjyIwxXEOJiZ2qwfpatxeNjReNj4zoEJ/V?=
 =?us-ascii?Q?y4Sz7+LjbUf1UDrS5jZZeZmDaUDOZmxVHQTogoBfEBqoGmZk+YVXTDAefewG?=
 =?us-ascii?Q?ajELDPbKkHdsq7Of6e1zR1/sxawr8zw4T+jpY8ES2OHvF5MhbT22wlBnCNWj?=
 =?us-ascii?Q?tBAu2HJVa5Jo+a+6I+h7CxRZbNupfmxGapyCV5oLvFS/qJXKjvO0PgGGHXDr?=
 =?us-ascii?Q?Fqm7/25zN37LpB+jVY2Cv9GI2x/xC0+LxGAEKf+A/mK0r33Rm3UwD5bz76ow?=
 =?us-ascii?Q?nGw+MPsnG6wqH2U9FFAM6WSwVFh1fqPBPWYvvG1OCXiEWvaiV602WuPLua/A?=
 =?us-ascii?Q?nL6Bch1WT6HuzOuAFEcSt4Ae00TrEZA/XMsWLWlc9oi2sbNd58CoSJUMSIdy?=
 =?us-ascii?Q?dGROkNrv14Z6lyDthGivcf3MVGXqO8ivubZ/O2sUvgZivXXjkOyS23lEIgzl?=
 =?us-ascii?Q?6M7N7vfHKrk2WLwU/MznCASur0QpWIoHFTMLw4FeOSKFT8E+NcbU1cmnSjGX?=
 =?us-ascii?Q?mTYDY4QBNRW1uUlnU3q/25yLMV7v0NZSsDFQYoer7jbJ9sZTO/gbgXrlsmHP?=
 =?us-ascii?Q?lotN6Ji51Df04ljLZm2htdUrPnoCYjLFSd1Dfsmw8dRxgMksBNw1Q/YZYpus?=
 =?us-ascii?Q?xy6hQKCIkcYrdhREI8QmFEYs3qsy31dlEqiYwztHhzQd7cuByUCL0xi0OSaH?=
 =?us-ascii?Q?FQ9tdE4JlGj2R3XIkGULHsWoWr3YFiaxA0DXB5bkv3ugcb7IscKI5hbjVYv1?=
 =?us-ascii?Q?jbK2gZq4ESuzrjhkVM0A3JyFSpcS01bDLL+FyGHKPnrxdBQU3DvnCp2Bwgac?=
 =?us-ascii?Q?gb7xiqM9tFNtbgK4PqCakVIJG3E07RtcjQ4m4KYE3dhbLN2mOPnLBJNMOac2?=
 =?us-ascii?Q?MaUTyOKcMdC/X45ykkopp6yoJ7fkeRwNo/tFcHgzrNev4U5z9OIBi7xLu7Z7?=
 =?us-ascii?Q?Sx7eUUUyl6QMUXUfmIYu2naim5r/bzk/s+6aToa7zRlDNa+Y1lInB2gzghJK?=
 =?us-ascii?Q?XIUUrKqk3VGr7BU3CNu1tFtehazjh9drft5L5XQNqKGH4ZwP+jXKmrM/4wc0?=
 =?us-ascii?Q?xxYISENgFrpCKE01gesVYc6zNTXmvT94WdRv8FfaQdat5Sa7V0g+ygehuNvP?=
 =?us-ascii?Q?tw15/kwkbLflPa6G7L7P2AspBL8xC1hgAQ64WHPSUEEA6krejIVDOXBNL2EY?=
 =?us-ascii?Q?KZsZybSEcHkIE7Gry+OMZNYKIGtSElPLGeIkCg60?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e124c2b-36c6-4b69-418a-08de25886649
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 03:21:29.6257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPbv16O2qAZlxthKPEEXjieOyqq8HepSmGEpnHJ24GRgjsKBpIoXQRMD2zFxs6AR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7301
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C4831C0006
X-Stat-Signature: 1ftanizysyoazomyymhxmir1y9ycfeq7
X-HE-Tag: 1763349694-691594
X-HE-Meta: U2FsdGVkX1+SMiPZW0BtVQrfF6hnZITcvcMgN6SVoNk74Xkhbnb8dbDBLw0bI06hcvwZb4QCwm6WoHKT6PFrY+WVDdHgVwh8JXpVpp5y+gT/LbDn3BycA8a71MYO/nsnBj4RpVouNw30wI87WQdSVaHqjnT7wx4EL9RvaUmvfal+c1InbpwOiEX8l6SYuJJSsTsQ7yuEgstri2g/qR2osrU1AHqnCIMoa0Adm47d3aTTfacAQpFS95bSGJt+5uICxrYf+6xjJHK6LifwOnu4SN1hj8vjEYx9XvpnoG/aeLzvOfP+eUB6I5NY7jLnP1kGvKUy/ST7s8rxprYhltg7YDQ5vVA+IK/nMN80JLGA+/CWZmzIPGLglmVP53TNwc0o9tgxJHBMiw5Hbv/pMUPKj3ShaFWme9wp/j+g4myzBCSHuhEQvkcBowst+kQ+5X8WYCfuno0miMj5Y6BU+hw7Cdxd6ui+Xl7v5pebuuOZ/j36BUcGnPRAo0pJoNWVTAqleFXYI6B+G8lIxtuEYVSnXS6rRyvatf6ficzUKp20jWjp6xXfElDJUqAvFJj6LtJhMnzfHA3X4zVjdGYfKbecOI74lS5AGOYjOi6aKLgoND2m2NDIJwtYdfXXdpxEIVAM2+8wCnc0oEuPwlFse3YHX5g1PdyjoXJepppNNZdFo0O+HcrlIQeEN1EwmHz8yfG6nqQnrJ7Mr+GXWrG9b8rj9YWg1rKw31M3NRXC4c+cciW0J2s7SvwVOVpRhzJhBrCpAOo4CBvEqdfsfy0oCF8WpfkEQMwqk6bVRiEAvPDKBg3F3+CTb1cid0zNc8NFTR7JU+Y8MTPOmQCae/APya6LG/wvVPMX7i64Tv+DFQTmoPhA9qSENMmA4hYnhvvrTp5uwj27c4jml9o5gLJhNNmaM6H0eKV6gajhzXsBZzIJHEyzjjRFuJcufSQnzvxzCiBNVHO9Z5sWx7qwuwy331r
 b4ccvlAS
 4vdVUwTo4yrUx4FxBUEJQHfvUObNDD0ryiG2VQ7eGlVpKvbT86B8R8x5qeFKqgup2UoROAdJb1JD0fojjL9JVj8hxFG3BNIceZjDVU7o8f3FAWc5B7soyNmaMv5+tu3mlj/clyZLD2cgCHO5NCqooQB+oYwXJmDM7E4F/7cf27Z5JKdKHlZm/9DHTpCKMeJhxQutYrSbUfoeV0cANU798yoXReyaio79pyyasMT0iYu+se7aajEF+xtP6wEixqdagCFY7h9/o9hPyNIV+Kt807l/UxyxNgFJXeLQrPa3VHlEByzEmpgReJmzU0WGCvkshPI8fSj3WScTCGslfaENpts9Vapw93/IyRtaK2OcFh+yS1AOMFD22zVfO5HTOoqK7Z+Aq2STdCUn4YlypJpRnwk2A8lkOAFV6dBlXtKiWwPy/nUkwLTFAWiHF+viqtl59x75y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Nov 2025, at 22:15, Harry Yoo wrote:

> On Sun, Nov 16, 2025 at 11:51:14AM +0000, Matthew Wilcox wrote:
>> On Sun, Nov 16, 2025 at 01:47:20AM +0000, Jiaqi Yan wrote:
>>> Introduce uniform_split_unmapped_folio_to_zero_order, a wrapper
>>> to the existing __split_unmapped_folio. Caller can use it to
>>> uniformly split an unmapped high-order folio into 0-order folios.
>>
>> Please don't make this function exist.  I appreciate what you're trying
>> to do, but let's try to do it differently?
>>
>> When we have struct folio separately allocated from struct page,
>> splitting a folio will mean allocating new struct folios for every
>> new folio created.  I anticipate an order-0 folio will be about 80 or
>> 96 bytes.  So if we create 512 * 512 folios in a single go, that'll be
>> an allocation of 20MB.
>>
>> This is why I asked Zi Yan to create the asymmetrical folio split, so we
>> only end up creating log() of this.  In the case of a single hwpoison page
>> in an order-18 hugetlb, that'd be 19 allocations totallying 1520 bytes.
>
> Oh god, I completely overlooked this aspect when discussing this with Jiaqi.
> Thanks for raising this concern.
>
>> But since we're only doing this on free, we won't need to do folio
>> allocations at all; we'll just be able to release the good pages to the
>> page allocator and sequester the hwpoison pages.
>
> [+Cc PAGE ALLOCATOR folks]
>
> So we need an interface to free only healthy portion of a hwpoison folio.
>
> I think a proper approach to this should be to "free a hwpoison folio
> just like freeing a normal folio via folio_put() or free_frozen_pages(),
> then the page allocator will add only healthy pages to the freelist and
> isolate the hwpoison pages". Oherwise we'll end up open coding a lot,
> which is too fragile.

Why not use __split_unmaped_folio(folio, /*new_order=*/0,
								  /split_at=*/HWPoisoned_page,
								  ..., /*uniform_split=*/ false)?

If there are multiple HWPoisoned pages, just repeat.

>
> In fact, that can be done by teaching free_pages_prepare() how to handle
> the case where one or more subpages of a folio are hwpoison pages.
>
> How this should be implemented in the page allocator in memdescs world?
> Hmm, we'll want to do some kind of non-uniform split, without actually
> splitting the folio but allocating struct buddy?
>
> But... for now I think hiding this complexity inside the page allocator
> is good enough. For now this would just mean splitting a frozen page
> inside the page allocator (probably non-uniform?). We can later re-implement
> this to provide better support for memdescs.
>
> -- 
> Cheers,
> Harry / Hyeonggon


--
Best Regards,
Yan, Zi


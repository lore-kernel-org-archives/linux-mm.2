Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F760D5E390
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5CD36B0089; Tue, 16 Dec 2025 09:42:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11A06B008A; Tue, 16 Dec 2025 09:42:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906636B008C; Tue, 16 Dec 2025 09:42:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3AC6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:42:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23C5460648
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:42:38 +0000 (UTC)
X-FDA: 84225600396.08.866397B
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E5D540017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:42:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j3g66CVT;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765896155; a=rsa-sha256;
	cv=pass;
	b=iS0YwJ4Mh7SQ8ckSu0A4sFPt2Ng9BcbH8sbf2rSKmOQkZPT0hnZWuyhkQHdZBz3DbL3lzQ
	Oebbzgj39cQixcUQ0TOAER0hZbQwX25AMct2+XfjJEVLqoAtTmAkZx43eQM4yjYO61XhIc
	HkdZ8NQQJGFwBK1X4DF99FSX8UsNYeg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j3g66CVT;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765896155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sm9SRye+v6Bd3G6/YTFYzP4mrWbsDAegSvv2kve8ICE=;
	b=cGAWNvuQqoaJI/jMmTBWbfUno2aPrxiPqbTrjTdkm51mJHDsS8Gkyyi1ChEUfSfBz2POnB
	j8SrK2Xi6bYgf/kmd/kTq6UVY95Hisf8/P+/8Rz20YML0J5KhPLqqhEKPbuRIMHWI+8CMR
	wiOEPd8vJ2HvLFQp6xv4iirjJqRja5I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYjKBpgnEpAHa+BJygX7GpC2+AOWsSBJ0jhcYm02YvyDHmWdjvPncGfooFoa4BIBsNAZgb+xn203xOwKSS5zoRSg9Po9GdFBwcMA1iORcjSkHl4OD5VpSsWs9Agg/nidMr8r48As2bMGz9qsttsMKLbFdVxSPcSS14CaHYc24AmHfjqmw58ka8b8bpundYw1HayeQGebXpDFeyjquDn65/hpRjQRnGHO2J8E/M4RAaCrhm8r0Cjt8PqSVzfY4Zqb42c3QdWgPJMtqHx9tRDLGJofq4EtvMRCykBiJbC20boh3vQcmWEbNCMOksf14RBhjOtL9vwj04bHFwatXeG6xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sm9SRye+v6Bd3G6/YTFYzP4mrWbsDAegSvv2kve8ICE=;
 b=aHJoEfkRY0q1R8y2LRRXxV/bJIgaRibRQuivP2W7fGpzkO3Fz5Zgv1JopOhTcPmEnINM1u6AfuSKac9wajxx0wwAxam+krZKlWsiDSpCTYtsewHQsn0+dCey3vL7yAqB2UywWhZQw/wN94v+QuBYjhV/YEH7HnrZDRAgTcteVJJ20gZ37RQlZb0kmV1uRyclOlxhDHOe0dIkbtopVnSBn8fyj7poMo2rrg72LAEexL78pbQrqxzWE7NEvd4KplrnwvM3jW5WYlrTWZhwNwn15625ceDxbEHOdSZ+TVCS7cnC8YDRn/vzKll8aK9L7Qn51uTwW6rP+KfgWgyEUO8PuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sm9SRye+v6Bd3G6/YTFYzP4mrWbsDAegSvv2kve8ICE=;
 b=j3g66CVTzbI1/PEMAi7Gci/WChn6fgmjvMhFuVm1dM9ayQUmXdEVngd/dpa7APFec6AQclb1/fV0w5u4B783H3EmxJEwXW8WbalGLk5NY5DE3MKPvHrRGLpo5Yh1pOpJbX7iDLkMC8vJziopGWXBQHzYwDR9lKSt4naL9dqUF5uwXYG4O82+6x/Hrni3eDcKaIPdMtL1xCMYblTCUdRREZg2NkY+dHE/JuACN6LEj7quFNQYcVmU8VJk/hVx9JCazPGNDO2FwvMt2A+u0xxsHpHMPtpT4vtqSNhF3MmiaqZV3VDI7VKPI48t6SKwqXb0pTpKiJdaW/wl8bP/bO1C/A==
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by IA0PR12MB8895.namprd12.prod.outlook.com (2603:10b6:208:491::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 14:42:30 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 14:42:26 +0000
Date: Tue, 16 Dec 2025 10:42:24 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <20251216144224.GE6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
 <aTnbf_dtwOo_gaVM@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTnbf_dtwOo_gaVM@x1.local>
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|IA0PR12MB8895:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e078e2-f62c-481e-9357-08de3cb15452
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PIC/dqyIzD0JntHINVBtNk2rSq5uOGlrcUF9TyeJAjkv+7ZoHmmEbfMn6ZcI?=
 =?us-ascii?Q?vH0M0AZ3InBApKEGeFrLlpPXuYKzAW/IIORMX0uvCaoeNxQpJzGeKz95UrNg?=
 =?us-ascii?Q?Tk37+LEWnuonzD+EIgXFaAT+xVtZqlUJt6FX3oerrMas8ZOsEIJZ3T/UBHSY?=
 =?us-ascii?Q?VdAnGX3OVelHObsRd1RpOU0LOR+HYbvcljX1AhSnp+nqW0dQnBdWXp8enjZq?=
 =?us-ascii?Q?bbQQkAZzLxrGsOiHQpNik3OcTVJIKGsX/3NtsO5kJqS6G2eg94Z5zI1GCA8R?=
 =?us-ascii?Q?vIYB5cg8g39J0+AW3qjxalcHj6z/uNIGVBJhuDu/shy7GEwWCgH/gcDXjGJq?=
 =?us-ascii?Q?bEBI/fh+vZHodVS6asaczYxp66I9XjbObDRNq4SaR6EALwt5nEzhw1wXB/m+?=
 =?us-ascii?Q?OoJ4SUH8Bq3az8q9PaRB2pDPzuQydyFdXcO2mbjubR5Rx8qqDJubqu1lRo18?=
 =?us-ascii?Q?oI3IpB3sW6GP7Joxb67BdhPyNs2v49M+qdOu0W6rHI/I+bLcMN2dwTBGE6PM?=
 =?us-ascii?Q?8/zKe9wt10NANx+BG3+mtw3cbUV0ukd5x14S4af/o8LuHpf5WyEVoRTg5qrB?=
 =?us-ascii?Q?p4cv6+K3vNtNnbQZFX2Zr3z+Qq5ev5+HgANELdpAVmMGY7bwUT+2UTxgoODq?=
 =?us-ascii?Q?rBYbVsDYZzYJL42cThNkFVLOOCRhgk98KLvplizRvRm0PdKNlh/jVVLNH5Lt?=
 =?us-ascii?Q?Kt4CfzQjhm5L8WRSgMmTr8Ac9jOllr6RteSxFATGCxUzdiFzCoulrKpES/zW?=
 =?us-ascii?Q?TL+fmz48uZRxIa9GpVew10pdoAllVaV+7jmv8pYR4req5s239eukNBZPjKFH?=
 =?us-ascii?Q?z8uu1fS1XHFuSkL1fXaFoBr/jP4oEUohGO4KHo6PVk4MtvcZ3kyKBIRFHto9?=
 =?us-ascii?Q?Ukj315bOnhd/57Ho108iflZofdl5JQy0xWSAnZkT2FLAMIUC23dH33q/PU2b?=
 =?us-ascii?Q?djRYDwu9TulY16g1Y3Hu0O0uH6fOZMXY5X/vsqwc/yclxTMAiG/dsS7OKCTu?=
 =?us-ascii?Q?V9NLD77c6IbAL8dayb9oj/WVkTWvCG9thXQ4GtG7GVz5Tk/vWvdkfG8Ltrn5?=
 =?us-ascii?Q?tiMgFXPP16dDsOWoscHRcipraR+OltuHKgfo78LuBrXsxEbFAlhJZjZJ2g9j?=
 =?us-ascii?Q?Da2CbcC2I/PQsJYicmnfEwh3OHWMX10soIScv4KsxK1JWIICYfh3/610oLKM?=
 =?us-ascii?Q?HX5OPv/FJ8DQ5KA6GITlHno3aXV0KTGF652PBanqApcFea+G9vPeWqOoLYT1?=
 =?us-ascii?Q?CVwDUDmcFLKvjBlauBi1ROEMObzdum8nSSJsGplN6zHWj0HvrbK0ERUcBOdj?=
 =?us-ascii?Q?BF8Qa4X2fgZd0FweMz/gAA0+3QcfRDlWlaOoLcK2iZAjrlOuSSq9QTR99S5Z?=
 =?us-ascii?Q?Thh4rdZJecfWH0xgm/7tPtDGHmVPtj8KziFY/OSVry1OI01suG8rt8+dYPjU?=
 =?us-ascii?Q?riMexDQ8+E6zZgJiHJhH3xsoweO+0dF+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sd4qTPnlZuQ3RFzAxC2zpstLON1xE94An9mc0BoAgAVFIGNcs1lgKwUpsJEY?=
 =?us-ascii?Q?/St2TPCTqMj/fQtiMZL+BlfziyQSuOQpYRqpX7J6NRoGBtupFs67lDy2QLJ+?=
 =?us-ascii?Q?v3SxAMacj1eM5f31ZY0p1ZHZe9LpVRR0taEUysfuNDwIkqUh8WZqObUWxBBg?=
 =?us-ascii?Q?4s6QxOSKjUf9f1NfpwOpoZxKrAn671fraLHpwrOcZhgIhY4yLJGLzK73DQ8t?=
 =?us-ascii?Q?ZVnmwMQktDlK1G+WF8BMJ1dOqbjfJepoV7f1pVmeULQoItadenP6A+k1dpEd?=
 =?us-ascii?Q?9T/DvmBxRygoae2O3vghThZWLZqYtSMKwyv17zsgiRtRXSFRZIqOyar+OtTK?=
 =?us-ascii?Q?SChkP87Rk1PEtfeN0ORWwri6kGYPpL2UNNlBLw25P2lr7RLCmJBo/FtK/ioP?=
 =?us-ascii?Q?Vw6P8B7BTekoYGwTsPMsP2M00dh4q2+/PIUbKAEcUShx852mTrm65dgYG2Vv?=
 =?us-ascii?Q?Kbe1hD56XKoLvlqiuXvJ83TBSB28qxgru1hhV/2ub+ipgcv88yH8MNogHkdP?=
 =?us-ascii?Q?OUA+eHFAopGiMopHY72cdgjyCgUxQqaB1e5QYuvP6o8x4xX4WhrCpdy+EM+6?=
 =?us-ascii?Q?+Yc62RaQQvpKvAMkSANeRPp8DI7I6N0bcQ56a2vXoLgJsGuGl578TeZ0ac2Q?=
 =?us-ascii?Q?+TwO2LhSzMZuUIFNwgJ192jnNL4t+bB4qUognFwtqSfmCwInykJ+1xiqRN1W?=
 =?us-ascii?Q?po/lcb8XImvuxk17TNR8rThJC+VATmquWQHiv1Nf6smyTDeaurONkyGIInT6?=
 =?us-ascii?Q?7vv3DQRPy6LjZoVWGZ0O0MLJDUPvLOZ5uO5NuUZI7UGOqIUvAyO2rsKweVie?=
 =?us-ascii?Q?fUuTaHmRt5dFOrbB4HjujLCrfitd1MqZRFlYd7BGeKgj1NveVbltb0S54Zcs?=
 =?us-ascii?Q?9NmG5lyC9OJeZcXOVvD4eFZEmVo86CfvYuzLe4s0CyqWI4x0uOJRjrrgBEdU?=
 =?us-ascii?Q?GipeQ/307m/J5VL7di2Z//J+MOgJJKbFKTNyy/d8kfBiTFJ016r7xbfhQuMJ?=
 =?us-ascii?Q?fOC4AGjomUiNwtMQougxf92tdHbdRPafl3yNQOw/swrWTdugILNFHjzx3Ix/?=
 =?us-ascii?Q?aE4/2Ub8MPE1DsLhlfqtsZYpE7zwteKROTve2TLmVyLuhQAh8S0B3DQxHyg0?=
 =?us-ascii?Q?7UHdT8miBcpEa1kMRtdmcjdEwWOk0HswimmrR2aLB6pFrh/bqnrztxN30Zmj?=
 =?us-ascii?Q?wM+cW0weiMZDBsseoUSWipU/LY2GARVJyFf6glNozFkbZxmFQ6bnjT92hoL5?=
 =?us-ascii?Q?Ejtl9r5yNmykE+D00hlbruQSfuYNYiBcWEb3ZIYa3hKf6KWre5q6cAR91cQy?=
 =?us-ascii?Q?PnnskhEVX6HKoJjSESx7H8DOdZDuTRFrpwGuJLB6eIOhANVdcYugOM6LOimS?=
 =?us-ascii?Q?OVxt5KTTDGughpmPV6dpk8r8+53j5qcE9mrXitDQErPoLouTMZKNWo7Xlq3z?=
 =?us-ascii?Q?acjI7ty1Fa0Qvsqb3ZxYNM6uDqgb/CLP4oMZtGFwVXk+47IIMzW5/J40qcHi?=
 =?us-ascii?Q?jpzlvT9bydj6nqA62ErXvJElrCVe7r0P6YM1jm/w9Y6XDsX0tVxMA9FXplzZ?=
 =?us-ascii?Q?onY1XO+NZvIti0SXC2o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e078e2-f62c-481e-9357-08de3cb15452
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 14:42:25.6856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3nIRhr/Z6lTpzRMd7pauZv4ZbsSE2zFK9NC8bGvAzGeEVA9FAQ+qlSU4mnV6RC5F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8895
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E5D540017
X-Rspamd-Server: rspam04
X-Stat-Signature: nszizckk1cdtbunwgyggiaqrkri5ug43
X-HE-Tag: 1765896154-950053
X-HE-Meta: U2FsdGVkX19BWBjaLHLlLQifalB0B2VG0jPe9C+2AMD0tr/+ADnhk5uDNy7YO9QAF13PJYI7FmyQTxbb43CbDHTKAPG4hQ7On2Y903as7CRnw4A5rh3TfooTyAHWa6dPcEee3KtUNPqfaL8d023Sj/hVUWz6IJzfAcM+xTkxdPM+cm8kIWOLEWjSBsGAJLh073+qTLO5uSyiM7IJ0KAJbnyVGSV067jmOlBx4zeLGMBL4n21gndp1nxQo5MaRLT7IyhrNLqspp3f5wa3typDLlYx8TQtAOl0yJml4ZKVfGzJzN263nIRivqQeveSTzQC4GX12ElPEjRPSp4EWDeBVRPIif10oEFRZHtfCWPrbxBHFyCngLUhGDOPOO+CIqsO5Z5HlPwy2CRke+xnPboldh7xFy/mNxZSmRLgY4PNEmxRXFjVGqbdGilulqFVr34OWKwCGYwoNy+gL8vdnEFCRhJkvu1OfjC3QLLXt2xnQzkVQbDQvIiB203/STkX05OsUL2F3aUcBI7aY+VL2nf9y20ZqJgNt2zYFNhIcBqlbEYjYMy0V1UphfNVfvBQmz1G51yytVskb3FcA4GCRJkPoFFLrf5k0tQ8c2T2Y9nz5nGudlSZunLGuBF/RkGIYw/+/2kynub3J+0C+s9NiCXd0Rz9FdmZcRsdoqtad9+IDtShuUegDj9Bm9/BOU6xfZi7kOeefs3mOrjS4GvoG5i/gVkISm671pCZ9Gb3DgSq7mzH1sKzSjtUYMY6i+vE1Dx2U3wFBkJuFPW89yQAIuASvGSrP97x3Tch2uNNC7bsXHxaifDmRMLVkisIayjVRUdY1PC1IPQCu4FEvIFDirU4BuWbPfyB4EoKTAUO1QPPDBSO21KzXTkeWsEPEmWuG8CQDVJsfSuSYeYzFxxSkOfcq74B+/PcQLezv7OtahkuYzUW0hy4SQHP6xvz5RHm4Btug9hdoi1FasD86kzerM7
 A/fSfhC3
 8Gmdu6v/kNh4Ay+4GTUbIZOCRYqRokyLmITzc8Y0Il/UZXEha507lRHVmvASZjs7TKLdtInTl4nimWADZUJtCf8lf+OoO7rXe1MVOneYnVOIGHswo8ubz4tCt+lRWfoDzQ0PR0+phURl9f0W10+i14p1HAIikvRcmn/F10lFcXlwJrQ19MsOg++zrClGt3yDLLZNhohLDRuaAfcSNyX14AyYh7xjtUUMa4q1txVrrobDsljgj7sewSQivlh+KGzWnp12rPEunKpw+fOW8voOlrgn34IgV2oJU3wH0ePgZj16TwmeMcLEKOXiAcm36I2VugSHaxpmlqtISL0mR0TNZhGIMRcedLO2Sm05Bb1lZtM1X3bSk2N1/JyJeEwwWAW6wHhJk2Y4NupX50f2WofIXfKIz44Hur1B7iQUU7g/u0R2wuaxe7bXGEgO4O2yEYDbSUvcSDbTLXZsv/BEzQxDd5N9g/7auATi+bzK3PV3ucq4i/aWy+H51fBBXcSka/RoqmJVVbQpc9UzACQm1fNr1r6ghNTZe9/EHf1Un6JjgutyhwlZQuZ0iwgxufhzKWWMuCf2q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 03:43:43PM -0500, Peter Xu wrote:
> > This seems a bit weird, the vma length is already known, it is len,
> > why do we go to all this trouble to recalculate len in terms of phys?
> > 
> > If the length is wrong the mmap will fail, so there is no issue with
> > returning a larger order here.
> > 
> > I feel this should just return the order based on pci_resource_len()?
> 
> IIUC there's a trivial difference when partial of a huge bar is mapped.
> 
> Example: 1G bar, map range (pgoff=2M, size=1G-2M).
> 
> If we return bar size order, we'd say 1G, however then it means we'll do
> the alignment with 1G. __thp_get_unmapped_area() will think it's not
> proper, because:
> 
> 	loff_t off_end = off + len;
> 	loff_t off_align = round_up(off, size);
> 
> 	if (off_end <= off_align || (off_end - off_align) < size)
> 		return 0;
> 
> Here what we really want is to map (2M, 1G-2M) with 2M huge, not 1G, nor
> 4K.

This was the point of my prior email, the alignment calculation can't
just be 'align to a size'. The core code needs to choose a VA such
that:

   VA % (1 << order) == pg_off % (1 << order)

So if VFIO returns 1G then the VA should be aligned to 2M within a 1G
region. This allows opportunities to increase the alignment as the
mapping continues, eg if the arch supports a 32M 16x2M contiguous page
then we'd get 32M mappings with your example.

The core code should adjust the target order from the driver by:
   lowest of order or size rounded down to a power of two
 then
   highest arch supported leaf size below the above

None of this logic should be in drivers.

The way to think about this is that the driver is returning an order
which indicates the maximum case where:

   VA % (1 << order) == pg_off % (1 << order)

Could be true. Eg a PCI BAR returns an order that is the size of the
BAR because it is always true. Something that stores at most 1G pages
would return 1G pages, etc.

> Note that here checking CONFIG_ARCH_SUPPORTS_P*D_PFNMAP is a vfio behavior,
> pairing with the huge_fault() of vfio-pci driver.  It implies if vfio-pci's
> huge pfnmap is enabled or not.  If it's not enabled, we don't need to
> report larger orders here.

Honestly, I'd ignore this, and I'm not sure VFIO should be testing
those in the huge_fault either. Again the core code should deal with
it.

> Shall I keep it simple to leave it to drivers, until we have something more
> solid (I think we need HAVE_ARCH_HUGE_P*D_LEAVES here)?

Logic like this should not be in drivers.

> Even with that config ready, drivers should always still do proper check on
> its own (drivers need to support huge pfnmaps here first before reporting
> high orders).  

Drivers shouldn't implement this alignment function without also
implementing huge fault, it is pointless. Don't see a reason to add
extra complexity.

Jason


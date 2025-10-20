Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA87CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFAA8E0013; Mon, 20 Oct 2025 09:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB62B8E0005; Mon, 20 Oct 2025 09:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E288E0013; Mon, 20 Oct 2025 09:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83FAD8E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:15:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27430C017A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:15:28 +0000 (UTC)
X-FDA: 84018539136.15.367AF41
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id C70541C0018
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:15:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ppcPfRGG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XlPtDTWA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760966124; a=rsa-sha256;
	cv=pass;
	b=8ZppZAwaiYqXNUIrVxIGabkAm1kIP9hT0RvlgS4v9zi/Ro+S6rwG6YdlPUdROSMc+jDFgA
	0cozmFB6XsoCpR69xxE6AjHhEAjvLW6qGRmIUL9Z16/ZgjUg7aftCAo9IFSEp4SfRB/fci
	kj+KAtRgRpWXF/zu2/5vOVmyNgfoWNw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ppcPfRGG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XlPtDTWA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760966124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qai4qFhduN3yUgpPJFxWBUUh1dfFJ1fgNCxTWGk6Jfs=;
	b=Sgka3rE1bzEFaih28lEx1x/+3+0KeOvol2Jz++lTmRmpbpiFtfIMITem1Dp+wHD/mS8kym
	8YWaxoboJA7G6Ji34kYsd4wR6ckeCoy+V7A6+DBpbk3K+aeyc1+njcitZNRWeCadny51iB
	ZWvcr6gM0vxDIaULp22caV1Ef/HSmuY=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SA1V006199;
	Mon, 20 Oct 2025 13:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qai4qFhduN3yUgpPJF
	xWBUUh1dfFJ1fgNCxTWGk6Jfs=; b=ppcPfRGGqSMh8Uidf0nsOS8O21VKENlDyP
	VGzRrpvLixctrYbDpC7CGOrJ3LjQYWUFLs4TPppwUB4wTUlTnKBy+Uc6q4Xy1GyK
	L3OgAL8MHoQQH+P5pAVXr1NuOow5i6VpCrsiZqRllR+yY7Gg7K8DMg1dh/Lq8pzz
	GgWCdoPnTU0UjFqAoWcyGgtenVH9KJ1/P9oKVXgfMQvSlod8Q47e71rlujnl4Xcc
	kSP+/ujMxe+ITQHJfhZGbfHwPZVT38qWRP4/w0uA5HQxL38iSmsDGYWnmC3v+JGe
	cX5cOl3yUNosVx5N9mTct97oH+nWNmqnvYUidcWJpRASOkjCMOMg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vvt82e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:15:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KB0AAj013117;
	Mon, 20 Oct 2025 13:15:13 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011049.outbound.protection.outlook.com [52.101.52.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bansrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:15:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h0UT6BbI6uDjX+fAqJyq57zUFfl4IhE1GMoasItlnA0DzYw3nhE0SNHV3nVjX5dIoKjW1tJM8WKXboIlPTct9S2rgCM4+zqOTKtGg9/mAC8MT1BQzWdtMjaGYMERSumBY+vHwLoETKeGtjDCwPCddgdgqgLRRwNqtY8ZqaWsowDhkAfpFwXUjFdWRrKkea0OMDaqJwgRqurfsjsD8P+4FWFN6m+aQuKBCQ2uL8FzUF3vaAWmCI0TKvfEwAONkKQo4VUK80Dc6FHAQzKvjF4A6x9y8dYnLe1GA06w5OQ5ok4B22aofQTIPVSUkUO3WKRjemxKmW4BtOZkMs4UEF7FoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qai4qFhduN3yUgpPJFxWBUUh1dfFJ1fgNCxTWGk6Jfs=;
 b=IRC8OKPi3EBvvNoK8BxABvT2xEWc0Nqiw7PX5GisLMR0sgEOKN36VoHdSb3lzJCAwU2LIVE6ErulmJbZcy40BJ0sak0WJ4w+KiKUVuMeWUjTS5dyu33hNwzUAReHbtOrA9eeEOs1J9qpons9O6R9S8hlDfSPo8d/7oa8YBIKcoQTEdFQ1+2ItpkIhbR8BtSYvoWU2UqWVTvoncW2Pvkkb3nY7Oww+BQyFr/0AG+Z6vx5S9NYhdkcBW7IKkOVEQkOQR89z74yYvdiWS79JVGp/I+JDPjDtertue0xhXGuKOCiFT5f8jtdKS41P6nZIBmUzSUQHWo282pk2PxeA7SfIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qai4qFhduN3yUgpPJFxWBUUh1dfFJ1fgNCxTWGk6Jfs=;
 b=XlPtDTWApWzjDjjowKs2x7TPy8c4vgNE4wWmcgxgHiCIy+8CVPcO52r2zQ9YrgpNL+iNlhLNM5uL/CqbXCDwMMzayQStttjC0rgfj53WowPnpKCzerku4GPWmOoS2qi/Or4tKGe7VmXYc28mtuENVgjo2MnwMkDruIPC9T5ktTI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5142.namprd10.prod.outlook.com (2603:10b6:408:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 20 Oct
 2025 13:15:09 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 13:15:09 +0000
Date: Mon, 20 Oct 2025 14:15:04 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
Message-ID: <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: LO4P123CA0044.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: 28143e7d-e7b8-4977-a99a-08de0fdab19a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uBZIfQt7FM7NU3og15n+7fL3s4q76PW3TYZ24ace+mTSdx00CCkEtXcwvAnn?=
 =?us-ascii?Q?Fvh5cX3V4q/C3cs5Sl9oE+kUIjT34i9ktZEahCA52ZW9lHUgGnOgMJ2LyV8+?=
 =?us-ascii?Q?8zW8eK6+746HZo8mhRfBJv93jr7VVKDrOXv9r4sB3t8zihOjqaaFQ8SsAizO?=
 =?us-ascii?Q?PfN6R/1lM3Ynl9cagEfLO5YprSOVtvseC4Y/VSCPW1y8iQYQVIUGd5FAZf+w?=
 =?us-ascii?Q?7mzUCmkxxyrsaWCzQW2L4Gy+JokTg2Dq+5VdzOmc65LkfjwkDDRtN/1h90q6?=
 =?us-ascii?Q?4x4Kq4jLxvgg5xQQRVR9YBO5AzK5jF16fQr+Dko6ZS8iHH88wMQRVSKrm1mK?=
 =?us-ascii?Q?HiTcSowbMP53cPbM8RVjKA4x+P2uf96DkvqhcjX/l5SOdfUnuVf4qRzftFTY?=
 =?us-ascii?Q?CwOYdkj6lQNfTO5TY9BTqG/VLKewh+xxAVXUrU/4cE6YgzQSsHqUcFChrNcO?=
 =?us-ascii?Q?3JqkVLKUF7+XIJvOZ6TT5LfyJ86wR5zLIfQ/Mmw1xcdcZ63HbUiGJOQ6b3Pu?=
 =?us-ascii?Q?6MUAPLWYb3ndccwI78qeQMG9VhAnAfF/CtANUqEBV/2lg/io0ZhiaMdj1qA1?=
 =?us-ascii?Q?N08KZh2xL7IR8iHRyY2B5jhp+FOCxBbdoOo+UX8DyrTiFRlKmscqr0+fNDrv?=
 =?us-ascii?Q?oPPQs+f3hbHzr3BjCa+jOr20okXd/LnRK4WdbVQ89HShtDW570kW0sacVCfi?=
 =?us-ascii?Q?yu7aeJFm+54NiwQbVyU3rPouAq5TZ3f8OD6JSsoHpD12Np9iaHMG1aNCZNea?=
 =?us-ascii?Q?57WLx5EIenV8FuvY+b/Yr+gTpzHCfEDvi+gkLoWiNbK3Eqhfv3Ou57r/Lb/O?=
 =?us-ascii?Q?gLERBUCoS1xyre2XwRIxBxM/t0F5/s4nw6Hlc4wM6DaB9LOgaJxRDDAWnS4j?=
 =?us-ascii?Q?7eSQYlTuYXH4rgGDusn8EJYfG+QUaxIFrw3LulPYbVNhqiWn9gqr1Gb3ZMFC?=
 =?us-ascii?Q?8OHlYMRXlmUaIG2UEs8fw07CDLzktsPevEUmjlreXO8fb/hLNPygxm1SbvzU?=
 =?us-ascii?Q?MNEQncUOQA8xgSogFsNPSGT1BLHY6TdWgOpsA2quwecJYoK35tXl9wYIatcp?=
 =?us-ascii?Q?ygY+Gn5XkFuWrDWAP0Br4dfmeyfYXjT8v2BK82qy4zgPz82yc7LPnncJh4jF?=
 =?us-ascii?Q?cV3BzW5dVuvXP1/HwLbnXxjUi8Sbpo0NkBA9kQA3ZvNfPgoCFFHoIIzd2buQ?=
 =?us-ascii?Q?pUH6X/XSFezeJ0a1neJrnHzPqIJalwsDUOz75E0XdXUYVnT3GGaF40eC9KOx?=
 =?us-ascii?Q?dRoapcPKV5fpcnK8GRAZsEr2CkUFP0Z+bFagQH6WOFdQTyt0VtraiSliDlRf?=
 =?us-ascii?Q?5o3+FPb9cnbh8qN+25sfh8+73RP9YOFsnCfa0su2ZwnV21WFAWj57Un+98+r?=
 =?us-ascii?Q?jDGFdzp+olJlO1lKRtEt3bOfHVRfPQD9j2oDmVZoFmKPohAW5pkN9LHX/f3g?=
 =?us-ascii?Q?2riqoDkm0jPAO+f0a7/o9ljgrjR4Yyl9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?emmTqwvrUeXfcj1YFQHkjh5iuQsciLjagSGLLj3m8TTojmDk3UXENoFLcJEa?=
 =?us-ascii?Q?KrI9nSdO/wXpNeiURiwWJnuMA7Rq2hzTUvnLqdUon99Gp6UbkG10Bw2UxfaM?=
 =?us-ascii?Q?U9LTVLve6hxMDMVKyWfo2tq5O5+h4A2Tu1cQ6I6Ikz96X2YQ1s9LSKeCxm9D?=
 =?us-ascii?Q?cVDiW91GGBIE1qXy7ETe+cf6+bZaOVFn5NslucAJuwug4mL/tKwelgjoczi7?=
 =?us-ascii?Q?R+t0SE5Kv9w6EuZoEnyDLWo0SPu7Go139J4V+XwXkTCZj0PzmksTidZeM6uN?=
 =?us-ascii?Q?DlFVYyDAK0L33/BMVqQM2zIZ5CL/Jo1b/ITaQIthE7GTDadzPT2/8cnl3DBy?=
 =?us-ascii?Q?Lb8mxvcJIC8S7NnExCdFXdWMdBaKimxm3dNGpXTTHbm0RE/C6iScIrKlNv1i?=
 =?us-ascii?Q?r65SniI6zYsJqSahH6m7rDxozcmhwhM//mrtPNr/yIGWqA1pjCOdm1ZJzJy5?=
 =?us-ascii?Q?LGE3vloNymr0Gajeg1jvw1RTvM834goGxBOGHfdHw0CAmY4lXV/YL8pwWeQq?=
 =?us-ascii?Q?D50nClNIEbAlHLWm7DvVPgrlF5lX/7cJlUY4ID4qnu/44a7DDFX6dLphyGLz?=
 =?us-ascii?Q?KMyE0rNRmHgaY018Ju7C6ByKrLWZrTkdW8sbmxuDi3mRg4OSz7c32xkKXJYs?=
 =?us-ascii?Q?5jNuBOYxI4xbsswlNZI1RyzZ7+8ZvcjIl09TWCXEMFL4gP5g4Q8y4w863ZJO?=
 =?us-ascii?Q?FugYjdtzeujGtea9zsJ4wZlV6eLTrMsYvtyQsyHIzTLLqPKrdzQ08ZxIngOI?=
 =?us-ascii?Q?wLkuxyUklPKc0pFgMCrs0NZOoCyab8fRb3qf1xbVhn94tFDGgeA6cblvMQ/3?=
 =?us-ascii?Q?8xSU+watBQ/MJHHGhxNbtEWz8s1jWqfpskAo32l9LkuZufcFlcnse6cfDMNM?=
 =?us-ascii?Q?svultwq7QvUr3FnDB/IEpt7qwbovJ+FrVIBoIHCt6zTT+sCAdZn4tRlAbOYK?=
 =?us-ascii?Q?OBpUtNXf/Wmi1bjzr7mrfqlbUzL/8o9vExELLDDpdcAFkXjQeqjFqRmUYq3W?=
 =?us-ascii?Q?rxnPar1KbLxPObpMOYeV+QB+KfGqzUYfIDILA051t1szlngpmuodbx0+g60J?=
 =?us-ascii?Q?zgc2+rVQf6TOtBhg1Oc3wi60yv4i9YV0dqmzd4+Ms1H5O01CeSRMFCvP5OUo?=
 =?us-ascii?Q?MGnP9Uj++jHxHYDAEO8ET/JG1pjfnNWuLJd1iGiQRlFZRtzfNcvgxH5FPNgP?=
 =?us-ascii?Q?Fijaqzea+kShf24hxNJq2d2kyXnyKdKxB+b0z6sIIwnivZ4V4oJKFFpe5s2v?=
 =?us-ascii?Q?SkbgKyp6bOdZVC7jPIsLoVpG67n+GxLNM9ZyL2ELmo+/vM91Vpe5PQvXxlYv?=
 =?us-ascii?Q?rY5XppI7S/OYAwiQqyJyyHBbowgLpb2FjcmLVvrf4t5v2q2jw0UUm0spuEGm?=
 =?us-ascii?Q?ObGjQ+1z10JMGvXbgwMKXwoGcpETjaLhj1aJ9mWaP1ecEVQ1cCVGl1STWNJk?=
 =?us-ascii?Q?4QHyFsJ+205IFxYKMribV5hGjiNv2GdoDlh/sRqedH8tZhlRZPdxFQFEoQ3B?=
 =?us-ascii?Q?wzyx76Z4Zz9/GaxXpe1exyqBdY/G+l6MfFSWBiAI3oUfZ+C7/JkfvdmxM7Dj?=
 =?us-ascii?Q?po5P2lLdFDDANIcFc9gTv2zsISvv2S/scWvHcH1pgkfWPdhdYKRhP59CCdJH?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U91vWdhOPRIMKIxkdjp4lQ2JURrAhu8ueAVCU8aZbMh8Lpt4lnxzanmwxs9po1JtI1B5qzvKfsFHB0zUxrrIkPTprkTSxZBUUTKXCBmSjz0+dFO/kGPFOBpYtXvgWAp879P/U27WNAX1ypvGaw8hmbna4EyjtL69Aj54ySp/i5W/xSOs1NPdmQ9je4T0ChU+lfbcp5w4i3oA5vZ5HA37lPDG2B3ohTwJ2ZJoBFMcEsSo0FMQLgx5gnX7UqQUmKIZwZjE0g8f8eqa7wzF3DGIDZDgFQmrSU2DZw/9AJVKrE3JsZeRceTJRCl06dD+fh6Nj7NR24GCuCZ+oYRWGcxeFBkYpsEPsvz+4Ce5PaqffY5A8bRXRpqOpEHFbNfrqnp5hOcm7ZjMzJPXuRoReLJVdX5b6U6SRODxVggFdLhW3Ursu+0JKcvlOS9Ps10vt9JF7MWOtkrLUbpCF+GPfYnY0sFD5d4Sie2SY7eoidr0mjRasXrx2rWXRT9Vb6m1hsgtc70tKvtObMVvSlvlvOhJdZfso4UyzHVtS4kRpeJm/Uwpr9WKrcsK0y2biZDM2P8Xj+MUZ43QuN49pf9wD1j1KFNenUg4RRpE8VYcmp6T4Vg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28143e7d-e7b8-4977-a99a-08de0fdab19a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 13:15:09.0754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7GnTu7RXAYz7DX5IPKAzuNREQMblSbtVDMv4N5o9v3n+Ok6VYIRiq5bSoiWlu5CYma1V+BVUI+FNyHkdjdfBc2CSZ692pi0Z8Ede0qaAv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5142
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXze2dz2CoZVT8
 IVBEBbyi3JM/sbqPQjb8W4p+3Bi5ZeVe+VwP9WYVGHrdhrFJWHAcbZM7mKbjx5vjJTEWtvC5Z43
 cp3MW5nLkWeOViYytU3W0s1p15b7N0ho3msNs1Q29hgr7xRqpKPJkr8P6/mSW3DTWME92ua0jNh
 sXBFBCoL8gJXqIZMRWGqGL9PcYdAOduEhWbIXYKbom72urk2NUCxRXw6ABI10CVgOn4VqY7Gw2e
 vTW4HTibLuBGvTdNHelnisLgsK2tAsGFPPD41Q/zwY9KQ4kVDHCZr/ISHPQBcIRcge1xmReiJMJ
 53xSCo+mrSalc5Funejx/+Bar9TQB0/rH1zTVV3MCgn6JMNNLnEur1kwGzUGhoA8sBfjtbjXo4k
 yvzCfjKEtoWndCSnPkUuGeyY4jML1Q==
X-Proofpoint-ORIG-GUID: VxXHGWEDNKGobIAMQH9IF780j5-FqOZw
X-Proofpoint-GUID: VxXHGWEDNKGobIAMQH9IF780j5-FqOZw
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68f635e2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=aZt07LFgc2qZqf-IiTwA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Stat-Signature: 6uhwfkie7fft6qfqjgo7f6me65c4oq1i
X-Rspamd-Queue-Id: C70541C0018
X-Rspamd-Server: rspam09
X-HE-Tag: 1760966124-279023
X-HE-Meta: U2FsdGVkX18nwauuevgDMnFsbAqAsQrz2/c5ex6NDXgEH3vhhWRuvtoBaNBGhpxENStCwuE42IKDqyzmmyN7jXed+QxgAPHdMTR1rIdncPMv/tIRXnMkmixyQfi6bZo6gLszUtEH1EuAjotnSm9rFAqu3pTN0/BiIO10W8B3sGo5h+XKV6n3NHP2/MZvFjNKBzQhXGRvUaqPQzDn1T/+HRXPHTiZEZfXG+vLiBLuX86pIEu+x1SPAwE22jWoeX4VHa16mfW8Ra2enlPOdi/f7+j8A22vfwq86woK/+tUh6bs1yiCLgBzcPb0vlNQaEEClvbLmF+l7JYii7DCThUKWLDDTC0FaAtd9pxRei87HYMKym0cW5sJ4jbNLZ10dTnyqLcyW1Pyhc6liNnnDdPdrV/7KTibBO5kIx1N6mWW9CRlnAOIQTY1Uz+4cc0bEyveIBR8NqR/G5ed+DSj4UI3UQ6JZl0mKHkaXOGiigLEQ6dMaxal9JIp/AYYVp3JoxyvqUyGMDRptI22sKdbQVEyqM9lVeJVHLgmQMa8ZBtfPpEeFPDLOVatrL5g4M2pMUjrfL6Pg1Fa+qzevhTL7Jhi2CynLRcAQ+09HU/PLSndgPQ6jf0GZt+O+sNatJUpHeGG6iWolKqeAj0vwzr59eeVFpj2kU4Ruu8cg9bE+3blKXLqeAZXpsIczXV8fJU50IUzTW9I08MEgOhZjQES/jfBlaVZVuHvzU61tt6GWn+URXAux2pFh3aPW1c0MQWmnzbP43AXvT/nCt4flTgCs5Dj0rgQqE+vnZA1eiS14EYF4PQO9g3+0lUpClmhEm8XCi6Gu7cDI8l+I0DzTtUMmbD3shc4nFXP8UHgUUKp5y3bEJxkTt9E1yW8bx63934TUzDVqQ02EkWB8fywKv0mCpP0FuPQJp18VDRU2PkinwQt9vJ4CHCosdWSU6h3s3CsfXdlp8PJOLQZk+CqZAy5YcA
 n7jGWpue
 47NjCR4N0dw/9hqzix/zFkxD0cv6j9eU24++uesn/EaGRErd35C61FbNulMql4CnFfT0RIsfZF66SP7DzxJNwZV2qxlILyg9HXRORqK3NNybDnJgrwcIjZbOvqZAuZI/PuCfXl7A1Qs4o50bdhem36d0xNJk/vGKouRcr3Dpixm5kvioxiNcDkpQ0I+3OkFTnUtlqPGz6astZy8ruqZ1la3wbX1pQQcOuIwbqBI8WwLSKGzeWaU70rHwYJksEoRzqY4VGOyHQBrRjr0xPc5L1mob1bCj8z57saXR5X3KqChe5vTZ+CWbJnT/gXuPfOTeHkpnqHrzeRap5w7XBP5hu4OYjKZ/HvNtGv8of/SuVIeHuFujdyHhHvKmyisLNl2xO6kiGSKntTh6c/u9+X32zGlfhig9HU1CegENWBGeE1aM3H895oyWqhpbi5S/gQEk90vaqaZhRx6xN09UT/3NSoke/MyATvNpZh0Q/0ULkWpDEMULmHQpLVcOu8E+db0z4q1IOYmrRYnJFnN60K1z7/RQ1rWnK2QAaccNqpFRHl2RNOABFc6FG9NIHxiYZFwwDqXqXMRzHaXQYQfLOB8CiatJ+LY5zeapYmgqVtV8wXlQ0ddo+RXEPHwT+WyLziyendwgRDrnAhK0vKkAM6vZqkAVSzqWWmPw7ZZRmiIQ8klLLnHJX642MVCzSbxypofO3eGBinEK3Ffft5n04A7WIb3VjmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 02:18:45PM +0800, Kefeng Wang wrote:
> The folio_needs_prot_numa() checks whether to need prot numa, which
> skips unsuitable folio, i.e. zone device, shared folios(ksm, CoW),
> non-movable dma pinned, dirty file folio and already numa affinity's
> folios, the policy should be applied to pmd folio too, which helps
> to avoid unnecessary pmd change and folio migration attempts.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

This is a nice change thanks, and splitting this up is useful.

With the duplication addressed below, this LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/huge_memory.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2764613a9b3d..121c92f5c486 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2477,8 +2477,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  #endif
>
>  	if (prot_numa) {
> -		struct folio *folio;
> -		bool toptier;
> +		int target_node = NUMA_NO_NODE;
> +
>  		/*
>  		 * Avoid trapping faults against the zero page. The read-only
>  		 * data is likely to be read-cached on the local CPU and
> @@ -2490,19 +2490,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		if (pmd_protnone(*pmd))
>  			goto unlock;
>
> -		folio = pmd_folio(*pmd);
> -		toptier = node_is_toptier(folio_nid(folio));
> -		/*
> -		 * Skip scanning top tier node if normal numa
> -		 * balancing is disabled
> -		 */
> -		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> -		    toptier)
> -			goto unlock;
> +		/* Get target node for single threaded private VMAs */
> +		if (!(vma->vm_flags & VM_SHARED) &&
> +		    atomic_read(&vma->vm_mm->mm_users) == 1)
> +			target_node = numa_node_id();

This is duplicated in both callers, and only used by folio_needs_prot_numa(),
why not abstract this to the function also?

>
> -		if (folio_use_access_time(folio))
> -			folio_xchg_access_time(folio,
> -					       jiffies_to_msecs(jiffies));
> +		if (!folio_needs_prot_numa(pmd_folio(*pmd), vma, target_node))
> +			goto unlock;
>  	}
>  	/*
>  	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
> --
> 2.27.0
>
>


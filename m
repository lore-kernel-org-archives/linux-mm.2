Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4963BCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A343D8E004E; Fri, 17 Oct 2025 04:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C498E0016; Fri, 17 Oct 2025 04:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4A08E004E; Fri, 17 Oct 2025 04:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 760F18E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:47:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E36613B52D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:47:12 +0000 (UTC)
X-FDA: 84006976704.16.07D4FCA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE94E1A0010
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:47:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a9ZFGQR+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W67exp9p;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760690828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BePQFiCAQXOHF9BHW/rxHTpkcLKuI/yUFsi4ryAwrG0=;
	b=3ECLRXCbxj0Q6zqPVUgBkd2xymvl0EMJ7QT69xOAbhsOPius+cN3/yNpFGyMYWF9D7nwwu
	rH9SnMrOqEcaRDgMi1F9dneNVFzBGX1My+Ww7ax9ZnNnesxqAHh7NV8c/oU2vkNapqDRrY
	YmljAYUksQOkkWBqrxS5ZStwC/WwINs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a9ZFGQR+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W67exp9p;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760690828; a=rsa-sha256;
	cv=pass;
	b=EQZmJSH8Gn+VYVZ8r4/rAwPIlM4f/gm3TrM1dj9rMw0SCGZGmxd//mdSC6vRNx2Re3LIGE
	Z9EKltxlIzPpdPWj6eKHlRkIHbSSWQciOsKQ/U3Q7rFqlezsq4Bjsla/tJFK07LRztNOPr
	NOnNvB8ATFdpZur3s3Jnb8jMr0AP6SI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7ujAL021595;
	Fri, 17 Oct 2025 08:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BePQFiCAQXOHF9BHW/
	rxHTpkcLKuI/yUFsi4ryAwrG0=; b=a9ZFGQR+OM1/utPt9xR0mVv4bOm93CY1wi
	imrjszn37lLjGikaWnckRBvvGkETgbXl4g4Kzje5VJ2zDycpRqzTc/LngwTbH6hl
	/rPKIRK/c4l/ETNw5Uo9a4W8Ow//uosubs8JuArJqMmMRbCPTG+O6XIqfXoITrP2
	rPDUKFX+6sUnfL6HWnDx4stButjy3tSazuUzouCAXskRqWGmZ8jvcJZ3k3V56DEb
	Znin1Y0GHSFIC/Hg/AB5Q5HA2h/XLc78LfmWwA9mqOM2e1czdsgJMld/suE5i7u8
	Q7vOQCFlf+S8q0zhEhBoKljph9krILSYPb1khlVuvvL6+MExcd7g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qhm84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 08:46:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H6WwwU025967;
	Fri, 17 Oct 2025 08:46:56 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010045.outbound.protection.outlook.com [52.101.193.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpjtmd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 08:46:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qIyOtPHEKlE0nucyRWqmpUu6cTNnnoiFysLUiUkq9kfpCuhj8EGnpJO0wTH3do+bvAT6W/qPI7HzuPfazfsYMWcCalEo0QYaj0iA0CJhKOHd3+UD7cpm9YKI0OmMlfD0zRSAt6TJhO+NufcOR/TnGfvfGMam//hGXsYJ2BgjypLHjBVDpT/QPeiitp1TPhoT8ixpOiRTf44axqcnbL37yi3bRdn+kNZwB0RERGGoC3tR41+aEE/Ht3zMMxbhRCt81ECRMG6/qoMa4gdUJUFNeVf3y6/7MZRJm+7s99lzsx6vzZw60fYjvB4FK0LKM9BkgeIHsgnDBZWesOnNVPAu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BePQFiCAQXOHF9BHW/rxHTpkcLKuI/yUFsi4ryAwrG0=;
 b=CWhbZLB3hhh8eoih8XXOPhG8r+XTD/FYkOAfBxeaRAfruIYUXYBg0BGIehyxGbfh1gZMbTTMSvzl41wDGlswKewrSPEsyqmsxIrWpSxBs6a/hFzRp9TPurJWPxjNvTXGdPizR2gxgJ7cfZ3d1dwzBCee3jJ2ty6IJV+2zv7f+Y0pY+ThwCQK5uF9s2Jonzk/iGduCULMphahThCRxyw9NOTsg9iYI+xSA7onh3FrE7NfXs+6fWQJwQD5r+j6DtWxcHU+vEKqYzQn6UfAkEIk0xn9HgAnCv4l2hXal1xPfTa44DcaAEZBtEZnnKnz6u5fGUQAUELiGMMqak7mo750fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BePQFiCAQXOHF9BHW/rxHTpkcLKuI/yUFsi4ryAwrG0=;
 b=W67exp9pn41omsekXn1QwvTDENLnpEBzlGPd5rnf0tN6gJdW2W8FC+AYEWVFYKPx//4InJzV5jI2cobLKZLGvpJat8wB/vNQH986UuW1cLD3bEH31rVCQYwckn39Rpaf3fCxq6eUyKa/5Tc+5ZyPF3CgxRMrSZbnvaRJDExPxGQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6862.namprd10.prod.outlook.com (2603:10b6:8:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Fri, 17 Oct
 2025 08:46:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:46:53 +0000
Date: Fri, 17 Oct 2025 09:46:51 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
Message-ID: <5597c4eb-4ed9-4707-bcc5-741729b1e714@lucifer.local>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
 <db3fedc0-6ed3-429d-b124-d1e67992d6f8@lucifer.local>
 <2c2a9527-e52b-46db-ac8b-b13f4ba6d0cb@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c2a9527-e52b-46db-ac8b-b13f4ba6d0cb@redhat.com>
X-ClientProxiedBy: LO4P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6862:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b9dcc4-a0eb-4549-2daf-08de0d59b8b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gBiIwbwI8sKgdXGO8UNzcSHXNXqrEeoSpPulfYS3tj0FhMZLjMp0yhrIelaT?=
 =?us-ascii?Q?fgDBxJsmFltyGddWrUh4sFeo2v5ZQBs8FO8F4xPL/tORcl3nEAN6B3hHsmhr?=
 =?us-ascii?Q?0Ae+HtxgyUBqRgA5pLBQ4c+rpLcmfPoPId8L8y9M34e8GbuqEcYvh7/oZu+0?=
 =?us-ascii?Q?+hokDA1CmWRiwN5jCiWi58gVKWqxaUGLZ+YI3wBKNN1mBp8nlcuZtEDaNYvs?=
 =?us-ascii?Q?OC4PkPIZUTOfJY+CHGJy2TJq10VIlGteQEeklH77SapuzidTHAsK7ZZfjNlg?=
 =?us-ascii?Q?4lfnyx7Fc4OJkcVuHFZXwXqJndPsKM5DHABeg/e3Bt61/j2QNLVTQRNZPeaV?=
 =?us-ascii?Q?yUu4JTzoN2xJzWW/INfupnlkxWbi1PXBKcVvOTMupdYfEJs77ePzvJXu0WVy?=
 =?us-ascii?Q?2nHOFi2Ds65DmUyES/JBX9SzGUgVSX9xwATKZEIh65+hZPDoucB5gqHjjsb7?=
 =?us-ascii?Q?nM4laKuHLq8a2gSWQSpdamginevTqDTevvN7RZ4dXnrnJYpw3EhNH/rWc9AP?=
 =?us-ascii?Q?KO3+9XH9FPrDI4UJmgZE24p+0q64lT8qMpS2cmpNlscrDhTPNLz7gGuct/R6?=
 =?us-ascii?Q?nQo5Rc8nrC6QwiX1ocQpO8bp0XKIODeqMDp3hDC84qmV9qbBZU745hT9DnOC?=
 =?us-ascii?Q?Wze5BEJ2NWAFSnPttZa0Nv8tV67knnqKeijRzsa4/wKgb7AfkjKKEzDTltrH?=
 =?us-ascii?Q?KTVsVntAd63Bwyfb4rvqLXP02+qvce1JcgIeL4Dv5SJ11fGXoGbQwjevTRha?=
 =?us-ascii?Q?PSphmGlZaIYPskaqcTjysLQhwm/gcuE7cUwMKRatvU9MaR9gYqw0kNw3mPnI?=
 =?us-ascii?Q?8YpghMC30K+3HJyiZhyyw5dCISpclohjHRjr7BtWv/VuQculUzsPV/m5Xtsk?=
 =?us-ascii?Q?jWMkRBQUo3iXz05MtWnur3STw7i8x1KyNK5WHCzdENZ+9hatNs5AwaUq+e+Z?=
 =?us-ascii?Q?pel35s3gwe9yvHolFVFJCMHx65OnKoXKZqv9W82caUza0y7f4VB7wACjaeWQ?=
 =?us-ascii?Q?24J2ukOlMsgrmugOPyR0bPYzCbJork1X2uw3Ikef8fHCudW35Cb0EsXYlKVa?=
 =?us-ascii?Q?gAgG3U+GoF73qZcWLVTjwtcv+kIVqouzNPMGNANq6Bse+cLE83FBNMCs8xC2?=
 =?us-ascii?Q?+d2Pw0GJdFPMmdsUU+Ql9BHwpI4VNKLZ/b2I3R4vA8p6sKeMpJykRE03++Gk?=
 =?us-ascii?Q?ZNWBiAJbjAF9wkOpQvjHsSUV3fv5H5zVzx4GvYV68mupaKIyLWYZDWI0rqHc?=
 =?us-ascii?Q?0w2X8TuXNGm0b81CVA5dfZfKYqMuofnDVKn94oL+cWJtg1IwdmtXfnCRATmc?=
 =?us-ascii?Q?kCaK97YMsFDcznhIayh9J/qEX/8Wol1uU7M5FN8ynq1+JedqutH5podMakCU?=
 =?us-ascii?Q?9AhQSjps9rSpvKRec0EwANJU+gCDQ3GffG0BJjaal87XKRzP+h6uI5BkEmxq?=
 =?us-ascii?Q?649oEX5zV6hMEvTMYoK+LN7eLzWa/rR7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tJuN6iy4KOSWXa5OjdWiNCfZRchcZYAePGP5cv6Wt+j9hOI72eZAgEBFWo/j?=
 =?us-ascii?Q?IyztOiGCYLTqsVADBplgXEZ+bjjhsCZ32ou7GN2oUzaZxF+T1VLbv37IZitk?=
 =?us-ascii?Q?xXblqF+jesz97E+ifJeyfL2OXmsoCFX5kgRvRRssg12OwSbAnX8d+XYZV4Jz?=
 =?us-ascii?Q?Zj+C2e5/gBoqqIjh438xqpfU2XlkYfKmtj0NsMFmUndEbfBQvmYp4rduaqNB?=
 =?us-ascii?Q?kYtMFBtA3d0grrMvLwlg/5CVnKblR6LWXnooImMa+M9nqze4Y3KfbHhU+EGW?=
 =?us-ascii?Q?/ml478PtVJ7MGMVz32QXDRjlRRkD+adG7o3mysjR3fTIvTdfB64Ng51c63Pt?=
 =?us-ascii?Q?KGWVAIefkPNmbCqjs2N7sc0FqbmXOkj4CClsqUP1MS3z68k5rYqVCE+wrwZ5?=
 =?us-ascii?Q?olCOL9W6esxBK3ynN6qjbHMxKB7EtQsnNLj7kD/GNM8M4KAT9YpjB1Bzb+Fl?=
 =?us-ascii?Q?xmAor9+Dl5ypZPnFHMdz/hLtzhtLT7uH19qXey2Wx8W0V5xlPeT8Ex/WbTJv?=
 =?us-ascii?Q?pOlCA0CXOrBS82vZG/EKWtsrTm3wNGZE7kWHOga9dlz2C46rB5DHE3R3/GAy?=
 =?us-ascii?Q?k9bf8rKzz7hWYLqoBZ4URYi3nQW6NAb/0T8KdX8S6FU3HB585ca99YOhRxkG?=
 =?us-ascii?Q?6iWFpVIzMpH6guIy56+l6D2JBV33NbiAeXbOlJQmOoLJPOfInT5hixz7Umze?=
 =?us-ascii?Q?0AjYtXJKoQdvPjB/gvIOHDmeXIF8fMgoRjTWyG+C1Bf3dU3H9d9sLFQrAkxf?=
 =?us-ascii?Q?uj8xJz0SmWZFgPhWqtl7FeZuTldszI5jtIdBYwp2AfZxEpzqzRoI/1z6/eX7?=
 =?us-ascii?Q?uU3H6bJCECKpiNl6KPSKmX+8gGB05pDEAEaVW9xD26p+aPYkjk0wEtxd7/0L?=
 =?us-ascii?Q?Fn02O3zhVTuxEeeG07nzDYJ0J5uapMX7Ko3ktm+4gxvE40zhNgaxxBtkhiux?=
 =?us-ascii?Q?V9/jk7OdCMrfqBjUnAg5J7pn9J0N2DZ3UbwmX0G0B0v5AwHY22yFmA4Yq3HM?=
 =?us-ascii?Q?7QYK390/mi32d5xwSiWJF9fbUCtpy/na+F5KUCrEnJTp+PDv3gokODltdhXB?=
 =?us-ascii?Q?vgxv4tefOj6/HQJxmdJVIx8yI0tmBimH2lQk31YcjQCOzmqK2ypwLjMVax3c?=
 =?us-ascii?Q?Hk6/KZiMssqHJsAcIvfymVbVgyPFvke7S0/iMSpB8bmmf8eTJ6+cUlKuEXma?=
 =?us-ascii?Q?jTADfrc3KmR2e/z6hRFsZ0ixWomIHuc+Ag/MRvFLqcBYDqKr0e/YgcOlIyEm?=
 =?us-ascii?Q?CiYdG+vATSle7dSrFgRDXqIJCiYTNg9Zk0A/qIaQELlX3hSTh/CnR90LXrRm?=
 =?us-ascii?Q?SvGOQNEPGXuzUrzaFQDWsbGupg3tqVrUm8oSSbRi5JVan2i014cQePWMfjZD?=
 =?us-ascii?Q?hDQFlFlwml6OD5bL7r9togucorTvmyJggL/XaVOLb2OhFzpzQkxI5soUv1vr?=
 =?us-ascii?Q?eJpFB4F6mN4M79Cbm97n6dewW20l1wmkhIfmZHteE8AODa636da81wbO7LR7?=
 =?us-ascii?Q?aH+Qj2mTI+u/2+DS4Dqo/9DDa+s4X3YKHyOJAdzktXvGDlT8lUDdcbKLSzSQ?=
 =?us-ascii?Q?EHKCIbCkgoeIP78AAef0lTMhZcd3uFThipRGd0issZDQX9WuwvXxOmO1I1vc?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hcrj0UBR6NaGbQh182Wg0C4bdwaSRbL8OVYSBISNIr7mCYkUlmLJbETfeJE9tw4p8EY9JQ2ULPxuFc21jwovPhyKcHJ9CxBs5obl3j3yD+cVGZRTatgzVL/Qe1jer2F6nx+qmQkdfKILItVGfVSOL6GBxcCKSM7uIbe8+AroxRxn8qsK8h8X5MWBtnU6MrR3EG3Ws8w2qDy0KFCeWrhP5mobQwUB3gEKl4l8SQIvoidudwhqg5bc/CoChyoUZgtBvm7xkRnjLQMplh5QVW/BUylWhF+3ZDKdIzEBolftNUNnHcK9cxRnCfpt0j3JqUru99ZQ07JeTrI2OyYOhW0nG5PcFBBzcU4TpDAICVW6QZLnQy9CdMuLQEG0Orgbgp1qbOQN1uwinQ65rzKytkpcqZJZzL8upP7+6kKgRz5WwGx8EyeGWQpMd1Ai//FWq5PuALOq6MtsQc64pFly1D+VFMzFiEv4p+rgqAgGy+tWbXt6la0RzjTVYsOdLouejQjHAFRaiDZyNfG2uV41Beoyfabayy43KuShKTpRxN4id0r2BD6YMEpbvNXggZKbUfGvnHxX7WC2O18cw5NyDJwKnvbD2DyHxNOHaF49A1W6OCo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b9dcc4-a0eb-4549-2daf-08de0d59b8b2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 08:46:53.5711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1GITu9A4MMyItNpH7p+kGoJiHMTvuC5xN2OKU/TzEg+IfWdnDmmUxMgCKmbJB6h+lTC/DGzI4M9Vll6zLvMweFQr9rxG1QGCCL2Htc91iw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170064
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfXxm3AV1k3ihso
 OXsuzkr5cNUWBAqQ2uu75+w9iQUpZj3qQWWIIU8FfH6D+fqhPyInbhEyJwr5eKrPar9CT8ypJjh
 ht2JaHMIMn67UiJnVY9t/y4jQ/A1SN9FHCm+z6u8yhO5O5i3JzCbwJ+ovXc4w45RD59SRMT5SXc
 nxOEWKpuG5+7y7oPoVSLSgOhvEoeK6uumFyV9Z82Bfv93jgSo87HY8EuEVznzs1HqKItJ6BhnOT
 J6m9AY+BfXa08V4f9d+NEHzFnwMGE4yWIiu9EqTa0880Ijy9qmzs4LQqFl3lzD3NDVpT84jn0dM
 4pADysz9HhA+doiBqe2p5mtWbeXFwh5eFUCMh6dEpbNaM1o7N24Oto2qVVs6ZC7SQNJCCvIF5Ef
 fwpNPoQ/MVrAkrknevw5/kl/MRJ43bpa6Ei0hV2YryaKpIxAjOY=
X-Proofpoint-GUID: M3_Hy5t4BdKIGrzr8BZYStFI-TeqCpCJ
X-Proofpoint-ORIG-GUID: M3_Hy5t4BdKIGrzr8BZYStFI-TeqCpCJ
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68f20281 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=BTQsouF1d6qLFXDYpN8A:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12091
X-Stat-Signature: j1duch83buu339bsxhofk3pqwzy6rzud
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE94E1A0010
X-HE-Tag: 1760690828-212207
X-HE-Meta: U2FsdGVkX1/ax+KDazRnRCzRNEe1uk9lZa0YVfuSQcYQlr7WWuWP6CWYLhOj0cog8PDKvSi/Jchnnu/lvtw2NlHb01ph6ZcB847UU44n2Grk/c6T6y2AjVdKTY3mz/e6HA0+aNGhiakPofnkBRtzljLrimWbkGRNNtY+Un6gzsMmYppCwr84Qu9uLvdUpbiBJUo1sGYFtrHz+Bl/skjNuATGE5cJ2Wd2Odz5FD8QznWqXmpJSEyroAtuGVuFydHnHziN2/KoQEdqEdKSO10vxUwWaDsMdNrynzyXFtgzQPOu2NYI+K77ASACwhd2tqOHBMvY2SlZTrZK17szuDWW9Zc3EoN0Tper6LSPZjIlmCII/kN5kCq2wkzyGGM1K+5+P4HGf7tsaREZfxCAY34tDjJqI4bPMwO7kXltjG9cPg3Ve7qDIxfG19OlxvitLa76UE433RcEYLgQ7YtKs02e8TyG6lsppn6OnmmB//sKP/RIhq13BIhzRLdO/Lg/jtj98s4Q9kSyXcqxyCbjI1VeSyN+Zj6M8sTgBPBsq6iUKpz3rLpZhpcwsxokrvfQrcY7kOIXcc3rnTNA52VsdC3+7B6eWOmIhbKrV25ViHOeZKzh3cCbJTEr38pNmnoTzAVRXnpmnVsXtCQrn+DpVEnQk80y5HXpJuL3yPew1jFXGjjadFJdGgII8VDVPghjM46Wz94CmNS3tD70jQ6KfjsVxmtsNTYBjdBBQW3PPydTgvtZ0vcn/SvTjll9almgMv5ByP6Qmh6sRQkt+ZVFoH14oornSxr3KBsCM70pvSskx/jhyU/P3TLn4mgGqZk4/X+2+diWNDKg2yKHBRMBfbrZAuBynCr8EDaXXF6C830al8othNf3lzbMgnQPOG08wpgsUW7EFqULAvVQsxsmBS4A3+PbZR4oeATzq3nBt/XlUqTJ7kuRM4dgvkRWnW9zHisXpmXCuh14jgW8DbLtAr0
 tlbz/jfp
 0fN/2U42DahWLvtIjjk/QhOjHxa/Hwatb6gKSePjRM/OxOcxXG4zCaGnMpp2LCB9AfgBQUcQyxfqS7SM0fHYdCNfwQV3tAW8TFOoVVtYhwRvsK+TnEylFFgnede6v7ifr17RcmdJNrIyVMSFM1umlUcWq3JuT1CIyp878JKQlEmtg17BqqI2VA2ii8XSQiL/JyL1DItK2vyDnoFaA7uAmDHpLtEDPV5cMVwrNeR3+6IdDwfZQaxGyJXJZ8SF+w2q2AmiaZLjAGLylKHqhpB77e2rVJQxrDq6+zMvDkR5TG/0uCi418+ACjg+3Nq8bA4YVqrNVz5KWp5XsMs2d56ZDkbsuPxEkONKSVoRkVCkrRkd2kORpFXcXhpCkMBRcReHX4PlBx4BBTbfhwaBYuKxfLlVZ7PiA2hvmJvHcXwxhafjNQ0QVKcTMuyfKBwLvO0vJ6SQBtXQd8MMnZX4B4CHjrgRdiYBzwxltRkH5Wv5pUvA55HFd2T+ef5PwDOyRXvK+l2i/PCpyzJ9ElOCi3M897FrgvkjTd3/6RVEI03d4VZJX9QVzIN931LU44m9pQtv6qGTtM7GtwO1v4rAwtIy5F25vk6tHg+PKFnq3JrNLSuvXeB12QnGkKyxObMx765/neeDpmA8Y9MefCOegTdG4xHjBYXgARdgdMcOVOSYVTHSu1j09Mu7nx6Bsk0xV4IEg3cy8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 07:45:24PM +0200, David Hildenbrand wrote:
> On 15.10.25 17:43, Lorenzo Stoakes wrote:
> > On Wed, Oct 15, 2025 at 08:35:15PM +0800, Kefeng Wang wrote:
> > > If the pte_protnone() is true, we could avoid unnecessary struct page
> > > accessing and reduce cache footprint when scanning page tables for prot
> > > numa, the performance test of pmbench memory accessing benchmark
> > > should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> > > footprint when scanning page tables").
> >
> > Hm should benefit? But you've not tested it? Seems like rather than
> > guessing you should actually give data. Otherwise I don't know why we're
> > referencing a benchmark.
>
> I guess it might be harder to quantify, but theoretically it makes sense to
> me to just skip in any case.

Right, yeah let's just drop that then.

>
> ... and it enables patch #3, which is nice :)

:)

>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo


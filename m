Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F1BCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C337F8E0077; Fri, 17 Oct 2025 05:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4358E0016; Fri, 17 Oct 2025 05:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A848E8E0077; Fri, 17 Oct 2025 05:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92EE28E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:53:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37488C05BD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:53:19 +0000 (UTC)
X-FDA: 84007143318.04.3F5C7E2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3615120004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:53:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nLqfSBq6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XY55QcU0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760694795; a=rsa-sha256;
	cv=pass;
	b=frxfxej0Ouyn69poMJt39TBBxft1wd2GGjWrRp7f3TR6mC/6sEiqP7hKStuz0PhhsAbr3G
	AQnE2z8TL0xVtCSuIbJFkOkFdOSUrXWal+0cbpe5CKvFF8llJoLr6AmJ7v4JVv84ySPxCq
	1g1PmrE+FIbXbj0igmS1aB121YRyrwU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nLqfSBq6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XY55QcU0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760694795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hhroYipE7niTiZL5ivl16nM7K/9/JJy5D8LA5EAbtg=;
	b=h6kz0xBkq5yQoNuSgsVSMIOFPrxqXmKqtcTPWmUmaLBImoduZUKU52if3EEVbjqOkjTEqv
	p1KPJtQMnABfRhl5tlSv0LB5J4m7tHx5H40TmiISWgnwkgNh+w6N79mbXdTCYzmlx7EPW2
	Zffdo8ceObeHYgqOcmSxFEXuaMaKx2o=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uEwa008797;
	Fri, 17 Oct 2025 09:53:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/hhroYipE7niTiZL5i
	vl16nM7K/9/JJy5D8LA5EAbtg=; b=nLqfSBq64YlMMpBmfPyt2OLx0VOGEG0LI6
	cz2R86NeO81oi2pSj3WeyoCmjNn3H6jeZtFCJvyh/yIiJMViaGUf8uoh0DEsn/qQ
	NzEsBEVuq9sT41pUwe+JiGS5eFgh/XLTDxV/9qlSwErAflUXiD4t0iFCIWNHs7Km
	uojF0UoGQ5oOvSw97h/QTE16MXTaSgeWqbIBOngLQ3vWan1sM5NcghaUDLgo9NG0
	gdkUkuNJ+iu4b2ge0k444CWnaiqPuGh5RPd5CNDMSRJH37P1qaX/iU9+yfOVEh1K
	6apGRSzQtvo5wODLS2xYLEv2dAUGVkKObunvCV7tbdbs31AmsESw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qf47thsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:53:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H90EqG013930;
	Fri, 17 Oct 2025 09:53:06 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpcm4ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:53:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfJW6r2ftDOjoWCCeglezlRkVqOiev58SuXCDd/cHSTmG7Cd7z0Ni2utzN8v3WFt0q0wFo209vPbzkuHLOKZ0+Kb5IPdoR/60U4efFN7A9rp7c9Cip9xoDPhh0ln+yZhnufTa2jL8h7KmFGn289GZfuP29KdtThAq+KVXom6i69pDux9niuCvyFZ3I1uZ3yLZsPtxOHQWnF6gy8e+fM+oSVPXn3hq/YFxkooKsrdhfTbxPWB088LXW8cnGUW0FwUTLOZ9buaAwxg1dl90f8T6FI0Zo2YYtrg30nxUvXkDhnSTvnial9k+K4TruTm9lAT75M5c4gN6SX3q3mT6sKu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hhroYipE7niTiZL5ivl16nM7K/9/JJy5D8LA5EAbtg=;
 b=D35PuZj6gI5kPpV8CmwqxNVVsP9O8HjmJ+Eo0unJMm47trmOzjBvYb7BzDTh5+oeHDRuaYSUKQsumrS2bh3FPY1Dy0AWyrhAlIGzk7zEAfEZFz8O+vuRJ6BjVzgNkOcZDzuQuGmahoWI0Ew35VfXLNSmkbMpyMk10U9xH0z5EB5wDGko0tVqFbLBZMVNNloJbrv9rr8XFGXcGomjqIZrWrkvEcoI/EoPaTkv1eYMElIwYtEQMudE4ABMWv4pm0CJ2j4Uz9eOW6ngar8Dj+QQ34yUQfs9T1SdH9mhjcJsRPtOjTg72CSnQR/RvsdxcAIwg2BRMVRAx96hqFApd9invw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hhroYipE7niTiZL5ivl16nM7K/9/JJy5D8LA5EAbtg=;
 b=XY55QcU0yKq7zRAnfmTtALWvZo4U50+DxHVXjjPjEU6XC0t8TYQyXg/UCXGlJ6MGtHYzBsxDfGEDJNuL0gnQ9uFdsBdWLLDdZB0gwJtV89wV1XfJalq6fJFMVlQ97azIVmNAPWqSvJFo7PSYnTbO93dY5H0rvmnnvEmHHXiZnuU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB997570.namprd10.prod.outlook.com (2603:10b6:510:385::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 09:53:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:53:03 +0000
Date: Fri, 17 Oct 2025 10:52:57 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
        David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Harry Yoo <harry.yoo@oracle.com>, Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Byungchul Park <byungchul@sk.com>,
        Gregory Price <gourry@gourry.net>,
        "Huang, Ying" <ying.huang@linux.alibaba.com>,
        Jann Horn <jannh@google.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
        Mariano Pache <npache@redhat.com>,
        Mathew Brost <matthew.brost@intel.com>, Peter Xu <peterx@redhat.com>,
        Rakie Kim <rakie.kim@sk.com>, Rik van Riel <riel@surriel.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Usama Arif <usamaarif642@gmail.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.12.y 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss
 when remapping zero-filled mTHP subpage to shared zeropage
Message-ID: <121d5933-16d9-4eb5-b2b5-2edff9b36c16@lucifer.local>
References: <2025101627-shortage-author-7f5b@gregkh>
 <20251017085106.16330-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017085106.16330-1-lance.yang@linux.dev>
X-ClientProxiedBy: LO4P123CA0256.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB997570:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed7a8ee-d05b-4951-c6c6-08de0d62f705
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q5ZhxFK5rwWCJxrB3f9bDgtKm+q/J2+rgZisnzGglr7WBgu7OzQa2Nc1Dg1v?=
 =?us-ascii?Q?yEnLIcJN1OXtCH0JLJV0/WGYMrv4yddtBS5oSPVSyomGyeDT9oGRh5iGtEhQ?=
 =?us-ascii?Q?OHEnat3VlNgdX/l9mrQ7WFZuk5b8TsF444WKCYIpmpuo3uwwj74Tbq7QfobN?=
 =?us-ascii?Q?fab6sA8LG0Vw6XuU84pG3Jkp7iuoWpkc3+nSLa6ebDaIn36+XxlC0JoETnq3?=
 =?us-ascii?Q?PEXHbY6INZyEbudouoO/hEr9XeQeiRigUPObELuNwAT3mJ4QPq+aorcKAgHS?=
 =?us-ascii?Q?bniz/wYTIefuBzhUYsSo2eR1jVNR2G4cx8o3LwSY8SKEdLsdPJyFRbM79kj0?=
 =?us-ascii?Q?gbcQMiuJY0trj+ZMJLp2f4XuCZOVlChLHg5ylzSKrnJFFufi+OXQsn0areC8?=
 =?us-ascii?Q?mBU94+RiG4e3/fiWQIKLKds4Rwf37W9A0m4NGwBXFx25ih0VeZTwRFj6l3nA?=
 =?us-ascii?Q?lz1YY+VfNC4nCOFWFnTJ3nFEDzTkD62PGK2Ehlv8zzQHezIukGBhrosmmJxb?=
 =?us-ascii?Q?aaw0tR1tGuC5bU1wlLRlDIDvnLxj5zPHqP0CIFcdlU2PVrxqHg2Z+c/S4lZb?=
 =?us-ascii?Q?OSuVESZJcb3bpiQbKng4LvHV3eeI/XzPPGMT+HUM7hbtDWKtmXmbPA5fTrnK?=
 =?us-ascii?Q?IHnk9u6fbymb40rF9tzHMTy+VRNYfg9pLul5BcFxPczOImIx1cLibDSV2f5w?=
 =?us-ascii?Q?LGXJ9X8jn9YSFK00X05C2x2bfmlT0Qc3+NcNHDsCt5G8OYl4GVLa2+v3EuAG?=
 =?us-ascii?Q?xz31scoR8mup2LbU7xGaWG5mJ12jnQKCxuBCISLGydhJWEz2F3Iudklp3Lwm?=
 =?us-ascii?Q?SGElSUHGC8D42svmw+08O3bRMzmEYSF5BzNpPDDFJUcIngVAJVd+7baVhZ7v?=
 =?us-ascii?Q?x2/a8EAqMVvZvaNRk6XalkT2py65nyPWEqR46lBI99E+aAgm/H+L0J696z3F?=
 =?us-ascii?Q?V9Gp1fgORn0kr8jVdAgsQB1//qIl21kAZ4p8js05u8bPHnqShK9EDrzA7SQm?=
 =?us-ascii?Q?qzaankQgETTTT0vDtQYpE3njt2UHVqXt5QB8VHFQl9R8i+hpeTKHxnb8avej?=
 =?us-ascii?Q?ztkqihfQRIrqNW/jOiPzRlBlCQHzmGUywzHBsZ2ggjmvX7BFLZMXtdNSCp0w?=
 =?us-ascii?Q?cbeHM9fn2Nm0u1hGFHrno/5MtW9ad30Bu9zkuDNtLCc/l53X2GjOuHMvIa3L?=
 =?us-ascii?Q?q3E1aR4kgpS2iuApkflOORK3WDgr+mPyZ0kKdONPbjVWkDqj2RGC48zc/SZ1?=
 =?us-ascii?Q?5FkXxR2YryBTQbo8Kp1tYe0+TWlQHZiz0GTHF5jo4orJFK3p20I7MdvsnzN8?=
 =?us-ascii?Q?Z2zenPKV42c7AAF3YTxuotVuqoxvZtXe1yN6MP93xoBaW5A4ZaCRS2ExvWZd?=
 =?us-ascii?Q?ePvlIbHva5f5/yhPPNaDTyFskYD4J+/0DUNesRsEYCdLJ4QAJ6COzjLmgDNl?=
 =?us-ascii?Q?OxX4uTbfFC4FKopgm+2W7fG2KeGZfbLM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NGODEZQTwdPVU82Z77XguSsV5AWf4Xp3dKq+rImJMQcaOBuIV/cnV1SChfW/?=
 =?us-ascii?Q?mdKIEBQmoMkj2ZFuir1/b2YiUnbCao2Z5LdPvof6UoVynPioLeSi8PNB0q4i?=
 =?us-ascii?Q?amzdZllboJHEQo/k7VRceBMxOo8ws/AX6/PxAWmpY5JeDLUSOwqshec1yddS?=
 =?us-ascii?Q?ywLv1nYdtpaqnN7VQT5X2q358ZgofCyiW+zPF3oxaG6aK8yiPQvAUrFXHbWq?=
 =?us-ascii?Q?s5dkrxDfeuHorViaGsGuDHkuYrjGSOSUZu11q5iUCv478KSyol/kxKtgOKu3?=
 =?us-ascii?Q?MVHWprYADBZ0rqBO3kNtJ/ta86F4fH/gkB8XNUSFiHHCMYSLmmtYO7PkZGWQ?=
 =?us-ascii?Q?T6EPXnT6UXRtxqcsasB3ujFLfNTOWKTu8z5vj/5Bfu+XqykUspFdNQfcGNNW?=
 =?us-ascii?Q?k9VXHJIi2OEW5If9oQvZapnoHDu/ZopXRcqiq3Qt4reSOPV5XUT8pQ+X0h2v?=
 =?us-ascii?Q?mjCVWDVYOxdtymsK3XWAn6Aue8qdHBuw+hH8pUgr6MlVriE9FasH9RwIk+ZK?=
 =?us-ascii?Q?tCCGqGKvMAK/QKmAS34qZRaIkZDK49rC/kTcGuq+eLdsTF8JULcJtK1XAV0n?=
 =?us-ascii?Q?qE5PHaQ0CRLFwiKRFQ74PTALRSMUOLQRIFSPHTk2ZSKeoTeFHB3CylSVken0?=
 =?us-ascii?Q?DMXruQtVv8FLLBl1iBDPn9qhXaho8o7zbQIAK1YQFaYzDdoIb3gSpGSKRYqS?=
 =?us-ascii?Q?AdEp171MuYYU68QtK21VOgAhGhb7nQJdqY6qoccyLzTpA1L90f3gkx/ltUrd?=
 =?us-ascii?Q?NXUj9QX8S3CQDtvWpUKG19a9koRO9ld16+xCrGUkNdaz5MhtbAkvPUlFriCy?=
 =?us-ascii?Q?DF+8cR6lhYPY7KxjefVQ8LYVVTtjM5L9q1iFzsvrR6qhybNtcEOtYWWCxt5i?=
 =?us-ascii?Q?taZBEXIaBsj2YAfqQk82CiICVZTgMvPzqlXnsalP9E6BVccX+SMqUt1JUoGh?=
 =?us-ascii?Q?2UhNYuDKzO1XhbBQhsu4RfyfjjekUiTm51cwWG1ut4uEsfPkn6UmCT703Bfd?=
 =?us-ascii?Q?gxFmHkrD/KffngQD1RNFdlu0qf92tT7DiLyMHnEVRvfbOiDwk/e0x8UWLNhC?=
 =?us-ascii?Q?LO8o3XM1BsMSYqiKh/NHxnRKARMbihP4yiWYwVyglc6b/pE2Bq/dxh+yVmHZ?=
 =?us-ascii?Q?j0iEyJ69/aLyHr9QeL2/3/hrUc6J5pOEF++KNIgN0TxAHX7n2oEsE4AUon3w?=
 =?us-ascii?Q?zqYChnzwQHMCdNyq0Zs379eMhw8MBBC0XvOemllxsRPm85NE0D//2I7C9kfz?=
 =?us-ascii?Q?KWjs/WKYr4biZf75VtKqCsK9I2Ffr4hu8HnMYuVOYV9k/VQ0Ya2cFNEotagT?=
 =?us-ascii?Q?ro29PFkx/KpdOZzxY9iorFHFZjlL5sMxdqr37UtBX3OwPvry25UtfbnIVTfR?=
 =?us-ascii?Q?Zbcg6/V6rgfkQYmtYFZGrvp/oxKf8RVAUoPKJI4b62BNBR3HW29XeWa3+MKi?=
 =?us-ascii?Q?nEPIIqFY9PX0o+396d1/m6Tyw1aa9ovfdp2h30rp/AFjrjagI/DCCWQ7fWWW?=
 =?us-ascii?Q?QGVlGp3PKtpWUIPXgjkHK1okZdYOity/EJIxxXDtyg7jXqDugXnGE+Ccbu83?=
 =?us-ascii?Q?eyBSOh4X90A2ZeKXl17LwYfZ1C28P95i4ohEzLqP3ds4YjYySwTGIHLlN5D3?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G1cW23BEVTpw4UZRoUp1dIcBKzm75U90BLP1FQQLlHnHSqFbav473U028WyPLs930GlvpqV8vMQmXQDiDo5Wub0r0GbyrYfawuApdQv5eZeK2LApvg7cqbZNCcHxyzVYzO9MJoClIO1Ekmm0jK/K6woCHMDAEZ+khSMYqktD60kgd66kCmnQTsHGuJ9OCkfPbJLOO60NxCiC9dB3gjCdGZoemU4r6XjwkL+vloFTz30HKRtgYcT+iGZCtyniVI+NwrcXvos7XLrVSd9DmHEn0TTBDhV/MFdw4F2XzlwEzf9h1e5JaJRrCLsaOWu9NIOhf+bDEQUT5lxoyk0i7xVGGdKQeH53AZbSXXDDKC2k02XObbK7AyBj3PWrUt4A5E00BrtQMOEI3AGRMtS4ky7qg9zvgxfV47UOZwDuTp5fMCgP2/r98/yVITwRhStD8PpJrwXaJ4i1mkbeBtzFT3IudpvaFMy6i0vru9CvMBs2Yj+3Z9j6Vasm3Riz0VhD3EH9lvbN6VydjEojpEtQ+m1wvM4tS4TP5x2N/T50hxlplcG3t2dINdGcYEloRzxz0PR8IGPtjsdh+KcmUa53lUOdyf0cOPwvLiHywfR0qT9NhB0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed7a8ee-d05b-4951-c6c6-08de0d62f705
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:53:03.6099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTYKf0Vr8C88HnyrPz4SnSJhX4xZvsMHlaEwvh0cwCjVEyFict5wge1DggH2VnIAJGP8XDISv9a+00xsaN8c6FO1ciJBEHhDNYjumRDFreM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=844 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170072
X-Authority-Analysis: v=2.4 cv=SK9PlevH c=1 sm=1 tr=0 ts=68f21203 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=Ikd4Dj_1AAAA:8
 a=yPCof4ZbAAAA:8 a=aNqfV0i3yNbtuYEf5NcA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13624
X-Proofpoint-GUID: H7yoovcXEsxkV8s2Z_OKEnn3Oa5HA8rP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNiBTYWx0ZWRfX7wwu9KLifC/N
 0QNJlN5nr60olSxEWxMG5oQTm59uJyzMInw/K1EVf+/Jm4oHqxpWEv51lQlFK7wRtzQ7JMf/MUV
 z24DpDhJWq9Q5yzO3BWC8Z7AseAY7BgK4Vj7vPIS6Zxii0n3gi78JJ0zUpa2xqetLYDyzYNk45u
 IxcInsNb1Iy4mts6ZfYnVCnq35tuC71WMgcxoEDZgO/nbFpKuXaCAIl5tUksTPMvM3hGiMCIQJk
 rsZRaNbZZIxtSwv+Ku8Xc3WR+bllC9LZYaPutanF9ikRorBs1hI+V5G1m+oTYGktPK9bM17TqHI
 KRamUCn3aWLWwfgcqYt0LrS2VY/3QQ49JOl1CtzBKfWGr7d+WGG7OwjGPVMN50aU38UQ8ANIOvG
 +zA6m7A4YHYTxDvakEZ1hDFY2P9KpwcAayoQ23uxH2j7LzdV/eU=
X-Proofpoint-ORIG-GUID: H7yoovcXEsxkV8s2Z_OKEnn3Oa5HA8rP
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3615120004
X-Stat-Signature: gx37te3d35wy1sb3gcehi94ebxqmjf3q
X-HE-Tag: 1760694795-654758
X-HE-Meta: U2FsdGVkX1+aGszfUeETMom8l/HOGw3T4qfKEwUxYAV8eN8YSHTeTGZ7v1m4Ut9OC6aO5dG+yJhnqJ7ZlcZxg6fnA5lSVDrQAFED8UA/+GFkWKyVd6O3Jn+wnJo9rRGnEC6QidnV52NUeGSWlshDWsPkUK8oQZMG+hpt1fP6xKDCR+Al59rmocWWETWgJU8J6GWyrITY5Zv4ksB/wjNeCybIM30rMz7zdhzMYMD5D5Kf8uJG3jt5+XiqAl3XKcoWlXUvpArlSxzYJ3l21xyRTq5YNfjMAiKx4dakhngRr/Hn7riLTO3U0aaS+DQ3V+7ApivyQJWQYQ3123bQChV6TiOoXGIcs93/hQu+vAfsIkNJo3JHu/s9Z484FFcKkocqJ+NbIDRs9WH5i28OjiOsVg37kxRDfkwLD3is0Yz9cnX4FV8aL97/NAgqHTAniw0RJdnFZTJa7sL7zkXM9UqQayQ94gGMi2VQuXd3HENRzWTeHmmG/HKdIAFeWCmMlQanjCOQ/llTVIIY0DrBphd6AKRkkjq+6jcJO7geS9Yn1dFlI7q7Zd/eNYz1e/qbcBNJXUO+/7rA394sKYSzVfG58wbteDUnXIPSk5OQ+vkGrK7nsaiJlbB80cIBnaMEIqq/r3q6tKYHbUmC2XYLJErYo1RQCBrNPhu424YebAhWXOJakwc+4z3D5jj3PZ0qIEF5utnwr+4Uiu2VS60WuQGmwTFSFKUNgiBgEze2otIqvNmCRd5EuztZmuKTXGidNPuuJrFWc13pqHy6cvlf/DKooJCSjum9t7rs829u3vRstOae9nMCR+KO5bH0TtkBD3NEZwJqvRTQKscXAf9nmLb/dZGVEDzybEKtGeJCcO5+WYT+6nRE+MiwnGEkrsEhwo2ECgsQwjBaUqwW/eoBgrPxMK/JlQUXTwqohhkWUYKv8DhhTDmrXerNiCiMoQAVlYSH+Atyzf/UPJ4EwCpppq7
 nojlJclY
 JjJ0IMxW8XD43gVCg6iDymin/60DjUcOiZ0y5si3ZtxeUKwxqP5KbXFhts6Vu+c5Kl1YF4fS16FsSRoR0/s2NBZ2cePXBBYjdH73HcXODhGNAkHx024+oGGfnYNhXvjP6L6VRCLufrC4G/tMI00ku3L+pBZKbgrl7wfW9wLZlI+qx1bsczAOSFW4caNmXBQ8VIY4IV8gYAAcppLMiLmEVy9VmhV+GI7vuRkdtnC+xKLGrDiptvKs93DsYlWy+yppqKVTZGmkrlbdYvFan9tFgborKiOsoTN1Q3dAZgI4P1okY0tOjBLEsZQRi4DX4DPaXraHBQtKNbEFZpHyIj7SWm8Xqdqz8nPSg9GocnnY1rwXNovP2V0F/JPluLl1LqM3YELa8ldhbyEGl+nKOMZDmf1aK+IvH2wjmrRwthR+VeTtl9nQi/N6x7dGdKBvFzL63zeePRA8JNFw6jRP/brQ2vQJhH8/oEIn6PbxU3McbBaieTk5vQeiOHMWrADB4FUoeeVYnU6wrfYq8fj3t81L6ZI9X40JQo2wZQLNYzvdwxtAJSmgBlooGBjTxAfHxL7vekCEhLEFy0oxoPDNRmw2cEDHqj47bDpwiH104rbomDK1pN9H36IJjX7iI4hLfc8G7441hulJQ7TFpqTpyHdrgEFWz6q5BJIdVburyYUz8WIG1lTihbU3B0Vkqzy3Z70Zsn1rM9NJrTQQtzRfZCNeCq+mbIwUTp0etm28DgNpEbCcZ4ZCSY/A2vlsEUNsgk1vLyMLyma3N3mi58YD1vMBWKRP3dGwyGEsy015XviJSbpDmd7Y6o+/0C6Ui4JfptWy7PaHJsqBbmUkrs2MXrDAZ37xWpaEhgLiZz7iB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 04:51:06PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> When splitting an mTHP and replacing a zero-filled subpage with the shared
> zeropage, try_to_map_unused_to_zeropage() currently drops several
> important PTE bits.
>
> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> incremental snapshots, losing the soft-dirty bit means modified pages are
> missed, leading to inconsistent memory state after restore.
>
> As pointed out by David, the more critical uffd-wp bit is also dropped.
> This breaks the userfaultfd write-protection mechanism, causing writes to
> be silently missed by monitoring applications, which can lead to data
> corruption.
>
> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
> creating the new zeropage mapping to ensure they are correctly tracked.
>
> Link: https://lkml.kernel.org/r/20250930081040.80926-1-lance.yang@linux.dev
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

You're missing my R-b...


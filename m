Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4986ECCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63CF8E0137; Tue, 14 Oct 2025 10:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C058E010A; Tue, 14 Oct 2025 10:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9038D8E0137; Tue, 14 Oct 2025 10:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8E98E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:49:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38D8DBC36F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:49:33 +0000 (UTC)
X-FDA: 83997003426.24.56C5471
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id B155A140009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:49:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ns4XmrU9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hHPJWuUb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760453369; a=rsa-sha256;
	cv=pass;
	b=rDwo42I11vNSbHHMcNFeg0euBcb3A6tFEWCPL9Jv8yu1HNkrTyXEN375U9a9KEPuWpEA3X
	9drE3+XfhtkOrNYsQiNBSrlbkvDdvfHHn8Xb2UNQFe5RFuwT55BwTw/zhOPegQYfJHEd/u
	OzLaEVcccvF6RheH2ZbVCn6aiqPmTcY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ns4XmrU9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hHPJWuUb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCm5XcQizFKXw0o++bPcLrGmydBNctS1K+3kcbarOm8=;
	b=v51c4YhuFu/0JYZT0kZPg/9H8jC3uUMF+V5fzym14Pq06glQMJFyYEWZVKNeKybqNeBYUt
	icl2fakms9Zn6Pg/u6ydBkGA0pBS9bhubiX9gsgtyyq14O546U6pZ2yYMiOaOv0lbpE1tG
	EY23AoEJf2aF+m0P8AznPitzXo3M/bQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEgCs9004443;
	Tue, 14 Oct 2025 14:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hCm5XcQizFKXw0o++b
	PcLrGmydBNctS1K+3kcbarOm8=; b=Ns4XmrU9ND1eK4pE7ihGg8lXK5eu+OZpX+
	8t5rEN4qcB1nCVMqExaYPpN3vwN07PvMTEgRkJCJ8V1mWXI7r9o54ycKQrLtA0tk
	D0ZwJZkJNLu4YIWWGnPAIvWZYiaOm57jej6gUJoi4AYNjeSNpSW/s6AOYpblMwCR
	KLXAYClpj0tiIoVF+5WjXeLyEy6wrFpis4gmPpsFQB6lbLcwXlLBuuMWHq0BIGAX
	gJuvhtm3iC/8vswJNI/iPXrc7DhBoGIPLX41utjf/MbuCsoP5TsfMMJUs8hdq2kn
	ID3QMFUDHaXGu91VpdC6RVD3CBZ7ViulFOCdwSj2nq6XgF/4La5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59cj2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:49:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEBb91037461;
	Tue, 14 Oct 2025 14:49:13 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp91tw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:49:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RRKf09EPkrhQ2zhyNrB5o/++0nLDU3YsDj5fFK15nJzLesTt29Rv8zIjsPI1vWJt3C62kEkSuzR8+pmgBnuQRBxTDgIBHf3QUtasdGBsl5LZ6F5x+iTmupnoUa03YfpYlfu/KrBz8aLX20BNoowsBDV87zDuGPoRFC9+W8KQ1ZmGtAyvGbUyQkS3nMjh1MJBOGv99843Ttx4Pu+px1jL/DhmOFMK6f6LWJuyUVIrQdfIfY3JM2tfpVoaiq7nuRPTkOBdeALTzCSTdm6lDhh9gkWRZ2HJkiiZQYLmCji6ukq+Ug5v0cIbbHSbY3cIZk/5lI+MlmEu2uA9mFX0usWldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCm5XcQizFKXw0o++bPcLrGmydBNctS1K+3kcbarOm8=;
 b=au92xtirc7OPTxKJ5Bhj6ctmHk8iVdyHxqDbp8S/RO0AZYE0YFqXXFwUH3hWJhnGM+fN/tquRLkbZQOJBNXi6WZQK87L1Eqg2GTqnSjBRb9vGJfXOB5yP4b0zzZaD1XmE4OfLOAzd4mbABzXhidaJgwXsuGcpCgFbtT41usZjhrHGf6x865823uEGPQiA4FFoZa9JdK3G4/b4rdJ2fyhELwwAvotlnuhaWFFm4BYBWS2yLbC2tWAOrTf0EVtQYB4uMlXiw9uZT3kG4Te1tW+GDhRAlNaGIMd0/FyhHEq5g6ACdH2sTsQZyrGB13VpyfXv72au5ZTBT23NAfbiTbjuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCm5XcQizFKXw0o++bPcLrGmydBNctS1K+3kcbarOm8=;
 b=hHPJWuUbL02Re+xCrJNWiuWkFn8UhwLb8hCslDQaNEPVTKZupBowitKpjDnNW+Kfgaciiyc5vSKd437L7ol84IqqHrg0T/P4hd+kRDBlniUF9a+w015QJwmiFPUIYUZsQWH5ub2bW0g6aLrXYs9ilJn3KpgaZ+xMkgbtrOYHpec=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4326.namprd10.prod.outlook.com (2603:10b6:610:78::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 14:49:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 14:49:09 +0000
Date: Tue, 14 Oct 2025 15:49:07 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Yin Fengwei <fengwei_yin@linux.alibaba.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge
 pmd
Message-ID: <86bb70dd-2602-48f3-a683-5ec62b37fd46@lucifer.local>
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-2-ying.huang@linux.alibaba.com>
 <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
 <2861a35d-4f8e-4ee1-bd11-b915580c9ce3@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2861a35d-4f8e-4ee1-bd11-b915580c9ce3@redhat.com>
X-ClientProxiedBy: LO4P265CA0230.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ab1708d-bb9e-4aa9-1795-08de0b30d4f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jEFg2iMzE7e5FO7NvH116HQqVyYylC/OJvOr+rl/ztRmzgBvngbB0yuyw6m+?=
 =?us-ascii?Q?UVkIfMAMQp3HvKNk20PYQ5ZAf7wohVKRGJweRdIshiMdWBIhLZZuk8yO3PEz?=
 =?us-ascii?Q?gHULFHx/AsiWhSaJ1aKRJgpzefwODwTDp+m63uYIKC4Fy0JkRJuH6tRVPZLW?=
 =?us-ascii?Q?CKmCX4HkN6jy2/iVj4YMnE3XcMjso1UeI5zPOJgkO+29+MYRWxz4EvTMll+N?=
 =?us-ascii?Q?pvQwqQyFulPMbJkHgO0HcPctv5EhPffRjWYGN5Lp9YB+WNX0dLX/c+JhEFIH?=
 =?us-ascii?Q?TRYIGG6h2383d+ozc/ACDyZhIuoRsLjsOv4iJ6M+WevhFQoaq5l86i9yuLsK?=
 =?us-ascii?Q?DKrRyKMar7/WSqXH+knwnwqRfD0jdO89WULNdCtDp4BcfyXoncuzInDGL0sR?=
 =?us-ascii?Q?YZNdAjCyP/86a9Khl78Zo2d+i3afxDEhgH61ZZrcdYZvsMSxfhUq6FuIVe0v?=
 =?us-ascii?Q?HfCBUEv9vQb0ZQspn7vmEAzOAux0orNUFsva+wVUXC3TOz7HqiSFjk/RZfc/?=
 =?us-ascii?Q?L0EGgyHMFK1btdhm63SFSOC/PlCFqAZpGZjZ+MT60VAslUp1NzGlJKX/kcGj?=
 =?us-ascii?Q?4v4iDU5M6jkejP53ky0+jsbZ2rMupxdx7l0gzL+wrTAGJVJfJB56JAzAm9Nk?=
 =?us-ascii?Q?4Nl6AQaAcijHgpndbqG9B55SEDFfx9Vq+k5aYQ5V7OAGbUFa93YjCVwCuCq2?=
 =?us-ascii?Q?it+UfZw6WGnVMmMISYKqvFBOaSMIxOb2xJYW6VouNruzktkLDjEMf/NRszfk?=
 =?us-ascii?Q?IV5eaYa6fwtPm5wQRLzEh2IyX5r5jr/n1xCuFoDZOpjtrvP00JdkdAU92KJx?=
 =?us-ascii?Q?SBYcSLzYJJ4BsOzSnCGAMZhxRW3p2hKUvcxI/lA8iOuDWiSSewPgzGYl2WD8?=
 =?us-ascii?Q?+oSQiAouc9vlUBeBmqfCg0MiUsXCeTnFOMYZwjdh2b/wN35FsyQP2EYTISKr?=
 =?us-ascii?Q?jlEXaxIJyzU3BIAhO2hNAc5dPta8PZOGQQEuVyC0pudpjolFsMDrI4lId6bz?=
 =?us-ascii?Q?ibb53IF1zHX1vLmxY8eFk1DFy+D3fKHW5mLH4rSypouryMDYWAv4+66g54ko?=
 =?us-ascii?Q?SbpC7/ZsOzlf6w50X/0qs37xilkJTFFUeBZN1QrcJDV/QAaN9LTAXbfxFjw0?=
 =?us-ascii?Q?WceKCqYUG67ZDW2j2oJJ5w+IIuTmi8mY1hHn8w7zQUGhnAM3vaqSkwI+VlaG?=
 =?us-ascii?Q?22q8R84ljUBIc/dbGc/JWQz43yOSS0lu4jVgHOfpuU7+eP52H+fz/JvyHTwF?=
 =?us-ascii?Q?RG0fn0n9igr75mCVYC2olQgamG/pNS6jpym/W6jDiTW+v/HSeFowvnqP6czU?=
 =?us-ascii?Q?CCGO5tlUtzOF/wgynbbpC+LOH8IudXdBC/oNbICJ84cXr/KSz5xqKb3Z9nMR?=
 =?us-ascii?Q?6lfUtN2IvodYj1IlWX4S1vIheNzcIbcejbPInK79kblbNVsrxcvLb929cjwu?=
 =?us-ascii?Q?xUwuULNBN96+QIknCmfDRApJtN4iaGZS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CEUWE8+MN+v3aXjBB8bKqDsAeiHLglokhx3I8kS9M8faN/03xwSTPG+yd9lN?=
 =?us-ascii?Q?XKEoouwW2+QTmaLtL/lqp5vUkQbFwkGWoJ+dAoD3xjeqRZvxuOn87H3BVlQK?=
 =?us-ascii?Q?9SCAtm0iJvZC4Di3/ITrZjYoSpkLHzGkMuvy/2zq+y+1Bry6ksCoFQ5U9K15?=
 =?us-ascii?Q?sHbW5by+HjHWq62iSAJH6DV3ADkPYQZuRic18DcCXiyfMI80Dd4BIAiOzq0m?=
 =?us-ascii?Q?5/vlHbCRycCwoj+TOihWrvjfjvPhZKMiBikYYws0bTq75gdNsztdRI3S9tCM?=
 =?us-ascii?Q?W/hTgBgWixXG10OHgrUTdPMVzlCwsAfzehAOnNUWOwc8chvbskwPVxsD0kYO?=
 =?us-ascii?Q?g3xlb105nv22HhUyKR98zbdSRd7VrpIQPu8BXNJeGJyHvSqTDIMuU5eqJYcR?=
 =?us-ascii?Q?OF5krbH5PBipbYAMEXAku6c5rats++LZslKAq0fTHIPGSh+BebNy8BWy80Ty?=
 =?us-ascii?Q?IyD3tXMRLZUeopdSpFcSgvW4DlWXBeT9vHeBooCIdFgBggNrC5dKqwg9gHm3?=
 =?us-ascii?Q?x3VP1LUg3K/6aC/QTdxDDDOl4pEyoBRzSHOznfP2Duq/UGhLS/5IzG5ZmRwu?=
 =?us-ascii?Q?t33rHfafrY8yEYJ3+QZfyGCuMad1YdY2l2EXYB4j/VP6G5THpCQiJM2mPjYH?=
 =?us-ascii?Q?faVlQoyEuy48IRmH9k7Up43O1cXh+6y7l0OmYrmLsJqYnRUpohC+/pGUCGRR?=
 =?us-ascii?Q?qul693mqpeZpNLKSD+81qoohoDGvhlsc//u7ikwOE50OC+KEaOfYKgMpPxPp?=
 =?us-ascii?Q?dYAy2N2e8ATrhWd1lvY0NJrSb5iFUA+AcGClk6cSqSGZ0OvliYUBmwJ5b/PM?=
 =?us-ascii?Q?LYz2BLuT5fPiC8xK51qu8iNdOcZQQ0LDZ8P7MnCp6iiPuaQex5yCRh9aL7J7?=
 =?us-ascii?Q?jEKSdlWO2CgiYd5tyaLzCGbyJdvdKQpLfNtbF4a8tiR03XygMO8JMmsH5r/h?=
 =?us-ascii?Q?Ep6vlqJUInIpzC5fKU3MEFgwR6A/WQNjyAb4xZraBeSubjFRGuiAcdZb5R9+?=
 =?us-ascii?Q?BMimcKaX8MAA9Vl0RvuyF7dFn7zMcPneS3/F/rDGiMyfYVIxT0s12v3dYAOT?=
 =?us-ascii?Q?1EDEIj1b4140LA0TF6NNFvjZI2TL/xwWyCl5JvC9ipmBzpz29t41NFFB/2e+?=
 =?us-ascii?Q?vKPiPu9fMgBS63pmaRpeEyEUYn6YQr2O8NuLF8QpreVm9dAfspQoRlm2M/ZD?=
 =?us-ascii?Q?b3I+2QvyC3cx+f8pkjL0JPjg66WHYqz+CV0ncrk9qpT43IvU4uWu6DPvU4sU?=
 =?us-ascii?Q?86k5R97Ta8cQx/607Q62FG5BLsbb+4kGWo1uxKcwGVoa3UyZ1nrcMzdH5qOM?=
 =?us-ascii?Q?qUVZvppU2He//4Se1mZZozxXH02lymSzVmNKFK4X2hgQPcYxg7cxyHAJx7pY?=
 =?us-ascii?Q?8WNsqjeuhL5vM/jGDINpQi+BC7aPMR4WDHyzqsJo++lTM44hWDc7jDMHczDQ?=
 =?us-ascii?Q?MV187XFN3jGy4kNUTF3N1SEXIqI3yJHO4pJPfY0Q7wGbMJotpWSB5vqHvKp1?=
 =?us-ascii?Q?QWORtC669STrOXovD0tuWxb0FqTOwbwGc6Twqsucp2ZzUMgVfdJ+2MhbGdCT?=
 =?us-ascii?Q?UCinScTUBv58gj5iy8527Nvi9v1SltzPilVwlv8VmDkSo35tO/XIe5SFZV2r?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yvk0My/Q04n9tKcQof6fjKYgG2phmUybWWulX1Wqaf7RcrCshf/+xAhKEP2JUU4VIO7FJSsBz93pqBoP7sXGEIFUEIMxXz4xr8sVXQPJWEA9GDLA8dT9nZghMS8zBeLQBmGCIfjiQdoJQJkDxIU8WdcSLE4rHMX1P2K8I8dLfgjWr0OTw+TKZ5yCAJ903ktDZFFSltxi8t7p6f3SSQmbVnW6OzKOnicPJNOejrMyEav5HzG9F/ViYi/AmoPYGQvgfdjs/m3CWMvlSiIWzpq6i+U7G+WqdimEngRqTK7OjkLxkNUMs4jxpUtW4IBE0XDUYi7YKdJOkmJlxFr4JgzeI85FtxuadSGW/kBhTatd2MAwbdGxjycllzLizNgh93lGYzaUXHU6FHCCqqz6z1zKcyamHX3ZMR6yO3jTcYDdZvCob5LqP2vbB6WDLGegJjmiFIZBIosW18Si27CI+CSWFHnh1lf8OJ3FkdSQ+sGVDYzDdN+gGFOe5PGUPos4JnsjWWlygJBaJzjz6/QACqn/5LfMPLJK7SIBOg9yFHpq5sUTVgWNzFZD/z0/QIR9CYAaz1a2a4CdCqUEkt3ESmwC4Zhmso9Zi289amY+VBkvtSg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab1708d-bb9e-4aa9-1795-08de0b30d4f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 14:49:09.4101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4MbwB8Q4G7s7WLI9Z0t2CQlqX4qobxlpsiezN5sYHgNgff9K8hW+FCTBnhbk55KPwJ0nw+UcvuZq+GOogAooCCfPxgDxEJK8FATwFkgnMkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4326
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510140111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfXx4SA9j691EOw
 h8RxIR90dmEXE129J9CBgtABPYzVsbOVP7SC49g1an6/sF2dry9yZnzC4kBl8XzaUHb4nkkHplP
 K06BGIe+nPk5g6m//MCjIUJ+PDviCXZ+IVz0AmOw31MyzO07CqwVkn/pBmHGrFY7zcVU1p44ob4
 Dsa3s+wgaDv4CPUBzzVlXI/gVAzh7JTzUj9aFO/qkI1p2QyhwSNP3nAtX2qCxKLycZYEPEC0ScN
 1J0H/Hpjqf1Y9y7b6HiVmQiKadsl0mEYjb0Nfi3l+i5qCr1HlhD5xdQchggWfehj/cjkZXLELS4
 oq1eADZAJwAjdpwS1Bq9RkJVe6niBhKUQZJ8MamlV3XEv7i82Y7A4n5zFmmGBFi392Ip7RmfeXM
 auFbXkK3ORpDDrIcD5Wss3kmVxyQ1A==
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68ee62e9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=XsKhEmAtKFYngn54E4QA:9 a=CjuIK1q_8ugA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: atHhCjo18SSWPUEw3_WA8dMdDnHT636F
X-Proofpoint-GUID: atHhCjo18SSWPUEw3_WA8dMdDnHT636F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B155A140009
X-Stat-Signature: hy5838614q8u8cfygxz46hrzyd3jnerr
X-HE-Tag: 1760453369-706862
X-HE-Meta: U2FsdGVkX1/6BNsCdygqlvV+R9+xoUOackP9w8GZmhJo3ioW47aHJ3/f95d5GIyUEw/LEYttYz8sAiaPVVAUbUXYC3oraYBTpjnV7XpHWaigYqz9mVI5GAwQqSwtztfpXDGFTrtkVjl37/d+RfgaZ2duGsn0tKLiF5ley2DvpODqBHCDgeXn2PKEkbdnKXvDEd9aidhaQk6hzUOSioeOOoy5fey7p+9BNybStBdroDwmmEEmw0itfKW1DTNjo3rqH5Cdw3Jl0lxrkhdCwr6tLNjcj/ulIVInrMkeYphcQgZAqFJVUHAYvOc+7pHwE1spB/WtxImPRscJ7USCrtcEMGh/bYbUu5C41ywtHqsapfNQW9kV/AX+qOcTrH0620K54lqS3cW5+ayocKlfzUAiDPwHeGKCXaSVT+1GiFJDd26EMHaZJj89LnK2AcomorT20khblVC8SgLM/GASO8Rnwqucjfh7MTl5RGDP0gmQj63MXApOgibDZy3C/217D4/hXF7Pzl7RzUG2f2vjGQGSJWwIHAO7GSxH1Z46lZlTyhbOCPKVhUU0wNvHHGr+M2tZYpbslYTT9OeFC7BkwjPPEukhRyA9rri+xO0qXBaMkIJ+L39EWGSwwXFRjOSQO5sDcshfBiNJOZtLqvoZW9FjhbhrhVCVvdylFAoQHTrUFm5ihEzShhl4QQSignPr3mipFMFwlmhW9nh3FkM2crqQ8vghJdmHbQvgAWK9eKOH7B5CbIM6kezAcEyhP7LFKUy28Cda3Nk31idQIZbq+HutCJjGqMQ50XGjB0qkv12Xob2pT6NjKz3zUiCuRNuyNKmo41YcC7SyZABjy6Yi/0L39BMK1h52IvBTIE2BXVilFPWIQXF9Gzbe8T3yNIfKplfve99TslevudExDI9DVYMi4hz5b/1BJW4nYGgrCmoen+oQ5COEGlcsSx91/pEaAQau0z8hWGXX1wr78WV8FHr
 LS3lhO77
 XRdODU2zRiAy9mdygvUSeiSooBgpDCzic++VhE0YXjtNNIxWh2o+A5KKCh14sBIpDUjH3Cb6AFIrcJQjrBqlQMXvWzsXUuusrCbtVv4O0Yh2nZ30A0pzbSGi+2lTXvvTLL3VzyAZU7ott5WajNt6FMSzTu9R06NklLSAQHvS3XlNLw1PESgyeIzBq/L4NAwWsAfMEfSvZ9vD5O9+YUewFT98OeVoEbniRQXpyaABrduNhQhXjXAmSBiXA3eQnDKmMC9GKGCQfKKgwDAPLNLuPXTm3wgtxg1qA5oYgeTygW5veCynVh1BBPcgCZOP011Uu630fnG2KbWyDTM1SyR9jTR3AhkOPLl3feFtUxho/FCE6TcaKcJpdjRCe8pY9qTDAkeHKknYleJ/jfqbdNcB6jl39WRS6b6+0VuexnNMdyPCAR5FXBbLyGqbf/9/YCSKR+wkn0MC1sqiIrBqOJTt/uH7/S8e6pPtBVvijSLNQHFAm+aF7krwronrNThibibaqcKGldCpDpMWibvUcKm+GnvHXf8VdrC+3JNrSkjPj+fykW7XEjiRTfgNpJZsliAwTF/hBqLIwe+PI3J4BvUiw6+RFqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 04:38:05PM +0200, David Hildenbrand wrote:
>
> >
> > 		/* Skip spurious TLB flush for retried page fault */
> > 		if (vmf->flags & FAULT_FLAG_TRIED)
> > 			goto unlock;
> > 		/*
> > 		 * This is needed only for protection faults but the arch code
> > 		 * is not yet telling us if this is a protection fault or not.
> > 		 * This still avoids useless tlb flushes for .text page faults
> > 		 * with threads.
> > 		 */
> > 		if (vmf->flags & FAULT_FLAG_WRITE)
> > 			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
> > 						     vmf->pte);
> >
> >
> > So I don't see why it's so egregious to have the equivalent here, or actually
> > ideally to abstract the code entirely.
>
> Let's definitely not duplicate such comments whereby one instance will end
> up bitrotting.

We're duplicating the code in two places, how would that bitrot happen exactly?

I mean as I also say, probably better to just de-duplicate in general.

It's one thing referring to a comment _above_ another function, it's quite
another to refer to comments buried in a branch buried inside another function
and to hand wave about it.

And _those_ comments might very well be moved when the function is sensibly
refactored (as it needs to be tbh).

So yeah, in general I'd agree _if_ you were doing something
similar-but-not-the-same AND referencing a clearly identifiable comment
(e.g. above the function).

But this isn't that at all.

Anyway TL;DR is that we should just de-dupe the code.

>
> When talking about spurious faults I assume the educated reader will usually
> find the right comments -- like you easily did :P

Yeah but I'm familiar with the (kinda hideous) code there, it wasn't so much
'easily' found and for somebody else they'd maybe get confused as to what on
earth that's referring to.

>
> However I agree that ...
>
> >
> > In commit b22cc9a9c7ff ("mm/rmap: convert "enum rmap_level" to "enum
> > pgtable_level"") David introduced:
> >
> > 	enum pgtable_level {
> > 		PGTABLE_LEVEL_PTE = 0,
> > 		PGTABLE_LEVEL_PMD,
> > 		PGTABLE_LEVEL_PUD,
> > 		PGTABLE_LEVEL_P4D,
> > 		PGTABLE_LEVEL_PGD,
> > 	};
> >
> > Which allows for sensible abstraction.
>
> ... if there is an easier way to just unify the code and have the comments
> at a central place, even better.

Yup we're agreed on that :)

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo


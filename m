Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666A9CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE27F8E0146; Thu, 18 Sep 2025 15:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB94D8E00F6; Thu, 18 Sep 2025 15:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AD48E0146; Thu, 18 Sep 2025 15:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9AF8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:44:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AD3DC0431
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:44:07 +0000 (UTC)
X-FDA: 83903396934.02.07DE343
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id AF0E2120007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:44:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DaoFuKrI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iahzhy3C;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758224643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbdijMagfd8Z+5ql8pbPvWeQthdyTMM0b0skO+KviTc=;
	b=HzIy12xqjLoqmc2OufAUi6ohtgZeXz6epJqdTv2IQeRHzKcqGaqinwhWiYfR31aUGQWBg8
	uHNUT/z+zGEVjA8uN53R8g1mI/bnSdguYlkOm8B3gEnA+L3GlNlm6nzKz1WcwfzECF1yb4
	obuF5h1NLkEUotg5XJSxg1Jqe26yBqs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758224643; a=rsa-sha256;
	cv=pass;
	b=Riub0Tnnesl4Bwh0D4/h+RxOy8+FZDkvR0NcRMFIzXOypQ/KxWwb7RofUli29tCJwBgbhB
	z3ec7XEnTZ4r1xvyRWi2E8DY6tet6ARLmEo8WCYXqaYHaZkgo5sd0vqeVKQ0cZoM0XgLY3
	AVQ+X40vBVuEPd57QgebPQJjuzLxHjU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DaoFuKrI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iahzhy3C;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58IGE109027262;
	Thu, 18 Sep 2025 19:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GbdijMagfd8Z+5ql8p
	bPvWeQthdyTMM0b0skO+KviTc=; b=DaoFuKrI3ISFi4V6b67h1mdMAfZFhdQY8z
	iGAe4IpZaHsMHg/sPmUaB0mBrhkjsADT0vSoz7yVuB5t/lt3rysZBqzQL/rSpB8g
	B8w86EqDRPfcBpKAvH0/Fef/gE89SS942HYLSFAzK8fPAA8PrBAMR77hreS/W3TJ
	Bu7LPJs5Ox9eYYaFUcJxvDX6MIyxoMXEnkPIq4pzyKQQ9O08Mq6J6QONz1Bx+tDQ
	4gEk1mlunYJPQ0N7sKNTTqc/KpspbBajFVyFYeuba9VGczTylrV7qD01PY/XWb2M
	e2R1tN2BdS4QnO+14bXFKOQHlyyWP2vEO1WMh2T9H8jwwpf5Ksdg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxd47qr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 19:43:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IImZ4U033703;
	Thu, 18 Sep 2025 19:43:50 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2fjush-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 19:43:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3ct/EMYGwaOnSyoOEwthDt9hAtjYt73YcYzTv4tRWBv3to5jO/4Be4UUNoSlgH/K9Z0aqlWu6oKi3n3a5p+SuZH8CZTssynGrP20FabSVxYODScPwftiigupKMvam0Lc/+yzami02cOGtThUmM6uS0w6ZtOS59nGNsnCXVAI0H6Ox7CvHgI6h+tRrLpC96nfd2Py8Zp+Aoi1mwyzjNdEW6dm9C2CWrs+5CLIXVI+UcSuqy7SSx3nlX+Fmk4TUgkC61yZEmXPiiwSWHLMJWxwL27DDdGYwGZw96lteYXobb1WlBX28inffW4jc7RrpfFzdpLuWyx2BaoBruzho7H9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbdijMagfd8Z+5ql8pbPvWeQthdyTMM0b0skO+KviTc=;
 b=Vdmmi7Ygo2c7T+P2apntuLlYIGchh1Xbbj7tBZizaR4/fR08iV7Gr5AshAV0EjL1GmTTJ1ixvnZyJ/OkiKIZ3wJxByFVxI8e+KO6ZvNMczRwNhKRiSvHZg4wFns9fvZgovHvA/FsWXb/pldM0RdvVSM29CKEKqoia0TAU+MU4EqnCYEGDbGqVemzrlzdLdgp8rujThHYnumAWsn63qsUE/ZS21ydtKHnEF7cEIVfnrjLwijjhCkzRp8ouMf5TUpbQvZwky0c3n3wREppHVFrXAWERGE84FBPLsVHnPh+ibrGrEzspxv7I4Mk7wlH67UPhZTJR6zfLY00tfOAtUv9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbdijMagfd8Z+5ql8pbPvWeQthdyTMM0b0skO+KviTc=;
 b=iahzhy3Ce8511O3Dbu+SvU1sUGfyP6uOUxcLXcOZ0VuasUTr3441+MwUqwEhHJCMTWMKnNDoYB8EkmUTm01guOMfTkKhwTWEpMwpnL2n/qgjbUwu6DVGIq48S/8a0ffr3xIJ3tca56Ri7PZlbqGrUEw2y7k/WNZ1IfUL9iIrFS4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4571.namprd10.prod.outlook.com (2603:10b6:806:11d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 19:43:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 19:43:46 +0000
Date: Thu, 18 Sep 2025 15:43:34 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Nikita Kalyazin <kalyazin@amazon.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <cigo2r2x22bk7wzr6qvazcdkmt5kfqhbgb7nslpuff7djufucg@f6xucfuntz3q>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>
References: <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
 <aMxNgyVRuiFq2Sms@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMxNgyVRuiFq2Sms@x1.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW3PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:303:2b::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4571:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da0849f-43f6-4742-c727-08ddf6ebaec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eu3keoo6Z/HRaUVpFRacLP1IzJso37gSE22mskktWK6vH20op83ZC/gr7NRO?=
 =?us-ascii?Q?PQqIf81XUWFFrvERQmXKfUp4pTXW8RxqhH5I/7Qx7weOESNVpHdBnuzDrQix?=
 =?us-ascii?Q?1RMQurCbCHp0lRwnGgXz6sD0pk3rTSP/V/LtXRf6d779T1+HTqzWnrfX2TaR?=
 =?us-ascii?Q?xP3n2Tl7h3UpBlUd6kbt81Wl+38z6Ey3TToGARUCsNFmwUsSdZfDvPleTz6B?=
 =?us-ascii?Q?7DW3yniBJADtCuNgxR2OKv6NO4gKrckl6eUWM3m8iC5o/cgtSad0sWFM2GCM?=
 =?us-ascii?Q?wGYaK68FuwCT6A5c9gblcBs8bj9Bbu0iX9KmP33L9J54RlAnrE5TN991kVrn?=
 =?us-ascii?Q?AiQIkq7rYPpUdsKUc+k9PDcyTZUYZMjnN9fF6RTgJa3FdncoHlkrlJj4tNcX?=
 =?us-ascii?Q?pxPNRI4HKiUiYrKV+a94yrOIrXnPwmXOC59nVizD7BGcVdysIv2k8Zkk+wXb?=
 =?us-ascii?Q?I87s1kjjKMDE/A1wb2FuasaqHco3l/AsPGc7tuQwDCsfeUaScxY63/yNREJv?=
 =?us-ascii?Q?43XzrPNaEYaWHzuXKhALqcmmulYCWquoNA1BpjeO3Jg7EonDovpGDu6AM+Bq?=
 =?us-ascii?Q?auzN/gzSRWa4zYqQ4TeT2WlYb/2pI2kFxLwRzN17KG0PDOHpnjBBs90S8t6q?=
 =?us-ascii?Q?gWwil6QOARy0wT0CCRMa6hkDbGJSBcq+NxQCISPeZ0BkvR+8/dEfDgxnZF5R?=
 =?us-ascii?Q?Ii80XoxcAU743keXm4hqHhQ5ZrNfE16HubecUPksFYzQjdmcnXiu+aqtK15f?=
 =?us-ascii?Q?LLi3OnQY1ZQ7C4ZeVIpV8i4AxPrZtSq/898QJHTWaToVnkgz4UyhmN6Qjmss?=
 =?us-ascii?Q?o2IRrWhIN+rF8SEA3qNE0S49PP9TNX689+BXMY4Dea8ob7so3D8wX3fBLseF?=
 =?us-ascii?Q?AB8D6MdFueAP7ZuwVcsqEr4IZ+919oIqqqEdAn/TQDxdGCVcjqcBaBIvra6k?=
 =?us-ascii?Q?zpnHaUkJPuirrhf7gFLmD+QHwsxajTg40iUCUXc5aILI8Ry19ZA5B2KqjNpY?=
 =?us-ascii?Q?ik7Gq5xi6m9usDRA5Fs7VG0kq7PmGN/7kKT/0/Ne5GDR3R43x/Nj9+DtMR0q?=
 =?us-ascii?Q?FRlDEEMfkuvQAeFFzf3lXXLgRfxT2C+35D3uaLZHDdFtu2EKyJQUxLI0sYyH?=
 =?us-ascii?Q?rjuePquFp4uGjR4HvBf8ZSzWatfkMapiLroc8rdE/MpDR9zeyE48rXRg0FiK?=
 =?us-ascii?Q?P3hbtLK8pd4OX5w29i0zU9y6p/LcxHyHxFu0h1HAzhVFA2NtgcBA9TeUFMf2?=
 =?us-ascii?Q?qPsoa4BMTpZ/8IC5djCfUyX9XfyVMKbkryBnQ4BR9xyh0SpXtBC2nsgan9at?=
 =?us-ascii?Q?GNyLWZSPxTfIGiuJ6Rkghd4h8EbS/ZMTFtnSEYefKmmt8gqSOIupfvsctcd7?=
 =?us-ascii?Q?Rfs1ofUtks+aXXZ3cnQTZDjSQ+zL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GxD9DgPxjRiPfZQrY58Ou8SnoBYgUdLsm8L6yu3q5nzh+urE1XYYSCtqjhug?=
 =?us-ascii?Q?GFIfWKH1APtdA1zYKB3mGvzCPtgsXowOaT+XS9Z0HHIxfh+qoAHwjd4685Ol?=
 =?us-ascii?Q?cgQ2OU/SeGIfAImTv/x0pfiWaeyUCwPSm0Jutxh4dN2co3Hg+Rf8+wXiTebx?=
 =?us-ascii?Q?McC5EBiziBfFiwq+Zg2pFNKG6MYZD7j4m1q3O8lsGrypJdHVTqni5RHhSVkE?=
 =?us-ascii?Q?oMGLq4IzFOxzcr7epqZajhf4Fpvtj3xDEq6QIxGLetVQ3agcASV6Q/iogk/7?=
 =?us-ascii?Q?Xr0ezsD4gg3R/kcW7fpu5wJgC4Z3kqifqZG6NdKgx/E4iYu6yUlZnAPc6W4U?=
 =?us-ascii?Q?WhX3aJ1BZ+IK3qQOXU6972fDYdSayQzCkQDRM9Lr5Wqb60HAL/zOZpaAXQu2?=
 =?us-ascii?Q?2nFLkEePciu3a/cxu5l4qMRRNkiqi4ua9KS9hL9bzANtVg/mUfYlaVe3RpOs?=
 =?us-ascii?Q?e0mzHG+c+U57k4OlhkGzNdfnI4VEhQr2qMBjqQs0j0W2nLFFZvhFO9CRtcMm?=
 =?us-ascii?Q?q9tLmhJBGANsu6aJRz1b/NBsEFtUQvspqABIi0r+5ONNbJrh23c3P5OW4tnB?=
 =?us-ascii?Q?20p3poGM7wBrVcXZFiuaTLmwr5HWt7JaJD4Te/NQzeFcYBXMkSpNdBcMVmA8?=
 =?us-ascii?Q?p692qqN5VXfXND1bsWIG0UgPMSB1WPsEbHzp4GU6FxA9MwT70Hqkg1EZUZct?=
 =?us-ascii?Q?ID2v2fuksVudMTqZOYz3n/m0UY9nkZB5ll4PXkGqL3wDoy/4a5UfjLEq4tFt?=
 =?us-ascii?Q?TPhm2bqxl5Z0MgV/clKB6tJ2jaMBVBNXL+GzvsTaXGhaQApXShaTJePxl2e3?=
 =?us-ascii?Q?kC77794kHXNVgl38F+r+3NRiN7rrsdArAX+JqpeAOOK6NPGYhEbJ7RcjKytB?=
 =?us-ascii?Q?kzdMqDWp7vEtHjR3I7rNXpdK4bBSiaS4sFwWCpQMCxpn9QxSF3Bsxy+u5+jH?=
 =?us-ascii?Q?rD9X+aE3Ve8J+35bqOAOziG9m2fRfJAeCB7WY9rwGuzkt2jQKrx4rc3mL5LP?=
 =?us-ascii?Q?OvA06bF2B+BaMlp90yl6gVUv/wCAuyjm8EjB8MM464dqg5ywLsYPP6R3zNsJ?=
 =?us-ascii?Q?QNROizwREO6kDw8qgIWYdfZzQ/M9tYPs8WLIxUD7uuKj8HWmr3Ykx6TGwdyz?=
 =?us-ascii?Q?fPcF+W7+vUIQ4tzdwtTkzfbJ6oyJNlhXDo8JT26bbgKX/V5f8SMT8qKnBC+j?=
 =?us-ascii?Q?njeuSR1eaWVwQ3j+vzBRtoNUr4cDwJouBHix2MOLtlhdyHrWFHxwY0EEr/XS?=
 =?us-ascii?Q?CC7J5hMoKE5Hb7Q3rNWUwNU64VpPBsWJu3QmBofpfQCi7x2VXYgqEKrck5sH?=
 =?us-ascii?Q?bn7IAaxs5N+NAFdJZAov58+TeRfNZovUvLQYbVi5c0ACaei+CcY3YCIr8+/y?=
 =?us-ascii?Q?FYJ2RgQ9BEYfwP9WzJIQQ7YWqBqafbtyY2gRJ0JgeDR59og87uLRlU2ifCsp?=
 =?us-ascii?Q?5a6lSKo2lrnYI851mwm0iCasZar8dXCq/8AfSlFtA88//rjTgfbL0HTCehcH?=
 =?us-ascii?Q?e3SQlVeOCz1hLmelIef4wGC10ymby50YhtN+RghZbxyWh6fpBGV47QE/P2XZ?=
 =?us-ascii?Q?DUps+eRDoPdo2O/Mc0vz8Q9MA36ARZ8Ioy7VoW/r?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6ig57Eax97L8/XeIYN5/cHpnK0EFmz+R28joB4gGZtnFTjzsy+/2rfnztHk2jzJpUBkfC9g/J9Pul8ogyvaJgCg7CfvLb6Dme6BhjgbIPfAHEFDnal5S58O4OQkfRuRNPlvD44PAapNkWcg1LuaD8h6zTrjTcNzvF0vowG46sJ5Kuav64pIphk8czDK5iVUlIsGq8U0XXtEZhcRPVm55hkDvGv558KMJGusPMctiWDlx77asHy+e8uy83+dYvcOWQbIivP2qYkHTxSk/G2AB1ZD2AKqqJSe+Ev0/gZWfRmA3gCjdIC7VKL98PXn01VkCLwUZzCDGvgiLh+eI93C79qYGCT/nbDkpW3gRa70Yci3CCaBaWIuSRdKYjNzGtuFWlqIhAQHpk/92Jsj3kFhZPakaP0tdKD9sM5TtqLSx2sZnziI82zR3KR1U+9F/AqglkLPrR8Q233MVmZxACSeX3VfsgN/eTLesl7PExNKNe6BRmb/d2SccJjW1fV+WGu0YgmJu+7Q2P4h2cCXQoV7e94Cp6UZSJVCGUAihlpIdp4n2TUL4ygXyfhkXe4qKG2ETHOhbo7T4+cqoqCF5ks/W34lAD+F0mzZPBJHECdBwq+8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da0849f-43f6-4742-c727-08ddf6ebaec1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 19:43:46.8310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X86qNFfZFy1gbUI5k5f60oYeOtO3/yehvcOOjSeZr6XTn5lYpoMWCDmHWYacjYmGAn22P43pbA/C94GflFcypg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_02,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180176
X-Proofpoint-GUID: EKuhsKeWx8BbexBmYhXHKBTKnSoVFYyX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXz+KjaGJ+5M2/
 nFVeYGE8gp1WiUig3yKTS8qeUrln+1iFLZrV2GhjxPi4AQYDPxUI0gY3c7SIqO1bRdJK5CBxbsP
 Ojw05OAngGsY6OLYVVoswWkXuT9TAJTqTSIZv1xCagZwM4U/LPBfVvc9ZTP9Ra2CR6NvcZj/Pjk
 r40VlsvmsDgvTORlKtTKEscD76BJrKdPm8050Pj6lcimQ446kjIa0rmN7gB/E0+n1JU+iVKxODj
 14QNNciLNPb7ZeY51dY1rucpzT/eNyGdIrsv4xNGeu2G4QZJJjwQyc9967pskhQnwfeIsE94aoH
 OsLV004+Cu3sx+NCx/2GwwIOkRMQz+iu9yLVqX29d6uCA5Jrl2n4nRUBhMafnwJAJJet0ukS9U2
 tOPA/LsX
X-Authority-Analysis: v=2.4 cv=cerSrmDM c=1 sm=1 tr=0 ts=68cc60fd b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=P-IC7800AAAA:8
 a=20KFwNOVAAAA:8 a=yb4417N6jwVSY2xLmeUA:9 a=CjuIK1q_8ugA:10
 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-ORIG-GUID: EKuhsKeWx8BbexBmYhXHKBTKnSoVFYyX
X-Stat-Signature: 7p8w6ic4eqe9xhbrwgm5gaba8kk5dsgz
X-Rspam-User: 
X-Rspamd-Queue-Id: AF0E2120007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758224643-311991
X-HE-Meta: U2FsdGVkX18iTqYO4dCQ6pWrNZvQvtjb4VH8eTKG62MFmvokByicPXMBhy9k+4Jk/LRzfwZfOMG2b+fpcdW+C5KUv5LB1BSGM1k020EneHfJ8h2x8QugLmgBoAj7UMTHjHYeJDaQAjxq6OQpklXjiOjeFcOrSrrLP6pJvq6YgAp1JHlmB6clAmo2VJdn8CnQ1ARg8OUEkelIHod4Dqcib8qbYjquRMFttxIEdP236MvsaJXHRe+sYsTV8zk6E0u0BBxTjnK2oT8/XW0jRHRSH7qEskGKj/1CwFGvlgNlv3PgZhwmCGDHZPgrBoTq3nuf+LxE1nc7DJJpyT59DD7mTtk5/K4xw11Ap+VgYCug0mo3xOsZ+9U9zNVUyjJAoNHyF93FzzS215pxDJas6l3Gx0Bf6is5pg9otqm8CGA7F8GiQawNMzyu8YHmUo4NKAq34Xfe9Y0zd0Vv/g34TNOQU9skl5hE+swE7009Dav0YctYYsQV/ujR9XE+T9JdC8CXhaopFj9apIQDha2A7aYeIBtBU/X3MLIAz55xBoGaOo5SWYuYOm7e80eQryfxDToAzy9CSUKVRbqFPvtG/hzhJlkyLJLs8Niqqszc05BzsrGH19EX2AqhVntBcFo9VI6PJIHzyhLpWb8HNIDlZES5e0HJ1MP6xDyaXoLzadNb78d17YtdkkVDDAZ2AVYzC4gHZDtLniTq6Ey3pBApVOTo6fGHfrZaBDg7fwKnEstu2lHuKgGYTCf28ys+4QNMwKU8zuM+f6Qdirr5YT28j3t2W8LH73+YyA3WtIoHZnfeCSx6dvMT9VUzh2ARLwkKI1MY25fwsASir49BhtlrPNuc+LWt9XUEvOD3oW6nNsauStQDcSGMjK7sOz/AWVC5i/t5NnAS7p2lUPol8WHAoZI0E6J9cF3HBJ7xZHPTY59QzWNP97iGv6r70zyodNC8pEnAEpJyetTnDrBUufZStOo
 NuTDXvBE
 bOMYE/aX7KRhigYrLflLGanK1qpGr2kFEISvM2oRg4nKSikZN3EWerHZQnkgmDFA8+psOt+AFIDv/7MdJCvGy1CLGPSimucdOV7r2rnCnvX6KbOEtHmN2OgLHbbJC1kzDyevXkyiz7/KV6e6l0gXhaoKDCUbn7dTREIuyyvrUQJSCA989YskT1H/raqJGmhU6cYHi03aMNozNgrY9B1hcGk+BV3VdlgGXSxwe9YDOuxL2krmhoRqXcq/hRjG4cKCrmTP+EOVJdKhHEOISBnSh2gVqCKCAowUdDprzzBkaE5vLzcakUwyTZE4399MoKfRYVSpvROppuWd9Hlb2Uk0OS9ZL2GQ+qSWy1XBZkaJW/VWQ5GptKLUPNX5zn1QzwI0AoM5XO2qxbEDNFVtcOTZt5Nv817Dnps4znnfvEbzKBv/01Tf332KnIO08nyMK/RD8cUnDfKN8jtxfOOue2LgkHdlPDtifjBFw4tPE/DNN3YEJa93D7AJYglUWem5pt8cSvl4jvKRLMFc0C/96DGlHQBCFj+SHBObSITcFz6bhmjkwDrWwz6jNypes8R29GXYy0EIwA4un/X7f/KksDfueo6a0sbwLncQiBoj/gwRVisUPGR8BxV4kcFmu1MEHBNKU8AMl5PFhmogHPkItivepFs0UeIbmpA0MU8vL7aBoWN6xIn7a+J1+99qKskr/saR3hZNaREXdY301FbxwBG66ZhDOyU7DaTMpXJnl1xvA93FqLzg0/j3rQkc0rUcQJFEtNzhHo0i5JrQW/hT/WqQdTtIUIvPR1qUSokUEK5AmZB2pkzQxfJNp5yymWjLDFVmlhl4chXMF6YnCNQy+jkGJsgvL2fkkXh0VwLCbhdrDNocM/T6jnKSKrXpW9MfVtmqHMICfCTZeeRllh0XlShy6BCGy1n804BIGaxQmlFBsDDRbErGD6Fxij2mN6BcZOLgkleZh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [250918 14:21]:
> On Thu, Sep 18, 2025 at 07:53:46PM +0200, David Hildenbrand wrote:
> > Re Nikita: If we could just reuse fault() for userfaultfd purposes, that
> > might actually be pretty nice.
> 
> I commented on that.
> 
> https://lore.kernel.org/all/aEiwHjl4tsUt98sh@x1.local/
> 
> That'll need to leak FAULT_FLAG_USERFAULT_CONTINUE which isn't necessary,
> make it extremely hard to know when to set the flag, and comlicates the
> fault path which isn't necessary.
> 
> I think Mike's comment was spot on, that the new API is literally
> do_fault() for shmem, but only used in userfaultfd context so it's even an
> oneliner.
> 
> I do not maintain mm, so above is only my two cents, so I don't make
> decisions.  Personally I still prefer the current approach of keep the mm
> main fault path clean.

What we are trying to say is you can have a fault path that takes a type
enum that calls into a function that does whatever you want.  It can
even live in mm/userfaultfd.c.  It can then jump off to mm/guest-memfd.c
which can contain super unique copying of memory if that's needed.

That way driver/i_know_better_that_everyone.c or fs/stature.c don't
decide they can register their uffd and do cool stuff that totally won't
tank the system in random strange ways.

Seriously, how many fault handlers are you expecting to have here?

I'd be surprised if a lot of the code in these memory types isn't
shared, but I guess if they are all over the kernel they'll just clone
the code and bugs (like the arch code does, but with less of a reason).

> Besides, this series also cleans up other places all over the places, the
> vm_uffd_ops is a most simplified version of description for a memory type.

6 files changed, 207 insertions(+), 76 deletions(-)

Can you please point me to which patch has clean up?

The mm has uffd code _everywhere_, including mm/userfaultfd.c that jumps
to fs/userfaultfd.c and back.  Every entry has a LIST_HEAD(uf) [1] [2]
[3] in it that is passed through the entire call stack in case it is
needed [4] [5] [6] [7] [8].   It has if statements in core mm functions
in the middle of loops [9].  It complicates error handling and has
tricky locking [10] (full disclosure, I helped with the locking..
totally worth the complication).

This is a seriously complicated feature.

How is a generic callback that splits out into, probably 4?, functions
the deal breaker here?

How is leaking a flag the line that we won't cross?

> So IMHO it's beneficial in other aspects as well.  If uffd_copy() is a
> concern, fine, we drop it.  We don't plan to have more use of UFFDIO_COPY
> outside of the known three memory types after all.

EXACTLY!  There are three memory types and we're going to the most
flexible interface possible, with the most danger.  With guest_memfd
we're up to four functions we'd need.  Why not keep the mm code in the
mm and have four functions to choose from?  If you want 5 we can always
add another.

Regards,
Liam


[1]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/mmap.c#L122
[2]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/vma.c#L3149
[3]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/util.c#L572


[4]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/mmap.c#L338
[5]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/mmap.c#L1063
[6]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/vma.c#L1478
[7]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/vma.c#L1517
[8]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/vma.c#L1563

[9]. https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/vma.c#L1407

[10].  https://elixir.bootlin.com/linux/v6.17-rc6/source/mm/userfaultfd.c#L69




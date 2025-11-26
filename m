Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0BAD10F5F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48ADC6B0029; Wed, 26 Nov 2025 09:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462C06B002A; Wed, 26 Nov 2025 09:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32FBD6B002B; Wed, 26 Nov 2025 09:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 218126B0029
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:52:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A05A3BA5F3
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:52:48 +0000 (UTC)
X-FDA: 84153050016.14.2A35DE4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2D0CD1C0015
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:52:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZUTYXJxp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ge+tqEs8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764168765; a=rsa-sha256;
	cv=pass;
	b=Op+cvaVuyXH0VxWSffdpKjSQHmDgWp9gfxLR3oXbtLYeseVh5wDKpeFf7xoN1lLzfFMn8r
	7RCCh/3usL9mOInlDkYy8cDRXsn/7ybPTGyFHfY4qMdroWzRj1f6JOJzR0bI65p/TjP93G
	NpSkY+wV7upWnvzW/8cbQOOo+W0rREg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZUTYXJxp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ge+tqEs8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764168765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXotIamsdSSiLRRf+yT2yOOeV1Hsklghqi5yVR6CuyE=;
	b=61C5dqJvQIXiligLxYdbS5SZEB0fqULrSC3E+KT/DjdtPaAagP+31edwXE/891r89NoDFT
	waYgSR4CoBrnkuAUTiYhxNtQ5/FSB4r+kJq5mkpCkvdhnYK8ar9f7ZfitW0puEdbpIz68x
	qnk0uV3E1RIlTMLnuFtiniipWKV9TZA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEoZjU2453400;
	Wed, 26 Nov 2025 14:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WXotIamsdSSiLRRf+y
	T2yOOeV1Hsklghqi5yVR6CuyE=; b=ZUTYXJxps5KXZUR2Ser5FEFcT4LTlBr9zL
	BTZ+PPNOdFl5DWPWu4m3tpUWxUTsUsuqFhtIvOHOPVSzhnhjAnt/rExybyAv4t8L
	R+ZKsQ+OouKIPf4NE3Pebwaxo6DNcNTbsFM/5VFH9bsqsEjvJX0vaEBBKKYDKyDJ
	DMBJb9I4fARQkwlF688ZGhsUhewzNPrPRwBT1Ds6mBH/sLEiVI/GLsrSV6xLI4is
	UucDepNnKkSD+C/R5AHJNSbpT0Fe+QRNcIg38HQoE9Lp2n1ekxVBQxtxAO8ZrnSW
	rHnbf70wvGKCV8db60z3LcqIJxlm3NIWXTrNcsTsp1ZbtEC6JF2g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fkme44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 14:52:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQDwBDk023147;
	Wed, 26 Nov 2025 14:52:22 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010015.outbound.protection.outlook.com [52.101.61.15])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mn4wt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 14:52:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZebI8qn5Y5amZh0hsxp+bpzyYx4rvBhUnbIqeAHGfpTQBPvyUtPGe2pr5EqbZK/VGSoPJCjuuYnZdT9hNKiBRdoHZtGTnHOHJhOt/Y3E6WsGsotQKEqOhsFHP+9rzVomLemRP/dcRKQzBLLkoRqYagTPkRbTeNPVIsy9VhH9nM/hFFW2oYRvw/DKiyPqMP9mgARPcgmLwe3jQmWmdXcg2KBQCpSVkv0FtJxJW5/meDXvni1oTNcU/h02VjjfUWyFPhisLc0i1u7lgn/IeREGjgBUEwf472nEPtRnIYKXBebkkk+woTm4OfGDEOdHy5zcWRlMENMa6j4QBk2xuF+Z2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXotIamsdSSiLRRf+yT2yOOeV1Hsklghqi5yVR6CuyE=;
 b=Y5+im7iHJdDpyoGZhD9DvC3bWfbEUDd1o5dnmv+qzP3y4rFxgYYJk0S4l7xCap0vAe3sDBeHWdGpx3nt9aIc4oaqQOfDnVojlX5VUmR3LB2YZfRitc0achTszjqzVqA9k0x6jmFQLLjHNkLeMqmBsOtIYu45Xwzd46QBskYrpACPKbXE2HO+qUJ2cvLUFoZ9uw/uV4J3LWtouzmtVxBX71DD0UUOv3TG6XqEV3qQRkvyKxHGnOz86o7FCz4LUFREQze8yoWvqRRMaFSEsrfBLVEc+6rvKjZ8d6ISOBdYT4qYqyYV3Mo0VctqICLK9YSu0B7bfK97EXom2BETYGO7Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXotIamsdSSiLRRf+yT2yOOeV1Hsklghqi5yVR6CuyE=;
 b=ge+tqEs8LREcrLTZT6x0BpyJc5Z/huYo/12PyNDTSrZ+424xmzTmbCVVmDs5PRmJ7+IEqtf6li5e8JNn+xOoeIlnfIyY+3CvP0HyLM1QN4cUfyZebJ8nVg/aCPCunV5LnW2kLoe3ypBrO38TbaXTaYX8JIgw7TO0vmSuKDOfNnc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7754.namprd10.prod.outlook.com (2603:10b6:806:3a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 14:52:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 14:52:18 +0000
Date: Wed, 26 Nov 2025 14:52:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
        Samuel Holland <samuel.holland@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        linux-riscv@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Message-ID: <ab39d448-aa1c-4c93-8e2b-5d97a9c76af5@lucifer.local>
References: <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
 <20251126134726.yrya5xxayfcde3kl@master>
 <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
 <6b966403-91e0-4f06-86a9-a4f7780b9557@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b966403-91e0-4f06-86a9-a4f7780b9557@kernel.org>
X-ClientProxiedBy: LO4P265CA0058.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d91d78-353a-4ac0-94e9-08de2cfb658c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KnMKw++6we9iqOka2XRst09HCucHDE/Bel5wTIFBbmD1daBHGvGaCdSTER4H?=
 =?us-ascii?Q?f6xxWk+TZk9l+Xaohp/4aZKNGw0UvnkRVNWna6nAxN2kVdwBxVxxsgzj+GOS?=
 =?us-ascii?Q?2nKkuIjVsF9j8zTwukKvAiWNLozTdqhbd2+1WKZMqrJnk/DgMXnwepYSDzbW?=
 =?us-ascii?Q?xlME5CnyeaeAUA57JONHUsZjBItUBQVhcj2AhLpUsd0Kf//xknW/9XkjswfI?=
 =?us-ascii?Q?OLQoi8G7JScDeH+nLpWqHwgR11wHXMLQoEpes2PKTWmRpvcCUWpXn8oa/T+i?=
 =?us-ascii?Q?7HXyjnHH2P1MfXtkf+J+uPV3p1LT5dY1hC9X3xujrvKBklNRztProXBM4ACk?=
 =?us-ascii?Q?IwMxavfDsKByE/wRum/BEWIXQGR6NgQ5fdnidkgx+HLL8YTuPDdlRzhG/HwS?=
 =?us-ascii?Q?cXER0Ct4tWC22qtaF+VMisRfnL3PNi2VJJl/SAV9vz/qB/bMHx7GRGKw6Pm1?=
 =?us-ascii?Q?Pv8LFxJoiSLifkaHGNfHZj1Zq2BfGeWmwmnYvcd48CJTDESUFNCAZZPSEbAM?=
 =?us-ascii?Q?W+fqqqFPpRQftgCaHYIYGucmbqFK1Gjv9fBC42vtqhhXaShCsmhYerDqd5x/?=
 =?us-ascii?Q?eCLd30NjKFeJSpWkKFm+qHa9ZTirOov4kWQQCmURYA73oWTmY2jVdM2LK6N7?=
 =?us-ascii?Q?Lc3iEHtn/yZtt8VhnwWRbFyk4wFhVAow+3RIpiAioiinX0jbM/lCWS5xVooO?=
 =?us-ascii?Q?HrkpRzriun25dguI6eSMztCAO9sOQEyCI54tGmeyjiWThjc6uWaHLTUZHAYM?=
 =?us-ascii?Q?ppuj2e4Zdcqp7TUJFogEun7ok3CXCXbO9IpI2g6QwPMPUzqIxOQeXTOBIerQ?=
 =?us-ascii?Q?muV0mxXo0QKErg0XAg5lDuxwKU5WiLrQ912bFV/O1VcZZzjNXtytIy1/n1wX?=
 =?us-ascii?Q?oEjznx5u0Xvp0Vc4QHFjg+cjdTugd09W+HfTWoCUmGzWI0kVOU6131lkezQq?=
 =?us-ascii?Q?b5mSgLmvgGGUwkwmlANSrBdzOhTX3X4w0kdKzFO5Iafkx5Rmsy3PJMmdIXns?=
 =?us-ascii?Q?JPt/PDSNXzJZuiBW6xBu8EpJdxKG16iw1Y6l64o97S63QlSThd53jbCLW9st?=
 =?us-ascii?Q?I1KBHTo8T8A3croOEUxdRIWpKx0hTtbbmY5AkAOw9+BkJC28ZpoGHA12gLLn?=
 =?us-ascii?Q?G+X7tFgToIvLCYdDeAbTvNvBtJTDLz+HUtSTMXCNOhJILyfLQuMiAJV4Vm/F?=
 =?us-ascii?Q?9KNg318ngV53XaEPbqaxl9re4Vlp2Stv3XRxgwBH0AwUnQA4sQeiHxpLX6SM?=
 =?us-ascii?Q?uwKvKcbTI+QRvZPx97i+sPsCBHQU2as8dUVP8PCRgZAyPZyDQcydtTsOV58a?=
 =?us-ascii?Q?e50b6GBCayUJnHu1TgfMfF8P09MxFnTpPcXPec/rwBGfS4HiJ4QlvqDtYnEL?=
 =?us-ascii?Q?4ff0eV3jEDuOrGyvhFJAKAYtPF7BsI9P+aYbbuRsyBEpx0dPkujj/y/6M3AT?=
 =?us-ascii?Q?A/0p1vovBXZt2f18GJnxis6+uhnpVa4lgIuTL6FDo7B21Z0M1RhV2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vwRpImDHl/7aX/dY+CCzNeBdaU67LyXXUmltxftD8z9y+fA6p+6+b/EVae1j?=
 =?us-ascii?Q?q0i+ujGqGMdIGrILJXKmdqnkHri/SEe8BBLsDJh+byGjKKsMnxzTQ5q2MxCy?=
 =?us-ascii?Q?rYuPLJrAS+v23jrgiC9HUBbkbhqNLLzm8Yl4HDyIe+bDHlbzpyvK2unhXA/U?=
 =?us-ascii?Q?GclBkpfhkWXAcfIGoQJPzQU4W8gcmRFxeP0GMbJPZF4ETz3Yp2we11WCu5r8?=
 =?us-ascii?Q?jf2nOcqDRZ9lOkscauyG4Ps735f5/EsqFiU2hLJNq6SbhMGJYJolyLhjH3SM?=
 =?us-ascii?Q?CjlUfQhbd0Fi48X02/WjOeIL/hlOZh5HY0hddoAzZokFVBW4jOuyfDGZJoCK?=
 =?us-ascii?Q?S3DqS4CTRg88nULSyY30TIvXAG5+qbCe5qK9mx3kzcglnFR8oHFvSCnf6J4B?=
 =?us-ascii?Q?dfwfolDM0QwEVm3GhuEGzcxWmGiIfD6IjGciY6FzTIYQhxtSCznlS7gCMd6k?=
 =?us-ascii?Q?ZGoaNN83iesFZyU2pKuyRxM4XjZZdTNt66j80caUSNpjazf/UiKbg8UtcSW5?=
 =?us-ascii?Q?0DmYPUmG4fQGPTooGCqfUnP2+D6xedDfuIgd0qceJin7JenxHhwZA7vQ/vil?=
 =?us-ascii?Q?74k5ZES02pDvoh7EvCOsvX8TrO0GOKqpjcTtZgBrzCLF6HlDfeJ3iWKJ8KFd?=
 =?us-ascii?Q?nO2bw43Q9AWBMdZwMd/frfa540LrQftIFyukoYcakA290Xh+WAJXlM7kDUd2?=
 =?us-ascii?Q?PnFXWago2/LMX84lJ7UBmsca6UZBQTpxyESs2C7DvXkiLu3FrnwD6n643XZQ?=
 =?us-ascii?Q?nmRTsviWe324XSjY8MnBtZAZVPxJDtSDRfjWWiPwEg5rwjt15Yh6DKGIf7D0?=
 =?us-ascii?Q?iCMMPfOYTwGuyiSa8+eIksRhsJ1NZo9TOY2Whz7IJIAKGAkEQRLFMih/mPMZ?=
 =?us-ascii?Q?ZQyuitdouLyymyHwboXgDphURnSZ9B011rsRjfx9/FL8pJTMXJkbqPSXsQsK?=
 =?us-ascii?Q?XomPbWdPs4orrFxEc5AmN0fn+QF1bv5VTLf2zSRHntP/m7Da6/o/QjwvwT4j?=
 =?us-ascii?Q?MCmGu6wBSGpdEoRqO3lYwLoyX1cYI8aLYewffE+0CF7HBPxBqZqKhsoBvN8a?=
 =?us-ascii?Q?eJDNBZCnwmT/FAcAl8yoSXg1DlfhHEEh7xDX3LcIZA69/8LTu6qVud8xUuhE?=
 =?us-ascii?Q?z4o/XO/roFZPmsFMffV3ZbAYHJZva+bdIomlLjJV2EJo6QgND7TQyXdK9dm9?=
 =?us-ascii?Q?m21GRhpLeAiCwUQy4vviCEnZ+Bl6aTS6CPuYaa8PtahE4HoO8emQzpWdyTQ2?=
 =?us-ascii?Q?GXrCIHVyfo8zFrVBI02aIG9yNp+OMhCuR5nDHhb9/YtMuIdisb1pZeaWFOuO?=
 =?us-ascii?Q?cYw0uzSOVZdLlKyEOdubBoCoPtA1ebUQStf+O7suOk77RzuKuDuOLijK6SJz?=
 =?us-ascii?Q?y+6f4Klnd51Eobjb9DhqMH4zJ2vfDXMhjNEKjyYX3MsbMT1ID9S/kkNqPGW7?=
 =?us-ascii?Q?+iCc0aPRSG/diEydWb1BA2aWieFu7WyxVR2rjzxwp4kl0JmgiCuruuxVuWmy?=
 =?us-ascii?Q?pyb6kg3swvfM9ec+aNJlE0TX/885HlAM1rSRwWOpz9TxUW9Macadwq2u5oF3?=
 =?us-ascii?Q?+ZFRFV9Uc40lwYndtOXP4Cf6eQ79gFkT6kEVmDZk7PQaig8zJ5a4uhg0mgXW?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/LT/rgpUzUcEElR+objSJIa+5teUTQBVzl8ojpMndaA/6gcNPUCdNqjU8Q+5ykuTft2EPwcHWyXOmQfPhp7pqU5FNiRTuxhBGf0JtG0OyG0ff74aMCL1PAkMRb/Pn6Bnp5gJgIrnm8KQAWIBo2bZlxuJoLbBI6sySOOgYCcKNl88A3R8S17SjJy0xWl/EdqZ+5YIzsWWMreSc5IdmNOA3Cv2b2pSn047fE+cCot6f+iXOXyxbSxMwhBNMT1cEuJE+xFAWelIlF+Nb+RYXUucuBR8TgyQRdYVz3yo4i5SxQagsVHN9YDnwWtrq5s5VT6UQJVXddH9KHAhHsGVOMoZslxelMeOi1uE2KnLGQ3SHqLl6vuKC8Cgd2dcNP15Xen+SgTiHta3c4nBxz3EMFpsUSWA9e/8vhPvRwnfJMBNV/jyKyLestErbLOBVBO4tt2tYBdI8DAM+EYQeJD+oAksyHQwyllEDxZH5yk8GAPwXILSCXwuIMU16XHpiOB2LLLS6HwvPob3u7sn7eo7qaijJvvKKmKO/eh1SrTqqWscTNy2OCLNYJliwYxoR5OTpOs9njAtQGTR0AFtlTD6hS2oEO7Qa99RQ4GNmqeG0VD4DHk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d91d78-353a-4ac0-94e9-08de2cfb658c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 14:52:18.6913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNA58QFcMkWTIGNpe8fLIbPC9McGrSyiS5Mi0jWlK8HiZVJB+kf21x9eMuIHsfLrNS0+HerHoAbqayC0BrseKJEwrWKQEdjZxHH73tsNcis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7754
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260121
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=69271427 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=YdfN3bKcdGmksHapDwMA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEyMiBTYWx0ZWRfX6Kc+QUj+v/+/
 a96L2U52/DSDU6+Ptf3AetDbZ4gtPzsKNGEc8jrlnok1fbLjqrin3Eu44bbquZlLmWuQn+Ev/Q2
 Rv9Ew4ylMuIcWfIAJCHU1hqCDWnnPlKZ7DD+rdbv5A/Q8AJZQdu2iisvnbDbJV6l63nb6v0BhmM
 7UpXP3/vYw7ueSSfoFbyyYdk2fDSTNnQTAGIJCaPXS5dykmjJvNipmRJDzhS4znnhRGHOk6A521
 EHyvG+1cHGiwzHXNpo9ZTCX2CDk0qsph+k2yoK8ac0Odw01C2172lfSKn/UhU6R8XHN7VCgvg9A
 0kouhF8Dza24wGGke9SH/vv6uxMerPXbVh4VwtgxhYs/iLaNzFIlGFXSndRzjiWGpyHXYSzYhZo
 GsvAUZET0vQQaQg/grxh96Kv1AMv+iBW74flgUbA+gX487OcBZI=
X-Proofpoint-ORIG-GUID: II1c14rFcdBsrgEug_ROy1exADd9k6Xp
X-Proofpoint-GUID: II1c14rFcdBsrgEug_ROy1exADd9k6Xp
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D0CD1C0015
X-Stat-Signature: kmtzp47ewmkhixwc8rje3rtkp9erzqru
X-Rspam-User: 
X-HE-Tag: 1764168764-297141
X-HE-Meta: U2FsdGVkX19PMNIHcr07rfT76VYJztbJLt+h+i3YDH2W2l2xskvccKf+7Ung1LXx2EejjRMUeDErE86hCgJCvh8wdrNlsd/ZM7dXI49U2kN/urbMTOjiK0YtYWQp1XscDjLgBpVtHi3pdeoI5vsxjjVlsqM027IP+8WQE3eoZlQbTP7qvJTJNx1JT3LQUxejCbRyDQaZ3MrqkUNQhKFUPNa28r0KsOIOLrpz/X0MDXpy4ZULgVJEbC/dk2KKzlKtr51ovBf8IMX5YkTpwHPCwqEIsfJdpQqTbsWM0DGwXwovYDihTy4n+tV2fAAoZ/B1oSoDMP83IMGzAZSUzEAFKL1IkNGVlenMN/dxtsBAYXe0IklI/uxFIaNv2FPfkrcsN29LPmEcmQG9fbamfyyIDeDIbCXoZn/R6DgXzbaezrFG5+1eL3nubyp1YImjUS7/ykXvGV6CAsJnN/9Q4rtIGpl+E/rs0ImiLqWyNLbu+QVQK8+g1dh1jiVpL9r+tUSYNIVneoMqlpEW6kPxSovKsmP05fIqDYzNzDDO7aBD6om4klG+xo09sK2yWnTasFuwevHz2Fgl1uOzg25GltPTY6loLJd4tpDwdtINP1D2lTS4fYLIvXPLvVHFDYUJXCrHYokGEatK0Ug4zRw1J6fhVL09zDIJi502qVrDplnlz8ZhJzr9O5A3QsRnVQYl1smk6MltPy3l4LcGf8AbYQnHPx7ZpkLx8RMb6MFRNWvAcb33RbCIdDlX0fH/sPsKXD3vTSLfvfKMrSwlwYbD1L+0Fs0qKKlgRLUPkT/nzykNHmrdHKqCOcj6etMgJ+45HNH6mlQz0EH6O/3QZynMW3TCCZ6Px2jn9ft5PtbDsu3G6OiDKv+pT/kKjmKIt81nSLTTwWw57qKhvDvnHx91z0VL9CbARfj7g7Crj28X9vJxudfSlfGnwcKpyOiwm3ZHbZdThGNPM24V8KQVgPxToFC
 EQgrYU4q
 9KBYX8VDdteHXYfHrgJ/FgHZtUcUznnH380UbqeD2QSb4u5QNEC+/m4jCaFx95HkdqVoB7luFzSlMWLt5QSNLqNhtBDYAGfv+4xAyohxfrjxyEHtqE08CLhEdKMY1BzqwMJ4qk9Cc1Ctn1MxU/n0ILPwPNz/JEjA4+nSDGBU/IzJj0ZFTyWiriAwYKlxckonge/jqCs1uckNReHu++15TI6r6uoU6Vh0OFyzjfxKRKmBTxIRbhkXIu0Aay1+liAaX9yiuZTGvqUcERAHKAesPcX3O+Z4atE0Msc7YD2Bqnkan1aoq9yYh100Cao/EYPR3MPTv/QjWTo39BYhQ9Gm6KPHvDsBhpKqYA5e2EUpA4zIiGM4WnssZmqQ8X3VF8H2omdIAXk11rOu7K9hV6vGnl6vm24CHxK2rB7SUhtqmRv1Da7SG1OIQBoKTfzLlQVDRmeqRWuvoDloRX2snDh5ia7Rz3saLE3hY95BzlIPSvSWcfXrnc7pnf508BTYgSZQdGDUkFGtR1kaq3CnzYPYhxuvL8VgNrAjdr25bOBYR8T19QENAOU4CVqKLak6qm/ry1tsp4+Sb0U2JtdFpoZKwu2VJpnpME0koq1m2GQFaqIanesoo0Rtst7qxFxtyuX5KCLt2zLmidbZtXk5QBI9NTu+sPTuFR1gKh46WWMdqG3DjhB7+4YUA58g46T14DECAi9maXooo6RWqQU6XHD7k+9x6dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 03:46:40PM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/26/25 15:22, Ryan Roberts wrote:
> > On 26/11/2025 13:47, Wei Yang wrote:
> > > On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
> > > > On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
> > > [...]
> > > > > > > > > Hi,
> > > > > > > > >
> > > > > > > > > I've just come across this patch and wanted to mention that we could also
> > > > > > > > > benefit from this improved absraction for some features we are looking at for
> > > > > > > > > arm64. As you mention, Anshuman had a go but hit some roadblocks.
> > > > > > > > >
> > > > > > > > > The main issue is that the compiler was unable to optimize away the
> > > > > > > > > READ_ONCE()s
> > > > > > > > > for the case where certain levels of the pgtable are folded. But it can
> > > > > > > > > optimize
> > > > > > > > > the plain C dereferences. There were complaints the the generated code for arm
> > > > > > > > > (32) and powerpc was significantly impacted due to having many more
> > > > > > > > > (redundant)
> > > > > > > > > loads.
> > > > > > > > >
> > > > > > > >
> > > > > > > > We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
> > > > > > > > this out internally?
> > > > > > > >
> > > > > > >
> > > > > > > Just stumbled over the reply from Christope:
> > > > > > >
> > > > > > > https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
> > > > > > >
> > > > > > > And wonder if we could handle that somehow directly in the pgdp_get() etc.
> > > >
> > > > I certainly don't like the suggestion of doing the is_folded() test outside the
> > > > helper, but if we can push that logic down into pXdp_get() that would be pretty
> > > > neat. Anshuman and I did briefly play with the idea of doing a C dereference if
> > > > the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
> > > > helper. Although we never proved it to be correct. I struggle with the model for
> > > > folding. Do you want to optimize out all-but-the-highest level's access or
> > > > all-but-the-lowest level's access? Makes my head hurt...
> > > >
> > > >
> > >
> > > You mean sth like:
> > >
> > > static inline pmd_t pmdp_get(pmd_t *pmdp)
> > > {
> > > #ifdef __PAGETABLE_PMD_FOLDED
> > > 	return *pmdp;
> > > #else
> > > 	return READ_ONCE(*pmdp);
> > > #endif
> > > }
> >
> > Yes. But I'm not convinced it's correct.
>
> Yeah, I'm also still trying to understand how it could work.
>
> >
> > I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
> > P4D must also be folded, and you effectively have a 2 level pgtable consisting
> > of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
> > all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
> > was already called and used READ_ONCE(), you might hope the compiler will just
> > drop the other loads and just use the value returned by READ_ONCE(). But I doubt
> > there is any guarantee of that and you might be in a situation where pgdp_get()
> > never even got called (perhaps you already have the pmd pointer).
> With __PAGETABLE_PMD_FOLDED we treat the PUD to be fake-present, like
>
> static inline int pud_present(pud_t pud)	{ return 1; }
>
> And obtaining the pmd_t* is essentially  cast of the pud_t*
>
> static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
> {
> 	return (pmd_t *)pud;
> }
>
> So in that case we might want to have the READ_ONCE() remove from the
> pudp_get(), not the pmdp_get()?

Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
requiring a READ_ONCE() further up the stack?

>
> IOW, push the READ_ONCE() down to the lowest level so the previous ones
> (that will get essentially ignore?) will get folded into the last
> READ_ONCE()?
>
> But my head still hurts and I am focusing on something else concurrently :)

Even if we could make this work, I don't love that there's some implicit
assumption there that could easily break later on.

I'd rather we kept it as stupid/obvious as possible...

>
> --
> Cheers
>
> David


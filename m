Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD97C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A33C6B00A6; Wed, 21 Jan 2026 11:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950CE6B00A7; Wed, 21 Jan 2026 11:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA406B00A8; Wed, 21 Jan 2026 11:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67CA66B00A6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17048160855
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:10 +0000 (UTC)
X-FDA: 84356561100.20.4DC80B0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id A4FA640008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p+S3AlUF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V4ePYkTy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014266; a=rsa-sha256;
	cv=pass;
	b=tuboTxiDwr4Ou3tNQMbsqK+VHQ+S1oQB+YxuWvILSpBqNQavo3jc5XZDE2NRSkqVwYjE3v
	wEYFxw34i/9xFj9V4QkG5IuN6LUCCVimSDxp+2LSmrbh9yXPFRp72LNALGPiU98Or+cKAj
	webowBoZK8EU3wX7dL3YMsRjpH+2uVk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p+S3AlUF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V4ePYkTy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOqu8wHtXb2fNj4hsacQcVtKshgkahrNK8CeVOkA6pQ=;
	b=k47s9c6pIzw639QvDSTi0BwAwVemFfsgppcMGkMuSxGVPU5Y0rBrVzvOqFpKsoQc1jR5K+
	SQSlIrRC+XzhoQ/GDiwB1nzXtNC4GH3GvEMYnfm7W+GsaLCs3O/2T9HgzqlaFuIknGVv5x
	FKVRGiEGadwswS8NZtROTKqEIekptRo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LFIRU9420923;
	Wed, 21 Jan 2026 16:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pOqu8wHtXb2fNj4hsacQcVtKshgkahrNK8CeVOkA6pQ=; b=
	p+S3AlUFqTRjQ/n+sbplPCnarhzyLZoCFAHRJcizXu0eOVRM8WBuffZzCUS3M6cp
	llGV9hT5MzvuHRj60UwqUESDq1zsoSTQTk5dszfGH8zboX0HO8JsPqaqHDwOxAE/
	lcgCfuXbBPT82let4v7EbX52lwMrPVGrVy7N5YZtrA8VS5BPufvomj/W/QOEw9lV
	3O5UHRSgHoUYKfqwCmYVybECfO1QCVrLG39ixNKTIRLeBFY9ZE2TPMQoFN8djjdr
	haN6VyB0JeTj748nr+bOh0ZOQzUCzMPe8fgTy4aZObnDEI6ysGq25TOCBN4Idqp/
	puPAo0gTrguKvTzi99N8AQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagctsy9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LG5lZI032293;
	Wed, 21 Jan 2026 16:50:50 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfacnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VPz0rg1jLi3eNbSg1VgX2Iq0UsHD3cDcokep9l5lYHXml69JMiHBx9RO/rDNpU7q/+DMPrqMiVHhGhnDOSi6A5VmVsDUFSF0u2GAJuIJq4Ai4/qNy99FHAOoQigLShIV/vFXxaDYJTSTsHnJ5mZKkQ7sJyb8akVXhzaLQjkbVjjYN1/q9pYOBW9oCzgl3hxk3fq0oMjvPOqIN61abM56tD1wtKFinY9LmT8t6ZqoKfCpWFGuniYYfz6jjeh8O0m9/VPs3oMmYCJCT80OLKhYlBiUL6zfkQZfPEqaFXSFV/HPPwxx4yp8qE2AuDi5fjlRJB9rhaJ8eJY1qHO2iuAYmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOqu8wHtXb2fNj4hsacQcVtKshgkahrNK8CeVOkA6pQ=;
 b=AYFIkz/9EMP+Ee/OdRdRtbRSLC17/D4p8Ji8Gw2Gk/oKMrMprj8YURmyx4E5YwpNcLFlutABy8y12hOI/bIaOJxgoVy2SptJa9ivOwQE0Lw4ePjqtkeELA1YKe3YFQj6389YfT1jAEFs2xR1IvaQUNfHQJdcxnIla4Nnn1oLNP3rDwucG00hQCEBjRQ9yZ0WjV18cdJHjZRkBYktCQJSalNq/TPthMmFLvEGbfcTq2jZBmiWzHNQL9DPjCrSvK39UDnF4bwszIf4ravzHlKQN8EnH21ikMXqpDl3guRVf9IiOVWYQ/37TtX5NiMy4vZwpdjjDhyrltC/PexM/C9uUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOqu8wHtXb2fNj4hsacQcVtKshgkahrNK8CeVOkA6pQ=;
 b=V4ePYkTyVVgkLDh6VT72pQWk2H8kglVULHMdV0NhwpgNttolRJ/jlCHijI5+0OzUpUNihGhkF4wkvxNGbhZC5Rd/FP5N0tN7DeXrqyIA+YjJckrpGy4U6d7vQaKMDZlhEf7fBCxz2/ickOxzAQTMLglKx/1+1L/fIZ+T2p3xY/I=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4255.namprd10.prod.outlook.com (2603:10b6:208:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:50:46 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:46 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 01/11] mm: Relocate the page table ceiling and floor definitions
Date: Wed, 21 Jan 2026 11:49:36 -0500
Message-ID: <20260121164946.2093480-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::33) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b9a07c-c938-419c-98d6-08de590d3900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BKQa6YHBOpaAOWQeG2ND6Rrwck8vHjpbr2IaZOp4rSvBW+9QfxalqC1Y8lNA?=
 =?us-ascii?Q?eWjCeum9DGZewyKyXAD+ZpQ2YXNNVMKMst1Np/b9nVsizgtYozY6YrHh3Q99?=
 =?us-ascii?Q?ApD1rAYqw6uvVodvA4LBN6bLEkDq2IB72w7AdvN9X8KzCDXxokBYOODOIw6V?=
 =?us-ascii?Q?lPzWneqJOQ1Kl/9zzCMmWwkPbHNvDrhGUK4qdM2myeqmYb/uITgC9Dvw1p+v?=
 =?us-ascii?Q?0D0lFkkVek3+fDMAdx8Lz9Ocs7ZzhD3ocwRFtbXkTZx5UAqS0guB9MGS25Yc?=
 =?us-ascii?Q?tBDgsBDsQ6rP9iEf+0TF0/LcdfDHnJErI/bMQWlfazl1D7ZpD3akvPLFADgl?=
 =?us-ascii?Q?kY8jscgxsUgMsuE3Gq654wT1+ViLUI35a3DrUksYAWtSdlEhWdgokZj6oiVC?=
 =?us-ascii?Q?EJfHCIknGECz1Lu2AVEQ8kFgVcbKK07mBJeHqA+uc/6h1cO2N+rjmlcnIs8/?=
 =?us-ascii?Q?y+C8Vk5C5BHlVpkZJlW9DdejejTMoREzxt6wmcj5PKvaMnAMK6u9KHLmF5Kn?=
 =?us-ascii?Q?IoQ1aHR5mV1rJErhPYwufJgZgUHP9aD1L6vttoosidZqgc6CiSKxPLLusN5P?=
 =?us-ascii?Q?d06pyAgENCvUmA6dFpZ9xBTOWFHrxD1o9M+URz1DJVOklLFTK06YlAMO5yBj?=
 =?us-ascii?Q?Ckrf5nDoBZJyfEkpWQ16BUgBwmt9goVydzDrGf/m3c9/qD/6iDGelmMQahgt?=
 =?us-ascii?Q?RK7hfOnMS7NsVnuE8Wrocz1tRDK1zfYFpyYTM/xsOE1YJ0vpQtdgwM7lJ9xO?=
 =?us-ascii?Q?u6vcZ5u3WB5mEs3ElvUqLDmKb7L+VfvJDp1w9mxJjt1fTMUp2peMvxBaK3L+?=
 =?us-ascii?Q?tV35VxmrdGh+Q7MrQM+Nqlr+uQcWBKmWQ7iURTgE6WupKFXzxBsaf5WEHZp1?=
 =?us-ascii?Q?JN0UBRiBY0a0aCbJ2wBcw9SNqL6W+4OWlB5JtgTFpCw0Ju6tjFx/fKCz2dR6?=
 =?us-ascii?Q?qOek2U11cxRpbiGmrqNUIBZwtHar7+R1YUKT/cSs5jP22e8/fmY5VeANSMCx?=
 =?us-ascii?Q?sKEyDol0PjUkBsPeuwzaITChRad3C+74P5FMF8NL3pmubYlqJiFHthzNIWFK?=
 =?us-ascii?Q?tdCMcKC2BFe3M8LSJcwebBAfkiFKhuA/glBEQp98lVFmsJzJ3n+BV8f6aTE5?=
 =?us-ascii?Q?djQHelwHMpP2xLZYu+9HKlhbkPJW8Vzc+3sNjk9rTD6a2i7GEwetMXOUQNeq?=
 =?us-ascii?Q?W+Y063Q2NUnH/V7pswXCJ3dUanJWvVvBGhIl53usw8sMjqS/7vh/1BeYur99?=
 =?us-ascii?Q?LRaSh00EHHBsQ8EDVDhtfcbXvcLE9YizTnhvghhSrR7uJTPPgsP/U6rdHl/W?=
 =?us-ascii?Q?0/wEesXq3AyM/nxTd6RMJ1xYkjMggJeZVxNS/p3edPpOfd6hmeuPP+tOzdI+?=
 =?us-ascii?Q?MmxOJ/pycyUEiRxHXgzyLtJTZyRnYlJ3848sEUfonI+MF9w2dQJsQjVi565z?=
 =?us-ascii?Q?TTzUp3sTUVVbYH2x8NfWxJF2jxyjj1Zqmy/FD9e1RY2zvRGTBExk39/lxOoj?=
 =?us-ascii?Q?YVyrwsDCDLTh6RZy16J+NrRdzQ8rJLrUYFzpnv+KB0IM0voQnC7cq0BoKyw1?=
 =?us-ascii?Q?b0bEE+sNQvMOrhb5UO8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+vZzCHK8ilhheMcNiycvkS4ecPJ9795ZeATmILW945Ngdm2G6b7hym5KhIN/?=
 =?us-ascii?Q?pBfpbxLzQ1+mqSHMqK55T7BwB19sdg8SU/kvQ598AfImP7323/hsJfFuqXsC?=
 =?us-ascii?Q?EUEIAbRM/4+SsaX1Gy+N7XYcpZy+DyxZ1YbbXgfDEvYpRXjfk6kzXm5kiP7t?=
 =?us-ascii?Q?xU9JvDUgDsmWg9N3qnrPc4JvTbpagZw4Oi2P0s+AEqDATZkvQ1/mpDiYyAo+?=
 =?us-ascii?Q?RTxP1AWSHyDN1ucJNxSHymmx+Y/2bzVT1SlkGT+bAgrnowadl8jNrXYwQJuC?=
 =?us-ascii?Q?A60YJVjDlOQlIbHkYsHHJtSuihZ/fDCgJlGR8DyVMa/OdWvGL3UG3Uh2wHQE?=
 =?us-ascii?Q?jHiZjmUVnjtz3+Y/Yv+aEXTBNLQ/4TeoKvZrQSy+cOIiOU3TubcWI7ugyD+Y?=
 =?us-ascii?Q?cRa3T7S+3AbCG0bHfqDSGTFkqXJKjIpXamOnKB41zoh74uApsGQZuhMLKFol?=
 =?us-ascii?Q?hBNnUaePNeR2O86oYkLrhbIMa9UVeWu0a+7s9KXWfPnwQfVTD4cHG15bmf7b?=
 =?us-ascii?Q?+s9Xy7DZdzUB7jVqXT2pLqXWIRA+9qg8k+F4ElfShLQ3cdl5cMmHFyy+crHs?=
 =?us-ascii?Q?RE23Ee6Diov3ghc4LgMJizxBo9upWftd56JPtYxlA1O50n82VaOc9pgVE/oY?=
 =?us-ascii?Q?mfXjbqyD6KpxacjZqnknp8v3o+MT4D+ZeDc01XBTUkk0m/vSkkhlAiWi20Cz?=
 =?us-ascii?Q?yI2m5XUajBeQJrfV6ww5Es4gB5cprk5ItlvZ3ZzN+ZtQu1Jr7/Taw3wzmYuX?=
 =?us-ascii?Q?wH1CNFYHRsKGg0i2nx5rlSw+y9CCGUWFvqzeWY4yDtx90yv5MfTxXCAeYQuZ?=
 =?us-ascii?Q?wiROpUOBLSeDHIWoeToXLuh+hfdfCP1tRkJRARMYxTdjPxLM5beA+CoLclTY?=
 =?us-ascii?Q?e6vs2gLFosIGyPSByVxFWIo8qBMT6bOVpsV3jjLnkUpWYL1BteOFVWDlqc2e?=
 =?us-ascii?Q?dxycRqfqHeMjQFtgUJl0K479lTSgRM6RiBsJH0kbYGbmQeW5OwnL6zgeZtxA?=
 =?us-ascii?Q?HLdzcqCcQrL9E6fUm2KbFZDtqkgc678NrjfoMMeiw6u0pzr45uMK8pybYEul?=
 =?us-ascii?Q?ZvcHLJDU9751AkyYUFqgrXmClT5jeEuNl2YEXLOuWoSOYRMm67r1/oGRZH3m?=
 =?us-ascii?Q?oHxsllrzY5QRwko5l0+GczhUATQDGR6qCieLWlVuKTUHcg7VH+lDoXAreSPQ?=
 =?us-ascii?Q?ySdG2P6zHkjZ+zHNKgHUYUpBx+407YRNQ2rrgOMUXyfeq9M8DRxzExL58UB4?=
 =?us-ascii?Q?tQiLsVC3jEWL0IzavQFJrzOc/W8gWAn8xkM8thEopN3PkJjOxTnpbpOPPtZZ?=
 =?us-ascii?Q?sl0qphdNlQPnJyDCwAnHP4AGVD19h7qiRL3PJM/PTFd1wVsdSUJN0sM1HJfQ?=
 =?us-ascii?Q?7p0q+SW6VRY6TDzMXZhkVH16PN8SJaO0PHZXRpbtf4jh/2bJgz4Jd8y9egyj?=
 =?us-ascii?Q?c2ol5PQpU9vseH7B2rz2liRbtvfvUdmfTKIulQB3xGGPduGNyXBxjCYPEKEF?=
 =?us-ascii?Q?fgl+jskBhs98K1DOhDsQJMlWaM94fOF/FYVldeD2dSKvUD5c2XigKmQLUQaP?=
 =?us-ascii?Q?vJjOqVW10M1b/WNFSq2Cl8db/1FJn/8WJ/R68aKo+UgxUa9xkrIiFIr5riuH?=
 =?us-ascii?Q?Iq3YeH+3dqiEyPEvFOOZQbywel4k8gk4xtrtSW+XcshYHBHjho2Z3OtjW6p6?=
 =?us-ascii?Q?mxg6j+WjaVz1SlzxlS731cJLfCp43ASp5lNLlvt9DqWO+4vlU6LD6O/9/FAS?=
 =?us-ascii?Q?9F4ShrW2+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pS/FiOKJX0O9LD65iGZIbq6PXhLyutnFC8xu+/oGmpdNikfryCEPsahlhDP4miVTOhW7vy5pDz0rvNGnp35vQYMx991/cq1TVwNxT5rWLEGPhXuP3P/2Gn5H2sAgh6/eguuFbZLt3p1Wq0Z6nEz3bBINWrYYsXU02Jyr45TaBlYAosC0+hkWmJ2jVRXGp+I7p5527a5eXVQB9xscK5GZAwdKF8L4eUJ8CkKTxbxUr7YAlBmdvX1pnhSo8Pjf6jxq3t7t8EixXLkY9kuOo0JUXRZG5r3wubNWXsaqZSUs1/2F//qpL0ksVTp6p0Ug/f62C8WEPq+p1fOJyKTjpDqh1if7pgfQjNS2mdNFWYzvqdtrDLF2xswqbCsWQdwZ1jKit1XGsHIm20hoTMVRwf4QySDih+b1IGi8emiCAurls+8CDsDRtDsp9uaQHFwNAyip353j5ac2g2xAQLmI6AwFniuCZXb9fjXCGMCvZ0PFDTZnLbewyL0j6z4wyptSyunyCDjsWuJe6yh+jiHxl5g7H3hfcgipX5eZBx7ty+ebd6fY25OKjVhOwtqE6pP6GpyHAe72p8d6fHQUbEm5P0VtsGl3hHeQwKi/EBtxy8wMqV4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b9a07c-c938-419c-98d6-08de590d3900
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:46.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCCTKle5M/HQqg9t1V22hlF0xt8YE6OHMP7tHKMCLI7a3Q7b5BrAWJlYQnb8duDlT731rn7g2PrJx9ZmpIhwCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-ORIG-GUID: aWjiIm3abmZ-im9aJv2Q9uoQCEW3DTMh
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=697103ea b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=oTg4wnMlkjT4RT2_utAA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX0lhDRVn3noJC
 CScSdrAwIE4d38tZMymAQvfXs7WKKZKt/8zbmpAFAzDRheBC909GPZVCgnX/awJSLcgb2E7GH6I
 T4tppZM8pUWBdb3c/Qt37sYxTAtt3RieUvGSQGNJXILYyW461QOhl5dT5IW0TpvJtkyoKmIabEz
 zL8Kb17C/V9LXmm0JOGsFApZw7Boy23gdvd+gpfhvS4/bySAq8xfxbPQyCymrDINU3AylC8XMdc
 1pPmpxNpq17/p1yrMdcjFn19BDGtAd5vFI0/p9ZTmyWqDhAGT4laizt3XQAuK6TZP+AElcZ7nzT
 +FU12wahTlrioUgHJXSVMpX05C++BmhzOvTubMYGDP2RYsxcP//WVaG5hC35i08+TnV3q5ZK6eM
 iLL3IThuOuZTsXk1GtI1OXc5CKXanAUBQnA9z47UMGDDxR9uoaba/NxMTUkuHBmDA/ci18dYY/8
 UCGELA5lUgfZL5jaewsYJs9uaNIO0Vx7p/CdE34k=
X-Proofpoint-GUID: aWjiIm3abmZ-im9aJv2Q9uoQCEW3DTMh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A4FA640008
X-Stat-Signature: 7f7hu63fj5ygfichd3c5qon89yzub3qq
X-HE-Tag: 1769014266-630867
X-HE-Meta: U2FsdGVkX1/DmNrcSLMOyP6x0h7SBT9wTlNSCEW2meSAgmBn44Rlrk3VhZl2ts9hZuHJyWHgc3uhAqW0QOqfoQ7hWBitWko3kkF84Q8mdgDniIbJPhiYlzXtueXZ1kslrYGIPfSGPhUGWZ1mzO0KuGo2sgbhxsmJpyI1chUYcAvr7kEX++I5UoOvxsQPKpQyrcOJm3xAoqY0jFA6KPkT1yu1L5PaJMudSjXQUvnfOVEMww9aYHU0GmDm/RENdfrQyevSGPSpBCAhIdFsj2nqRF5M5bEssEWWmqGybEezmvWQ3wS2CU6oi+INLtdJALUDkNjpiBFTz1Xa7N4ElS9fFcZUAktuycg76CBMmn6I96iMeLlvXZSJAgF9f8KzcWzeWjeZ9RSKEc0+tG3m+KpZ2UpuVSXuqHmGH6p0ZbB7Uk/JFK/+L8KRtaJDnTuJHM57u8QMdL/0Nl62l42XbW3PGmbSip7JJKLFyAaPfsxC+tBYg/usfmmav4beFwXc3L+y16Xa6zdvZ0el/8G43ZGPVaO+wochZ8aB+uimbKLxvv8rgiYsMw3h4bhAC0kzhruWVAPpu5cTIc7+oOcw+Mznr7ej8sulbXy0oOBGR/FSTNELKlIt1OcX+cS2gnJSbS/eu1shWoRZTC412DP+309TxZlZXjqDv41T7c2l5omG19e2pjzNokecOVB4oDjs1lc682yPAaiuUHZ6Bg+kMpLVMBmWIPtFliYo0gKD7osC2aXaqvayZhQ4c0s6mcD72jQ7S/vPPfy6oXZnfOoxKT0+ikXMKW9kkhetFDkAexGsbfE/hYXP3/Wpsjm0KOgSdmlfjAfDZKj5LkPaOHslq4LBmPpGbdDmtRY8hTvS6/CnNcgYfXpHy8SMx6NHfIGjG2imJKDKz7q+ohE9mXilXDKX02577i6Ga71uLNqv2DakiqlPLxkvDIaCX0mgezJfZXJ3EupQy5r4IfPhk22lpmL
 StmwKcO4
 cj8ZyK1OWItJtylkXbx6DcqqBI31b3AjV1FH4AbCK27pe/o4UfrNkZmbWL7/OTG9IFPf4bv/9A/bmFrvokHHt6Rcxjb0twdfO5w27Ltc5uKKvig91ixpGlcKYskAoWjna83o75gO2fhjxghT7VFadqF7Mn1g8SVzfeY1NYRrwt5NBgsFIFeBiThhrjdMe8FdEIgUimFgmz2XFjxFQQnfxG7tDSrfm6MqXMWkGnDsf3JGv6RAJ6uazVG4FDJGXEM6ORzD4rfW/ZknDftYb5T4Nubnj6z0g9GamWCRMoz3XAcgJ9lfl3VJB7hLBbXyxnZVc3hKAnESOLtPSmkcRpURgerUCReIECWi6QEhdX9kd84Wgd+9IFWyfNhUv090hnCMi/dDja5HlGxS3832Gd9mWRUfDS/ivJcKnbPao1JhBEkaOimW+shwVQLPqb7W8jsT2rN6c9lpaVP1uu+2vJN/W2lcrBEjzRYvMXLAD6YpVP307Q0Ts38s0wpZ/ibMjtvpvuTy45oGupN3lmMMltTL7UlUYlA0QH4D7GfyBn+aXZN36GNe0uVIOWQ9fz469iSpw31C91WbsM/CpLT8L4Kv0u80qRwxkbek30d5S8ttK3B5eDJomPudMVK4zEh/rzqjiIvEvmDtYWW7oq+SzZ6UfO9+2Ix0t6+fE0On4gZYIVy8EJYWzoEek7ZzXHH/vWtUqX+GS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pgtables.h defines a fallback for ceiling and floor of the page tables
within the CONFIG_MMU section.  Moving the definitions to outside the
CONFIG_MMU Allows for using them in generic code.

Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/pgtable.h | 39 ++++++++++++++++++++-------------------
 mm/vma_internal.h       |  1 +
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index eb8aacba3698d..557ac918bdca6 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -22,25 +22,6 @@
 #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
 #endif
 
-/*
- * On almost all architectures and configurations, 0 can be used as the
- * upper ceiling to free_pgtables(): on many architectures it has the same
- * effect as using TASK_SIZE.  However, there is one configuration which
- * must impose a more careful limit, to avoid freeing kernel pgtables.
- */
-#ifndef USER_PGTABLES_CEILING
-#define USER_PGTABLES_CEILING	0UL
-#endif
-
-/*
- * This defines the first usable user address. Platforms
- * can override its value with custom FIRST_USER_ADDRESS
- * defined in their respective <asm/pgtable.h>.
- */
-#ifndef FIRST_USER_ADDRESS
-#define FIRST_USER_ADDRESS	0UL
-#endif
-
 /*
  * This defines the generic helper for accessing PMD page
  * table page. Although platforms can still override this
@@ -1660,6 +1641,26 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
 
 #endif /* CONFIG_MMU */
 
+/*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
+/*
+ * This defines the first usable user address. Platforms
+ * can override its value with custom FIRST_USER_ADDRESS
+ * defined in their respective <asm/pgtable.h>.
+ */
+#ifndef FIRST_USER_ADDRESS
+#define FIRST_USER_ADDRESS	0UL
+#endif
+
+
 /*
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 2f05735ff190c..2da6d224c1a85 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -46,6 +46,7 @@
 #include <linux/swap.h>
 #include <linux/uprobes.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/pgtable.h>
 
 #include <asm/current.h>
 #include <asm/tlb.h>
-- 
2.47.3



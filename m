Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685F7D74951
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 04:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D816B0089; Thu, 18 Dec 2025 23:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05796B008A; Thu, 18 Dec 2025 23:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9CF6B008C; Thu, 18 Dec 2025 23:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAAEE6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:10:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B2BC8A650
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:10:18 +0000 (UTC)
X-FDA: 84234893316.16.D99BC85
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF594180003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:10:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WMclXIu1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="DI/b4+Vv";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766117414; a=rsa-sha256;
	cv=pass;
	b=TSOL2gjtrpw0Ns55L3Ct7c+nK9T3TMxtBrVRlrz2P9ge3ss7ZP987YEJmr2ODzTW92dTMZ
	h6O3HwH+GMmQIxrNbMD/fwg6yrZscUqWdmHnAfFyLPvj5/1wdilLu3w6/vZlim2YHd4wT6
	RIHF4n5V1ua/6C+uCInoWreTuMOSaqg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WMclXIu1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="DI/b4+Vv";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766117414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/CEmD3EX/iqppjhHqO5odNu6ADbZpznoXJG5EiASMI=;
	b=zmOFMfX8rZnfsNOtYx7QexR0MpPYwkQ8Zg+hAO+8TrbvAe9MBAlEw0rpbUI1SLjmL/Y0R0
	NtFNAR8dyGn6wTICdfq2srmIv/4DVlyBce2k1/R7Q5goGw+JRHaU8KrZjbIPgp6E3r8IC+
	1PjseV/y4P/OAM3wvaXz2oZDLP2KrCU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ3U2E42765260;
	Fri, 19 Dec 2025 04:10:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=i/CEmD3EX/iqppjhHqO5odNu6ADbZpznoXJG5EiASMI=; b=
	WMclXIu1ZL4S8SV64cp2VB72ohlKvsRA9o3/Kg5HBu4CIlPYBObPVKs0KsL2v3o6
	/8EBWE2GspHM6HlvU99bTyc9bgS/HC3JxDjCv2XhmVD9FQW8NcLbuNSnJu9XwUmY
	y8re6wie1D0r6JQ7/hEHx+kmOzn8nQ7xb1B19MdE3VKzxrYYu1bcZez6Q5wQZAu3
	+2NCKTI2QNZZWLO9kJTF/9T+PHOAOaRO1+lp0Q1ojGoJYjFVMnu9dXHfE84Trg6o
	GPKJH3Zw78FYFtsrJkcsfPma0OSC74xlN/C1ZzvkyGJ1EHFe5+TBGmwkUiK0WO5B
	nPs6gGMdHkMv9GCFb+uL0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2bgf7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 04:10:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJ0OqJv036655;
	Fri, 19 Dec 2025 04:10:03 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtkw29p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 04:10:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tVeMgenpQ4f61vGIZCIIKnNsuaJ3tsLWOmRThb+686VRP3Mfj9mQgCr7wAywoI4RpifK2eINU0JOr17BF8a/NqQi/+MYz8Id2yK0XrgCS0cSI/eNfoosVghEU5/yLAVUnV7z0W4VslZjK6uo9hifAeeRUkuDM+ta3zKJWBBXyTVGtYDEt+jWRxPyMrMIpqpQVSWuRKjaRRFnA6TNSpiNON3zNfCUYaChoA1v9OehSwC2h3er1cJysxKJMgXdc18MDXbJ0PSGSRKZUeAYAeSX4Kr6RIFXs3KdtK2yXN6jncF+PNY0EflQTDJ+q8r/DYQD1lwHyyEEiRFzfn+/Xk/ClQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/CEmD3EX/iqppjhHqO5odNu6ADbZpznoXJG5EiASMI=;
 b=D2RGq3XbQIs9lRM3VrLDFig6Oo2x9Rr4ZRptPjJS6tNlXNEwkQspxWp3424v5cMtcbmqEgkqfF/9SJKASgY437rQtPPsH5qn91TLbiuzMaFttK0ulR5nTXpVhTVVp5ZcTPgRxo39E0Synjh/l1OhVKr9RJibbr3XF184YSDUKZwlfNS8TBFHszf9xbHGpNk3335/I1xkfNUyswGtnniWJP7SCUlbermC4/9Ou0d8Mgioxxi3GAfSP6fEApOHiUhc27nViolOEoduu2CKL0jr2sEcC5qez3Z2MNWFzTglUWRCl98QDujTsKFQ2h2qYl+YguihDtWAMShhvkTwD8NWlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/CEmD3EX/iqppjhHqO5odNu6ADbZpznoXJG5EiASMI=;
 b=DI/b4+Vv/2DyiE8tQLI6j/o39TxwuMmeK/olNnvHuJPaHG6ErlgfbL5l234KI/OTH3tolnEdJW5Z/tAqGGjob/phyNTQcUBmq4yp4fb++w0/fHqUNS2MyQpSTGAWxrXdJk1vWs1v9UHFlCNuySeEs5NfReVi2/ef3RgTQbWcRDs=
Received: from MW5PR10MB5764.namprd10.prod.outlook.com (2603:10b6:303:190::15)
 by DS0PR10MB6797.namprd10.prod.outlook.com (2603:10b6:8:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 04:09:59 +0000
Received: from MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae]) by MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae%5]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 04:09:59 +0000
Date: Thu, 18 Dec 2025 23:09:55 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: jane.chu@oracle.com
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, muchun.song@linux.dev,
        osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com,
        william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
Message-ID: <urxtx66muia2uggyr4mysxzdakavu5gypn6hu4xlwizisl4cjz@btsapum2gzbo>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	jane.chu@oracle.com, "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	muchun.song@linux.dev, osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com, 
	william.roche@oracle.com, rientjes@google.com, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251216215621.920093-1-jane.chu@oracle.com>
 <a7cec1cc-bcab-4dff-926b-f3d3c5136f61@kernel.org>
 <609ec743-e989-4c50-904a-80388d6a0096@oracle.com>
 <duh4px5nbhpuy2t3oztp7gersieo5q76kdlbzkgya27cxmaoxs@uvzwpigeknpo>
 <55542653-8902-46ea-b416-776fc58bd644@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <55542653-8902-46ea-b416-776fc58bd644@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0387.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::12) To MW5PR10MB5764.namprd10.prod.outlook.com
 (2603:10b6:303:190::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5764:EE_|DS0PR10MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ecdd83-d8f6-4886-5d27-08de3eb479a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?kWINTHq6UGW42qYxnvyvjRnMjGyCHl1U/aSBOPIfo+UoqGOF1aG62KB2J2?=
 =?iso-8859-1?Q?Gx36a1HtkeTqYddyv/o87ef4oxKTRm0D3SQDeFVw4qhAKCqJ4GzGgKmSLD?=
 =?iso-8859-1?Q?hqw+RaZpY7jb0yk+ASDQv0+G9N/bAoMn42K63xGJfMyQctjBuXX9oyEVog?=
 =?iso-8859-1?Q?AwOrOJTfdst36pDQXz8JivfWlssvUFVnbh0x3AklBzfiDzUELGWNgJv4Np?=
 =?iso-8859-1?Q?sAse1Kt9ngTCWyVBaO5QdSaCyKxyttMKDdcakmMH65WqEF6X8Qzjajs0gS?=
 =?iso-8859-1?Q?NfRA7y1fzWER7Brz2EupZKLRS0rROnxtnQfDp+6kxE85xuzfupdzdIElRE?=
 =?iso-8859-1?Q?GMzgahYOeK/+9jTRE02cZlnGNAA3un45kbd4473P0iV3rODpBVP9D7WRU0?=
 =?iso-8859-1?Q?WkVlD6IppnHtZkt3E8AaebqDNXDkG2OWBF/ZdM/oE5WP017PRJFvq5kEyi?=
 =?iso-8859-1?Q?WYI2x4Hq5dZr9TtOtXCp/eTXrDgZahQY62d+WA/XWYaM2Jv5hvk4ovcemT?=
 =?iso-8859-1?Q?W4t8NFLmb0+kqeWi8gnXTq6hxzQvjX8b/CB1WR6hAw0ANdeCdoT0n9urG5?=
 =?iso-8859-1?Q?h/zbGYIUwDX4X9fUUaY22rp7uIIc5EbjdmviuTn2FEYHatK/Pm4+saAHK5?=
 =?iso-8859-1?Q?3fzbzAMnzfjMGPxyvubrFZ5GajDiWzQmzrJL//bEeoWOFXyYMKsgCpPCmO?=
 =?iso-8859-1?Q?VZEr56AgQ6EyGU4AEV0WvbealycpU2UEJO1UfaiG/ZCp7Vk85PuJc19B/r?=
 =?iso-8859-1?Q?bcM8LmQngyR2aQPY8OXbTvWGvGrbU9xmy10kfA9tBmEwEVWqu4KegC2k8w?=
 =?iso-8859-1?Q?xOpBgB/3+CqUo1n9VC5WtPER/36JG97kDUb8sHbK28RDY23C2Jq+Z5T6Br?=
 =?iso-8859-1?Q?TXDvlR6J3nBzhsFZZPwrOGhT8tKSJVjs+HeXmeuH0Pzdz+jNTgJy26xtfP?=
 =?iso-8859-1?Q?ZZSkR6+2PAPsVQVLK8NQAAdyP6DUb8FaubA0LHJxLb12Ua9t6eneykWK8m?=
 =?iso-8859-1?Q?wxe1kgNnAL2WyEcjB6eloAqwHXdlS2QSC1i/VqG/FqpyUJShHfeZWX2VOD?=
 =?iso-8859-1?Q?zqAwn9acViMIYC/957R1sw/W6nnAVRvZ3azhw3m95V8vMKUOsyTmri4EqD?=
 =?iso-8859-1?Q?oDY51KpamuPkvv5gPU1lQsUaOExTEguSiZ4V8xPkAmgV/B90QZdX2HE6TM?=
 =?iso-8859-1?Q?HSF3kOVTN9GB1pSoKYZS2/M0bF3Z6AUtbKGby2D7DHeRVs4K2ZOXCYyGSD?=
 =?iso-8859-1?Q?iyQj949WdlY5naXvmxbhv+tHuVd7e/y2U3qghwt9wtTBksnI0hzUxe91bU?=
 =?iso-8859-1?Q?TJ75l6MYTO4sGjRXIj6ZfS6cQVNfazfw3FUC+Z4WCJC2b6PDgnwpPAbZO+?=
 =?iso-8859-1?Q?8zkBowX/EXng7vwyN+F5x03ulKiYaY4AzbcU8N6czjoFDblXF3zqniVXvf?=
 =?iso-8859-1?Q?bM84PDFLJape5zw9gGg5tYpgggZBjVXfxfzyi3pgMCrlL08wHXRuAca7LK?=
 =?iso-8859-1?Q?kW0vwAaaR39vewXMvqb5JH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR10MB5764.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?P43SA+87j9uyDF2LodgkHthC4wF7BXQsoLd9OROyD9TLhylqLQ8KIFkja8?=
 =?iso-8859-1?Q?1WNfd6+DDsdoD1oFZF9RSEU65idCU3FysV5+u7U8Z72sz6fulgdc6L8zSb?=
 =?iso-8859-1?Q?OahRFktqB/oHPtyr2yH4qPKHaHzoVUiSB6ssBLF+VTOZqWwGtU44ypnCrK?=
 =?iso-8859-1?Q?IeQZiKc5RTP4vI1NS6fgTmmZ4acoZmzs5Vy9qTgPoW/qCaIMhFgErLFhf+?=
 =?iso-8859-1?Q?1YMxOpss5twaUJtR1vBYTvwjmaNa1FdyZzLyI5Zn46Lus49oVemFpqqxw4?=
 =?iso-8859-1?Q?zKJasJopb/h/yOf6yKkDNy/Roidh23DnvQoqgRkCNyRxvqJMEN8diY5oKg?=
 =?iso-8859-1?Q?BaI0pdhqNUKlexN8TqGE4Hv9gL6fNRLrIY9ijz26QCiqp6pHAyRTPQl23Z?=
 =?iso-8859-1?Q?0pLqMr2xv12PrKetgVST6cF1Oi4rQI1Wj37+DS9QOKKUsP9wfmXkX6Fn10?=
 =?iso-8859-1?Q?MaR6MZS2AjVtqDZdLTJ0aWcxR9/daw+z+tt1FNH//4htbyP0mKu7anYc6A?=
 =?iso-8859-1?Q?MORJmO2oWzFNw+s9pBw5Vfn41hWlzN2pLnj1iFQnWymZeYmmewubccmr1m?=
 =?iso-8859-1?Q?X+eKhAatm4ljOpLhGAFCV4vPHyGi3FihM/tySA2AJRZCS30Fhb/ULnirC8?=
 =?iso-8859-1?Q?ZHlbghKU2o1vcfYzwENcuJrZNbOJ245TFENl9fw1QVRmI4Rxt9/xHLeN8d?=
 =?iso-8859-1?Q?W+OfLGJkOzxXIgdjCd7m8ozjSe5/c8SvK+5s16O29W7f+RNIxVxBVTEVq8?=
 =?iso-8859-1?Q?6168bA/RhZSMXn4gVMCIMS0sQAcJtKtUu0cQCxL4IYRPSdiOvzlMB7S4pu?=
 =?iso-8859-1?Q?fdas4j+4rexq6cyswZBhl72ZnCOz4rmszuW9MQJxzGHUkBfi1xFTluVQPJ?=
 =?iso-8859-1?Q?c/H2JK5FktHzH4kfe/4ibwMd74ZQuaKsdhN3cWLuvVL79qh+JWN9UMYnGo?=
 =?iso-8859-1?Q?jFcuAaU/7oquLcxczRuRoS5fx0rC5MgKtO/zXMeKK1k7poEh+LE+xgAd7n?=
 =?iso-8859-1?Q?XRR/VRpbuUNIbdKPWysk+6hEt6SY+qbLe5L6q6xIBd3bK40OfBEMFB352e?=
 =?iso-8859-1?Q?SqDvExNzODRIEFB21oCGRtYyK9VXY139/olxt6RumjNFpvDcYzObNzPxoL?=
 =?iso-8859-1?Q?+ZFDI1AYcxSl7cyYFVUy/327Hfwg7tNIVfEfUgO7t1B4Gn5Lh0zWilyNMM?=
 =?iso-8859-1?Q?W1Yde5XBRHA71nN9oz/D9XHpfN0R6hGrqfl18Rk9u8l2uI4a04DZVU9moD?=
 =?iso-8859-1?Q?sZ5Gtd8ZBMesc0CAlduxwQjQHldzcdhKgCmJWGjxg2eZkIkZSFmuRprvEL?=
 =?iso-8859-1?Q?qPE+JwhPPDwC1MquVRsqSonHshMgNOTFM8n98S7WKrWRUsJsUQV04P7k8t?=
 =?iso-8859-1?Q?AWtoh+3CNQ2qWStRoOLTR9dRFX3D0HJdtWJ56t5hhot8E3Ede/e0Gw15gs?=
 =?iso-8859-1?Q?JF2VIQaEdBnzEJzJM2ZbiIwc6Biw3xd7EhXLR49mVpHBQLWJFkY28g3Ry2?=
 =?iso-8859-1?Q?CXroFCm5Zkw1eSq2YboMI0OYqxdSQ75MkzOm7zBSQE3F0dip0wm9F+P9NQ?=
 =?iso-8859-1?Q?Nud85nxSwdCLLESAbePiqIIMKQaL9w3f1m4K85J06LFrbtG6euwFaxlCaa?=
 =?iso-8859-1?Q?YI11rRlB1cJqtb8pqrJ5hnB78QzLK3CuDF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XiNke+FVfAQakeLpXWcRBtoHm7gWBsdlZod10MvTTQ6x8tgeLugHec0kYPNOmrXDEp8AhpCBUWeNH3y2HcC6vPgD9MyWgtCJP0kyWVrlC+h2vE+KLmb+TFDxCx/4bSV0OGJvwx5zGLoAe0IDLPOgvLpx+XsnbzmBwQH/aNS5W7JYSucDyOzGxdlW1MNwPxp9CYzj5luHx2BHmypnX+QMoFLBYvV9E2G7fAxr3KQVMcAr5zhCizRrGrca3ydec0lFgSP4dbvTfF4LKi5RyJzqtJArUGoKHpodEAqxVodda+i5Cb4LF5Z+7cHxmvSYVbWDfoeNZADFL3uxw4jVbvdWa4qd4y2/mIUFPny+UKvdKeVT5k1wmfLNQZtKivXRI2CsaeVDvzpM8/J9lRGcnqX1zCevySmw6JI65WV9F6SN4603UGMiqgQH876ObWtWxFGmAEQSMTNbWlZ5gR0iqjnmVX5D+3LurWI15iMKOMU5Odn5VxvhSbBKh6mjqKUNjpjlVKUaj7nac3k+FIUi7ZM8WsBZG7nam8ODom81Ov9RHs8jeZhEDOBXZI0w2P4/9TTcfxsQ9hxtR+i9T+iiimeTuiDCo0IY5LRfPBr6Xb0Un/U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ecdd83-d8f6-4886-5d27-08de3eb479a9
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5764.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 04:09:59.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRqrf+/WXbVfzxds+VEB14VsJdTWc6PWArEW7F5eCpS+IXWXl/ljGQg91YlsHSTnWxf8l/w5CcOjENIBg20CsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_01,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512190032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDAzMSBTYWx0ZWRfX6ged7JVC4LiV
 ovSJYGz4QTn+yAWwQn1B/fKrg/pw9NWE9y3++7PGam/kvTJOLJOVAjZGs+oTbz/aPQGJYfSDb+I
 jRUROjeNiBUSoeYoNJIGqnMuDrLLMOQa2yyW/RoHlyPpQjk41Dub82eb/hEFtKQmk6hUihJuQhu
 u3dA697Zp39OCfaHGBnksFZtkL8x5nDe8CEQmFtLkKJNNDiIKwIzzkB4TNn1kNAL2lOWmVjQ5j4
 l1E4vBCjI02WHvdhse2vWxU3uwY8NeBN46Ce6FHmbzzZ3/aNCDlmEgKiuZvQ5IjqkG1SWgswgAP
 /T/CZaWxprF5IB4KjPErHL43eBIiCIDzXrPZrnZ0Z4yp1nfwvU7WQ6xjq1DGxiQ/pLEAavOZ3ca
 F4q5dnlHfP1a6zQNkOWb2Yl6QZxVdBdG8NE00/fdic5VpshwO69HweTBVcZt7GvEq/7Z5fMGJ7Q
 yxkHOUiKJ7Z7uX+r22O8wYMYrxbD44jx4uBPqQZU=
X-Proofpoint-ORIG-GUID: 4z1kthlHhVZTVgr8YMn4Q47kSXIo6oWc
X-Proofpoint-GUID: 4z1kthlHhVZTVgr8YMn4Q47kSXIo6oWc
X-Authority-Analysis: v=2.4 cv=ObyVzxTY c=1 sm=1 tr=0 ts=6944d01c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=zd1fFWlSK1ch2GnlpzgA:9 a=wPNLvfGTeEIA:10 cc=ntf
 awl=host:13654
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF594180003
X-Stat-Signature: g4t1jsr76sb3buamkdcn46dowm6fmodp
X-Rspam-User: 
X-HE-Tag: 1766117414-488930
X-HE-Meta: U2FsdGVkX187L4VcBLRlHGvVKreGBjpMpBlEeU/F/5BledYmu48GGhSmboddHGg42IDAl5VYU+S7XZbZJ9t7y9L6txJK2DuRG9MQImJtJTVo1XGnySWLu1gYZ5qMMLPkf5RyIoPjWLIxaispWblpwElq54jmoe9fOwv2W1fExFyt6Hm9rfiGmQLF+0iBXP/ZGcO/CiMeEOdULWG8XPTRl3M3xQqMQoJy6scmBsiOVEzT+Nv628BdKgD4EpNNK4POZeiWXoEn+c+ebnNGUYbNnTd/SKeZmTHN/VtXcmvLkNVDppFjanRxOw7eAZuhlad9eQXrrLON8dHuWwt3hurP3B8MOZZIfPQ9aNxSKQTiWXQ8mDp7OLXOMiYh1tQ4/prG/dQuQ41x1CCRT83q4mQ6k3kPGvLxdivMe+P55XRMrXRIFUg0HBn24nz/toNTH0dNL9nsaR24vNi5j4HyARk4RfxtBaMrIp7/be5LiQSik3RW/KNyyC7BIYW2+x+CPB7s2Wf7ibWIpHswQDS+aFlwKci/+F7GGP3J31geLDW0XllGaevjVERhWjMv9lo1qKGWFXGhTE8GqeqgHp5khtYUIn0R4YCBDyTDpO3aitplv4nfGfBEynQbqdMdyUGZnxEP5KFG6psJNieJo/PnT5q4LsnRKfZFUXLdcESrt8dFMKxPdYA03qoEuXUgwEy4Ac0YwxDn27dYvcSUBGX1yC0xNw0Nmu9C4ZMOrqF6vp3BT+BqRwANsByaT5q/vHnnlgkMTtlkdtksljGfc3zTVqulYoEcQs9dwXWEGnSw6dk7lBNpOgFhdPK5nyTJYIPUr8y0AaQqlQpe3r1T3GNUQ7qeb9eKUokMOXb0t4p0CBK73wTCc+V3FCYfcgqthLitf39OHRoJIgiw8z18KzPSfBRF4yIxCihb48U6Bd8UccgPn6GTEiAEU8ysV86jVy20aqwRGI1VBE8OA2tpR8xc4JG
 QOfn+jlJ
 NWNaB7pfA6Fe/39mubm38CBjtn5Jedof2sNGhnNIJ6lyx/R5TSjUghkV4XYh883kSYxn09XpbMRpu+2NTq24jD/m84OCXGTPrTBV8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* jane.chu@oracle.com <jane.chu@oracle.com> [251218 18:10]:
...
> > * jane.chu@oracle.com <jane.chu@oracle.com> [251218 14:01]:
...
> > > On 12/18/2025 12:41 AM, David Hildenbrand (Red Hat) wrote:
> > > > On 12/16/25 22:56, Jane Chu wrote:
...

> > > > > -static int folio_set_hugetlb_hwpoison(struct folio *folio, struc=
t
> > > > > page *page)
> > > > > +static int folio_set_hugetlb_hwpoison(struct folio *folio, struc=
t
> > > > > page *page,
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *=
samepg)
> > > > >  =A0 {
> > > > >  =A0=A0=A0=A0=A0 struct llist_head *head;
> > > > >  =A0=A0=A0=A0=A0 struct raw_hwp_page *raw_hwp;
> > > > > @@ -1889,17 +1890,16 @@ static int folio_set_hugetlb_hwpoison(str=
uct
> > > > > folio *folio, struct page *page)
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EHWPOISON;
> > > > >  =A0=A0=A0=A0=A0 head =3D raw_hwp_list_head(folio);
> > > > >  =A0=A0=A0=A0=A0 llist_for_each_entry(p, head->first, node) {
> > > > > -=A0=A0=A0=A0=A0=A0=A0 if (p->page =3D=3D page)
> > > > > +=A0=A0=A0=A0=A0=A0=A0 if (p->page =3D=3D page) {
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *samepg =3D true;
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EHWPOISON;
> > > > > +=A0=A0=A0=A0=A0=A0=A0 }
> > > > >  =A0=A0=A0=A0=A0 }
> > > > >  =A0=A0=A0=A0=A0 raw_hwp =3D kmalloc(sizeof(struct raw_hwp_page),=
 GFP_ATOMIC);
> > > > >  =A0=A0=A0=A0=A0 if (raw_hwp) {
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0 raw_hwp->page =3D page;
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0 llist_add(&raw_hwp->node, head);
> > > > > -=A0=A0=A0=A0=A0=A0=A0 /* the first error event will be counted i=
n action_result(). */
> > > > > -=A0=A0=A0=A0=A0=A0=A0 if (ret)
> > > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 num_poisoned_pages_inc(page_to=
_pfn(page));
> > > > >  =A0=A0=A0=A0=A0 } else {
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Failed to save raw error info.=
=A0 We no longer trace all
...

> > > > > try_memory_failure_hugetlb(unsigned long pfn, int flags, int
> > > > > *hugetlb
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 folio =3D page_folio(p);
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 res =3D kill_accessing_p=
rocess(current,
> > > > > folio_pfn(folio), flags);
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> > > > > -=A0=A0=A0=A0=A0=A0=A0 action_result(pfn, MF_MSG_ALREADY_POISONED=
, MF_FAILED);
> > > > > +=A0=A0=A0=A0=A0=A0=A0 if (samepg)
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 action_result(pfn, MF_MSG_ALRE=
ADY_POISONED, MF_FAILED);
> > > > > +=A0=A0=A0=A0=A0=A0=A0 else
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 action_result(pfn, MF_MSG_HUGE=
, MF_FAILED);
> > > >=20
> > > > Can't we somehow return that result from get_huge_page_for_hwpoison=
()
> > > > ... folio_set_hugetlb_hwpoison() differently? E.g., return an enum
> > > > instead of "-EHWPOISON" or magic value "2".
> > >=20
> > > This is an option. The existing return codes are as follow.
> > > __get_huge_page_for_hwpoison():
> > >   * Return values:
> > >   *   0             - free hugepage
> > >   *   1             - in-use hugepage
> > >   *   2             - not a hugepage
> > >   *   -EBUSY        - the hugepage is busy (try to retry)
> > >   *   -EHWPOISON    - the hugepage is already hwpoisoned
> > >=20
> > > folio_set_hugetlb_hwpoison()
> > > returns
> > > 	0:		folio was not poisoned before
> > > 	-EHWPOISON:	folio was poisoned before
> > >=20
> > > To get rid of 'samepg', how about
> > >=20
> > > __get_huge_page_for_hwpoison():
> > >   * Return values:
> > >   *   0             - free hugepage
> > >   *   1             - in-use hugepage
> > >   *   2             - not a hugepage
> > >   *   3		   - the hugepage is already hwpoisoned in different page
> > >   *   4  	   - the hugepage is already hwpoisoned in the same page
> > >   *   -EBUSY        - the hugepage is busy (try to retry)
> > >=20
> > > folio_set_hugetlb_hwpoison()
> > > returns
> > > 	0:		folio was not poisoned before
> > > 	1:	        folio was poisoned before in different page
> > > 	2:	        folio was poisoned before in the same page
> > >=20
> > > The whole point about identifying the same page is so that the re-poi=
son
> > > event is not doubled counted.
> >=20
> > This means folio_set_hugetlb_hwpoison() returns 0 on success but
> > positives on error.. this seems to be going further away from the
> > standard way of doing things?
>=20
> Yes.
> > > It would actually be good to remove all magic values instead of
> > expanding them.
> >=20
> > I think what David was trying to say is to have a local enum that state=
s
> > what these numbers mean so that the code reads more cleanly, instead of
> > digging for the right comment to decode it.
> >=20
> > For example, in try_memory_failure_hugetlb():
> >=20
> > if (res =3D=3D 2) { /* fallback to normal page handling */
> >=20
> > vs:
> >=20
> > if (res =3D=3D MEMORY_FAILURE_NOT_HUGEPAGE) { /* fallback to normal pag=
e handling */
> >=20
> > You could spell out your other options as well.  Maybe something like
> > MEMORY_FAILURE_HWPOISONED_ALREADY_COUNTED
> > MEMORY_FAILURE_HWPOISONED
> >=20
> > This would avoid adding more magic values and increase readability.
> >=20
> > If you changed try_memory_failure_hugetlb() to use a switch statement,
> > then the compiler can catch unchecked enums for us too.
> >=20
> > If you don't want to go the enum route, then you could use a different
> > error code and propagate it through, like -EEXISTS for the new case?
> > That way the return is still 0 on success and less than 0 on failure,
> > but I think the enum idea has a number of advantages.
>=20
> I am open, actually prefer enum with switch statement as you suggested
> above.

It's David's suggestion, really :)

>=20
> What about folio_set_hugetlb_hwpoison()?
> Indeed the conventional way of folio_set_X_Y() returns only two possible
> values, but we need three.

I am having a hard time finding any folio_set_* that returns anything.

$ git grep int\ folio_set_|wc -l
1
$ git grep void\ folio_set_|wc -l
20

> How about changing the function name to set_hugetlb_hwpoison() to deviate
> from the convention?  afterall, the function does more than conventional =
bit
> setting, it maintains a per folio raw-error linked list
> to track the poisoned pages within.

I think that's a good idea considering it seems like folio_set_ implies
that it will be setting something unconditionally, and this function
does not always set something and does even more work.

In fact the names make no sense to begin with.
get_huge_page_for_hwpoison() ends up actually calling
folio_set_hugetlb_hwpoison(), so it's not getting the huge page at all,
it's doing (at least some of) the work.

So, yeah, renaming it isn't going to make things worse.  I'd try to
indicate that folio_set_hugetlb_hwpoison() might not do anything.  It's
static and has hugetlb in the name, so we're pretty safe with anything.

Maybe update_hugetlb_hwpoison_list() ?

Thanks,
Liam



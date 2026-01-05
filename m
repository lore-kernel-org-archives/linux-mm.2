Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A3EC2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 05:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E02A6B00D8; Mon,  5 Jan 2026 00:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AE16B00DC; Mon,  5 Jan 2026 00:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363226B00DF; Mon,  5 Jan 2026 00:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 216E16B00D8
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:11:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7678141D3C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:11:49 +0000 (UTC)
X-FDA: 84296737938.12.5716416
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3261C40013
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:11:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TeJFp9Zy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pvEROS10;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767589906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmvRBIKYSJzPVyDfv09H0Nz65HEzTuVRHsNrf4nmV2k=;
	b=y9pGSNVEyn/ZJA2FIwHw7CU4o5bE18PrHr7feJRUh8w9NwjGBm3PqHw+43pDkGP1kQUPWH
	6odOAdoCQAb2hINN+HQJLqwnkGKxvm7Bj78M5NlN70UuWEYaJ7MVAzhnZ7wL6lZE+3blRl
	MrO2TDhw4wD2F72BdCvLu7HawtEofpo=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TeJFp9Zy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pvEROS10;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767589906; a=rsa-sha256;
	cv=pass;
	b=7zC739LjvNbOqj/jG6Tl0N3cXKnVB8zXRq7+lr9RCRlfLaoaa5d4MyQUn3F+OftlLsok6h
	V/OAgLE5xyWmYbcFyeGHuuKCNeJU/ZGtcG1uAwxzq8RPta2+BIvNccHF/OGpO+KusElJ0u
	N+vjpPgU86GJeA49YWZQqLEMi8D+SUg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6051fcdE131705;
	Mon, 5 Jan 2026 05:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qmvRBIKYSJzPVyDfv0
	9H0Nz65HEzTuVRHsNrf4nmV2k=; b=TeJFp9ZyO9hEqiOhPbKOUQd2SNvo+lajai
	DZBVbPOn6krY3KSS+elgeJkjWegFtS2WdMRhZmNAltW6QfjAma355LM04RzMUijU
	aW4AmtUJtBJowplYaPGDb39f2yxsZB10YkLqurVQK6YyqbZG7GeVtkD82jNtUjtJ
	F47OmaKFn7NmXz/2wkTaIqAdDAy0EEI8KVXw/N/WPyrfnnxdGQj64xRCZ/cZmeO7
	wp1sXmDtEY/T1uMCfOMjwq0fBG6BnXuaDcujZPHAWroqLKpAASzaRO4xTJIpPYJp
	IYbGR1ooVrr4N6VXcqLWhmV4JauPS/aIxJlgRLAFsTiZUl1HREBw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev1t9574-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 05:11:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6054G489016365;
	Mon, 5 Jan 2026 05:11:35 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6qb4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 05:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMztluodNo3FsFunjdkUqsmUIrfKnwFX7gyDnf4BDMZbmQSusok6otg/XkGWL4tnH8evAnx3fALFhKdvpvRB7fEAldryAzvX4Yf46WlIKdNdK5rmosg+5BjeeQ/aqwnV3g+TyPV0/CKGkVImnKiyfT3hTMsTRqFZr69AOdBdRChW7gjbjoEmYo4zMJuLPMSVZsZorzeRpekmNM/X+349QNnjSX/enbJfer9LcHsgi/ISFoXMJRYy4t17vlXl2WinQhr4XAajfGFIMaR8+/WHNi12IyTJlTapYw44gYaJknCeK6JtZUaPqHoKE3IGMXB/eny/zZ7k64KcZ14ukShdfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmvRBIKYSJzPVyDfv09H0Nz65HEzTuVRHsNrf4nmV2k=;
 b=dNvYQ11aXJdC/cHrywcp4MWvioJRLXgiF6QDQ75ibBi7zvBCnqhfKmIHfFif6eW7Ssx1x9ULn6Eox9BSMebbaakg0pBLOvt61OJR/ISwz3WX0tEfsxdhrSauubSudE+u17qG2E/Ph58X4YtDlbiOQBIfysyrQrwIMLtN78vyM2JN1ALPyMqaFAkDWCileVypM1raQxbgEUYhwqMWEw2JBQqGL73a6MpmlXv65+2D8hGrFMFegvn0NAmdTZuemNai8I4M00yw7mOOyDMrWBNxsXbg7e+cPcXgckhZTkENtHIFKuIYh3PASQWeLrWXvMKJjZ11z/3Eoz12C0tvj07vbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmvRBIKYSJzPVyDfv09H0Nz65HEzTuVRHsNrf4nmV2k=;
 b=pvEROS10wJRJnj+ZZv/m0xPVIz4Kcmh08UMW+4GLs6RIEWQTMRZ3q5VbjrkBbKCOIAJrLlBffKIGR50JK1ojPvVHcyMSiin6qN1b+bj6cTLXEyEVKBFuZFuk3j17NmEDzm1Az9Tr1uO37q/6WTWFA9kWfvS/oRlXxRpyTDd23vw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN2PR10MB4176.namprd10.prod.outlook.com (2603:10b6:208:1da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 05:11:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 05:11:32 +0000
Date: Mon, 5 Jan 2026 14:11:23 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
 merge
Message-ID: <aVtH-9rUDNAhjc6V@hyeyoo>
References: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: SE2P216CA0125.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN2PR10MB4176:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b3c61c3-2083-4395-5140-08de4c18e428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rVQ6M4udyA7JyWESaU0eYO/5ikNHoyYwxQzp+vOfBwxCNWMmd31CF+pzqIcC?=
 =?us-ascii?Q?PHpi4cCb+rDrtgYBCkzdbg1gWZIi+MRF2vILNeeqEPFv+QRGW5k2IucqixA/?=
 =?us-ascii?Q?T+Es9WczQBrMqMrWDLjg5gk0pBmIUI5oQCGzrPcuRQf50jEcRM510i9dnpBg?=
 =?us-ascii?Q?g5hF6UC4kRgbFM/mJ6A4DG/yKl9Hxmw7ZkZnHrIXRDqhgyrhznCPUg/K+J6q?=
 =?us-ascii?Q?BUyHmokexS485VS4RXySu2EVAQ9kjC2bZ5Sf1l++2sK0T7+eGAuVb1sXURuN?=
 =?us-ascii?Q?uzaTeNK+p0bKE57jLo/43tbl7Jyveb2FdPTT+fCulSHf1yQfYAPxBRMdCMXR?=
 =?us-ascii?Q?AQrvl9jjLT7rnIPF5TE5VTg+v4EkPil5Mdzh+atS5T49FJld9DXG9FMlV2eR?=
 =?us-ascii?Q?DqdfI0SDKkn67BSNMjmhVoNQHnmpEVIqIGgVQAyzWZIeSHj+iG6Dzh+e9pxA?=
 =?us-ascii?Q?2/zr+e4GEwfsT92LEfxGz8n9v01JoWtb6F3Q3cqyxTRr0tZugqxaVKdHDRsu?=
 =?us-ascii?Q?sr0mQMqZ2nqT6b6/7f5Hsp/QWGChHvOD3ni9d7BdB9pyx69nHuY6kaQfscpo?=
 =?us-ascii?Q?aox3X/aWYn0nH3psP5iOjQGYxD7WkkdXNvhDrju5lqfRA6NHs8u5gf1Y8Hm8?=
 =?us-ascii?Q?UeWte8sHwYOJ2RHDE0IPoY7Ly12LZ+wb+o1H5O9h16fMQJRRsUQJZKMKDr/L?=
 =?us-ascii?Q?ZQKhFAm0vGlMDfPc75hIe/9f6N0nvAb2HPFWjg3j1dx+eSU46HpUMmGMbNyp?=
 =?us-ascii?Q?TDB7ZKxWAmBM56jOsP3tXhlBRmOHYdx1yCujYEXE8vqTjp3OkbM32XeZsz4A?=
 =?us-ascii?Q?H70JyMP0UditZ3ta5xilavKkuenQ2F3JG5/aDdc9POiHzoeMyfznk7Qdbd12?=
 =?us-ascii?Q?fmXinxgTw8ZIpEuqM5bF/ta6DWGEF2NeIQosRl9H0mFkQ3hNRB4eoXS9RQgI?=
 =?us-ascii?Q?7EGbYjZ8SK8R4OGjlQMYEic+s9aqaVwSm1oLHC4gDgMb4duOa4vTdeIqJgPP?=
 =?us-ascii?Q?O9SP/XrWvKJL7++PjrSL6fYedL2jAGEtgymY1lIhBU1msz9hBBNhlmt7eZFo?=
 =?us-ascii?Q?QuTpgxnRLnfsZvQ8AIlNlIZndnkNwcUykV3nRPNh0cwaOPUR2uUdk+YK4uGq?=
 =?us-ascii?Q?bA/ab+tvZvqCzR2Qp4JjIKdEVqg3RY1BgO8bCxh7EkeYXBXnrXsJwK7p2V4o?=
 =?us-ascii?Q?q36YCrkRuitwtnv4JOq1HAoc4P/i52YrPPsmcfLJj5PlHBxJ0TOeYBDQRD4J?=
 =?us-ascii?Q?5J0vbE3J2khmhoO6DsVDpx+9Rn3xj4/BGtGdAO5ZP71N++Z1dQyNUl6AJ+m5?=
 =?us-ascii?Q?h2kutzjKopd9UxpBFEeuvPbhS4WJel1dsV2ANbvTlXm+z8gCKGqQ9//acOLN?=
 =?us-ascii?Q?F1eL5ISzVm/nhFO97xWsEszGfh0hWXDQz8bQIFluyfp7k3OdvlkM3AexeKkw?=
 =?us-ascii?Q?h2QccDkIgXs6bkMYQtEpkPSWDsrWQlIQ2VqBoyVHLvv8P1F8yet6fw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BdXjoUwirsnYvdx23+l+tpuCvEnGdWxaQIYwtUQqg8of0UHavHSmZo6FvkUl?=
 =?us-ascii?Q?UFl2hNK9N3APAPVttP77ztsFINB4g3QBuQKWfHry4/j1JDbpDbA8/vyjC9mp?=
 =?us-ascii?Q?SyCY3mZtl4gZacOGU4FGebRdFKLpxJOU/uhLiLI+yOwsUq61SvHP58JnSI2Q?=
 =?us-ascii?Q?KrKU4agIhEEbN6GEuhPM5PdDmdek/F0C1ByhQ/gUdOVjp8JBblQcnX4c1fsw?=
 =?us-ascii?Q?RGltIlm5U3/HTtIpJkwdqI6fsQE9KsFQp8JJ4X8SuqzOs7E5qDg631u2QMJU?=
 =?us-ascii?Q?jkREys1HbGZ1IqP4f7aBShNQjpGkTRiNu8BV2jy8OqgJ8LBY7DFdUhigL0In?=
 =?us-ascii?Q?VZmWpzhfbNHuBPsngo7WFVDK3dHKTvV9bNCSNf39YvbgJajtY/6xTUjkm7ec?=
 =?us-ascii?Q?aKlKq5VoF2EuK+Qr5BzcfZYJk7W2z8B4x0yAObfc62yzafOoazEolr1wlRFR?=
 =?us-ascii?Q?RKCJtWX41XLZjLO3b9eW2LqZM5Ns6QBM1yqYglz0nghCMiel4w/PmBJoPMlF?=
 =?us-ascii?Q?66jcrPDNOn0CW/3dqGuI9vmvsNsySiD471+mO2laAQRD+ptw+ITDpdVeZU/4?=
 =?us-ascii?Q?U+QpGz3NGo9pltmsVUcqX7YWL9BPFTUxoTpWWVw7KF9LLkqJF4rKAWr5zyVj?=
 =?us-ascii?Q?3z+VkIK2O27+I3IxfHh+Q4fFwO85Ux+bf5Gi+40qT2SIenpA7nh/7dMk9UMk?=
 =?us-ascii?Q?2U12tMs4sDpC3KEWj3evVMUW0ylk1ieC+s4HVCe72rsQoGnozpB+ijsbeaZ4?=
 =?us-ascii?Q?u3febaJHVEuesntEZ0GU3vd3sqSvaARErfET0rxl1U0WjWkEjfXl379efFPh?=
 =?us-ascii?Q?fKXv5O0wbv+jce8EY0e5BHnyFHODoCXe4VHkekCkVcqn18ylvoe1mGlfTDhf?=
 =?us-ascii?Q?bmOUNMDaYDlvhpBG79n2mbsWPi+3Bu11Y+T8wTiecGg6l13+9k1E9QoK1ezo?=
 =?us-ascii?Q?9tjqo+qJVjn6gv4JM/uHJpyEKsozZov9/L19KzR2SRE6llLTJqQxnjAcC5LU?=
 =?us-ascii?Q?Gb7ZR9Gn23no6QF2q2Vusg6t/oPe0Qc8QIc9fK6I0xD6XWqsR/N/lkwp27jJ?=
 =?us-ascii?Q?NpWG/oIaItP8UDG3rehQ7z6IoQlxCfh/8rK2r1d29Nn/a+kdhz5AgNAg2TM0?=
 =?us-ascii?Q?Im1mq7iVRe4N+hAPownXurhskVwtfTsm6OuIULVBaOz3FfUPmjYfQlc3o6AW?=
 =?us-ascii?Q?/YoC7Ovjl9bNwFR+xcKO+Dttb0oBhKrFVdQFGVN4W9XVP6cQ1jh3hUtntmg1?=
 =?us-ascii?Q?7ytWKA+N2eRMQrzh6iVDGkNG6C5GV/+bSyu8Gx+qCJR5Q+GMymu96l7oZ5iu?=
 =?us-ascii?Q?KCP1ONSko7QTZX6/yEGX4euBZ+RrbWYvUDWUe2fvrzHpz4CqxUUgxXNd8z1b?=
 =?us-ascii?Q?eV7RXZ0tUyj6D/QyRScO90kTSMcZHhUjGN/JRHGD74Zhffekl1hazt38NZmJ?=
 =?us-ascii?Q?wM61YHjfgccNccuc9SPmwTI6cYgKlm5hN5NWpn4KX8G60YjOc4RphFVuclsM?=
 =?us-ascii?Q?OV8q/nCBAV4H+64hHr0LVDU5QIUQ4PpHIj8wZSRBFqRA2jo0lCRnJywLiYNX?=
 =?us-ascii?Q?FXEA3QUwIEQLMJijK8iHg6i8zc2N3eY7AYEJQPdUG+2mu0ZH2sdYUAdLXMWI?=
 =?us-ascii?Q?i6X3jesUC1mgH+i1T3z7eBq6/BeJ62PaVWxS462ChWHa9tkQsthxRfP9Syh0?=
 =?us-ascii?Q?KJ2vkzf92PNgJ+cHp8++b2xN0axY5VyTKNYTJsaKy35+IViC6N0vJAvUaOmC?=
 =?us-ascii?Q?3KklcS3Cfg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q1Q/ouC3h0EddP0TvAXovPieihHGYPiekB6przHG14066DGc4lKUjSqHz3X8PmvQXlGycyOSv3bmTUP7bRZsmsvM8FbhPrWd85LHcX3kC4orKFmH/dxx0H1oL0GPyp6rwJGIwCT0R73ngJxSHkhvF0+yZY82Zqq8r+/sGemxdCYOLCYLl+RuAG4Ek+bR3NsqatPomWp3pe3S1YEKUJzcmtiyx+CsnxhnbysDC+0mpOtZ4D0Us+GeoJdeBEap9c16td+fB0MPbHNKEh181MMVe5HENDf/vkxz0QuaD9mD7gF7A+fSDrlZdff3P1RnC1g5rpXYHTrypNRV+P2dmI8Be/jIeH0M9I1tHYBa04j/gV+H0hE/9AfdQlDi6kZt/CMwdQs+62uvxX0ESKWNyT8sfVt9aHGNyVUrU0LvQ3ZxzcSUNqTZ+fCpLC5v5jP/Hw5zwR8bpXoKjhstx4fQS8uvcgFooIpMVVsyrR79b3p/yaP54kG3Sz23NBYFVj080BHe5kJnxJa6hB1hxyJ1zhLvFMX6bqrDv/0MtAA05WblfdzGkiIPuqDRHBcFubF1Wlae6wVVTg3R1XszCIvZGF/AGoaAOvvHWiHwj4otRIyLQKo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3c61c3-2083-4395-5140-08de4c18e428
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 05:11:32.5748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlrTGcwRR2ILPQ9A1C+lAPiyRP/opdKoNGINtm02cJgmxmd8YO/FJHyBeYn7aSKwYNzxXrQBoOUyYQqA6HbqqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4176
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-04_07,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=888 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050045
X-Proofpoint-ORIG-GUID: vkIoCU873hjKbml-NC34bFW96RRYIHq6
X-Authority-Analysis: v=2.4 cv=CKknnBrD c=1 sm=1 tr=0 ts=695b4808 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=KHkFnJLSZI5IAFLIxyMA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA0NiBTYWx0ZWRfX9MoItqBxI+fx
 XT82grQP6xZS/TCkjEc8kG7KtDO+ioz6VJZXfVPmvyYaXz1PAnzMcugN6atuCLNmmdG0zr1wGxi
 G0YkwhNaS+GovkZiWVjgd2hNhG9oLMdv7cWyytq3juQAJAZFt9iODldo1paTfMUMR/NMHttU6Hu
 F6N0FjZQJvOgeSIKms3O5A9jNdcyBAXKpCXhZOeTXsLhDizohEpnwakUuV6o9l5ij9yV+6NS791
 brbw8tfgzZ9CuiCFrqCRyvojq+Jkd63RczdF8QXMg6csJbbBsr7b14WlIX7b88GdU4cceg1Oyrx
 J+Ip4GcXzv+Z76XJzNSqes55FawWH/iXAhiiliMjBBAWDWhF5hCefSPnz0Lp85pjcYvk6dyxwol
 J85MgEaFFcNeQht60GgI7g8ld7j8mSMcXcTXuoU+x1ihaxaQrbJknVppYVDwOScipm+Z22rxXxW
 o5nOH0d3I5hRrZ+OZFA==
X-Proofpoint-GUID: vkIoCU873hjKbml-NC34bFW96RRYIHq6
X-Rspamd-Server: rspam02
X-Stat-Signature: mefxjti13bc8m1o599mku7pamheqc786
X-Rspam-User: 
X-Rspamd-Queue-Id: 3261C40013
X-HE-Tag: 1767589905-16119
X-HE-Meta: U2FsdGVkX19Gmduj88jl2R9cH5fu2BqDBDFQtQf+NMSZ7ir0sJAIpIC96TKam8egrQmrnNGLNZPECfXezM17+oEGydFs2aYHiIX+LEOd3raJUss+jTRYxKCcq8bko6VtTkm3OdiCvLfGHFuu6yIHZGRzG9mx+9RdoOOJXDdbScwLEvlyeDtM3Ujv/pyEZ6T2hYZPh0CkPpyd/1U7L4i9cf+s2Ay4PP5eoXBJH5wsov6LxD07TGEd40u1bTwOUV8SDD7GrbO3fePFYwVlwrApOTZpvsoajZi7e7tR0i2m8L80hELxZy6rQ17E/LM851hbOovYYA470dVE1rjrt67FWUgPJqd4K5gJKe21WDafPJuLs9+ihH0R0TLteUaCx/2ueYpOviKddPgejBJjHAEKpHf8Mo44QrkM8baSSpj+xhBQk+RihY4V6tnk27D0xZwfgyP/D3dp21Zccuiq6AnGarLZTlaMIF+KoCfPSqymlVjS6bysKnJ0eNroJbDF2ajQKhZIYETQveENNgUmX+l+LdSU4oYUNI92M5hO3G2nd2gOY+EVZ4IHrygWoO74KD5nLxAwAriYKpuUqaf1q7/mYzyVj7p0YwoR878izZqk6nBpta0S7KCub3V3qNAausoR1Cms3pojxkfLeDS/R/0Fs/XBO0q61oOSPN/ywyn3qrgodJPYFyzg2YrIjnYasNibaTP7TjlRJcTDFDLJ2KKXrPPnL5OJPY1qBmlhPrmlqz5hn3KVL8tNR4k/uZzDS3NpgLdtqeoa6kvYCrZZ4CMXqqVEyCBFdp2WPKr7kTIvlkLeEgd2EP5L1dglE2xGINY3Sya0KHxADt/ZB2tq2a6ijki+KxatQ5SZ7NEcEbM1MdIkZj3YnTiF3QlZgHRuZlvG2km0qeMTzHlvPkkR1y+MgOFqeRBsPWKmY6S6V+qPdUL36qGqKoWTeQepqql+5fnP5G5D2SIsB2bUy3wbdvH
 IB1f9WQH
 5as0kppYtbpK6wJFpsQa6g3AL0Tj4fyU56e7JmkQJNy9q3NDG+sEAqHWKOvSnSSQab/tmVpCyNm0eGeLkST71DtA2BNF2EpQD5vUXgnupFCb+bbUjpCSH3qMGqDciUP28cGRVCv+C8/dVxpn1b3w2UGsaZirWaxLmJXS6djHfot1KPIeZPHp7jupxPU1wJFbwHcbgvSJvu/f9dF7Zl3qFtigA/41SaP5+yx+EYVCnkxoAowsTkonduMFb7gMoTYlvL61p70L9Bhifn0pxMeFTO1hwfHiuAFbGBms93kka6PGQiZgyBKfLbAAYpJzKxk2uneM/qkxAtdBFzDNQLKKeTQg64qajOLpUDJt+MTSkzqVjbUHY/Qbtp6p0mviBQPQA+9T6m8suSPu4BsT7A42W0/3TdEh35QeZqsVuVGr4Syi/qqxHwXETt39Wu5b8L8TexWtE+MOm0BK93wSpW23SZdLzSZSStVbmnV5poFFvDQqJKCMmWqnZ7X9E4YaqikxQd7+r9oo0pmaW0ez7DQ5gCxzkN/2EitPvrcJ9uN7vS+OCuPYPtvbUlUB6j6hWn8ahn86ZPyt3lhqYKZUghXrgUQNstadZ1TZHf5huu1iegUShBxrR3uiqapL7q/l5OahqSEf8OOgKUfiHhNawNgBXocaD0GbdRi06pUsAJEmSvzv+eyQdKHxKrlUTS2SYIsLalgrD3vKuBnbQtLy3uXatKRb0bgRqJXnGsLRH3HZ2XUL4EIKQT/e0gmbsx+EmaPNRojizlx/P9pt73AyMEgP+RMY6XluKifdcCEjam4/DrIqChl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 02, 2026 at 08:55:20PM +0000, Lorenzo Stoakes wrote:
> Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> merges") introduced the ability to merge previously unavailable VMA merge
> scenarios.
> 
> The key piece of logic introduced was the ability to merge a faulted VMA
> immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> correctly handle anon_vma state.
> 
> In the case of the merge of an existing VMA (that is changing properties of
> a VMA and then merging if those properties are shared by adjacent VMAs),
> dup_anon_vma() is invoked correctly.
> 
> However in the case of the merge of a new VMA, a corner case peculiar to
> mremap() was missed.
> 
> The issue is that vma_expand() only performs dup_anon_vma() if the target
> (the VMA that will ultimately become the merged VMA): is not the next VMA,
> i.e. the one that appears after the range in which the new VMA is to be
> established.
> 
> A key insight here is that in all other cases other than mremap(), a new
> VMA merge either expands an existing VMA, meaning that the target VMA will
> be that VMA, or would have anon_vma be NULL.
> 
> Specifically:
> 
> * __mmap_region() - no anon_vma in place, initial mapping.
> * do_brk_flags() - expanding an existing VMA.
> * vma_merge_extend() - expanding an existing VMA.
> * relocate_vma_down() - no anon_vma in place, initial mapping.
> 
> In addition, we are in the unique situation of needing to duplicate
> anon_vma state from a VMA that is neither the previous or next VMA being
> merged with.
> 
> To account for this, introduce a new field in struct vma_merge_struct
> specifically for the mremap() case, and update vma_expand() to explicitly
> check for this case and invoke dup_anon_vma() to ensure anon_vma state is
> correctly propagated.
> 
> This issue can be observed most directly by invoked mremap() to move around
> a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> specified.
> 
> This will result in unlink_anon_vmas() being called after failing to
> duplicate anon_vma state to the target VMA, which results in the anon_vma
> itself being freed with folios still possessing dangling pointers to the
> anon_vma and thus a use-after-free bug.
> 
> This bug was discovered via a syzbot report, which this patch resolves.
> 
> The following program reproduces the issue (and is fixed by this patch):

[...]

> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> Cc: stable@kernel.org
> ---

Hi Lorenzo, I really appreciate that you've done very through analysis of
the bug so quickly and precisely, and wrote a fix. Also having a simpler
repro (that works on my machine!) is hugely helpful.

My comment inlined below.

>  mm/vma.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
>  mm/vma.h |  3 +++
>  2 files changed, 47 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 6377aa290a27..2268f518a89b 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1130,26 +1130,50 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	mmap_assert_write_locked(vmg->mm);
> 
>  	vma_start_write(target);
> -	if (next && (target != next) && (vmg->end == next->vm_end)) {
> +	if (next && vmg->end == next->vm_end) {
> +		struct vm_area_struct *copied_from = vmg->copied_from;
>  		int ret;
> 
> -		sticky_flags |= next->vm_flags & VM_STICKY;
> -		remove_next = true;
> -		/* This should already have been checked by this point. */
> -		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> -		vma_start_write(next);
> -		/*
> -		 * In this case we don't report OOM, so vmg->give_up_on_mm is
> -		 * safe.
> -		 */
> -		ret = dup_anon_vma(target, next, &anon_dup);
> -		if (ret)
> -			return ret;
> +		if (target != next) {
> +			sticky_flags |= next->vm_flags & VM_STICKY;
> +			remove_next = true;
> +			/* This should already have been checked by this point. */
> +			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> +			vma_start_write(next);
> +			/*
> +			 * In this case we don't report OOM, so vmg->give_up_on_mm is
> +			 * safe.
> +			 */
> +			ret = dup_anon_vma(target, next, &anon_dup);
> +			if (ret)
> +				return ret;

While this fix works when we're expanding the next VMA to cover the new
range, I don't think it's covering the case where we're expanding the
prev VMA to cover the new range and next VMA.

Previously I argued [1] that when mremap()'ing into a gap between two unfaulted
VMAs that are compatible, calling `dup_anon_vma(target, next, &anon_dup);`
is incorrect:
                                      mremap()
                     |-----------------------------------|
                     |                                   |
                     v                                   |
[ VMA C, unfaulted ][ gap ][ VMA B, unfaulted ][ gap ][ VMA A, faulted ]
  

I suspected this patch doesn't cover the case, so I slightly modified your
repro to test my theory (added to the end of the email).

The test confirmed my theory. It doesn't cover the case above because
target is not next but prev ((target != next) returns true), and neither
target nor next have anon_vma, but the VMA that is copied from does.

With the modified repro, I'm still seeing the warning that Jann added,
on top of mm-hotfixes-unstable (HEAD: 871cf622a8ba) which already has
your fix (65769f3b9877).

[1] https://lore.kernel.org/linux-mm/aVd-UZQGW4ltH6hY@hyeyoo

> +		} else if (copied_from) {
> +			vma_start_write(next);
> +
> +			/*
> +			 * We are copying from a VMA (i.e. mremap()'ing) to
> +			 * next, and thus must ensure that either anon_vma's are
> +			 * already compatible (in which case this call is a nop)
> +			 * or all anon_vma state is propagated to next
> +			 */
> +			ret = dup_anon_vma(next, copied_from, &anon_dup);
> +			if (ret)
> +				return ret;

So we need to fix this to work even when (target != next) returns true.

Modified repro:

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

#define RESERVED_PGS	(100)
#define VMA_A_PGS	(10)
#define VMA_B_PGS	(10)
#define VMA_C_PGS	(10)
#define NUM_ITERS	(1000)

static void trigger_bug(void)
{
	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
	char *reserved, *ptr_a, *ptr_b, *ptr_c;

	/*
	 * The goal here is to achieve:
	 *                                       mremap()                                  
	 *                           |-----------------------------------|                        
	 *                           |                                   |                        
	 *                           v                                   |                         
	 *       [ VMA C, unfaulted ][ gap ][ VMA B, unfaulted ][ gap ][ VMA A, faulted ]
	 *
	 * Merge VMA C, B, A by expanding VMA C.
	 */

	/* Reserve a region of memory to operate in. */
	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
			MAP_PRIVATE | MAP_ANON, -1, 0);
	if (reserved == MAP_FAILED) {
		perror("mmap reserved");
		exit(EXIT_FAILURE);
	}

	/* Map VMA A into place. */
	ptr_a = mmap(&reserved[page_size + VMA_C_PGS * page_size], VMA_A_PGS * page_size,
		     PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
	if (ptr_a == MAP_FAILED) {
		perror("mmap VMA A");
		exit(EXIT_FAILURE);
	}
	/* Fault it in. */
	ptr_a[0] = 'x';

	/*
	 * Now move it out of the way so we can place VMA B in position,
	 * unfaulted.
	 */
	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
	if (ptr_a == MAP_FAILED) {
		perror("mremap VMA A out of the way");
		exit(EXIT_FAILURE);
	}

	/* Map VMA C into place. */
	ptr_c = mmap(&reserved[page_size], VMA_C_PGS * page_size,
		     PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
	if (ptr_c == MAP_FAILED) {
		perror("mmap VMA C");
		exit(EXIT_FAILURE);
	}

	/* Map VMA B into place. */
	ptr_b = mmap(&reserved[page_size + VMA_C_PGS * page_size + VMA_A_PGS * page_size],
		     VMA_B_PGS * page_size, PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
	if (ptr_b == MAP_FAILED) {
		perror("mmap VMA B");
		exit(EXIT_FAILURE);
	}

	/* Now move VMA A into position w/MREMAP_DONTUNMAP + free anon_vma. */
	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
		       &reserved[page_size + VMA_C_PGS * page_size]);
	if (ptr_a == MAP_FAILED) {
		perror("mremap VMA A with MREMAP_DONTUNMAP");
		exit(EXIT_FAILURE);
	}

	/* Finally, unmap VMA A which should trigger the bug. */
	munmap(ptr_a, VMA_A_PGS * page_size);

	/* Cleanup in case bug didn't trigger sufficiently visibly... */
	munmap(reserved, RESERVED_PGS * page_size);
}

int main(void)
{
	int i;

	for (i = 0; i < NUM_ITERS; i++)
		trigger_bug();

	return EXIT_SUCCESS;
}

--
Cheers,
Harry / Hyeonggon

